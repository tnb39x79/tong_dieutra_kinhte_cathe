import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:gov_statistics_investigation_economic/config/constants/app_define.dart';
import 'package:gov_statistics_investigation_economic/modules/question_module/question_no07/question_phieu_tb_controller.dart';
import 'package:gov_statistics_investigation_economic/resource/database/provider/dm_bkcoso_sxkd_nganh_sanpham_provider.dart';
import 'package:gov_statistics_investigation_economic/resource/database/provider/dm_mota_sanpham_provider.dart';
import 'package:gov_statistics_investigation_economic/resource/database/provider/phieu_provider.dart';
import 'package:gov_statistics_investigation_economic/resource/database/provider/provider_p07mau.dart';
import 'package:gov_statistics_investigation_economic/resource/database/provider/provider_p07mau_dm.dart';
import 'package:gov_statistics_investigation_economic/resource/database/table/table_data.dart';
import 'package:gov_statistics_investigation_economic/resource/database/table/table_dm.dart';
import 'package:gov_statistics_investigation_economic/common/common.dart';
import 'package:gov_statistics_investigation_economic/modules/modules.dart';
import 'package:gov_statistics_investigation_economic/resource/database/table/table_dm_bkcoso_sxkd.dart';
import 'package:gov_statistics_investigation_economic/resource/database/table/table_dm_bkcoso_sxkd_nganh_sanpham.dart';
import 'package:gov_statistics_investigation_economic/resource/database/table/table_phieu.dart';
import 'package:gov_statistics_investigation_economic/resource/database/table/table_phieu_mautb_sanpham.dart';

import 'package:gov_statistics_investigation_economic/resource/resource.dart';
import 'package:gov_statistics_investigation_economic/routes/routes.dart';

class GeneralInformationController extends BaseController {
  final formKey = GlobalKey<FormState>();

  static const giMaDoiTuongDTKey = 'maDoiTuongDT';
  static const giMaDiaBanKey = 'maDiaBan';
  static const giTenDiaBanKey = 'tenDiaBan';
  static const giMaXaKey = 'maXa';
  static const giTenXaKey = 'tenXa';
  static const giTenDoiTuongDTKey = "tenDoiTuongDT";
  static const giCoSoSXKDIdKey = "coSoSXKDId";
  static const giMaTinhTrangDTKey = "maTinhTrangDT";

  ///BEGIN::Thông tin cơ sở sxkd
  final maTinhController = TextEditingController();
  final tenTinhController = TextEditingController();
  final maHuyenController = TextEditingController();
  final tenHuyenController = TextEditingController();
  final maXaController = TextEditingController();
  final tenXaController = TextEditingController();
  //final coSoSoTextController = TextEditingController();
  final maCoSoController = TextEditingController();
  final tenCoSoController = TextEditingController();
  final dienThoaiController = TextEditingController();
  final emailController = TextEditingController();
  final maThonController = TextEditingController();
  final tenThonController = TextEditingController();
  final tenNganhVSIC5SoController = TextEditingController();
  final maNganhController = TextEditingController();

  ///END::Thông tin cơ sở sxkd
  ///
  ///BEGIN::Thông tin hộ
  final maDiaBanController = TextEditingController();
  final tenDiaBanController = TextEditingController();
  final hoSoController = TextEditingController();
  final tenChuCoSoController = TextEditingController();
  final maDanTocController = TextEditingController();
  final tenDanTocController = TextEditingController();
  final diaChiCoSoController = TextEditingController();
  final ttNTController = TextEditingController();

  final tenNganhController = TextEditingController();
  final moTaSPDuocChonController = TextEditingController();

  ///END::Thông tin hộ
  ///
  final HomeController homeController = Get.find();
  final MainMenuController mainMenuController = Get.find();
  final interviewListDetailController =
      Get.find<InterviewListDetailController>();

  /// RX
  final tblBkCoSoSXKD = TableBkCoSoSXKD().obs;

  final tblPhieu = TablePhieu().obs;
  //final tblBkCoSoSXKDNganhSanPham = <TableBkCoSoSXKDNganhSanPham>[].obs;
  final tblBkCoSoSXKDNganhSanPham = TableBkCoSoSXKDNganhSanPham().obs;
  final screenNos = <int>[].obs;
  final currentScreenNo = 0.obs;

  /// provider
  final dataProvider = DataProvider();
  final bkCoSoSXKDProvider = BKCoSoSXKDProvider();
  final bkCoSoSXKDNganhSanPhamProvider = BKCoSoSXKDNganhSanPhamProvider();

  final phieuProvider = PhieuProvider();
  final phieuMauTBProvider = PhieuMauTBProvider();
  final phieuMauTBSanPhamProvider = PhieuMauTBSanPhamProvider();
  //final dmNhomNganhVcpaProvider = CTDmNhomNganhVcpaProvider();
  final dmMotaSanphamProvider = DmMotaSanphamProvider();

  /// param
  String? currentIdHoDuPhong;
  String? currentIdCoSoDuPhong;
  String? currentMaDoiTuongDT;
  String? currentTenDoiTuongDT;
  String? currentMaTinhTrangDT;
  String? currentMaDiaBan;
  String? currentTenDiaBan;
  //String? currentIdCoSoTG;
  String? currentIdCoSo;
  String? currentMaXa;
  String? currentTenXa;
  String? currentMaVCPACap1;

  @override
  void onInit() async {
    setLoading(true);
    if (homeController.isDefaultUserType()) {
      currentMaDoiTuongDT = interviewListDetailController.currentMaDoiTuongDT;
      currentTenDoiTuongDT = interviewListDetailController.currentTenDoiTuongDT;
      currentMaTinhTrangDT = interviewListDetailController.currentMaTinhTrangDT;
      currentIdCoSo = interviewListDetailController.currentIdCoSo;
      currentMaXa = interviewListDetailController.currentMaXa;
      currentTenXa = interviewListDetailController.currentTenXa;
      currentMaDiaBan = interviewListDetailController.currentMaDiaBan;
      currentTenDiaBan = interviewListDetailController.currentTenDiaBan;
    } else {
      currentMaDoiTuongDT = Get.parameters[giMaDoiTuongDTKey]!;
      currentTenDoiTuongDT = Get.parameters[giTenDoiTuongDTKey]!;
      currentMaTinhTrangDT = Get.parameters[giMaTinhTrangDTKey]!;
      currentIdCoSo = Get.parameters[giCoSoSXKDIdKey]!;
      currentMaXa = Get.parameters[giMaXaKey]!;
      currentTenXa = Get.parameters[giTenXaKey]!;
      currentMaDiaBan = Get.parameters[giMaDiaBanKey]!;
      currentTenDiaBan = Get.parameters[giTenDiaBanKey]!;
    }
    await getGeneralInformation();
    await getScreenNo();
    setLoading(false);
    super.onInit();
  }

  getSubTitle() {
    return '$currentTenDoiTuongDT';
  }

  Future getGeneralInformation() async {
    if (currentMaDoiTuongDT == AppDefine.maDoiTuongDT_07Mau.toString() ||
        currentMaDoiTuongDT == AppDefine.maDoiTuongDT_07TB.toString()) {
      // String idCoso =
      //     currentIdCoSoDuPhong != null ? currentIdCoSoDuPhong! : currentIdCoSo!;

      var map = await bkCoSoSXKDProvider.getInformation(currentIdCoSo!);
      log(map.toString());
      if (map != null) {
        tblBkCoSoSXKD.value = TableBkCoSoSXKD.fromJson(map);

        maTinhController.text = tblBkCoSoSXKD.value.maTinh ?? '';
        tenTinhController.text = tblBkCoSoSXKD.value.tenTinh ?? '';

        maHuyenController.text = tblBkCoSoSXKD.value.maTKCS ?? '';
        tenHuyenController.text = tblBkCoSoSXKD.value.tenTKCS ?? '';

        maXaController.text = tblBkCoSoSXKD.value.maXa ?? '';
        tenXaController.text = tblBkCoSoSXKD.value.tenXa ?? '';

        maThonController.text = tblBkCoSoSXKD.value.maThon ?? '';
        tenThonController.text = tblBkCoSoSXKD.value.tenThon ?? '';
        // coSoSoTextController.text = tblBkCoSoSXKD.value.tenThon ?? '';
        maDiaBanController.text = tblBkCoSoSXKD.value.maDiaBan ?? '';
        tenDiaBanController.text = tblBkCoSoSXKD.value.tenDiaBan ?? '';
        maCoSoController.text = tblBkCoSoSXKD.value.maCoSo != null
            ? tblBkCoSoSXKD.value.maCoSo.toString()
            : '';
        // tenChuCoSoController.text = tblBkCoSoSXKD.value.tenChuCoSo ?? '';
        // tenCoSoController.text = tblBkCoSoSXKD.value.tenCoSo ?? '';
        // diaChiCoSoController.text = tblBkCoSoSXKD.value.diaChi ?? '';
        // dienThoaiController.text = tblBkCoSoSXKD.value.dienThoai ?? '';
        emailController.text = tblBkCoSoSXKD.value.email ?? '';

        var mapMaNganhs =
            await bkCoSoSXKDNganhSanPhamProvider.selectByIdCoSo(currentIdCoSo!);
        if (mapMaNganhs != null) {
          var nganhSP =
              TableBkCoSoSXKDNganhSanPham.listFromJson(mapMaNganhs).firstOrNull;
          if (nganhSP != null) {
            tblBkCoSoSXKDNganhSanPham.value = nganhSP;
          }
          maNganhController.text =
              tblBkCoSoSXKDNganhSanPham.value.maNganh ?? '';
          tenNganhController.text =
              tblBkCoSoSXKDNganhSanPham.value.tenNganh ?? '';
        }
        await getPhieu();
      }
    }
  }

  Future getPhieu() async {
    var phieuMau = await phieuProvider.selectByIdCoSo(currentIdCoSo!);
    if (phieuMau != null) {
      tblPhieu.value = TablePhieu.fromJson(phieuMau);
      tenChuCoSoController.text = tblPhieu.value.tenChuCoSo ?? '';
      tenCoSoController.text = tblPhieu.value.tenCoSo ?? '';
      diaChiCoSoController.text = tblPhieu.value.diaChi ?? '';
      dienThoaiController.text = tblPhieu.value.sDTCoSo ?? '';
    }
  }

  // Future<bool> checkMaNganhCap1BCEByMaVCPA() async {
  //   var maNganhs = await bkCoSoSXKDNganhSanPhamProvider
  //       .selectMaNganhByIdCoSo(tblBkCoSoSXKD.value.iDCoSo!);
  //   if (maNganhs.isNotEmpty) {
  //     var res =
  //         await dmNhomNganhVcpaProvider.kiemTraMaNganhCap1BCEByMaVCPA(maNganhs);
  //     return res;
  //   }
  //   return false;
  // }
  Future<bool> checkMaNganhCap1BCEByMaVCPA() async {
    var maNganhs = await bkCoSoSXKDNganhSanPhamProvider
        .selectMaNganhByIdCoSo(tblBkCoSoSXKD.value.iDCoSo!);
    if (maNganhs.isNotEmpty) {
      var res =
          await dmMotaSanphamProvider.kiemTraMaNganhCap1BCEByMaVCPA(maNganhs);
      return res;
    }
    return false;
  }

  Future getScreenNo({int screenNo = 2}) async {
    try {
      dynamic map = await dataProvider.selectTop1();
      TableData tableData = TableData.fromJson(map);
      if (currentMaDoiTuongDT == AppDefine.maDoiTuongDT_07Mau.toString()) {
        dynamic question04 = tableData.toCauHoiPhieu07Mau();

        List<QuestionCommonModel> questionsTemp =
            QuestionCommonModel.listFromJson(jsonDecode(question04));

        screenNos.value = questionsTemp.map((e) => e.manHinh!).toSet().toList();
      } else if (currentMaDoiTuongDT ==
          AppDefine.maDoiTuongDT_07TB.toString()) {
        dynamic question04 = tableData.toCauHoiPhieu07TB();

        List<QuestionCommonModel> questionsTemp =
            QuestionCommonModel.listFromJson(jsonDecode(question04));

        screenNos.value = questionsTemp.map((e) => e.manHinh!).toSet().toList();
      }
      // return questionSceenNo;
    } catch (e) {
      log('ERROR lấy danh sách câu hỏi phiếu: $e');
      return [];
    }
  }

  Future onPressNext() async {
    var validRes1 = onValidateTenCS(tenCoSoController.text, '');
    if (validRes1 != null && validRes1 != '') {
      return showError(validRes1);
    }
    var validRes2 = onValidateDiaChi(diaChiCoSoController.text, '');
    if (validRes2 != null && validRes2 != '') {
      return showError(validRes2);
    }
    var validRes3 = onValidateTenChuCS(tenChuCoSoController.text, '');
    if (validRes3 != null && validRes3 != '') {
      return showError(validRes3);
    }

    var phoneValidate = Valid.validateMobile(dienThoaiController.text);
    if (phoneValidate != null && phoneValidate != '') {
      return showError(phoneValidate);
    }
    // setLoading(true);

    /// ! HỎI LẠI: CÓ CẬP NHẬT CÁC THÔNG TIN NÀY KHÔNG? CÁC Ô NHẬP NÀO ĐƯỢC PHÉP NHẬP ?????
    if (currentMaDoiTuongDT == AppDefine.maDoiTuongDT_07Mau.toString() ||
        currentMaDoiTuongDT == AppDefine.maDoiTuongDT_07TB.toString()) {
      await bkCoSoSXKDProvider.updateValues(currentIdCoSo!, multiValue: {
        "TenCoSo": tenCoSoController.text,
        "DiaChi": diaChiCoSoController.text,
        "TenChuCoSo": tenChuCoSoController.text,
        "DienThoai": dienThoaiController.text,
      });

      //  await insertNewRecordSanPham();
    }
    setLoading(false);
    if (screenNos.isEmpty) {
      String msgContent =
          'Cơ sở chưa có câu hỏi phỏng vấn, vui lòng thử lại sau.';
      Get.dialog(DialogWidget(
        isCancelButton: false,
        onPressedPositive: () {
          Get.back();
        },
        onPressedNegative: () {
          Get.back();
        },
        title: 'Không có câu hỏi',
        content: msgContent,
      ));

      return;
    }
    currentScreenNo.value = screenNos[0];
    await getNextScreen(currentScreenNo.value);
  }

  getNextScreen(int screenNoValue) async {
    if (currentMaDoiTuongDT == AppDefine.maDoiTuongDT_07Mau.toString()) {
      var isCap1BCE = await checkMaNganhCap1BCEByMaVCPA();
      Get.toNamed(AppRoutes.questionTB, parameters: {
        QuestionPhieuTBController.idCoSoKey: currentIdCoSo!,
        QuestionPhieuTBController.isNhomNganhCap1BCEKey: isCap1BCE ? '1' : '0',
      });
    }
    if (currentMaDoiTuongDT == AppDefine.maDoiTuongDT_07TB.toString()) {
      Get.toNamed(AppRoutes.questionTB, parameters: {
        QuestionPhieuTBController.idCoSoKey: currentIdCoSo!,
        QuestionPhieuTBController.isNhomNganhCap1BCEKey: '',
      });
    }
  }

/***********/

  Future insertNewRecord() async {
    var res = await phieuMauTBSanPhamProvider.isExistProduct(currentIdCoSo!);
    if (res == false) {
      //var maNganhs = await bkCoSoSXKDNganhSanPhamProvider
      //     .selectMaNganhByIdCoSo(tblBkCoSoSXKD.value.iDCoSo!);
      // var maNganhVcpa = '';
      // if (maNganhs.isNotEmpty) {
      //   maNganhVcpa = maNganhs.first;
      // }
      var maxStt =
          await phieuMauTBSanPhamProvider.getMaxSTTByIdCoso(currentIdCoSo!);
      maxStt = maxStt + 1;
      var tblSp = TablePhieuMauTBSanPham(
          iDCoSo: currentIdCoSo,
          sTTSanPham: maxStt,
          isDefault: 1,
          maDTV: AppPref.uid);
      List<TablePhieuMauTBSanPham> tblSps = [];
      tblSps.add(tblSp);

      await phieuMauTBSanPhamProvider.insert(tblSps, AppPref.dateTimeSaveDB!);
    }
  }

  ///San pham

  ///
  Future insertNewRecordSanPham() async {
    var res = await phieuMauTBSanPhamProvider.isExistProduct(currentIdCoSo!);
    if (res == false) {
      //var maNganhs = await bkCoSoSXKDNganhSanPhamProvider
      //     .selectMaNganhByIdCoSo(tblBkCoSoSXKD.value.iDCoSo!);
      // var maNganhVcpa = '';
      // if (maNganhs.isNotEmpty) {
      //   maNganhVcpa = maNganhs.first;
      // }
      var maxStt =
          await phieuMauTBSanPhamProvider.getMaxSTTByIdCoso(currentIdCoSo!);
      maxStt = maxStt + 1;
      var tblSp = TablePhieuMauTBSanPham(
          iDCoSo: currentIdCoSo,
          sTTSanPham: maxStt,
          isDefault: 1,
          maDTV: AppPref.uid);
      List<TablePhieuMauTBSanPham> tblSps = [];
      tblSps.add(tblSp);

      await phieuMauTBSanPhamProvider.insert(tblSps, AppPref.dateTimeSaveDB!);
    }
  }

  onBackPage() async {
    if (homeController.isDefaultUserType()) {
      Get.back();
    } else {
      Get.offAllNamed(AppRoutes.mainMenu);
    }
  }

  onChangeTenCS(String? value, {bool updateText = false}) {
    String result;
    result = value ?? '';
    bool needUpdate = updateText;
    int maxL = 250;
    // Truncate if necessary
    if (result.length > maxL) {
      result = result.substring(0, maxL);
      needUpdate = true;
    }

    // Update controller if needed
    if (needUpdate) {
      tenCoSoController.value = tenCoSoController.value.copyWith(
        text: result,
        selection: TextSelection.fromPosition(
          TextPosition(offset: result.length),
        ),
      );
    }

    ///end added
    if (result.isNotEmpty) {
      result = result.toUpperCase();
    }
    phieuProvider.updateValue(colPhieuTenCoSo, result, currentIdCoSo!);
    bkCoSoSXKDProvider.updateValue(
        colBkCoSoSXKDTenCoSo, result, currentIdCoSo!);
    getPhieu();
  }

  onChangeDiaChi(String? value, {bool updateText = false}) {
    String result;
    result = value ?? '';
    bool needUpdate = updateText;
    int maxL = 250;
    // Truncate if necessary
    if (result.length > maxL) {
      result = result.substring(0, maxL);
      needUpdate = true;
    }

    // Update controller if needed
    if (needUpdate) {
      tenCoSoController.value = tenCoSoController.value.copyWith(
        text: result,
        selection: TextSelection.fromPosition(
          TextPosition(offset: result.length),
        ),
      );
    }
    phieuProvider.updateValue(colPhieuDiaChi, result, currentIdCoSo!);
    bkCoSoSXKDProvider.updateValue(colBkCoSoSXKDDiaChi, result, currentIdCoSo!);
    getPhieu();
  }

  onChangeTenChuCS(String? value, {bool updateText = false}) {
    String result;
    result = value ?? '';
    bool needUpdate = updateText;
    int maxL = 250;
    // Truncate if necessary
    if (result.length > maxL) {
      result = result.substring(0, maxL);
      needUpdate = true;
    }

    // Update controller if needed
    if (needUpdate) {
      tenCoSoController.value = tenCoSoController.value.copyWith(
        text: result,
        selection: TextSelection.fromPosition(
          TextPosition(offset: result.length),
        ),
      );
    }
    if (result.isNotEmpty) {
      result = result.toUpperCase();
    }
    phieuProvider.updateValue(colPhieuTenChuCoSo, result, currentIdCoSo!);
    bkCoSoSXKDProvider.updateValue(
        colBkCoSoSXKDTenChuCoSo, result, currentIdCoSo!);
    getPhieu();
  }

  onChangeSoDT(String? value) {
    phieuProvider.updateValue(colPhieuSDTCoSo, value, currentIdCoSo!);
    getPhieu();
  }

  String? onValidateTenCS(String? value, String fieldName) {
    if (tenCoSoController.text.isEmpty || tenCoSoController.text == "") {
      return 'Vui lòng nhập Tên cơ sở';
    } else if (tenCoSoController.text.length < 3) {
      return 'Tên cơ sở không được phép < 3 ký tự';
    }
    return null;
  }

  String? onValidateDiaChi(String? value, String fieldName) {
    if (diaChiCoSoController.text.isEmpty || diaChiCoSoController.text == "") {
      return 'Vui lòng nhập địa chỉ cơ sở';
    } else if (diaChiCoSoController.text.length < 3) {
      return 'Địa chỉ cơ sở không được phép < 3 ký tự';
    }
    return null;
  }

  String? onValidateTenChuCS(String? value, String fieldName) {
    if (tenChuCoSoController.text.isEmpty || tenChuCoSoController.text == "") {
      return 'Vui lòng nhập Tên chủ cơ sở';
    } else if (tenChuCoSoController.text.length < 3) {
      return 'Tên chủ cơ sở không được phép < 3 ký tự';
    }
    return null;
  }

  String? onValidateSoDT(String? value, String fieldName) {
    var phoneValidate = Valid.validateMobile(dienThoaiController.text);
    if (phoneValidate != null && phoneValidate != '') {
      return phoneValidate;
    }
    return null;
  }

  waringTenCs() {
    if (tenCoSoController.text.isNotEmpty) {
      if (tenCoSoController.text.length >= 3 &&
          tenCoSoController.text.length < 5) {
        return 'Tên cơ sở quá ngắn';
      }
    }
    return '';
  }

  waringTenChuCs() {
    if (tenChuCoSoController.text.isNotEmpty) {
      if (tenChuCoSoController.text.length >= 3 &&
          tenChuCoSoController.text.length < 5) {
        return 'Tên chủ cơ sở quá ngắn';
      }
    }
    return '';
  }

  waringDiaChi() {
    if (diaChiCoSoController.text.isNotEmpty) {
      if (diaChiCoSoController.text.length >= 3 &&
          diaChiCoSoController.text.length < 5) {
        return 'Địa chỉ cơ sở quá ngắn';
      }
    }
    return '';
  }

  waringSoDienThoai() {
    // if (dienThoaiController.text.isNotEmpty) {
    //   if (dienThoaiController.text.length < 10 ||
    //       dienThoaiController.text.length > 11) {
    //     return 'Kiểm tra lại số điện thoại <10 hoặc >11 số';
    //   } else {
    //     return '';
    //   }
    // }
    return '';
  }

  ///
/**********/
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

  ///END::
  ///
  ///
}
