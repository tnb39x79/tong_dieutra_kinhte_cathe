import 'dart:convert';
import 'dart:developer' as developer;
import 'dart:async';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:gov_statistics_investigation_economic/config/constants/app_define.dart';
import 'package:gov_statistics_investigation_economic/modules/sync_module/mixin_sync.dart';
import 'package:gov_statistics_investigation_economic/resource/database/provider/ct_dm_phieu_provider.dart';
import 'package:gov_statistics_investigation_economic/resource/database/provider/dm_bkcoso_sxkd_nganh_sanpham_provider.dart';
import 'package:gov_statistics_investigation_economic/resource/database/provider/dm_mota_sanpham_provider.dart';
import 'package:gov_statistics_investigation_economic/resource/database/provider/provider_p07mau.dart';
import 'package:gov_statistics_investigation_economic/resource/database/provider/provider_p07mau_dm.dart';
import 'package:gov_statistics_investigation_economic/resource/database/provider/xacnhan_logic_provider.dart';
import 'package:gov_statistics_investigation_economic/resource/database/table/table_ct_dm_phieu.dart';
import 'package:gov_statistics_investigation_economic/resource/database/table/table_data.dart';
import 'package:gov_statistics_investigation_economic/resource/database/table/table_dm.dart';
import 'package:gov_statistics_investigation_economic/resource/database/table/table_dm07mau.dart';
import 'package:gov_statistics_investigation_economic/resource/database/table/table_dm_bkcoso_sxkd.dart';
import 'package:gov_statistics_investigation_economic/resource/database/table/table_dm_bkcoso_sxkd_nganh_sanpham.dart';
import 'package:gov_statistics_investigation_economic/resource/database/table/table_dm_dia_ban_coso_sxkd.dart';
import 'package:gov_statistics_investigation_economic/resource/database/table/table_dm_mota_sanpham.dart';
import 'package:gov_statistics_investigation_economic/resource/database/table/table_p07mau.dart';
import 'package:gov_statistics_investigation_economic/resource/database/table/table_user_info.dart';
import 'package:gov_statistics_investigation_economic/resource/model/reponse/response_sync_model.dart';
import 'package:gov_statistics_investigation_economic/resource/services/location/location_provider.dart';
import 'package:new_version_plus/new_version_plus.dart';
import 'package:gov_statistics_investigation_economic/common/common.dart';
import 'package:gov_statistics_investigation_economic/common/widgets/dialogs/dialog_permission.dart';
import 'package:gov_statistics_investigation_economic/config/constants/app_values.dart';
import 'package:gov_statistics_investigation_economic/modules/modules.dart';
import 'package:gov_statistics_investigation_economic/resource/model/question/data_model.dart';
import 'package:gov_statistics_investigation_economic/resource/resource.dart';
import 'package:gov_statistics_investigation_economic/routes/routes.dart';
import 'package:url_launcher/url_launcher.dart' as linking;
import 'package:package_info_plus/package_info_plus.dart';

class HomeController extends BaseController with SyncMixin {
  HomeController(
      {required this.inputDataRepository,
      required this.syncRepository,
      required this.sendErrorRepository});

  AppLifecycleState appLifecycleState = AppLifecycleState.detached;
  final InputDataRepository inputDataRepository;
  final SyncRepository syncRepository;

  final SendErrorRepository sendErrorRepository;

  bool isGrantedPermission = false;

  MainMenuController mainMenuController = Get.find();
  LoginController loginController = Get.find();

  /// String? dateTimeSaveDB;
  List<String> namePhieu = [];
  String currentTenDoiTuongDT = "".obs();

  ///Provider
  ///DB
  final dataProvider = DataProvider();
  final bkCoSoSXKDProvider = BKCoSoSXKDProvider();
  final bkCoSoSXKDNganhSanPhamProvider = BKCoSoSXKDNganhSanPhamProvider();
  final diaBanCoSoSXKDProvider = DiaBanCoSoSXKDProvider();
  final dmTinhTrangHDProvider = DmTinhTrangHDProvider();
  final dmTrangThaiDTProvider = DmTrangThaiDTProvider();
  final dmCoKhongProvider = DmCoKhongProvider();
  final dmDanTocProvider = DmDanTocProvider();
  final dmGioiTinhProvider = DmGioiTinhProvider();

  final doiTuongDieuTraProvider = DmDoiTuongDieuTraProvider();
  final dmPhieuProvider = DmPhieuProvider();
  final userInfoProvider = UserInfoProvider();

  //final dmVsicIOProvider = DmVsicIOProvider();
  //final dmDiaDiemSXKDProvider = CTDmDiaDiemSXKDProvider();
  // final dmTongHopKQProvider = DmTongHopKQProvider();
  final xacNhanLogicProvider = XacNhanLogicProvider();

  ///Phiếu Cá thể mẫu
  ///thieeus dm_cap, dm hoat dong logistic
  final ctDmHoatDongLogisticProvider = CTDmHoatDongLogisticProvider();
  final ctDmDiaDiemSXKDProvider = CTDmDiaDiemSXKDProvider();
  final ctDmLinhVucProvider = CTDmLinhVucProvider();
  final ctDmLoaiDiaDiemProvider = CTDmLoaiDiaDiemProvider();
  final ctDmNhomNganhVcpaProvider = CTDmNhomNganhVcpaProvider();
  final dmQuocTichProvider = DmQuocTichProvider();
  final ctDmTinhTrangDKKDProvider = CTDmTinhTrangDKKDProvider();
  final ctDmTrinhDoChuyenMonProvider = CTDmTrinhDoChuyenMonProvider();
  final dmMotaSanphamProvider = DmMotaSanphamProvider();
  final dmLinhvucProvider = DmLinhvucProvider();

  final phieuProvider = PhieuProvider();
  final phieuMauTBProvider = PhieuMauTBProvider();
  final phieuMauTBSanPhamProvider = PhieuMauTBSanPhamProvider();
  final phieuNganhCNProvider = PhieuNganhCNProvider();
  final phieuNganhLTProvider = PhieuNganhLTProvider();
  final phieuNganhTMProvider = PhieuNganhTMProvider();
  final phieuNganhTMSanphamProvider = PhieuNganhTMSanPhamProvider();
  final phieuNganhVTProvider = PhieuNganhVTProvider();
  final phieuNganhVTGhiRoProvider = PhieuNganhVTGhiRoProvider();

  final progress = 0.0.obs;
  final errorMessage = ''.obs;
  final isSuccess = false.obs;
  final enSync = false.obs;
  final message = ''.obs;

  @override
  void onInit() async {
    mainMenuController.setLoading(true);

    await initProvider();
    if (AppPref.isFistInstall == 0) {
      var db = await DatabaseHelper.instance.database;

      await DatabaseHelper.instance.deleteAll(db);
      await updateData();
      developer.log('First install app');
      AppPref.isFistInstall = 1;
      // Get.dialog(DialogLogPermission(
      //   onPressedNegative: () {
      //     Get.back();
      //   },
      //   onPressedPositive: () {
      //     Get.back();
      //     updateData();
      //   },
      // ));
    }
    if (AppPref.uid!.isNotEmpty) {
      Map? isHad = await hasGetDataPv();
      if (isHad == null) {
        onGetDuLieuPhieu();
      }
    }
    
    mainMenuController.setLoading(false);
    super.onInit();

    ///Kiểm tra thời gian kết thúc phỏng vấn và thời gian đăng nhập gần nhất quá n ngày (n=SoNgayHHDN)
    ///=> Logout nếu true
    var isLogout = await shouleBeLogoutToDeleteData();
    if (isLogout) {
      await logOut();
    }

    ///Kiểm tra thời gian kết thúc phỏng vấn nhỏ hơn n ngày(n=SoNgayKT) ngày hiện tại và xoaDuLieu=1
    ///=> Thực hiện xoá dữ liệu và logout
    var idDeleteDb = await isDeleteData();
    if (idDeleteDb) {
      await deleteAllData();
      await logOut();
    }
  }

  ///Xoá dữ liệu pv khi: Ngày hiện tại lớn hơn ngày kết thúc điều tra và xoaDuLieu= '1'
  isDeleteData() async {
    DateTime now = DateTime.now();
    DateTime currentDateOnly = DateTime(now.year, now.month, now.day);
    String ngayKetThuc = AppPref.ngayKetThucDT;
    String xoaDuLieu = AppPref.xoaDuLieuDT;
    if (ngayKetThuc != '') {
      try {
        DateTime ngayKT = DateTime.parse(ngayKetThuc);
        if (currentDateOnly.isAfter(ngayKT)) {
          if (xoaDuLieu == '1') {
            return true;
          }
        }
      } catch (e) {
        developer.log('kiemTraNgayKetThucDT: $e');
      }
    }
    return false;
  }

  ///Logout khi: Ngày hiện tại > ngày kết thúc điều tra và xacNhanKetThuc = '1'
  shouleBeLogoutToDeleteData() async {
    DateTime now = DateTime.now();
    DateTime currentDateOnly = DateTime(now.year, now.month, now.day);
    String ngayKetThuc = AppPref.ngayKetThucDT;
    String llDate = AppPref.lastLoginDate;

    int soNgayHetHan = 0;
    //  int.parse(AppPref.soNgayHetHanDangNhap);
    if (AppPref.soNgayHetHanDangNhap != '') {
      soNgayHetHan = int.parse(AppPref.soNgayHetHanDangNhap);
    }
    int soNgayKT = 0;
    if (AppPref.soNgayChoPhepXoaDuLieu != '') {
      soNgayKT = int.parse(AppPref.soNgayChoPhepXoaDuLieu);
    }

    if (ngayKetThuc != '') {
      try {
        DateTime ngayKT = DateTime.parse(ngayKetThuc);
        DateTime lastloginDate = DateTime.parse(llDate);
        //Số ngày = ngày hiện tại - ngày kết thúc điều tra.
        int numDays = currentDateOnly.difference(ngayKT).inDays;
        //Số ngày = ngày hiện tại - ngày đăng nhập gần nhất.
        int numDaysCurrent = currentDateOnly.difference(lastloginDate).inDays;

        if (currentDateOnly.isAfter(ngayKT)) {
          if (numDays > soNgayKT && numDaysCurrent >= soNgayHetHan) {
            return true;
          }
        }
      } catch (e) {
        developer.log('kiemTraNgayKetThucDT: $e');
      }
    }
    return false;
  }

  logOut() async {
    await AppPref.clear();
    //snackBar('Thông báo', 'Phiên đăng nhập đã hết hạn.');
    Get.offAllNamed(AppRoutes.splash);
  }

  deleteAllData() async {
    var db = await DatabaseHelper.instance.database;
    await DatabaseHelper.instance.deleteAll(db);
  }

  Future hasGetDataPv() async {
    Map? isHad = await userInfoProvider.selectLastOneWithId(AppPref.uid!);
    return isHad;
  }

  Future updateData() async {
    await LocationProVider.requestPermission();
    await LocationProVider.requestLocationServices();
    mainMenuController.setLoading(true);

    try {
      var value = await getDataFromServer();

      if (value == 1) {
        snackBar('Tải dữ liệu thành công', '',
            durationSecond: const Duration(seconds: 3));
      }
    } catch (e) {
      snackBar('Đã có lỗi xảy ra', 'Đã có lỗi xảy ra, vui lòng thử lại sau.',
          style: ToastSnackType.error);
      developer.log(e.toString());
    }
    mainMenuController.setLoading(false);
  }

  /// BEGIN::TẢI DỮ LIỆU PHỎNG VẤN
  onGetDuLieuPhieu() async {
    AppPref.setQuestionNoStartTime = '';
    mainMenuController.setLoading(true);

    await refreshLoginData();

    Map? isHad = await hasGetDataPv();
    if (isHad != null) {
      AppPref.dateTimeSaveDB = isHad['CreatedAt'];

      var resultSunc = await syncDataMixin(
          syncRepository, sendErrorRepository, progress,
          isRetryWithSignIn: false);
      developer.log(
          'sync data: ${resultSunc.responseCode}::${resultSunc.responseMessage}');

      ///Kiểm tra kết quả đồng bộ
      ///Nếu thành công thì không thông báo
      ///Nếu không thành công thì sẽ hiện dialog thông báo:" Có muốn lấy lại dữ liệu phỏng vấn không?"
      // if (resultSunc.responseCode != ApiConstants.responseSuccess && resultSunc.responseCode != ApiConstants.duLieuDongBoRong) {
      //   Get.dialog(DialogWidget(
      //     onPressedPositive: () async {
      //       Get.back();
      //       await getOnlyDataTable();
      //     },
      //     onPressedNegative: () {
      //       Get.back();
      //       mainMenuController.setLoading(false);
      //       showDialogCancelGetDuLieuPhongVan();
      //     },
      //     title: 'dialog_title_warning'.tr,
      //     content: 'Đồng bộ bị lỗi. Bạn có muốn lấy lại dữ liệu phỏng vấn ?',
      //   ));
      // }
    }
    var db = await DatabaseHelper.instance.database;
    await DatabaseHelper.instance.deleteOnlyDataTable(db);
    await updateData();
    await Future.delayed(const Duration(seconds: 2));
    mainMenuController.setLoading(false);
  }

  showDialogCancelGetDuLieuPhongVan() {
    Get.dialog(DialogBarrierWidget(
      onPressedNegative: () {},
      onPressedPositive: () async {
        Get.back();
      },
      isCancelButton: false,
      title: 'dialog_title_warning'.tr,
      content: 'Chưa lấy được dữ liệu phỏng vấn.',
      confirmText: "Đóng",
    ));
  }

  Future getOnlyDataTable() async {
    mainMenuController.setLoading(true);
    var db = await DatabaseHelper.instance.database;
    await DatabaseHelper.instance.deleteOnlyDataTable(db);
    await updateData();
    await Future.delayed(const Duration(seconds: 2));
    mainMenuController.setLoading(false);
  }

  refreshLoginData() async {
    // await loginController.login(AppPref.userName!, AppPref.password!);
    var newLoginData = jsonDecode(AppPref.loginData);
    mainMenuController.loginData.value = TokenModel.fromJson(newLoginData);

    // await reGetToken();
  }

  // Future reGetToken() async {
  //   try {
  //     final data = await syncRepository.getToken(
  //         userName: AppPref.userName, password: AppPref.password);
  //     if (data.isSuccess) {
  //       AppPref.extraToken = data.body!.accessToken;
  //     } else {
  //       if (data.statusCode == 500 || data.statusCode == 404) {
  //         snackBar('error'.tr, 'can_not_connect_serve'.tr,
  //             style: ToastSnackType.error);
  //       } else if (data.errorDescription ==
  //           'Provided username and password is incorrect') {
  //         snackBar('error'.tr, 'username_password_incorrect'.tr,
  //             style: ToastSnackType.error);
  //       } else {
  //         snackBar('error'.tr, data.errorDescription ?? 'some_error'.tr,
  //             style: ToastSnackType.error);
  //       }
  //     }
  //   } catch (e) {
  //     developer.log(e.toString());
  //   }
  // }

  Future getDataFromServer() async {
    final data = await inputDataRepository.getData();
    if (data.statusCode == 200 &&
        data.body!.responseCode == ApiConstants.responseSuccess) {
      ///Kiểm tra có lấy dm hay ko?
      if (data.body!.hasDm != null && data.body!.hasDm == '1') {
        var db = await DatabaseHelper.instance.database;
        await DatabaseHelper.instance.deleteAll(db);
      }
      String dtSaveDB = DateTime.now().toIso8601String();
      AppPref.dateTimeSaveDB = dtSaveDB;
      //   developer.log('data.body = ${jsonEncode(data.body)}');
      var tableData = TableData(
        maDTV: AppPref.uid,
        questionNo07Mau: jsonEncode(data.body!.cauHoiPhieu07Maus),
        questionNo07TB: jsonEncode(data.body!.cauHoiPhieu07TBs),
        questionNo07MauMenu: jsonEncode(data.body!.cauHoiPhieu07MauMenu),
        questionNo07TBMenu: jsonEncode(data.body!.cauHoiPhieu07TBMenu),
        maSanPhamLoaiTruCoSoCT: data.body!.maSanPhamLoaiTruCoSoCT,
        createdAt: dtSaveDB,
        updatedAt: dtSaveDB,
      );
      //print(data.body!.data);
      await insertUserInfo(dtSaveDB);
      await insertIntoDb(tableData);
      await insertDoiTuongDT(data.body!.data, dtSaveDB);
      await insertIntoTableCoSoSxkd(data.body!.data, dtSaveDB);
      if (data.body!.hasDm == '1') {
        await insertDanhMucChung(data.body!, dtSaveDB);
        await insertDanhMucPhieuMau(data.body!, dtSaveDB);
        await insertDmNhomNganhVcpa();
        await insertDanhMucMoTaSanPham(data.body!, dtSaveDB);
      }

      ///Lưu lại versionDanhMuc
      AppPref.versionDanhMuc =
          data.body!.versionDanhMuc ?? AppValues.versionDanhMuc;
      return 1;
    } else {
      snackBar('some_error'.tr, data.body!.responseDesc ?? data.message ?? '',
          style: ToastSnackType.error);
      return null;
    }
  }

  Future<Map> insertIntoDb(TableData tableData) async {
    String dtSaveDB = tableData.createdAt!;
    List<int> ids = await dataProvider.insert([tableData], dtSaveDB);
    return await dataProvider.selectOne(ids[0]);
  }

  Future insertDoiTuongDT(dynamic bodyData, String dtSaveDB) async {
    List<TableDoiTuongDieuTra> dsDoiTuongDT =
        TableData.toListDoiTuongDieuTras(bodyData);
    await doiTuongDieuTraProvider.insert(dsDoiTuongDT, dtSaveDB);
  }

  Future insertIntoTableCoSoSxkd(
      dynamic tableData, String dtSaveDB) async {
    List<TableDmDiaBanCosoSxkd> dmDiaBanCosoSxkd =
        TableData.toListDiaBanCoSoSXKDs(tableData);
    

    List<TableBkCoSoSXKD> danhSachBkCsSxkd = [];
    for (var element in dmDiaBanCosoSxkd) {
      danhSachBkCsSxkd.addAll(element.tablebkCoSoSXKD ?? []);
    }

    List<TableBkCoSoSXKDNganhSanPham> danhSachNganhSanPham = [];
    for (var element in danhSachBkCsSxkd) {
      danhSachNganhSanPham.addAll(element.tableNganhSanPhams ?? []);
    }

    await insertDmDiaBanCosoSxkd(dmDiaBanCosoSxkd, dtSaveDB);

    await insertBkCoSoxkd(danhSachBkCsSxkd, dtSaveDB);
    await insertNganhSanPham(danhSachNganhSanPham, dtSaveDB);

    await insertPhieuMau(danhSachBkCsSxkd, dtSaveDB);
  }

  Future insertDmDiaBanCosoSxkd(
      List<TableDmDiaBanCosoSxkd> dsDiaBanCosoSxkd, String dtSaveDB) async {
    await diaBanCoSoSXKDProvider.insert(dsDiaBanCosoSxkd, dtSaveDB);
  }

  Future insertBkCoSoxkd(
      List<TableBkCoSoSXKD> bkCosoSxkd, String dtSaveDB) async {
    await bkCoSoSXKDProvider.insert(bkCosoSxkd, dtSaveDB, fromGetData: true);
  }

  Future insertNganhSanPham(
      List<TableBkCoSoSXKDNganhSanPham> bkCosoSxkdNganhSanPham,
      String dtSaveDB) async {
    await bkCoSoSXKDNganhSanPhamProvider.insert(
        bkCosoSxkdNganhSanPham, dtSaveDB);
  }

  Future insertPhieuMau(
      List<TableBkCoSoSXKD> danhSachBkCsSxkd, String dtSaveDB) async {
    List<TablePhieu> danhSachPhieu = [];
    List<TablePhieuMauTB> danhSachPhieuMauTB = [];
    List<TablePhieuMauTBSanPham> danhSachPhieuMauTBSanPham = [];
    List<TablePhieuNganhCN> danhSachPhieuNganhCN = [];
    List<TablePhieuNganhLT> danhSachPhieuNganhLT = [];
    List<TablePhieuNganhTM> danhSachPhieuNganhTM = [];
    List<TablePhieuNganhTMSanPham> danhSachPhieuNganhTMSanPham = [];
    List<TablePhieuNganhVT> danhSachPhieuNganhVT = [];
    List<TablePhieuNganhVTGhiRo> danhSachPhieuNganhVTGhiRos = [];

    for (var element in danhSachBkCsSxkd) {
      if (element.tablePhieu != null) {
        danhSachPhieu.add(element.tablePhieu!);
        if (element.tablePhieu!.tablePhieuMauTB != null) {
          danhSachPhieuMauTB.add(element.tablePhieu!.tablePhieuMauTB!);
        }
        if (element.tablePhieu!.tablePhieuMauTBSanPham != null) {
          danhSachPhieuMauTBSanPham
              .addAll(element.tablePhieu!.tablePhieuMauTBSanPham!);
        }
        if (element.tablePhieu!.tablePhieuNganhCN != null) {
          danhSachPhieuNganhCN.addAll(element.tablePhieu!.tablePhieuNganhCN!);
        }
        if (element.tablePhieu!.tablePhieuNganhLT != null) {
          danhSachPhieuNganhLT.add(element.tablePhieu!.tablePhieuNganhLT!);
        }
        if (element.tablePhieu!.tablePhieuNganhTM != null) {
          danhSachPhieuNganhTM.add(element.tablePhieu!.tablePhieuNganhTM!);
        }
        if (element.tablePhieu!.tablePhieuNganhTMSanPham != null) {
          danhSachPhieuNganhTMSanPham
              .addAll(element.tablePhieu!.tablePhieuNganhTMSanPham!);
        }
        if (element.tablePhieu!.tablePhieuNganhVT != null) {
          danhSachPhieuNganhVT.add(element.tablePhieu!.tablePhieuNganhVT!);

          if (element.tablePhieu!.tablePhieuNganhVT!.tablePhieuNganhVTGhiRos !=
              null) {
            danhSachPhieuNganhVTGhiRos.addAll(element
                .tablePhieu!.tablePhieuNganhVT!.tablePhieuNganhVTGhiRos!);
          }
        }
      }
    }
    await phieuProvider.insert(danhSachPhieu, dtSaveDB);
    await phieuMauTBProvider.insert(danhSachPhieuMauTB, dtSaveDB);
    await phieuMauTBSanPhamProvider.insert(danhSachPhieuMauTBSanPham, dtSaveDB);
    await phieuNganhCNProvider.insert(danhSachPhieuNganhCN, dtSaveDB);

    await phieuNganhLTProvider.insert(danhSachPhieuNganhLT, dtSaveDB);
    await phieuNganhTMProvider.insert(danhSachPhieuNganhTM, dtSaveDB);
    await phieuNganhTMSanphamProvider.insert(
        danhSachPhieuNganhTMSanPham, dtSaveDB);
    await phieuNganhVTProvider.insert(danhSachPhieuNganhVT, dtSaveDB);

    await phieuNganhVTGhiRoProvider.insert(
        danhSachPhieuNganhVTGhiRos, dtSaveDB);
  }

  Future insertUserInfo(String dtSaveDB) async {
    UserModel userModel = mainMenuController.userModel.value;
    var tableUserInfo = TableUserInfo();
    tableUserInfo
      ..maDangNhap = userModel.maDangNhap
      ..tenNguoiDung = userModel.tenNguoiDung
      ..matKhau = userModel.matKhau
      ..maTinh = userModel.maTinh
      ..maTKCS = userModel.maTKCS
      ..diaChi = userModel.diaChi
      ..sdt = userModel.sDT
      ..ghiChu = userModel.ghiChu
      ..iMei = userModel.iMei
      ..ngayCapNhat = userModel.ngayCapNhat
      ..createdAt = dtSaveDB
      ..updatedAt = dtSaveDB;

    await userInfoProvider.insert([tableUserInfo], dtSaveDB);
  }

  Future insertDanhMucChung(DataModel bodyData, String dtSaveDB) async {
    List<TableCTDmPhieu> dmPhieu = TableData.toListCTDmPhieus(bodyData.dmPhieu);

    // if (AppPref.isFistInstall == 0) {
    List<TableDmTinhTrangHD> dmTinhTrangHD =
        TableData.toListTinhTrangHDs(bodyData.danhSachTinhTrangHD);

    List<TableDmTrangThaiDT> dmTrangThaiDT =
        TableData.toListTrangThaiDTs(bodyData.danhSachTrangThaiDT);

    List<TableDmCoKhong> dmCoKhong =
        TableData.toListDmCoKhongs(bodyData.dmCoKhong);
    List<TableDmGioiTinh> dmGioiTinh =
        TableData.toListDmGioiTinhs(bodyData.dmGioiTinh);
    List<TableDmDanToc> dmDanToc = TableData.toListDmDanTocs(bodyData.dmDanToc);

    await dmPhieuProvider.insert(dmPhieu, dtSaveDB);
    await dmTinhTrangHDProvider.insert(dmTinhTrangHD, dtSaveDB);
    await dmTrangThaiDTProvider.insert(dmTrangThaiDT, dtSaveDB);
    await dmCoKhongProvider.insert(dmCoKhong, dtSaveDB);
    await dmGioiTinhProvider.insert(dmGioiTinh, dtSaveDB);
    await dmDanTocProvider.insert(dmDanToc, dtSaveDB);
    // }
  }

  Future insertDanhMucPhieuMau(DataModel bodyData, String dtSaveDB) async {
    // if (AppPref.isFistInstall == 0) {
    //  List<TableDmCap> dmCap = TableData.toListCTDmCaps(bodyData.ctDmCap);
    List<TableCTDmHoatDongLogistic> dmHoatDongLogistic =
        TableData.toListCTDmHoatDongLogistics(bodyData.ctDmHoatDongLogistic);
    List<TableCTDmDiaDiemSXKD> dmDiaDiemSxkd =
        TableData.toListCTDiaDiemSXKDs(bodyData.ctDmDiaDiemSXKDDtos);
    List<TableCTDmLoaiDiaDiem> dmLoaiDiaDiem =
        TableData.toListCTLoaiDiaDiems(bodyData.ctDmLoaiDiaDiem);

    List<TableCTDmLinhVuc> dmLinhVuc =
        TableData.toListCTLinhVucs(bodyData.ctDmLinhVuc);
    List<TableCTDmTinhTrangDKKD> dmTinhTrangSXKD =
        TableData.toListCTDmTinhTrangSXKDs(bodyData.ctDmTinhTrangDKKD);
    List<TableCTDmTrinhDoChuyenMon> dmTrinhDoChuyenMon =
        TableData.toListCTDmTrinhDoChuyenMons(bodyData.ctDmTrinhDoChuyenMon);
    List<TableCTDmQuocTich> dmQuocTich =
        TableData.toListCTDmQuocTichs(bodyData.ctDmQuocTich);

    await ctDmHoatDongLogisticProvider.insert(dmHoatDongLogistic, dtSaveDB);
    await ctDmDiaDiemSXKDProvider.insert(dmDiaDiemSxkd, dtSaveDB);
    await ctDmLoaiDiaDiemProvider.insert(dmLoaiDiaDiem, dtSaveDB);

    await ctDmLinhVucProvider.insert(dmLinhVuc, dtSaveDB);
    await ctDmTinhTrangDKKDProvider.insert(dmTinhTrangSXKD, dtSaveDB);
    await ctDmTrinhDoChuyenMonProvider.insert(dmTrinhDoChuyenMon, dtSaveDB);
    await dmQuocTichProvider.insert(dmQuocTich, dtSaveDB);
    //  }

//export 'ct_dm_nhomnganh_vcpa_provider.dart';
  }

  Future insertDmNhomNganhVcpa() async {
    var countRes = await ctDmNhomNganhVcpaProvider.countAll();
    if (countRes <= 0) {
      final String response =
          await rootBundle.loadString('assets/datavc/nhomnganhvcpa.json');

      List<dynamic> dataC8 = await json.decode(response);

      await ctDmNhomNganhVcpaProvider.insertNhomNganhVcpa(dataC8, '');
      AppPref.savedNhomNganhVcpa = true;
    }
  }

  Future insertDanhMucMoTaSanPham(DataModel bodyData, String dtSaveDB) async {
    //  if (AppPref.isFistInstall == 0) {
    List<TableDmLinhvuc> dmLinhVuc =
        TableData.toListDmLinhVuc(bodyData.dmLinhVuc);

    List<TableDmMotaSanpham> dmMoTaSanPham =
        TableData.toLisMoTaSanPhamVcpas(bodyData.dmMoTaSanPham);

    await dmLinhvucProvider.insert(dmLinhVuc, dtSaveDB);
    await dmMotaSanphamProvider.insert(dmMoTaSanPham, dtSaveDB);
    // }
  }

  /// END::TẢI DỮ LIỆU PHỎNG VẤN

  onInterViewScreen() async {
    Map? isHad = await hasGetDataPv();
    if (isHad != null) {
      //if (isDefaultUserType()) {
      AppPref.dateTimeSaveDB = isHad['CreatedAt'];
      Get.toNamed(AppRoutes.interviewObjectList);
      // } else {
      //   await goToGeneralInformation();
      // }
    } else {
      snackBar(
        'not_had_db'.tr,
        'need_update_db'.tr,
        style: ToastSnackType.error,
      );
    }
  }

  onSyncDataScreen() async {
    Get.toNamed(AppRoutes.sync);
  }

  onProgressViewScreen() async {
    Get.toNamed(AppRoutes.progress, arguments: {});
  }

  Future initProvider() async {
    await dataProvider.init();
    await doiTuongDieuTraProvider.init();
    await dmPhieuProvider.init();
    await bkCoSoSXKDProvider.init();
    await bkCoSoSXKDNganhSanPhamProvider.init();
    await diaBanCoSoSXKDProvider.init();
    await userInfoProvider.init();
    await dmTinhTrangHDProvider.init();
    await dmTrangThaiDTProvider.init();
    await dmCoKhongProvider.init();
    await dmDanTocProvider.init();
    await dmGioiTinhProvider.init();

    await xacNhanLogicProvider.init();

    ///DM Phiếu 07 mau

    await ctDmHoatDongLogisticProvider.init();
    await ctDmLinhVucProvider.init();
    await ctDmDiaDiemSXKDProvider.init();
    await ctDmLoaiDiaDiemProvider.init();
    await dmQuocTichProvider.init();
    await ctDmTinhTrangDKKDProvider.init();
    await ctDmTrinhDoChuyenMonProvider.init();
    await ctDmNhomNganhVcpaProvider.init();
    await dmMotaSanphamProvider.init();
    await dmLinhvucProvider.init();

    ///Phiếu 07 mau
    await phieuProvider.init();
    await phieuMauTBProvider.init();
    await phieuMauTBSanPhamProvider.init();
    await phieuNganhCNProvider.init();

    await phieuNganhLTProvider.init();
    await phieuNganhTMProvider.init();
    await phieuNganhTMSanphamProvider.init();
    await phieuNganhVTProvider.init();
    await phieuNganhVTGhiRoProvider.init();
  }

  Future checkUpdateApp() async {
    // snackBar('dialog_title_warning'.tr, 'Đang cập nhật');

    mainMenuController.setLoading(true);
    VersionStatus? status = await mainMenuController.getCurrentVersion();

    mainMenuController.setLoading(false);

    /// True if the there is a more recent version of the app in the store.
    bool isNewVersion = status != null && status.canUpdate;

    if (isNewVersion) {
      developer.log('----- Check version store --------');
      developer.log('releaseNotes: ${status.releaseNotes}');
      developer.log('localVersion: ${status.localVersion}');
      developer.log('storeVersion: ${status.storeVersion}');
      developer.log('appStoreLink: ${status.appStoreLink}');
      developer.log('-----+++++++++++++++++++++--------');

      AppPref.currentVersion = status.localVersion;
      Get.dialog(DialogWidget(
          onPressedPositive: () async {
            Get.back();
            await syncData();
            linking.launch(status.appStoreLink);
          },
          onPressedNegative: () {
            Get.back();
          },
          title: 'Đã có phiên bản mới',
          content:
              'Chọn "Đồng ý" để cập nhật phiên bản mới nhất(${status.storeVersion} ).'));
    } else if (Platform.isIOS) {
      mainMenuController.setLoading(true);

      ///await syncData(syncRepository: syncRepository);
      ///edited by tuannb 08/09/2024
      await syncData();
      mainMenuController.setLoading(false);
      Get.back();
      linking.launch(Uri.encodeFull(AppValues.urlStore));
    } else {
      Get.dialog(DialogWidget(
        onPressedPositive: () {
          Get.back();
        },
        onPressedNegative: () {
          Get.back();
        },
        title: 'update_app_title'.tr,
        isCancelButton: false,
        content: 'Bạn đang sử dụng phiên bản mới nhât',
      ));
    }
  }

  ///Tải model AI
  onDownloadModelAI() async {
    // Get.toNamed(AppRoutes.downloadModelAI);
    Get.toNamed(AppRoutes.downloadModelAI_V2);
  }

  Future syncData() async {
    // resetVarBeforeSync();
    // endSync(false);
    await getData();
    var resSync =
        await uploadDataMixin(syncRepository, sendErrorRepository, progress);
    // responseCode.value = resSync.responseCode ?? '';
    if (resSync.responseCode == ApiConstants.responseSuccess) {
      //   responseMessage.value = resSync.responseMessage ?? "Đồng bộ thành công.";
    } else {
      // responseMessage.value = resSync.responseMessage ?? "Đồng bộ lỗi.";
    }

    // endSync(true);
  }

  isDefaultUserType() {
    var userModel = mainMenuController.userModel.value;
    if (userModel.maDangNhap != null && userModel.maDangNhap != '') {
      return (userModel.maDangNhap!.characters.first == "D" ||
              userModel.maDangNhap!.characters.first == "d") ||
          (userModel.maDangNhap!.characters.first == "H" ||
              userModel.maDangNhap!.characters.first == "h") ||
          (userModel.maDangNhap!.characters.first == "T" ||
              userModel.maDangNhap!.characters.first == "t");
    } else {
      return (AppPref.uid!.characters.first == "D" ||
              AppPref.uid!.characters.first == "d") ||
          (AppPref.uid!.characters.first == "H" ||
              AppPref.uid!.characters.first == "h") ||
          (userModel.maDangNhap!.characters.first == "T" ||
              userModel.maDangNhap!.characters.first == "t");
    }
  }

/**
 * BEGIN::TỰ KÊ KHAI
*/
  goToGeneralInformation() async {
    //Lấy mã phiếu
    var bkCoSo = await bkCoSoSXKDProvider.getInformation(AppPref.uid!);
    if (bkCoSo != null) {
      var bkCosoSXKD = TableBkCoSoSXKD.fromJson(bkCoSo);

      //lấy tên đối tượng điều tra
      //
      String tenDoiTuongDT = '';
      var doiTuongDTs = <TableDoiTuongDieuTra>[];
      List<Map> doiTuongMaps = await doiTuongDieuTraProvider.selectOneWithMaDT(
          maDT: bkCosoSXKD.loaiPhieu!.toString());
      for (var element in doiTuongMaps) {
        doiTuongDTs.add(TableDoiTuongDieuTra.fromJson(element));
      }
      if (doiTuongDTs.isNotEmpty) {
        var doiTuong = doiTuongDTs.first;
        tenDoiTuongDT = doiTuong.tenDoiTuongDT ?? '';
      }
      //
      List<Map> map =
          await diaBanCoSoSXKDProvider.selectByMaPhieu(bkCosoSXKD.loaiPhieu!);
      var diaBanCoSoSXKDs = <TableDmDiaBanCosoSxkd>[];
      for (var element in map) {
        diaBanCoSoSXKDs.add(TableDmDiaBanCosoSxkd.fromJson(element));
      }
      if (diaBanCoSoSXKDs.isNotEmpty) {
        int index = 0;
        await insertNewPhieu07MauTBCxx(bkCosoSXKD);

        Get.toNamed(AppRoutes.generalInformation, parameters: {
          GeneralInformationController.giMaDoiTuongDTKey:
              bkCosoSXKD.loaiPhieu!.toString(),
          GeneralInformationController.giTenDoiTuongDTKey: tenDoiTuongDT,
          GeneralInformationController.giMaTinhTrangDTKey:
              bkCosoSXKD.maTrangThaiDT == AppDefine.hoanThanhPhongVan
                  ? AppDefine.dangPhongVan.toString()
                  : AppDefine.chuaPhongVan.toString(),
          GeneralInformationController.giMaDiaBanKey:
              diaBanCoSoSXKDs[index].maDiaBan!,
          GeneralInformationController.giMaXaKey: diaBanCoSoSXKDs[index].maXa!,
          GeneralInformationController.giCoSoSXKDIdKey: bkCosoSXKD.iDCoSo!
        });
      }
    }
  }

  insertNewPhieu07MauTBCxx(TableBkCoSoSXKD tableBkCoSoSXKD) async {
    var maTrangThaiHD = AppDefine.maTinhTrangHDTuKeKhai;
    var phieuMau = await phieuProvider.selectByIdCoSo(AppPref.uid!);
    if (phieuMau.isNotEmpty) {
      // await phieuMauProvider.updateById(columnMaTinhTrangHD,
      //     currentIndex.value + 1, TablePhieuMau.fromJson(phieuMau).id!);
    } else {
      var maNganhs = await bkCoSoSXKDNganhSanPhamProvider
          .selectMaNganhByIdCoSo(tableBkCoSoSXKD.iDCoSo!);
      var maNganhMau = '';
      if (maNganhs.isNotEmpty) {
        maNganhMau = maNganhs.first;
        await initRecordPhieu07Mau(tableBkCoSoSXKD, maNganhMau, maTrangThaiHD);
      }
    }
  }

  Future initRecordPhieu07Mau(TableBkCoSoSXKD tableBkCoSoSXKD, String maNganh,
      int maTrangThaiHD) async {
    List<TablePhieu> tableP07Maus = [];

    var tableP07 = TablePhieu(
        loaiPhieu: tableBkCoSoSXKD.loaiPhieu,
        iDCoSo: tableBkCoSoSXKD.iDCoSo,
        maTinh: tableBkCoSoSXKD.maTinh!,
        maTKCS: tableBkCoSoSXKD.maTKCS,
        maXa: tableBkCoSoSXKD.maXa,
        maThon: tableBkCoSoSXKD.maThon,
        iDDB: tableBkCoSoSXKD.iDDB,
        maDiaBan: tableBkCoSoSXKD.maDiaBan,
        maCoSo: tableBkCoSoSXKD.maCoSo,
        tenCoSo: tableBkCoSoSXKD.tenCoSo,
        diaChi: tableBkCoSoSXKD.diaChi,
        tenChuCoSo: tableBkCoSoSXKD.tenChuCoSo,
        sDTCoSo: tableBkCoSoSXKD.dienThoai,
        maNganhMau: maNganh,
        maDTV: AppPref.uid);
    tableP07Maus.add(tableP07);
    await phieuProvider.insert(tableP07Maus, AppPref.dateTimeSaveDB!);
  }
/**
 * END::TỰ KÊ KHAI
*/

  @override
  void onDetached() {
    print('HomeController - onDetached called');
  }

  // Mandatory
  @override
  void onInactive() {
    print('HomeController - onInative called');
  }

  // Mandatory
  @override
  void onPaused() {
    print('HomeController - onPaused called');
  }

  // Mandatory
  @override
  void onResumed() {
    print('HomeController - onResumed called');
    var isLogout = shouleBeLogoutToDeleteData();
    isLogout.then((value) {
      if (value) {
        mainMenuController.onPressLogOut();
      }
    });
  }

  @override
  void onHidden() {
    // TODO: implement onHidden
  }
}
