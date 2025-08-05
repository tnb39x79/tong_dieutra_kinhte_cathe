import 'dart:convert';
import 'dart:developer' as developer;
import 'dart:async';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:gov_statistics_investigation_economic/config/constants/app_define.dart';
import 'package:gov_statistics_investigation_economic/modules/sync_module/mixin_sync.dart';
import 'package:gov_statistics_investigation_economic/resource/database/provider/dm_bkcoso_sxkd_nganh_sanpham_provider.dart';
import 'package:gov_statistics_investigation_economic/resource/database/provider/dm_cokhong_provider.dart';
import 'package:gov_statistics_investigation_economic/resource/database/provider/dm_dantoc_provider.dart';
import 'package:gov_statistics_investigation_economic/resource/database/provider/dm_gioitinh_provider.dart';
import 'package:gov_statistics_investigation_economic/resource/database/provider/dm_linhvuc_provider.dart';
import 'package:gov_statistics_investigation_economic/resource/database/provider/dm_mota_sanpham_provider.dart';
import 'package:gov_statistics_investigation_economic/resource/database/provider/provider_p07mau.dart';
import 'package:gov_statistics_investigation_economic/resource/database/provider/provider_p07mau_dm.dart';
import 'package:gov_statistics_investigation_economic/resource/database/provider/provider_p08.dart';
import 'package:gov_statistics_investigation_economic/resource/database/provider/provider_p08dm.dart';
import 'package:gov_statistics_investigation_economic/resource/database/provider/tg_dm_loai_tongiao_provider.dart';
import 'package:gov_statistics_investigation_economic/resource/database/provider/xacnhan_logic_provider.dart';
import 'package:gov_statistics_investigation_economic/resource/database/table/table_ct_dm_cap.dart';
import 'package:gov_statistics_investigation_economic/resource/database/table/table_ct_dm_quoctich.dart';
import 'package:gov_statistics_investigation_economic/resource/database/table/table_data.dart';
import 'package:gov_statistics_investigation_economic/resource/database/table/table_dm.dart';
import 'package:gov_statistics_investigation_economic/resource/database/table/table_dm07mau.dart';
import 'package:gov_statistics_investigation_economic/resource/database/table/table_dm08.dart';
import 'package:gov_statistics_investigation_economic/resource/database/table/table_dm_bkcoso_sxkd.dart';
import 'package:gov_statistics_investigation_economic/resource/database/table/table_dm_bkcoso_sxkd_nganh_sanpham.dart';
import 'package:gov_statistics_investigation_economic/resource/database/table/table_dm_bkcoso_tongiao.dart';
import 'package:gov_statistics_investigation_economic/resource/database/table/table_dm_cokhong.dart';
import 'package:gov_statistics_investigation_economic/resource/database/table/table_dm_dantoc.dart';
import 'package:gov_statistics_investigation_economic/resource/database/table/table_dm_dia_ban_coso_sxkd.dart';
import 'package:gov_statistics_investigation_economic/resource/database/table/table_dm_dia_ban_coso_tongiao.dart';
import 'package:gov_statistics_investigation_economic/resource/database/table/table_dm_gioitinh.dart';
import 'package:gov_statistics_investigation_economic/resource/database/table/table_dm_linhvuc.dart';
import 'package:gov_statistics_investigation_economic/resource/database/table/table_dm_mota_sanpham.dart';
import 'package:gov_statistics_investigation_economic/resource/database/table/table_p07mau.dart';
import 'package:gov_statistics_investigation_economic/resource/database/table/table_p08.dart';
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

  //added by tuannb 12/07/2024
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
  final bkCoSoTonGiaoProvider = BKCoSoTonGiaoProvider();
  final bkCoSoSXKDProvider = BKCoSoSXKDProvider();
  final bkCoSoSXKDNganhSanPhamProvider = BKCoSoSXKDNganhSanPhamProvider();
  final diaBanCoSoTonGiaoProvider = DiaBanCoSoTonGiaoProvider();
  final diaBanCoSoSXKDProvider = DiaBanCoSoSXKDProvider();
  final dmTinhTrangHDProvider = DmTinhTrangHDProvider();
  final dmTrangThaiDTProvider = DmTrangThaiDTProvider();
  final dmCoKhongProvider = DmCoKhongProvider();
  final dmDanTocProvider = DmDanTocProvider();
  final dmGioiTinhProvider = DmGioiTinhProvider();

  final doiTuongDieuTraProvider = DmDoiTuongDieuTraProvider();
  final userInfoProvider = UserInfoProvider();

  //final dmVsicIOProvider = DmVsicIOProvider();
  //final dmDiaDiemSXKDProvider = CTDmDiaDiemSXKDProvider();
  // final dmTongHopKQProvider = DmTongHopKQProvider();
  final xacNhanLogicProvider = XacNhanLogicProvider();

  ///Phiếu Cá thể mẫu
  ///thieeus dm_cap, dm hoat dong logistic
  final ctDmCapProvider = DmCapProvider();
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

  final phieuMauProvider = PhieuMauProvider();
  final phieuMauA61Provider = PhieuMauA61Provider();
  final phieuMauA68Provider = PhieuMauA68Provider();
  final phieuMauSanphamProvider = PhieuMauSanphamProvider();

  ///Phiếu Tôn giáo
  final tgDmCapCongNhanProvider = TGDmCapCongNhanProvider();
  final tgDmLoaiCoSoProvider = TGDmLoaiCoSoProvider();
  final tgDmLoaiHinhTonGiaoProvider = TGDmLoaiHinhTonGiaoProvider();
  final tgDmNangLuongProvider = TGDmNangLuongProvider();
  final tgDmSuDungPhanMemProvider = TGDmSuDungPhanMemProvider();
  final tgDmTrinhDoChuyenMonProvider = TGDmTrinhDoChuyenMonProvider();
  final tgDmXepHangProvider = TGDmXepHangProvider();
  final tgDmXepHangDiTichProvider = TGDmXepHangDiTichProvider();
  final tgDmLoaiTonGiaoProvider = TGDmLoaiTonGiaoProvider();

  final phieuTonGiaoProvider = PhieuTonGiaoProvider();
  final phieuTonGiaoA43Provider = PhieuTonGiaoA43Provider();

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
    //String dtSaveDB = DateTime.now().toIso8601String();

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
    await loginController.login(AppPref.userName!, AppPref.password!);
    var newLoginData = jsonDecode(AppPref.loginData);
    mainMenuController.loginData.value = TokenModel.fromJson(newLoginData);

    await reGetToken();
  }

  Future reGetToken() async {
    try {
      final data = await syncRepository.getToken(
          userName: AppPref.userName, password: AppPref.password);
      if (data.isSuccess) {
        AppPref.extraToken = data.body!.accessToken;
      } else {
        if (data.statusCode == 500 || data.statusCode == 404) {
          snackBar('error'.tr, 'can_not_connect_serve'.tr,
              style: ToastSnackType.error);
        } else if (data.errorDescription ==
            'Provided username and password is incorrect') {
          snackBar('error'.tr, 'username_password_incorrect'.tr,
              style: ToastSnackType.error);
        } else {
          snackBar('error'.tr, data.errorDescription ?? 'some_error'.tr,
              style: ToastSnackType.error);
        }
      }
    } catch (e) {
      developer.log(e.toString());
    }
  }

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
      //  questionNo08: jsonEncode(data.body!.cauHoiPhieu08s),
        createdAt: dtSaveDB,
        updatedAt: dtSaveDB,
      );
      //print(data.body!.data);
      await insertUserInfo(dtSaveDB);
      await insertIntoDb(tableData);
      await insertDoiTuongDT(data.body!.data, dtSaveDB);
      await insertIntoTableCoSoSxkdVaTonGiao(data.body!.data, dtSaveDB);
      if (data.body!.hasDm == '1') {
        await insertDanhMucChung(data.body!, dtSaveDB);
        await insertDanhMucPhieuMau(data.body!, dtSaveDB);
     //   await insertDanhMucTonGiao(data.body!, dtSaveDB);
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

  Future insertIntoTableCoSoSxkdVaTonGiao(
      dynamic tableData, String dtSaveDB) async {
    List<TableDmDiaBanCosoSxkd> dmDiaBanCosoSxkd =
        TableData.toListDiaBanCoSoSXKDs(tableData);
    // List<TableDmDiaBanTonGiao> dmDiaBanTonGiao =
    //     TableData.toListDiaBanTonGiaos(tableData);

    List<TableBkCoSoSXKD> danhSachBkCsSxkd = [];
    for (var element in dmDiaBanCosoSxkd) {
      danhSachBkCsSxkd.addAll(element.tablebkCoSoSXKD ?? []);
    }

    List<TableBkCoSoSXKDNganhSanPham> danhSachNganhSanPham = [];
    for (var element in danhSachBkCsSxkd) {
      danhSachNganhSanPham.addAll(element.tableNganhSanPhams ?? []);
    }

    // List<TableBkTonGiao> danhSachBKCoSoTonGiao = [];

    // for (var element in dmDiaBanTonGiao) {
    //   danhSachBKCoSoTonGiao.addAll(element.tableBkTonGiao ?? []);
    // }

    await insertDmDiaBanCosoSxkd(dmDiaBanCosoSxkd, dtSaveDB);
   // await insertDmDiaBanCoSoTonGiao(dmDiaBanTonGiao, dtSaveDB);

    await insertBkCoSoxkd(danhSachBkCsSxkd, dtSaveDB);
    await insertNganhSanPham(danhSachNganhSanPham, dtSaveDB);
   // await insertBkCoSoTonGiao(danhSachBKCoSoTonGiao, dtSaveDB);

    await insertPhieuMau(danhSachBkCsSxkd, dtSaveDB);
  //  await insertPhieuTonGiao(danhSachBKCoSoTonGiao, dtSaveDB);
  }

  Future insertDmDiaBanCosoSxkd(
      List<TableDmDiaBanCosoSxkd> dsDiaBanCosoSxkd, String dtSaveDB) async {
    await diaBanCoSoSXKDProvider.insert(dsDiaBanCosoSxkd, dtSaveDB);
  }

  Future insertDmDiaBanCoSoTonGiao(
      List<TableDmDiaBanTonGiao> dsDiaBanCoSoTonGiao, String dtSaveDB) async {
    await diaBanCoSoTonGiaoProvider.insert(dsDiaBanCoSoTonGiao, dtSaveDB);
  }

  Future insertBkCoSoxkd(
      List<TableBkCoSoSXKD> bkCosoSxkd, String dtSaveDB) async {
    await bkCoSoSXKDProvider.insert(bkCosoSxkd, dtSaveDB,fromGetData: true);
  }

  Future insertNganhSanPham(
      List<TableBkCoSoSXKDNganhSanPham> bkCosoSxkdNganhSanPham,
      String dtSaveDB) async {
    await bkCoSoSXKDNganhSanPhamProvider.insert(
        bkCosoSxkdNganhSanPham, dtSaveDB);
  }

  Future insertBkCoSoTonGiao(
      List<TableBkTonGiao> bkCoSoTG, String dtSaveDB) async {
    await bkCoSoTonGiaoProvider.insert(bkCoSoTG, dtSaveDB);
  }

  Future insertPhieuMau(
      List<TableBkCoSoSXKD> danhSachBkCsSxkd, String dtSaveDB) async {
    List<TablePhieuMau> danhSachPhieuMau = [];
    List<TablePhieuMauA61> danhSachPhieuMauA61 = [];
    List<TablePhieuMauA68> danhSachPhieuMauA68 = [];
    List<TablePhieuMauSanPham> danhSachPhieuMauSanPham = [];

    for (var element in danhSachBkCsSxkd) {
      if (element.tablePhieuMau != null) {
        danhSachPhieuMau.add(element.tablePhieuMau!);
        if (element.tablePhieuMau!.tablePhieuMauA61 != null) {
          danhSachPhieuMauA61.addAll(element.tablePhieuMau!.tablePhieuMauA61!);
        }
        if (element.tablePhieuMau!.tablePhieuMauA68 != null) {
          danhSachPhieuMauA68.addAll(element.tablePhieuMau!.tablePhieuMauA68!);
        }
        if (element.tablePhieuMau!.tablePhieuMauSanPham != null) {
          danhSachPhieuMauSanPham
              .addAll(element.tablePhieuMau!.tablePhieuMauSanPham!);
        }
      }
    }
    await phieuMauProvider.insert(danhSachPhieuMau, dtSaveDB);
    await phieuMauA61Provider.insert(danhSachPhieuMauA61, dtSaveDB);
    await phieuMauA68Provider.insert(danhSachPhieuMauA68, dtSaveDB);
    await phieuMauSanphamProvider.insert(danhSachPhieuMauSanPham, dtSaveDB);
  }

  Future insertPhieuTonGiao(
      List<TableBkTonGiao> danhSachBKCoSoTG, String dtSaveDB) async {
    List<TablePhieuTonGiao> danhSachPhieuTonGiao = [];
    List<TablePhieuTonGiaoA43> danhSachPhieuTonGiaoA43 = [];

    for (var element in danhSachBKCoSoTG) {
      if (element.tablePhieuTonGiao != null) {
        danhSachPhieuTonGiao.add(element.tablePhieuTonGiao!);
        if (element.tablePhieuTonGiao!.tablePhieuTonGiaoA43 != null) {
          danhSachPhieuTonGiaoA43
              .addAll(element.tablePhieuTonGiao!.tablePhieuTonGiaoA43!);
        }
      }
    }
    await phieuTonGiaoProvider.insert(danhSachPhieuTonGiao, dtSaveDB);

    await phieuTonGiaoA43Provider.insert(danhSachPhieuTonGiaoA43, dtSaveDB);
  }

  Future insertUserInfo(String dtSaveDB) async {
    UserModel userModel = mainMenuController.userModel.value;
    var tableUserInfo = TableUserInfo();
    tableUserInfo
      ..maDangNhap = userModel.maDangNhap
      ..tenNguoiDung = userModel.tenNguoiDung
      ..matKhau = userModel.matKhau
      ..maPBCC = userModel.maPBCC
      ..diaChi = userModel.diaChi
      ..sdt = userModel.sDT
      ..ghiChu = userModel.ghiChu
      ..ngayCapNhat = userModel.ngayCapNhat
      ..createdAt = dtSaveDB
      ..updatedAt = dtSaveDB;

    await userInfoProvider.insert([tableUserInfo], dtSaveDB);
  }

  Future insertDanhMucChung(DataModel bodyData, String dtSaveDB) async {
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

    await dmTinhTrangHDProvider.insert(dmTinhTrangHD, dtSaveDB);
    await dmTrangThaiDTProvider.insert(dmTrangThaiDT, dtSaveDB);
    await dmCoKhongProvider.insert(dmCoKhong, dtSaveDB);
    await dmGioiTinhProvider.insert(dmGioiTinh, dtSaveDB);
    await dmDanTocProvider.insert(dmDanToc, dtSaveDB);
    // }
  }

  Future insertDanhMucPhieuMau(DataModel bodyData, String dtSaveDB) async {
    // if (AppPref.isFistInstall == 0) {
    List<TableDmCap> dmCap = TableData.toListCTDmCaps(bodyData.ctDmCap);
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

    await ctDmCapProvider.insert(dmCap, dtSaveDB);
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

  Future insertDanhMucTonGiao(DataModel bodyData, String dtSaveDB) async {
    // if (AppPref.isFistInstall == 0) {
    List<TableTGDmCapCongNhan> tgDmCapCongNhan =
        TableData.toListTGDmCapCongNhan(bodyData.tgDmCapCongNhan);
    List<TableTGDmLoaiCoSo> dmLoaiCoSo =
        TableData.toListTGDmLoaiCoSo(bodyData.tgDmLoaiCoSo);
    List<TableTGDmLoaiHinhTonGiao> dmLoaiHinhTonGiao =
        TableData.toListTGDmLoaiHinhTonGiao(bodyData.tgDmLoaiHinhTonGiao);
    List<TableTGDmNangLuong> dmNangLuong =
        TableData.toListTGDmNangLuong(bodyData.tgDmNangLuong);

    List<TableTGDmSudDngPhanMem> dmSuDungPhanMem =
        TableData.toListTGDmSuDungPhanMem(bodyData.tgDmSuDungPhanMem);
    List<TableTGDmTrinhDoChuyenMon> dmTrinhDoChuyenMon =
        TableData.toListTGDmTrinhDoChuyenMon(bodyData.tgDmTrinhDoChuyenMon);
    List<TableTGDmXepHang> dmXepHang =
        TableData.toListTGDmXepHang(bodyData.tgDmXepHang);
    List<TableTGDmXepHangDiTich> dmXepHangDiTich =
        TableData.toListTGDmXepHangDiTich(bodyData.tgDmXepHangDiTich);

    List<TableDmLoaiTonGiao> dmLoaiTonGiao =
        TableData.toListTGDmLoaTonGiao(bodyData.tgDmLoaiTonGiao);

    await tgDmCapCongNhanProvider.insert(tgDmCapCongNhan, dtSaveDB);
    await tgDmLoaiCoSoProvider.insert(dmLoaiCoSo, dtSaveDB);
    await tgDmLoaiHinhTonGiaoProvider.insert(dmLoaiHinhTonGiao, dtSaveDB);
    await tgDmNangLuongProvider.insert(dmNangLuong, dtSaveDB);
    await tgDmSuDungPhanMemProvider.insert(dmSuDungPhanMem, dtSaveDB);
    await tgDmTrinhDoChuyenMonProvider.insert(dmTrinhDoChuyenMon, dtSaveDB);
    await tgDmXepHangProvider.insert(dmXepHang, dtSaveDB);
    await tgDmXepHangDiTichProvider.insert(dmXepHangDiTich, dtSaveDB);
    await tgDmLoaiTonGiaoProvider.insert(dmLoaiTonGiao, dtSaveDB);
    //  }
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
      if (isDefaultUserType()) {
        AppPref.dateTimeSaveDB = isHad['CreatedAt'];
        Get.toNamed(AppRoutes.interviewObjectList);
      } else {
        await goToGeneralInformation();
      }
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
    await bkCoSoTonGiaoProvider.init();
    await bkCoSoSXKDProvider.init();
    await bkCoSoSXKDNganhSanPhamProvider.init();
    await diaBanCoSoTonGiaoProvider.init();
    await diaBanCoSoSXKDProvider.init();
    await userInfoProvider.init();
    await dmTinhTrangHDProvider.init();
    await dmTrangThaiDTProvider.init();
    await dmCoKhongProvider.init();
    await dmDanTocProvider.init();
    await dmGioiTinhProvider.init();

    await xacNhanLogicProvider.init();

    ///DM Phiếu 07 mau
    await ctDmCapProvider.init();
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
    await phieuMauProvider.init();
    await phieuMauA61Provider.init();
    await phieuMauA68Provider.init();
    await phieuMauSanphamProvider.init();

    ///DM Phiếu 08 ton giao
    await tgDmCapCongNhanProvider.init();
    await tgDmLoaiCoSoProvider.init();
    await tgDmLoaiHinhTonGiaoProvider.init();
    await tgDmNangLuongProvider.init();
    await tgDmSuDungPhanMemProvider.init();
    await tgDmTrinhDoChuyenMonProvider.init();
    await tgDmXepHangProvider.init();
    await tgDmXepHangDiTichProvider.init();
    await tgDmLoaiTonGiaoProvider.init();

    ///Phiếu 08 ton giao
    await phieuTonGiaoProvider.init();
    await phieuTonGiaoA43Provider.init();
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
    Get.toNamed(AppRoutes.downloadModelAI);
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
              userModel.maDangNhap!.characters.first == "h");
    } else {
      return (AppPref.uid!.characters.first == "D" ||
              AppPref.uid!.characters.first == "d") ||
          (AppPref.uid!.characters.first == "H" ||
              AppPref.uid!.characters.first == "h");
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
          maDT: bkCosoSXKD.maPhieu!.toString());
      for (var element in doiTuongMaps) {
        doiTuongDTs.add(TableDoiTuongDieuTra.fromJson(element));
      }
      if (doiTuongDTs.isNotEmpty) {
        var doiTuong = doiTuongDTs.first;
        tenDoiTuongDT = doiTuong.tenDoiTuongDT ?? '';
      }
      //
      List<Map> map =
          await diaBanCoSoSXKDProvider.selectByMaPhieu(bkCosoSXKD.maPhieu!);
      var diaBanCoSoSXKDs = <TableDmDiaBanCosoSxkd>[];
      for (var element in map) {
        diaBanCoSoSXKDs.add(TableDmDiaBanCosoSxkd.fromJson(element));
      }
      if (diaBanCoSoSXKDs.isNotEmpty) {
        int index = 0;
        await insertNewPhieu07MauTBCxx();

        Get.toNamed(AppRoutes.generalInformation, parameters: {
          GeneralInformationController.giMaDoiTuongDTKey:
              bkCosoSXKD.maPhieu!.toString(),
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

  insertNewPhieu07MauTBCxx() async {
    var maTrangThaiHD = AppDefine.maTinhTrangHDTuKeKhai;

    var map = await bkCoSoSXKDProvider.getInformation(AppPref.uid!);
    if (map != null) {
      var bkCosoSXKD = TableBkCoSoSXKD.fromJson(map);

      var phieuMau = await phieuMauProvider.selectByIdCoSo(AppPref.uid!);
      if (phieuMau.isNotEmpty) {
        // await phieuMauProvider.updateById(columnMaTinhTrangHD,
        //     currentIndex.value + 1, TablePhieuMau.fromJson(phieuMau).id!);
      } else {
        await initRecordPhieu07Mau(bkCosoSXKD, maTrangThaiHD);
      }
    }
  }

  Future initRecordPhieu07Mau(
      TableBkCoSoSXKD tableBkCoSoSXKD, int maTrangThaiHD) async {
    List<TablePhieuMau> tableP07Maus = [];
    var tableP07 = TablePhieuMau(
        maPhieu: tableBkCoSoSXKD.maPhieu,
        iDCoSo: tableBkCoSoSXKD.iDCoSo,
        maTinh: tableBkCoSoSXKD.maTinh!,
        maHuyen: tableBkCoSoSXKD.maHuyen,
        maXa: tableBkCoSoSXKD.maXa,
        maDiaBan: tableBkCoSoSXKD.maDiaBan,
        a1_1: tableBkCoSoSXKD.tenCoSo,
        a1_2: tableBkCoSoSXKD.diaChi,
        maDTV: AppPref.uid);
    tableP07Maus.add(tableP07);
    await phieuMauProvider.insert(tableP07Maus, AppPref.dateTimeSaveDB!);
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
