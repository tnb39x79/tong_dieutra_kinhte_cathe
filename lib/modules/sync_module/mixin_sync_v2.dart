import 'dart:async';
import 'dart:convert';
import 'dart:developer' as developer;
import 'dart:io';

import 'package:get/get.dart';
import 'package:gov_statistics_investigation_economic/common/utils/app_pref.dart';
import 'package:gov_statistics_investigation_economic/modules/dashboard_module/main_menu/main_menu_controller.dart';
import 'package:gov_statistics_investigation_economic/resource/database/database_helper.dart';
import 'package:gov_statistics_investigation_economic/resource/database/provider/provider.dart';
import 'package:gov_statistics_investigation_economic/resource/database/provider/provider_p07mau.dart';
import 'package:gov_statistics_investigation_economic/resource/database/table/table_dm_bkcoso_sxkd.dart';
import 'package:gov_statistics_investigation_economic/resource/model/reponse/response_model.dart';
import 'package:gov_statistics_investigation_economic/resource/model/reponse/response_sync_model.dart';
import 'package:gov_statistics_investigation_economic/resource/model/senderror/senderror_model.dart';
import 'package:gov_statistics_investigation_economic/resource/model/sync/file_model.dart';
import 'package:gov_statistics_investigation_economic/resource/model/sync/sync_model.dart';
import 'package:gov_statistics_investigation_economic/resource/services/api/api_constants.dart';
import 'package:gov_statistics_investigation_economic/resource/services/api/send_error/send_error_repository.dart';
import 'package:gov_statistics_investigation_economic/resource/services/api/sync_data/sync_data_repository.dart';

import 'package:intl/intl.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:archive/archive_io.dart';

mixin SyncMixinV2 {
  Map fullBody = {};
  Map msgBundleBody = {};

  final MainMenuController mainMenuController = Get.find();

  final bkCoSoSXKDMixProvider = BKCoSoSXKDProvider();
  final diaBanCoSoSXKDMixProvider = DiaBanCoSoSXKDProvider();

  ///Phiếu 07 mẫu
  final phieuMixProvider = PhieuProvider();
  final phieuMauTBMixProvider = PhieuMauTBProvider();
  final phieuMauTBSanPhamMixProvider = PhieuMauTBSanPhamProvider();
  final phieuNganhCNMixProvider = PhieuNganhCNProvider();
  final phieuNganhLTMixProvider = PhieuNganhLTProvider();
  final phieuNganhTMMixProvider = PhieuNganhTMProvider();
  final phieuNganhTMSanphamMixProvider = PhieuNganhTMSanPhamProvider();
  final phieuNganhVTMixProvider = PhieuNganhVTProvider();
  final phieuNganhVTGhiRoMixProvider = PhieuNganhVTGhiRoProvider();

  final danhSachBkCoSoSXKDInterviewed = <TableBkCoSoSXKDSync>[].obs;
  final danhSachBkCoSoSXKDInterviewedPagingated = <TableBkCoSoSXKDSync>[].obs;
  final danhSachBkCoSoSXKDInterviewedFull = <TableBkCoSoSXKD>[].obs;

  Future getListInterviewed() async {
    List<Map>? item =
        await bkCoSoSXKDMixProvider.selectAllListInterviewedSync();
    danhSachBkCoSoSXKDInterviewed.clear();

    if (item.isNotEmpty) {
      for (var element in item) {
        developer.log('CSSXKDSync Part: $element');
        danhSachBkCoSoSXKDInterviewed
            .add(TableBkCoSoSXKDSync.fromJson(element));
      }
    }
  }

  Future getFullDataSync() async {
    await getListInterviewedFullSync();
    await getFullCoSoSXBody();
  }

  Future getListInterviewedFullSync() async {
    List<Map>? item =
        await bkCoSoSXKDMixProvider.selectAllListInterviewedSync();
    danhSachBkCoSoSXKDInterviewedFull.clear();

    if (item.isNotEmpty) {
      for (var element in item) {
        developer.log('CSSXKD Full: $element');
        danhSachBkCoSoSXKDInterviewedFull
            .add(TableBkCoSoSXKD.fromJson(element));
      }
    }
  }

  Future getListInterviewedPaginatedSync(int pageNumber, int pageSize) async {
    int offset = 0; // (pageNumber - 1) * pageSize;
    var items = danhSachBkCoSoSXKDInterviewed
        .where((x) => x.isSyncSuccess != 1)
        .skip(offset)
        .take(pageSize)
        .toList();
    danhSachBkCoSoSXKDInterviewedPagingated.clear();

    if (items.isNotEmpty) {
      danhSachBkCoSoSXKDInterviewedPagingated.assignAll(items);
    }
  }

  Future getBundleCoSoSX() async {
    List cosoSX = [];
    msgBundleBody = {};
// Map msgBody = {};
    await Future.wait(danhSachBkCoSoSXKDInterviewedPagingated.map((item) async {
      var map = {
        "LoaiPhieu": item.loaiPhieu,
        "IDCoso": item.iDCoSo,
        "MaTinh": item.maTinh,
        "MaTKCS": item.maTKCS,
        "MaXa": item.maXa,
        "MaThon": item.maThon,
        "TenThon": item.tenThon,
        "MaDiaBan": item.maDiaBan,
        "TenDiaBan": item.tenDiaBan,
        "TenCoso": item.tenCoSo,
        "DiaChi": item.diaChi,
        "TenChuCoSo": item.tenChuCoSo,
        "DienThoai": item.dienThoai,
        "Email": item.email,
        "MaTinhTrangHD": item.maTinhTrangHD,
      };

      Map phieuMauTBs = await getPhieuMauTBs(item.iDCoSo!);
      if (phieuMauTBs.isNotEmpty) {
        map['PhieuMauTB'] = phieuMauTBs;
      }

      cosoSX.add(map);
    }));

    // msgBody['CoSoSXKDData'] = cosoSX;
    msgBundleBody['CoSoSXKDData'] = cosoSX;
    return msgBundleBody;
  }

  Future getFullCoSoSXBody() async {
    List cosoSX = [];

    await Future.wait(danhSachBkCoSoSXKDInterviewedFull.map((item) async {
      var map = {
        "LoaiPhieu": item.loaiPhieu,
        "IDCoso": item.iDCoSo,
        "MaTinh": item.maTinh,
        "MaTKCS": item.maTKCS,
        "MaXa": item.maXa,
        "MaThon": item.maThon,
        "TenThon": item.tenThon,
        "MaDiaBan": item.maDiaBan,
        "TenDiaBan": item.tenDiaBan,
        "TenCoso": item.tenCoSo,
        "DiaChi": item.diaChi,
        "TenChuCoSo": item.tenChuCoSo,
        "DienThoai": item.dienThoai,
        "Email": item.email,
        "MaTinhTrangHD": item.maTinhTrangHD,
      };

      Map phieuMauTBs = await getPhieuMauTBs(item.iDCoSo!);
      if (phieuMauTBs.isNotEmpty) {
        map['PhieuMauTB'] = phieuMauTBs;
      }

      cosoSX.add(map);
    }));

    fullBody['CoSoSXKDData'] = cosoSX;
  }

  /// ****BEGIN::HOME SYNC****
  Future<ResponseSyncModel> syncDataMixinHome(SyncRepository syncRepository,
      SendErrorRepository sendErrorRepository, progress,
      {bool isRetryWithSignIn = false}) async {
    await getDataHome();

    return await uploadDataMixinHome(
        syncRepository, sendErrorRepository, progress,
        isRetryWithSignIn: false);
  }

  getDataHome() async {
    await getListInterviewedHome();
    await getBodyHome();
  }

  Future getBodyHome() async {
    await Future.wait([
      getFullCoSoSXBody(),
    ]);
    developer.log('GET FULL BODY HOME: ${jsonEncode(fullBody)}');
  }

  Future getListInterviewedHome() async {
    List<Map>? interviewedCoSoSXKD =
        await bkCoSoSXKDMixProvider.selectAllListInterviewedSync();
    danhSachBkCoSoSXKDInterviewedFull.clear();
    // developer.log('interviewedCoSoSXKD: $interviewedCoSoSXKD');
    if (interviewedCoSoSXKD.isNotEmpty) {
      for (var element in interviewedCoSoSXKD) {
        developer.log('CSSXKD Full Home: $element');
        danhSachBkCoSoSXKDInterviewedFull
            .add(TableBkCoSoSXKD.fromJson(element));
      }
    }
  }

  Future<ResponseSyncModel> uploadDataMixinHome(SyncRepository syncRepository,
      SendErrorRepository sendErrorRepository, progress,
      {bool isRetryWithSignIn = false}) async {
    developer.log('BODY: ${json.encode(fullBody)}');
    // developer.log('BODY: $body');
    print('$fullBody');
    var resCode = '';
    var errorMessage = '';
    var mustSendErrorToServer = false;

    //  await Future.delayed(const Duration(milliseconds: 1000000));
    ResponseModel request = await syncRepository.syncDataV2(fullBody,
        uploadProgress: (value) => progress.value = value);

    ///TRẢ LẠI SAU
    developer.log('SYNC fullBody SUCCESS: ${request.body}');
    if (request.statusCode == ApiConstants.errorToken && !isRetryWithSignIn) {
      var resp = await syncRepository.getToken(
          userName: AppPref.userName ?? '',
          password: AppPref.password ?? '',
          iMei: mainMenuController.userModel.value.iMei);
      AppPref.extraToken = resp.body?.accessToken;
      await uploadDataMixinHome(syncRepository, sendErrorRepository, progress,
          isRetryWithSignIn: true);
    }

    if (request.statusCode == 200) {
      SyncModel syncData = SyncModel.fromJson(jsonDecode(request.body));

      if (syncData.responseCode == ApiConstants.responseSuccess) {
        var coSoSuccess =
            jsonDecode(request.body)["Data"]["CoSoSXKDData"] as List;

        var iDCoSos = coSoSuccess
            .where((element) => element["ErrorMessage"] == null)
            .map((e) => e['IDCoso'])
            .toList();

        bkCoSoSXKDMixProvider.updateSuccess(iDCoSos);

        phieuMauTBSanPhamMixProvider.updateSuccess(iDCoSos);
        ResponseSyncModel responseSyncModel = ResponseSyncModel(
            isSuccess: true,
            responseCode: syncData.responseCode,
            responseMessage: syncData.responseMessage,
            syncResults: syncData.syncResults);

        return responseSyncModel;
      } else {
        if (syncData.responseCode == ApiConstants.invalidModelSate) {
          await uploadFullDataJson(
              syncRepository, sendErrorRepository, progress,
              isRetryWithSignIn: false);
          errorMessage = "Dữ liệu đầu vào không đúng định dạng.";
          developer
              .log('syncData.responseMessage: ${syncData.responseMessage}');
        } else if (syncData.responseCode == ApiConstants.khoaCAPI) {
          errorMessage = "Khóa CAPI đang bật.";
        } else if (syncData.responseCode == ApiConstants.duLieuDongBoRong) {
          errorMessage = "${syncData.responseMessage}";
        } else {
          errorMessage = "Lỗi đồng bộ:${syncData.responseMessage}";
          await uploadFullDataJson(
              syncRepository, sendErrorRepository, progress,
              isRetryWithSignIn: false);
        }

        ResponseSyncModel responseSyncModel = ResponseSyncModel(
            isSuccess: false,
            responseCode: syncData.responseCode,
            responseMessage: errorMessage);
        return responseSyncModel;
      }
    } else if (request.statusCode == 401) {
      errorMessage = 'Tài khoản đã hết hạn, vui lòng đăng nhập và đồng bộ lại.';
    } else if (request.statusCode == ApiConstants.errorDisconnect) {
      errorMessage = 'Kết nối mạng đã bị ngắt. Vui lòng kiểm tra lại.';
    } else if (request.statusCode == ApiConstants.errorException) {
      mustSendErrorToServer = true;
      errorMessage = 'Có lỗi: ${request.message}';
    } else if (request.statusCode == HttpStatus.requestTimeout) {
      await uploadDataJsonMixin(syncRepository, sendErrorRepository, progress,
          isRetryWithSignIn: false);
      resCode = request.statusCode.toString();
      errorMessage = 'Request timeout.';
    } else if (request.statusCode == HttpStatus.internalServerError) {
      await uploadDataJsonMixin(syncRepository, sendErrorRepository, progress,
          isRetryWithSignIn: false);
      errorMessage = 'Có lỗi: ${request.message}';
    } else {
      await uploadDataJsonMixin(syncRepository, sendErrorRepository, progress,
          isRetryWithSignIn: false);
      errorMessage =
          'Đã có lỗi xảy ra, vui lòng kiểm tra kết nối internet và thử lại!';
    }
    if (mustSendErrorToServer) {
      await uploadDataJsonMixin(syncRepository, sendErrorRepository, progress,
          isRetryWithSignIn: false);
      await uploadFullDataJson(syncRepository, sendErrorRepository, progress,
          isRetryWithSignIn: false);
    }
    ResponseSyncModel responseSyncModel = ResponseSyncModel(
        isSuccess: false,
        responseCode: request.statusCode.toString(),
        responseMessage: errorMessage);
    return responseSyncModel;
  }
  /******END::HOME SYNC*****/

  Future<Map> getPhieuMauTBs(String iDCoSo) async {
    Map mapPhieu = {};

    Map phieu = await phieuMixProvider.selectByIdCoSo(iDCoSo);

    Map phieuMauTB = await phieuMauTBMixProvider.selectByIdCoSo(iDCoSo);

    List<Map> phieuMauTBSanPhams =
        await phieuMauTBSanPhamMixProvider.selectByIdCosoSync(iDCoSo);

    List<Map> phieuNganhCNs =
        await phieuNganhCNMixProvider.selectByIdCosoSync(iDCoSo);

    Map phieuNganhVTs =
        await phieuNganhVTMixProvider.selectByIdCoSoSync(iDCoSo);

    List<Map> phieuNganhVTGhiRos =
        await phieuNganhVTGhiRoMixProvider.selectByIdCosoSync(iDCoSo);

    Map phieuNganhLTs =
        await phieuNganhLTMixProvider.selectByIdCoSoSync(iDCoSo);

    Map phieuNganhTMs =
        await phieuNganhTMMixProvider.selectByIdCoSoSync(iDCoSo);

    List<Map> phieuNganhTMSanPhams =
        await phieuNganhTMSanphamMixProvider.selectByIdCoSoSync(iDCoSo);

    if (phieu.isNotEmpty) {
      mapPhieu['PhieuDto'] = phieu;
      if (phieuMauTB.isNotEmpty) {
        mapPhieu['Phieu_MauTBDto'] = phieuMauTB;
      }

      if (phieuMauTBSanPhams.isNotEmpty) {
        mapPhieu['Phieu_MauTB_SanPhamDtos'] = phieuMauTBSanPhams;
      }
      if (phieuNganhCNs.isNotEmpty) {
        mapPhieu['Phieu_NganhCNDtos'] = phieuNganhCNs;
      }
      if (phieuNganhLTs.isNotEmpty) {
        mapPhieu['Phieu_NganhLTDto'] = phieuNganhLTs;
      }
      if (phieuNganhTMs.isNotEmpty) {
        mapPhieu['Phieu_NganhTMDto'] = phieuNganhTMs;
      }
      if (phieuNganhTMSanPhams.isNotEmpty) {
        mapPhieu['Phieu_NganhTM_SanPhamDtos'] = phieuNganhTMSanPhams;
      }
      if (phieuNganhVTs.isNotEmpty) {
        mapPhieu['Phieu_NganhVTDto'] = phieuNganhVTs;
      }
      if (phieuNganhVTGhiRos.isNotEmpty) {
        mapPhieu['Phieu_NganhVT_GhiRoDtos'] = phieuNganhVTGhiRos;
      }
    }

    return mapPhieu;
  }

  /// ******BEGIN:: SINGLE SYNC *******
  Future<ResponseSyncModel> syncSingleMixin(SyncRepository syncRepository,
      SendErrorRepository sendErrorRepository, progress,
      {bool isRetryWithSignIn = false,
      bool isSendFullDataError = false}) async {
    developer.log('BODY: ${json.encode(msgBundleBody)}');
    // developer.log('BODY: $body');
    print('$msgBundleBody');
    var resCode = '';
    var errorMessage = '';
    var mustSendErrorToServer = false;

    //  await Future.delayed(const Duration(milliseconds: 1000000));
    ResponseModel request = await syncRepository.syncDataV2(msgBundleBody,
        uploadProgress: (value) => progress.value = value);

    ///TRẢ LẠI SAU
    developer.log('SYNC SUCCESS: ${request.body}');
    if (request.statusCode == ApiConstants.errorToken && !isRetryWithSignIn) {
      var resp = await syncRepository.getToken(
          userName: AppPref.userName ?? '',
          password: AppPref.password ?? '',
          iMei: mainMenuController.userModel.value.iMei);
      AppPref.extraToken = resp.body?.accessToken;
      await syncSingleMixin(syncRepository, sendErrorRepository, progress,
          isRetryWithSignIn: true, isSendFullDataError: isSendFullDataError);
    }

    if (request.statusCode == 200) {
      SyncModel syncData = SyncModel.fromJson(jsonDecode(request.body));

      if (syncData.responseCode == ApiConstants.responseSuccess) {
        var coSoSuccess =
            jsonDecode(request.body)["Data"]["CoSoSXKDData"] as List;

        var iDCoSos = coSoSuccess
            .where((element) => element["ErrorMessage"] == null)
            .map((e) => e['IDCoso'])
            .toList();

        bkCoSoSXKDMixProvider.updateSuccess(iDCoSos);

        phieuMauTBSanPhamMixProvider.updateSuccess(iDCoSos);
        ResponseSyncModel responseSyncModel = ResponseSyncModel(
            isSuccess: true,
            responseCode: syncData.responseCode,
            responseMessage: syncData.responseMessage,
            syncResults: syncData.syncResults,
            syncResultDetailItems: syncData.syncResultDetails);

        return responseSyncModel;
      } else {
        if (syncData.responseCode == ApiConstants.invalidModelSate) {
          await uploadDataJsonMixin(
              syncRepository, sendErrorRepository, progress,
              isRetryWithSignIn: false);
          errorMessage = "Dữ liệu đầu vào không đúng định dạng.";
          developer
              .log('syncData.responseMessage: ${syncData.responseMessage}');
        } else if (syncData.responseCode == ApiConstants.khoaCAPI) {
          errorMessage = "Khóa CAPI đang bật.";
        } else if (syncData.responseCode == ApiConstants.duLieuDongBoRong) {
          errorMessage = "${syncData.responseMessage}";
        } else {
          await uploadDataJsonMixin(
              syncRepository, sendErrorRepository, progress,
              isRetryWithSignIn: false);
          errorMessage = "Lỗi đồng bộ:${syncData.responseMessage}";
          if (isSendFullDataError) {
            await uploadFullDataJson(
                syncRepository, sendErrorRepository, progress,
                isRetryWithSignIn: false);
          }
        }

        ResponseSyncModel responseSyncModel = ResponseSyncModel(
            isSuccess: false,
            responseCode: syncData.responseCode,
            responseMessage: errorMessage);
        return responseSyncModel;
      }
    } else if (request.statusCode == 401) {
      errorMessage = 'Tài khoản đã hết hạn, vui lòng đăng nhập và đồng bộ lại.';
    } else if (request.statusCode == ApiConstants.errorDisconnect) {
      errorMessage = 'Kết nối mạng đã bị ngắt. Vui lòng kiểm tra lại.';
    } else if (request.statusCode == ApiConstants.errorException) {
      mustSendErrorToServer = true;
      await uploadDataJsonMixin(syncRepository, sendErrorRepository, progress,
          isRetryWithSignIn: false);
      errorMessage = 'Có lỗi: ${request.message}';
    } else if (request.statusCode == HttpStatus.requestTimeout) {
      await uploadDataJsonMixin(syncRepository, sendErrorRepository, progress,
          isRetryWithSignIn: false);
      resCode = request.statusCode.toString();
      errorMessage = 'Request timeout.';
    } else if (request.statusCode == HttpStatus.internalServerError) {
      await uploadDataJsonMixin(syncRepository, sendErrorRepository, progress,
          isRetryWithSignIn: false);
      errorMessage = 'Có lỗi: ${request.message}';
    } else {
      await uploadDataJsonMixin(syncRepository, sendErrorRepository, progress,
          isRetryWithSignIn: false);
      errorMessage =
          'Đã có lỗi xảy ra, vui lòng kiểm tra kết nối internet và thử lại!';
    }
    if (mustSendErrorToServer) {
      await uploadDataJsonMixin(syncRepository, sendErrorRepository, progress,
          isRetryWithSignIn: false);
      //await uploadFullDataJson(syncRepository, sendErrorRepository, progress,
      //     isRetryWithSignIn: false);
    }
    ResponseSyncModel responseSyncModel = ResponseSyncModel(
        isSuccess: false,
        responseCode: request.statusCode.toString(),
        responseMessage: errorMessage);
    return responseSyncModel;
  }

  /// uploadDataJson sử dụng khi đồng bộ dữ liệu phát sinh lỗi;
  Future<ResponseSyncModel> uploadDataJsonMixin(SyncRepository syncRepository,
      SendErrorRepository sendErrorRepository, progress,
      {bool isRetryWithSignIn = false}) async {
    developer.log('FULL BODY: ${json.encode(fullBody)}');
    developer.log('FULL BODY: $fullBody');
    print('$fullBody');
    var errorMessage = '';
    var responseCode = '';
    var isSuccess = false;
    ResponseModel _request = await sendErrorRepository.sendErrorData(fullBody,
        uploadProgress: (value) => progress.value = value);
    developer.log('SEND ERROR JSON SUCCESS: ${_request.body}');

    if (_request.statusCode == ApiConstants.errorToken && !isRetryWithSignIn) {
      var resp = await syncRepository.getToken(
          userName: AppPref.userName,
          password: AppPref.password,
          iMei: mainMenuController.userModel.value.iMei);
      AppPref.accessToken = resp.body?.accessToken;
      await uploadDataJsonMixin(syncRepository, sendErrorRepository, progress,
          isRetryWithSignIn: true);
    }
    responseCode = _request.statusCode.toString();
    if (_request.statusCode == 200) {
      SendErrorModel dataSend =
          SendErrorModel.fromJson(jsonDecode(_request.body));
      errorMessage = dataSend.responseMessage ?? '';
      responseCode = dataSend.responseCode ?? '';

      if (dataSend.responseCode == ApiConstants.responseSuccess) {
        errorMessage = dataSend.responseMessage ?? '';
        isSuccess = true;
      } else {}
    } else if (_request.statusCode == 401) {
      errorMessage = 'Tài khoản đã hết hạn, vui lòng đăng nhập và đồng bộ lại.';
    } else if (_request.statusCode == ApiConstants.errorDisconnect) {
      errorMessage = 'Kết nối mạng đã bị ngắt. Vui lòng kiểm tra lại.';
    } else if (_request.statusCode == ApiConstants.errorException) {
      errorMessage = 'Có lỗi: ${_request.message}';
    } else if (_request.statusCode.toString() ==
        ApiConstants.notAllowSendFile) {
      errorMessage = _request.message ??
          'Bạn chưa được phân quyền thực hiện chức năng này.';
    } else if (_request.statusCode.toString() ==
        ApiConstants.errorMaDTVNotFound) {
      errorMessage = _request.message ?? 'Không tìm thấy dữ liệu';
    } else if (_request.statusCode == HttpStatus.requestTimeout) {
      errorMessage = 'Request timeout.';
    } else if (_request.statusCode == HttpStatus.internalServerError) {
      errorMessage = 'Có lỗi: ${_request.message}';
    } else {
      errorMessage =
          'Đã có lỗi xảy ra, vui lòng kiểm tra kết nối internet và thử lại!';
    }
    developer.log('_request.statusCode uploadDataJson ${_request.statusCode}');
    ResponseSyncModel responseSyncModel = ResponseSyncModel(
        isSuccess: isSuccess,
        responseCode: responseCode,
        responseMessage: errorMessage);
    return responseSyncModel;
  }

  Future<bool> getAllowSendFile(SendErrorRepository sendErrorRepository) async {
    bool result = false;
    var allowSendFile = await sendErrorRepository.getAllowSendFile();
    if (allowSendFile.responseCode == ApiConstants.responseSuccess) {
      if (allowSendFile.objectData != null) {
        result = allowSendFile.objectData!;
      }
    }
    return result;
  }

  Future<ResponseSyncModel> uploadFullDataJson(SyncRepository syncRepository,
      SendErrorRepository sendErrorRepository, progress,
      {bool isRetryWithSignIn = false}) async {
    var errorMessage = '';
    var responseCode = '';
    var isSuccess = false;

    var allowSendFile = await getAllowSendFile(sendErrorRepository);
    if (allowSendFile == false) {
      ResponseSyncModel responseSyncModel = ResponseSyncModel(
          isSuccess: true,
          responseCode: ApiConstants.allowSendFileOff,
          responseMessage: errorMessage);
      return responseSyncModel;
    }

    var fileModel = await getZipDbFileContent();
    // developer.log('FILE MODEL: ${fileModel.toJson()}');
    if (fileModel.dataFileContent == '') {
      fileModel = await getDbFileContent();
    }

    ResponseModel request = await sendErrorRepository.sendFullData(fileModel,
        uploadProgress: (value) => progress.value = value);
    developer.log('SEND FULL DATA SUCCESS: ${request.body}');

    if (request.statusCode == ApiConstants.errorToken && !isRetryWithSignIn) {
      var resp = await syncRepository.getToken(
          userName: AppPref.userName,
          password: AppPref.password,
          iMei: mainMenuController.userModel.value.iMei);
      AppPref.accessToken = resp.body?.accessToken;
      await uploadFullDataJson(syncRepository, sendErrorRepository, progress,
          isRetryWithSignIn: true);
    }
    responseCode = request.statusCode.toString();
    if (request.statusCode == 200) {
      SendErrorModel dataSend =
          SendErrorModel.fromJson(jsonDecode(request.body));
      errorMessage = dataSend.responseMessage ?? '';
      responseCode = dataSend.responseCode ?? '';

      if (dataSend.responseCode == ApiConstants.responseSuccess) {
        errorMessage = dataSend.responseMessage ?? '';
        isSuccess = true;
      } else {}
    } else if (request.statusCode == 401) {
      errorMessage = 'Tài khoản đã hết hạn, vui lòng đăng nhập và đồng bộ lại.';
    } else if (request.statusCode == ApiConstants.errorDisconnect) {
      errorMessage = 'Kết nối mạng đã bị ngắt. Vui lòng kiểm tra lại.';
    } else if (request.statusCode == ApiConstants.errorException) {
      errorMessage = 'Có lỗi: ${request.message}';
    } else if (request.statusCode.toString() == ApiConstants.notAllowSendFile) {
      errorMessage = request.message ??
          'Bạn chưa được phân quyền thực hiện chức năng này.';
    } else if (request.statusCode.toString() ==
        ApiConstants.errorMaDTVNotFound) {
      errorMessage = request.message ?? 'Không tìm thấy dữ liệu';
    } else if (request.statusCode == HttpStatus.requestTimeout) {
      errorMessage = 'Request timeout.';
    } else if (request.statusCode == HttpStatus.internalServerError) {
      errorMessage = 'Có lỗi: ${request.message}';
    } else {
      errorMessage =
          'Đã có lỗi xảy ra, vui lòng kiểm tra kết nối internet và thử lại!';
    }
    developer.log('_request.statusCode uploadDataJson ${request.statusCode}');
    ResponseSyncModel responseSyncModel = ResponseSyncModel(
        isSuccess: isSuccess,
        responseCode: responseCode,
        responseMessage: errorMessage);
    return responseSyncModel;
  }

  Future<FileModel> getDbFileContent() async {
    String dbPath = await DatabaseHelper.instance.getMyDatabasePath();
    String dbFilePath =
        p.join(dbPath, DatabaseHelper.instance.getMyDatabaseName());
    final dbFile = File(dbFilePath);
    final dbFileName = p.basename(dbFile.path);

    var isexistDbFile = dbFile.existsSync();
    if (isexistDbFile) {
      final fileBytes = dbFile.readAsBytesSync();
      final fileBase64 = base64Encode(fileBytes);

      var fileModel = FileModel(
          fileName: dbFileName, fileExt: "db", dataFileContent: fileBase64);
      return fileModel;
    }
    return FileModel(fileName: "", fileExt: "", dataFileContent: "");
  }

  Future<FileModel> getZipDbFileContent() async {
    String dbBackUpDir = 'dbbackup';
    String dbPath = await DatabaseHelper.instance.getMyDatabasePath();
    String dbFilePath =
        p.join(dbPath, DatabaseHelper.instance.getMyDatabaseName());
    final dbFile = File(dbFilePath);
    final dbFileName = p.basename(dbFile.path);

    Directory directory = Directory("");
    if (Platform.isAndroid) {
      directory = (await getExternalStorageDirectory())!;
    } else {
      directory = (await getApplicationDocumentsDirectory());
    }
    var dirPath = await createFolder(dbBackUpDir);
    try {
      final dir = Directory(dirPath);
      final List<FileSystemEntity> files = dir.listSync();
      for (final FileSystemEntity file in files) {
        await file.delete();
      }
    } catch (e) {
      // Error in getting access to the file.
    }

    String dtNow = DateFormat('yyyyMMddHHmmss').format(DateTime.now());
    String zipDbFileName = 'tongdtkt_tg_$dtNow.zip';
    String filePathBk = p.join(dirPath, zipDbFileName);
    // File dbFileCopied = await dbFile.copy(filePathBk);
    var isexistDbFile = dbFile.existsSync();

    final fileBytes = dbFile.readAsBytesSync();
    //zip file

    final archive = Archive();
    archive.addFile(ArchiveFile(dbFileName, fileBytes.length, fileBytes));

    final outputStream = OutputFileStream(filePathBk);
    final encoder = ZipEncoder();
    encoder.encode(archive, output: outputStream);
    await outputStream.close();

    final zipDbFile = File(filePathBk);
    if (zipDbFile.existsSync()) {
      final zipFileBytes = zipDbFile.readAsBytesSync();
      final zipFileBase64 = base64Encode(zipFileBytes);
      var zipFileModel = FileModel(
          fileName: zipDbFileName,
          fileExt: "zip",
          dataFileContent: zipFileBase64);
      return zipFileModel;
    }
    return FileModel(fileName: "", fileExt: "", dataFileContent: "");
  }

  Future<String> createFolder(String cow) async {
    final dir = Directory(
        '${(Platform.isAndroid ? await getExternalStorageDirectory() //FOR ANDROID
                : await getApplicationDocumentsDirectory() //FOR IOS
            )!.path}/$cow');
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }
    if ((await dir.exists())) {
      return dir.path;
    } else {
      dir.create();
      return dir.path;
    }
  }
/********END:: SINGLE SYNC ********/
}
