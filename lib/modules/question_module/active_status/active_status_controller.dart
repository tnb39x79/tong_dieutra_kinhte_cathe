import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:crypto/crypto.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/status/http_status.dart';
import 'package:gov_statistics_investigation_economic/common/common.dart';
import 'package:gov_statistics_investigation_economic/config/constants/app_colors.dart';
import 'package:gov_statistics_investigation_economic/config/constants/app_define.dart';
import 'package:gov_statistics_investigation_economic/config/constants/app_styles.dart';
import 'package:gov_statistics_investigation_economic/config/constants/app_values.dart';
import 'package:gov_statistics_investigation_economic/modules/modules.dart';
import 'package:gov_statistics_investigation_economic/resource/database/provider/dm_bkcoso_sxkd_nganh_sanpham_provider.dart';
import 'package:gov_statistics_investigation_economic/resource/database/provider/provider.dart';
import 'package:gov_statistics_investigation_economic/resource/database/provider/provider_p07mau.dart';
import 'package:gov_statistics_investigation_economic/resource/database/provider/xacnhan_logic_provider.dart';
import 'package:gov_statistics_investigation_economic/resource/database/table/filed_common.dart';
import 'package:gov_statistics_investigation_economic/resource/database/table/table_dm.dart';
import 'package:gov_statistics_investigation_economic/resource/database/table/table_dm_bkcoso_sxkd.dart';
import 'package:gov_statistics_investigation_economic/resource/database/table/table_dm_bkcoso_sxkd_nganh_sanpham.dart';
import 'package:gov_statistics_investigation_economic/resource/database/table/table_p07mau.dart';
import 'package:gov_statistics_investigation_economic/resource/model/errorlog/errorlog_model.dart';
import 'package:gov_statistics_investigation_economic/resource/model/reponse/response_cmm_model.dart';
import 'package:gov_statistics_investigation_economic/resource/model/reponse/response_model.dart';
import 'package:gov_statistics_investigation_economic/resource/model/sync/sync_model.dart';
import 'package:gov_statistics_investigation_economic/resource/services/api/api_constants.dart';
import 'package:gov_statistics_investigation_economic/resource/services/api/auth/auth_repository.dart';
import 'package:gov_statistics_investigation_economic/resource/services/api/error_log/error_log_repository.dart';
import 'package:gov_statistics_investigation_economic/resource/services/api/update_data/xacnhan_tukekhai_repository.dart';

import 'package:gov_statistics_investigation_economic/routes/routes.dart';

class ActiveStatusController extends BaseController {
  ActiveStatusController(
      {required this.errorLogRepository,
      required this.xacnhanTukekhaiRepository,
      required this.authRepository});
  final ErrorLogRepository errorLogRepository;
  final XacnhanTukekhaiRepository xacnhanTukekhaiRepository;
  final AuthRepository authRepository;

  final mainMenuController = Get.find<MainMenuController>();

  final currentIndex = (-1).obs;
  final tinhTrangHDs = <TableDmTinhTrangHD>[].obs;

  final InterviewListDetailController interviewListDetailController =
      Get.find();

  final bKCoSoSXKDProvider = BKCoSoSXKDProvider();
  final bkCoSoSXKDNganhSanPhamProvider = BKCoSoSXKDNganhSanPhamProvider();

  // provider
  final diaBanCoSoSXKDProvider = DiaBanCoSoSXKDProvider();
  final dmTinhTrangHDProvider = DmTinhTrangHDProvider();

  final phieuProvider = PhieuProvider();
  final phieuMauTBProvider = PhieuMauTBProvider();
  final phieuMauTBSanPhamProvider = PhieuMauTBSanPhamProvider();
  final phieuNganhCNProvider = PhieuNganhCNProvider();
  final phieuNganhLTProvider = PhieuNganhLTProvider();
  final phieuNganhTMProvider = PhieuNganhTMProvider();
  final phieuNganhTMSanphamProvider = PhieuNganhTMSanPhamProvider();
  final phieuNganhVTProvider = PhieuNganhVTProvider();
  final phieuNganhVTGhiRoProvider = PhieuNganhVTGhiRoProvider();
  final xacNhanLogicProvider = XacNhanLogicProvider();

  TablePhieu tablePhieuMau = TablePhieu();

  TableDmTinhTrangHD tableDmTinhTrangHD = TableDmTinhTrangHD();

  final tblBkCoSoSXKD = TableBkCoSoSXKD().obs;
  final tblBkCoSoSXKDNganhSanPham = TableBkCoSoSXKDNganhSanPham().obs;

  String? currentMaDoiTuongDT;
  String? currentTenDoiTuongDT;
  String? currentMaTinhTrangDT;
  String? currentMaDiaBan;
  String? currentTenDiaBan;
  String? currentIdCoSo;
  String? currentMaXa;
  String? currentTenXa;

  /// For dialog
  final dialogFormKey = GlobalKey<FormState>();
  //final passwordDtvController = TextEditingController();
  final phoneCoSoSxkdController = TextEditingController();

  final soDienThoaiCs = ''.obs;

//enum to declare 3 state of button
  final String buttonStateInit = 'init';
  final String buttonStateSubmitting = 'submitting';
  final String buttonStateCompleted = 'completed';
  final isAnimating = true.obs;
  final currentButtonState = 'init'.obs;

  final subTitleBar = ''.obs;
  final currentTenPhieu = ''.obs;

  @override
  void onInit() async {
    setLoading(true);

    try {
      currentMaDoiTuongDT = interviewListDetailController.currentMaDoiTuongDT;
      currentTenDoiTuongDT = interviewListDetailController.currentTenDoiTuongDT;
      currentIdCoSo = interviewListDetailController.currentIdCoSo;
      currentMaXa = interviewListDetailController.currentMaXa;
      currentTenXa = interviewListDetailController.currentTenXa;
      currentMaTinhTrangDT = interviewListDetailController.currentMaTinhTrangDT;
      currentMaDiaBan = interviewListDetailController.currentMaDiaBan;
      currentTenDiaBan = interviewListDetailController.currentTenDiaBan;
      currentTenPhieu.value = currentTenDoiTuongDT ?? '';
      await fetchDataPhieu();
      await getTinhTrangHD();
      subTitleBar.value =
          '${tblBkCoSoSXKD.value.tenCoSo} Địa bàn.$currentMaDiaBan - $currentTenDiaBan ${AppUtils.getXaPhuong(currentTenXa ?? '')}.$currentMaXa - $currentTenXa';
      setLoading(false);
    } on Exception catch (e) {
      errorLogRepository.sendErrorLog(
          ErrorLogModel(errorCode: "", errorMessage: e.toString()));
    }
    super.onInit();
  }

  onPressedCheckBox(int p1) {
    currentIndex.value = p1;
    //Nếu chọn giá trị tự kê khai
    // if (p1 == AppDefine.maTinhTrangHDTuKeKhai - 1) {
    //   showDialogNhapSDT(p1);
    // }
  }

  getTinhTrangHD() async {
    var tinhTrangs = await dmTinhTrangHDProvider.selectByMaDoiTuongDT();

    if (tblBkCoSoSXKD.value.maTrangThaiDT == AppDefine.hoanThanhPhongVan) {
      var ttDTTemp = TableDmTinhTrangHD.listFromJson(tinhTrangs);
      //  var ttDT = ttDTTemp.where((x) => x.maTinhTrang != 6).toList();
      tinhTrangHDs.value = ttDTTemp;
    } else {
      tinhTrangHDs.value = TableDmTinhTrangHD.listFromJson(tinhTrangs);
    }
  }

  fetchDataPhieu() async {
    if (currentMaDoiTuongDT == AppDefine.maDoiTuongDT_07Mau.toString() ||
        currentMaDoiTuongDT == AppDefine.maDoiTuongDT_07TB.toString()) {
      var bkCoSo = await bKCoSoSXKDProvider.getInformation(currentIdCoSo!);
      if (bkCoSo != null) {
        tblBkCoSoSXKD.value = TableBkCoSoSXKD.fromJson(bkCoSo);
        currentIndex.value = (tblBkCoSoSXKD.value.maTinhTrangHD ?? 0) - 1;
        // var phieu07Mau = await phieuMauProvider.selectByIdCoso(currentIdCoSo!);
        // tablePhieuMau = TablePhieuMau.fromJson(phieu07Mau);
        var bkNganh =
            await bkCoSoSXKDNganhSanPhamProvider.selectByIdCoSo(currentIdCoSo!);
        if (bkNganh != null) {
          var res = TableBkCoSoSXKDNganhSanPham.listFromJson(bkNganh);
          if (res.isNotEmpty) {
            tblBkCoSoSXKDNganhSanPham.value = res.first;
          }
        }
      }
    }
    subTitleBar.value =
        '${tblBkCoSoSXKD.value.tenCoSo} Địa bàn.$currentMaDiaBan - $currentTenDiaBan ${AppUtils.getXaPhuong(currentTenXa ?? '')}.$currentMaXa - $currentTenXa';
  }

  onPressNext() async {
    if (currentIndex.value < 0) {
      showError("Vui lòng chọn tình trạng hoạt động!");
      return;
    }

    if (currentIndex.value == 0 || currentIndex.value == 1) {
      //Hộ còn sản xuất kinh doanh (SXKD)
      //Hộ ngừng hoạt động SXKD và liên hệ được
      if (currentMaDoiTuongDT == AppDefine.maDoiTuongDT_07Mau.toString() ||
          currentMaDoiTuongDT == AppDefine.maDoiTuongDT_07TB.toString()) {
        if (tblBkCoSoSXKD.value.maTinhTrangHD != null &&
            tblBkCoSoSXKD.value.maTinhTrangHD != 1 && tblBkCoSoSXKD.value.isSyncSuccess!=null && tblBkCoSoSXKD.value.isSyncSuccess==1 ) {
          String msgContent =
              'Cơ sở này đã được xác nhận mất mẫu, không thể cập nhật trạng thái "Phỏng vấn"';
          Get.dialog(DialogWidget(
            onPressedPositive: () {
              Get.back();
            },
            onPressedNegative: () {
              Get.back();
            },
            title: 'Không thể cập nhật',
            confirmText: 'Đóng',
            isCancelButton: false,
            content: msgContent,
          ));

          return;
        } else {
          //TODO NHÓ KIỂM TRA LẠI MÃ TÌNH TRẠNG MÀ GỌI HÀM insert sản phẩm cho đúng.
          await insertNewPhieu07MauTBCxx();
          Get.toNamed(
            AppRoutes.generalInformation,
            arguments: currentIndex.value + 1,
          );
        }
      }
    } else if (currentIndex.value == 2) {
      //Hộ không SXKD lĩnh vực được điều tra: Sử dụng khi cơ sở được chọn mẫu trong lĩnh vực mà hiện ko còn kinh doanh lĩnh vực được chọn mẫu
      //=> PV điều tra phiếu TB
      int tinhTrangHD = currentIndex.value + 1;
      var item = tinhTrangHDs[currentIndex.value];

      String msgContent = 'Hộ không SXKD lĩnh vực được điều tra';
      if (item != null) {
        msgContent = '${item.tenTinhTrang}';
      }

      Get.dialog(DialogWidget(
        onPressedPositive: () {
          if (currentMaDoiTuongDT == AppDefine.maDoiTuongDT_07Mau.toString() ||
              currentMaDoiTuongDT == AppDefine.maDoiTuongDT_07TB.toString()) {
            ///Kiểm tra tồn tại IDCoSo ở các bảng thì phải xoá record đó.
            deleteRecordPhieuMau();
            // ho
            bKCoSoSXKDProvider.updateTrangThaiDTTinhTrangHD(
                currentIdCoSo!, tinhTrangHD);
          }
          Get.back();
          Get.back();
        },
        onPressedNegative: () {
          Get.back();
        },
        title: msgContent,
        content: 'Bạn có muốn kết thúc phỏng vấn?',
      ));
    } else {
      ///Nếu maTinhTrangDH=6 (currentIndex.value=5) => hiện dialog xác nhận thông tin tự kê khai;
      // if (currentIndex.value == 5) {
      //   return showDialogNhapSDT(currentIndex.value);
      // }
      //
      //if (currentIndex.value == 1 || currentIndex.value == 2) {
      int tinhTrangHD = currentIndex.value + 1;
      var item = tinhTrangHDs[currentIndex.value];

      String msgContent = 'Cơ sở rơi vào tình trạng mất mẫu/không điều tra được cơ sở này.';
      if (item != null) {
        msgContent = '${item.tenTinhTrang}';
      }
      Get.dialog(DialogWidget(
        onPressedPositive: () {
          if (currentMaDoiTuongDT == AppDefine.maDoiTuongDT_07Mau.toString() ||
              currentMaDoiTuongDT == AppDefine.maDoiTuongDT_07TB.toString()) {
            ///Kiểm tra tồn tại IDCoSo ở các bảng thì phải xoá record đó.
            deleteRecordPhieuMau();
            // ho
            bKCoSoSXKDProvider.updateTrangThaiDTTinhTrangHD(
                currentIdCoSo!, tinhTrangHD);
          }
          Get.back();
          Get.back();
        },
        onPressedNegative: () {
          Get.back();
        },
        title: msgContent,
        content: 'Bạn có muốn kết thúc phỏng vấn không?',
      ));
    }
  }

  deleteRecordPhieuMau() async {
    var phieuMau = await phieuProvider.isExistQuestion(currentIdCoSo!);
    if (phieuMau) {
      await phieuProvider.deleteByCoSoId(currentIdCoSo!);
      await phieuMauTBProvider.deleteByCoSoId(currentIdCoSo!);
      await phieuMauTBSanPhamProvider.deleteByCoSoId(currentIdCoSo!);
      await phieuNganhCNProvider.deleteByCoSoId(currentIdCoSo!);

      await phieuNganhLTProvider.deleteByCoSoId(currentIdCoSo!);
      await phieuNganhTMProvider.deleteByCoSoId(currentIdCoSo!);
      await phieuNganhTMSanphamProvider.deleteByCoSoId(currentIdCoSo!);
      await phieuNganhVTProvider.deleteByCoSoId(currentIdCoSo!);
      await phieuNganhVTGhiRoProvider.deleteByCoSoId(currentIdCoSo!);
    }
  }

  insertNewPhieu07MauTBCxx() async {
    var maTrangThaiHD = currentIndex.value + 1;
    if (currentMaDoiTuongDT == AppDefine.maDoiTuongDT_07Mau.toString() ||
        currentMaDoiTuongDT == AppDefine.maDoiTuongDT_07TB.toString()) {
      var phieuMau = await phieuProvider.selectByIdCoSo(currentIdCoSo!);
      if (phieuMau.isNotEmpty) {
      } else {
        var maNganhs = await bkCoSoSXKDNganhSanPhamProvider
            .selectMaNganhByIdCoSo(tblBkCoSoSXKD.value.iDCoSo!);
        var maNganhMau = '';
        if (maNganhs.isNotEmpty) {
          maNganhMau = maNganhs.first;
          await initRecordPhieu(tblBkCoSoSXKD.value, maNganhMau, maTrangThaiHD);
          await initRecordPhieuMauTB(tblBkCoSoSXKD.value);
          await initRecordPhieuMauTBNganhSanPham();
        }
      }
    }
  }

  ///BEGIN:: Phieu07 - Khởi tạo 1 record mặc định nếu bảng chưa có record nào.
  ///

  Future initRecordPhieu(TableBkCoSoSXKD tableBkCoSoSXKD, String maNganh,
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

  Future initRecordPhieuMauTB(TableBkCoSoSXKD tableBkCoSoSXKD) async {
    var phieuMauTB = await phieuMauTBProvider.selectByIdCoSo(currentIdCoSo!);
    if (phieuMauTB.isEmpty) {
      List<TablePhieuMauTB> tablePhieuMauTBs = [];

      var tableP07 = TablePhieuMauTB(
          iDCoSo: tableBkCoSoSXKD.iDCoSo,
          loaiPhieu: tableBkCoSoSXKD.loaiPhieu,
          maTinh: tableBkCoSoSXKD.maTinh!,
          maTKCS: tableBkCoSoSXKD.maTKCS,
          maXa: tableBkCoSoSXKD.maXa,
          maThon: tableBkCoSoSXKD.maThon,
          iDDB: tableBkCoSoSXKD.iDDB,
          maDiaBan: tableBkCoSoSXKD.maDiaBan,
          a1_1: tableBkCoSoSXKD.maDiaDiem,
          maDTV: AppPref.uid);
      tablePhieuMauTBs.add(tableP07);

      await phieuMauTBProvider.insert(
          tablePhieuMauTBs, AppPref.dateTimeSaveDB!);
    }
  }

  Future initRecordPhieuMauTBNganhSanPham() async {
    var phieuSp = await phieuMauTBSanPhamProvider.isExistProductByMaNganhC5(
        currentIdCoSo!, tblBkCoSoSXKDNganhSanPham.value.maNganh!);
    if (!phieuSp) {
      var tblMauTBSp = TablePhieuMauTBSanPham(
          iDCoSo: currentIdCoSo,
          sTTSanPham: 1,
          maNganhC5: tblBkCoSoSXKDNganhSanPham.value.maNganh!,
          a5_1_1: tblBkCoSoSXKDNganhSanPham.value.tenNganh!,
          a5_1_2: tblBkCoSoSXKDNganhSanPham.value.maNganh!,
          isDefault: 1,
          maDTV: AppPref.uid);
      List<TablePhieuMauTBSanPham> tblSanPhams = [];
      tblSanPhams.add(tblMauTBSp);
      await phieuMauTBSanPhamProvider.insert(
          tblSanPhams, AppPref.dateTimeSaveDB!);
      await phieuMauTBSanPhamProvider.updateDefaultByIdCoso(
          currentIdCoSo, tblBkCoSoSXKDNganhSanPham.value.maNganh!, null);
    }
  }

  // Future insertNewRecordSanPham() async {
  //   var res = await phieuMauTBSanPhamProvider.isExistProduct(currentIdCoSo!);
  //   if (res == false) {
  //     var tblSp = TablePhieuMauTBSanPham(
  //         iDCoSo: currentIdCoSo,
  //         sTTSanPham: 1,
  //         isDefault: 1,
  //         maDTV: AppPref.uid);
  //     List<TablePhieuMauTBSanPham> tblSps = [];
  //     tblSps.add(tblSp);

  //     await phieuMauTBSanPhamProvider.insert(tblSps, AppPref.dateTimeSaveDB!);
  //   }
  // }

  ///END:: Phieu07 - Khởi tạo 1 record mặc định nếu bảng chưa có record nào.
  ///

   

  @override
  void onDetached() {
    // TODO: implement onDetached
  }

  @override
  void onHidden() {
    // TODO: implement onHidden
  }

  @override
  void onInactive() {
    // TODO: implement onInactive
  }

  @override
  void onPaused() {
    // TODO: implement onPaused
  }

  @override
  void onResumed() {
    // TODO: implement onResumed
  }

  ///END:: Phieu05 - Khởi tạo 1 record mặc định nếu bảng chưa có record nào.
}
