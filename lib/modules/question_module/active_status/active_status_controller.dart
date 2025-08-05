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
import 'package:gov_statistics_investigation_economic/resource/database/provider/provider.dart';
import 'package:gov_statistics_investigation_economic/resource/database/provider/provider_p07mau.dart';
import 'package:gov_statistics_investigation_economic/resource/database/provider/provider_p08.dart';
import 'package:gov_statistics_investigation_economic/resource/database/provider/xacnhan_logic_provider.dart';
import 'package:gov_statistics_investigation_economic/resource/database/table/filed_common.dart';
import 'package:gov_statistics_investigation_economic/resource/database/table/table_dm.dart';
import 'package:gov_statistics_investigation_economic/resource/database/table/table_dm_bkcoso_sxkd.dart';
import 'package:gov_statistics_investigation_economic/resource/database/table/table_dm_bkcoso_tongiao.dart';
import 'package:gov_statistics_investigation_economic/resource/database/table/table_p07mau.dart';
import 'package:gov_statistics_investigation_economic/resource/database/table/table_phieu_08_tongiao.dart';
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
  final bkCoSoTonGiaoProvider = BKCoSoTonGiaoProvider();

  // provider
  final diaBanCoSoSXKDProvider = DiaBanCoSoSXKDProvider();
  final diaBanCoSoTonGiaoProvider = DiaBanCoSoTonGiaoProvider();
  final dmTinhTrangHDProvider = DmTinhTrangHDProvider();

  final phieuMauProvider = PhieuMauProvider();
  final phieuMauA61Provider = PhieuMauA61Provider();
  final phieuMauA68Provider = PhieuMauA68Provider();
  final phieuMauSanPhamProvider = PhieuMauSanphamProvider();
  final xacNhanLogicProvider = XacNhanLogicProvider();

  final phieuTonGiaoProvider = PhieuTonGiaoProvider();
  final phieuTonGiaoA43Provider = PhieuTonGiaoA43Provider();

  TablePhieuMau tablePhieuMau = TablePhieuMau();
  TablePhieuTonGiao tablePhieuTonGiao = TablePhieuTonGiao();

  TableDmTinhTrangHD tableDmTinhTrangHD = TableDmTinhTrangHD();

  final tblBkTonGiao = TableBkTonGiao().obs;
  final tblBkCoSoSXKD = TableBkCoSoSXKD().obs;

  String? currentMaDoiTuongDT;
  String? currentTenDoiTuongDT;
  String? currentMaTinhTrangDT;
  String? currentMaDiaBan;
  String? currentMaDiaBanTG;
  String? currentIdCoSoTG;
  String? currentIdCoSo;
  String? currentMaXa;

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

  @override
  void onInit() async {
    setLoading(true);

    try {
      currentMaDoiTuongDT = interviewListDetailController.currentMaDoiTuongDT;
      currentTenDoiTuongDT = interviewListDetailController.currentTenDoiTuongDT;
      currentIdCoSo = interviewListDetailController.currentIdCoSo;
      currentMaXa = interviewListDetailController.currentMaXa;
      currentMaTinhTrangDT = interviewListDetailController.currentMaTinhTrangDT;
      currentMaDiaBan = interviewListDetailController.currentMaDiaBan;
      currentMaDiaBanTG = interviewListDetailController.currentMaDiaBanTG;
      currentIdCoSoTG = interviewListDetailController.currentIdCoSoTG ?? '';

      await fetchDataPhieu();
      await getTinhTrangHD();
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
    if (p1 == AppDefine.maTinhTrangHDTuKeKhai - 1) {
      showDialogNhapSDT(p1);
    }
  }

  getTinhTrangHD() async {
    var tinhTrangs = await dmTinhTrangHDProvider
        .selectByMaDoiTuongDT(int.parse(currentMaDoiTuongDT!));

    if (tblBkCoSoSXKD.value.maTrangThaiDT == AppDefine.hoanThanhPhongVan) {
      var ttDTTemp = TableDmTinhTrangHD.listFromJson(tinhTrangs);
      var ttDT = ttDTTemp.where((x) => x.maTinhTrang != 6).toList();
      tinhTrangHDs.value = ttDT;
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
      }
    } else if (currentMaDoiTuongDT == AppDefine.maDoiTuongDT_08.toString()) {
      var bkCoSoTG =
          await bkCoSoTonGiaoProvider.getInformation(currentIdCoSoTG!);
      if (bkCoSoTG != null) {
        tblBkTonGiao.value = TableBkTonGiao.fromJson(bkCoSoTG);
        currentIndex.value = (tblBkTonGiao.value.maTinhTrangHD ?? 0) - 1;
      }
    }
  }

  onPressNext() async {
    if (currentIndex.value < 0) {
      showError("Vui lòng chọn tình trạng hoạt động!");
      return;
    }

    if (currentIndex.value == 0) {
      if (currentMaDoiTuongDT == AppDefine.maDoiTuongDT_07Mau.toString() ||
          currentMaDoiTuongDT == AppDefine.maDoiTuongDT_07TB.toString()) {
        if (tblBkCoSoSXKD.value.maTinhTrangHD != null &&
            tblBkCoSoSXKD.value.maTinhTrangHD != 1) {
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
          await insertNewPhieu07MauTBCxx();
          Get.toNamed(
            AppRoutes.generalInformation,
            arguments: currentIndex.value + 1,
          );
        }
      } else if (currentMaDoiTuongDT == AppDefine.maDoiTuongDT_08.toString()) {
        if (tblBkTonGiao.value.maTinhTrangHD != null &&
            tblBkTonGiao.value.maTinhTrangHD != 1) {
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
          await insertNewPhieu07MauTBCxx();
          Get.toNamed(
            AppRoutes.generalInformation,
            arguments: currentIndex.value + 1,
          );
        }
      }
    } else {
      ///Nếu maTinhTrangDH=6 (currentIndex.value=5) => hiện dialog xác nhận thông tin tự kê khai;
      if (currentIndex.value == 5) {
        return showDialogNhapSDT(currentIndex.value);
      }
      //
      //if (currentIndex.value == 1 || currentIndex.value == 2) {
      int tinhTrangHD = currentIndex.value + 1;
      String msgContent = 'Cơ sở đã mất mẫu';
      Get.dialog(DialogWidget(
        onPressedPositive: () {
          if (currentMaDoiTuongDT == AppDefine.maDoiTuongDT_07Mau.toString() ||
              currentMaDoiTuongDT == AppDefine.maDoiTuongDT_07TB.toString()) {
            // updatePhieu07Mau();
            ///Kiểm tra tồn tại IDCoSo ở các bảng thì phải xoá record đó.
            deleteRecordPhieuMau();
            // ho
            bKCoSoSXKDProvider.updateTrangThaiDTTinhTrangHD(
                currentIdCoSo!, tinhTrangHD);
          } else {
            //  updatePhieu08();
            deleteRecordPhieuTG();
            // thon
            bkCoSoTonGiaoProvider.updateTrangThaiDTTinhTrangHD(
                currentIdCoSoTG!, tinhTrangHD);
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
    }
  }

  deleteRecordPhieuMau() async {
    var phieuMau = await phieuMauProvider.isExistQuestion(currentIdCoSo!);
    if (phieuMau) {
      await phieuMauProvider.deleteByCoSoId(currentIdCoSo!);
      await phieuMauSanPhamProvider.deleteByCoSoId(currentIdCoSo!);
      await phieuMauA61Provider.deleteByCoSoId(currentIdCoSo!);
      await phieuMauA68Provider.deleteByCoSoId(currentIdCoSo!);
    }
  }

  deleteRecordPhieuTG() async {
    var phieuTG = await phieuTonGiaoProvider.isExistQuestion(currentIdCoSoTG!);
    if (phieuTG) {
      await phieuTonGiaoProvider.deleteByCoSoId(currentIdCoSoTG!);
      await phieuTonGiaoA43Provider.deleteAllByIdCoSo(currentIdCoSoTG!);
    }
  }
  // updatePhieu07Mau() async {
  //   await insertNewPhieu07MauTBCxx();
  //   var phieuMau = await phieuMauProvider.selectByIdCoso(currentIdCoSo!);
  //   if (phieuMau.isNotEmpty) {
  //     await phieuMauProvider.updateById(columnMaTinhTrangHD,
  //         currentIndex.value + 1, TablePhieuMau.fromJson(phieuMau).id!);
  //   }
  // }

  // updatePhieu08() async {
  //   await insertNewPhieu07MauTBCxx();
  //   var phieu08 = await phieuTonGiaoProvider.selectByIdCoSo(currentIdCoSoTG!);
  //   if (phieu08.isNotEmpty) {
  //     await phieuTonGiaoProvider.updateById(columnMaTinhTrangHD,
  //         currentIndex.value + 1, TablePhieuTonGiao.fromJson(phieu08).id!);
  //   }
  // }

  insertNewPhieu07MauTBCxx() async {
    var maTrangThaiHD = currentIndex.value + 1;
    if (currentMaDoiTuongDT == AppDefine.maDoiTuongDT_07Mau.toString() ||
        currentMaDoiTuongDT == AppDefine.maDoiTuongDT_07TB.toString()) {
      // var map = await bKCoSoSXKDProvider.getInformation(currentIdCoSo!);
      // var tableBkCoSoSXKD = TableBkCoSoSXKD.fromJson(map);
      var phieuMau = await phieuMauProvider.selectByIdCoSo(currentIdCoSo!);
      if (phieuMau.isNotEmpty) {
        // await phieuMauProvider.updateById(columnMaTinhTrangHD,
        //     currentIndex.value + 1, TablePhieuMau.fromJson(phieuMau).id!);
      } else {
        await initRecordPhieu07Mau(tblBkCoSoSXKD.value, maTrangThaiHD);
      }
    } else if (currentMaDoiTuongDT == AppDefine.maDoiTuongDT_08.toString()) {
      // var map = await bkCoSoTonGiaoProvider.getInformation(currentIdCoSoTG!);
      // var tableBkTonGiao = TablePhieuTonGiao.fromJson(map);
      var phieu08 = await phieuTonGiaoProvider.selectByIdCoSo(currentIdCoSoTG!);
      if (phieu08.isNotEmpty) {
        // await phieuTonGiaoProvider.updateById(columnMaTinhTrangHD,
        //     currentIndex.value + 1, TablePhieuTonGiao.fromJson(phieu08).id!);
      } else {
        await initRecordPhieu08(tblBkTonGiao.value, maTrangThaiHD);
      }
    }
  }

  ///BEGIN:: Phieu07 - Khởi tạo 1 record mặc định nếu bảng chưa có record nào.
  Future initRecordPhieu07Mau(
      TableBkCoSoSXKD tableBkCoSoSXKD, int maTrangThaiHD) async {
    List<TablePhieuMau> tableP07Maus = [];
    var tableP07 = TablePhieuMau(
        maPhieu: int.parse(currentMaDoiTuongDT!),
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

  ///END:: Phieu07 - Khởi tạo 1 record mặc định nếu bảng chưa có record nào.
  ///
  ///BEGIN:: Phieu05 - Khởi tạo 1 record mặc định nếu bảng chưa có record nào.
  Future initRecordPhieu08(
      TableBkTonGiao tableBkTonGiao, int maTrangThaiHD) async {
    List<TablePhieuTonGiao> tablePhieuTonGiaos = [];
    var tablePhieuTonGiao = TablePhieuTonGiao(
        maTinh: tableBkTonGiao.maTinh!,
        maHuyen: tableBkTonGiao.maHuyen,
        maXa: tableBkTonGiao.maXa,
        maThon: tableBkTonGiao.maThon,
        iDCoSo: tableBkTonGiao.iDCoSo,
        a1_1: tableBkTonGiao.tenCoSo,
        a1_2: tableBkTonGiao.diaChi,
        a1_3: tableBkTonGiao.dienThoai,
        a1_4: tableBkTonGiao.email,
        maDTV: AppPref.uid);
    tablePhieuTonGiaos.add(tablePhieuTonGiao);
    await phieuTonGiaoProvider.insert(
        tablePhieuTonGiaos, AppPref.dateTimeSaveDB!);
  }

  Future showDialogNhapSDT(int maTinhTrangHD) async {
    soDienThoaiCs.value = '';
    isAnimating.value = false;
    currentButtonState.value = buttonStateInit;
    Get.dialog(Dialog.fullscreen(
        // shape: RoundedRectangleBorder(
        //   borderRadius: BorderRadius.circular(AppValues.padding),
        // ),
        // insetPadding: const EdgeInsets.symmetric(horizontal: AppValues.padding),
        // elevation: 0,
        backgroundColor: Colors.white,
        child: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            child: Column(children: [
              Container(
                  //  width: Get.width,
                  width: double.infinity,
                  padding: const EdgeInsets.all(24.0),
                  // decoration: const BoxDecoration(
                  //   color: Colors.white70,
                  // ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Nhập số điện thoại của chủ cơ sở \n${tblBkCoSoSXKD.value.tenCoSo}',
                        style: styleLargeBold.copyWith(color: primaryColor),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Column(children: [
                        Container(
                          child: dialogForm(),
                        ),
                        const SizedBox(height: 24),
                        dialogButtonActions(),
                      ])
                    ],
                  ))
            ]))));
  }

  Future showDialogThongTinDangNhap(
      int maTinhTrangHD, String dieuTraCaTheUrl) async {
    Get.dialog(Dialog.fullscreen(
        backgroundColor: Colors.white,
        child: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            child: Column(children: [
              Container(
                  //  width: Get.width,
                  width: double.infinity,
                  padding: const EdgeInsets.all(24.0),
                  // decoration: const BoxDecoration(
                  //   color: Colors.white70,
                  // ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Thông tin đăng nhập',
                        style: styleLargeBold.copyWith(color: primaryColor),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      Column(children: [
                        Container(
                          child: dialogFormTTDN(dieuTraCaTheUrl),
                        ),
                        const SizedBox(height: 24),
                        Row(
                          children: [
                            Expanded(
                              child: WidgetButton(
                                  title: "Đóng", onPressed: onPressedClose),
                            ),
                          ],
                        )
                      ])
                    ],
                  ))
            ]))));
  }

  Widget dialogFormTTDN(String dieuTraCaTheUrl) {
    var userModel = mainMenuController.userModel.value;
    return Form(
      key: dialogFormKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Địa chỉ đăng nhập ',
            style: styleMedium.copyWith(color: blackText),
            textAlign: TextAlign.start,
          ),
          const Divider(),
          SelectableText(
            (dieuTraCaTheUrl == '')
                ? 'https://thidiemtdtkt2026.gso.gov.vn/CatheTongiao/MyLogin.aspx'
                : dieuTraCaTheUrl,
            style: styleMediumW400.copyWith(color: dangerColor),
            textAlign: TextAlign.start,
          ),
          const SizedBox(height: 16),
          Text(
            'Thông tin tài khoản',
            style: styleMedium.copyWith(color: blackText),
            textAlign: TextAlign.start,
          ),
          const Divider(),
          const SizedBox(height: 12),
          SelectableText.rich(TextSpan(
              text: '- Tên đăng nhập: ',
              style: styleMediumW400.copyWith(color: blackText),
              children: [
                TextSpan(
                    text: currentIdCoSo,
                    style: styleMediumW400.copyWith(color: dangerColor))
              ])),
          const SizedBox(height: 6),
          RichText(
              textAlign: TextAlign.start,
              text: TextSpan(
                  text: '- Mật khẩu: ',
                  style: styleMediumW400.copyWith(color: blackText),
                  children: [
                    TextSpan(
                        text: '1',
                        style: styleMediumW400.copyWith(color: dangerColor))
                  ])),
          const SizedBox(height: 16),
          Text(
            'Thông tin cơ sở ',
            style: styleMedium.copyWith(color: blackText),
            textAlign: TextAlign.start,
          ),
          const Divider(),
          const SizedBox(height: 12),
          RichText(
              text: TextSpan(
                  text: '- Tên cơ sở: ',
                  style: styleMediumW400.copyWith(color: blackText),
                  children: [
                TextSpan(
                    text: tblBkCoSoSXKD.value.tenCoSo,
                    style: styleMediumW400.copyWith(color: blackText))
              ])),
          const SizedBox(height: 6),
          SelectableText.rich(TextSpan(
              text: '- Số điện thoại: ',
              style: styleMediumW400.copyWith(color: blackText),
              children: [
                TextSpan(
                    text: soDienThoaiCs.value,
                    style: styleMediumW400.copyWith(color: blackText))
              ])),
          const SizedBox(height: 16),
          Text(
            'Thông tin Điều tra viên ',
            style: styleMedium.copyWith(color: blackText),
            textAlign: TextAlign.start,
          ),
          const Divider(),
          const SizedBox(height: 12),
          RichText(
              text: TextSpan(
                  text: '- Tên điều tra viên: ',
                  style: styleMediumW400.copyWith(color: blackText),
                  children: [
                TextSpan(
                    text: userModel.tenNguoiDung,
                    style: styleMediumW400.copyWith(color: blackText))
              ])),
          const SizedBox(height: 6),
          RichText(
              text: TextSpan(
                  text: '- Số điện thoại: ',
                  style: styleMediumW400.copyWith(color: blackText),
                  children: [
                TextSpan(
                    text: userModel.sDT,
                    style: styleMediumW400.copyWith(color: blackText))
              ])),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  Widget dialogForm() {
    return Column(
      children: [
        // WidgetFieldInput(
        //   controller: passwordDtvController,
        //   hint: 'Mật khẩu đăng nhập hiện tại của điều tra viên',
        //   bgColor: Colors.white,
        //   validator: validatePassword,
        //   isHideContent: true,
        // ),
        const SizedBox(height: 12),
        WidgetFieldInput(
          controller: phoneCoSoSxkdController,
          hint: 'Số điện thoại của cơ sở SXKD',
          bgColor: Colors.white,
          validator: validateMobileCosoSxkd,
        ),
      ],
    );
  }

  Widget dialogButtonActions() {
    return Row(children: [
      Expanded(
          child: Obx(
        () => WidgetButtonBorder(
          title: 'cancel'.tr,
          onPressed: (currentButtonState.value == buttonStateCompleted ||
                  currentButtonState.value == buttonStateInit)
              ? onPressedCancel
              : onPressedCancelNull,
          btnColor: currentButtonState.value == buttonStateSubmitting
              ? greyColor2
              : primaryColor,
        ),
      )),
      const SizedBox(width: AppValues.padding),
      Expanded(
          child: Obx(
        () => AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            onEnd: () => {isAnimating.value = !isAnimating.value},
            width: currentButtonState.value == buttonStateInit ? 200 : 55,
            height: 50,
            // If Button State is Submiting or Completed  show 'buttonCircular' widget as below
            child: currentButtonState.value == buttonStateInit
                ? buildButton()
                : circularContainer(
                    currentButtonState.value == buttonStateCompleted)),
      )),
    ]);
  }

  Widget buildButton() {
    return WidgetButton(title: "Xác nhận", onPressed: onPressedAccept);
  }

  Widget circularContainer(bool done) {
    final color = done ? Colors.green : primaryColor;
    return Container(
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
      child: Center(
        child: done
            ? const Icon(Icons.done, size: 40, color: Colors.white)
            : const CircularProgressIndicator(
                color: Colors.white,
              ),
      ),
    );
  }

  onPressedAccept() async {
    currentButtonState.value = buttonStateSubmitting;
    // await Future.delayed(const Duration(seconds: 2));
    // currentButtonState.value = buttonStateCompleted;
    // await Future.delayed(const Duration(seconds: 2));
    //currentButtonState.value = buttonStateInit;
    //String pwd = passwordDtvController.text.trim();
    String mobiPhone = phoneCoSoSxkdController.text.trim();
    soDienThoaiCs.value = mobiPhone;
    //var resValidPwd = validatePassword(pwd);
    // if (resValidPwd != '' && resValidPwd != null) {
    //   return snackBar('Thông tin lỗi', resValidPwd,
    //       style: ToastSnackType.error);
    // }
    // var resValidConfirmPwd = validateCurrentPassword(pwd);
    // if (resValidConfirmPwd != '' && resValidConfirmPwd != null) {
    //   return snackBar('Thông tin lỗi', resValidConfirmPwd,
    //       style: ToastSnackType.error);
    // }
    var resValidMobile = validateMobileCosoSxkd(mobiPhone);
    if (resValidMobile != '' && resValidMobile != null) {
      currentButtonState.value = buttonStateInit;
      return snackBar('Thông tin lỗi', resValidMobile,
          style: ToastSnackType.error);
    }
    // Get.close(1);
    //await showDialogThongTinDangNhap(AppDefine.maTinhTrangHDTuKeKhai - 1);

    await executeXacNhanTuKeKhai(currentIndex.value + 1);
  }

  onPressedCancelNull() async {}
  onPressedCancel() async {
    currentButtonState.value = buttonStateInit;
    Get.back();
  }

  onPressedClose() async {
    currentButtonState.value = buttonStateInit;
    Get.back();
    Get.back();
    // Get.offAllNamed(AppRoutes.mainMenu);
  }

  executeXacNhanTuKeKhai(int maTrinhTrangHD) async {
    var userModel = mainMenuController.userModel.value;
    String mobiPhone = phoneCoSoSxkdController.text.trim();
    String signatureXN =
        '${tblBkCoSoSXKD.value.maTinh}:${userModel.maDangNhap}:$currentIdCoSo:$maTrinhTrangHD:1';
    var bytes = utf8.encode(signatureXN);
    var md5Cover = md5.convert(bytes);
    Map body = {
      "MaTinh": tblBkCoSoSXKD.value.maTinh,
      "MaDangNhap": userModel.maDangNhap,
      "IdCoSo": currentIdCoSo,
      "SoDienThoaiCs": mobiPhone,
      "MaTinhTrangHD": maTrinhTrangHD,
      "LoaiDoiTuong": 1,
      "Signature": md5Cover.toString()
    };
    //goi server ok
    var (result, siteUrl) = await xacNhanToServer(body);
    if (result == "true") {
      ///xoá dữ liệu ở capi của currentidcoso
      await deleteCoSoSXKD();
      currentButtonState.value = buttonStateCompleted;
      Get.close(1);
      snackBar('Thông báo', 'Đã cập nhật');
      await showDialogThongTinDangNhap(
          AppDefine.maTinhTrangHDTuKeKhai - 1, siteUrl);
    } else {
      currentButtonState.value = buttonStateInit;
      if (result != null && result != '') {
        return snackBar('Thông tin lỗi', result, style: ToastSnackType.error);
      } else {
        return snackBar('Thông tin lỗi',
            'Đã có lỗi xảy ra, vui lòng kiểm tra kết nối internet và thử lại',
            style: ToastSnackType.error);
      }
    }
  }

  Future deleteCoSoSXKD() async {
    await phieuMauA61Provider.deleteByCoSoId(currentIdCoSo!);
    await phieuMauA68Provider.deleteByCoSoId(currentIdCoSo!);
    await phieuMauSanPhamProvider.deleteByCoSoId(currentIdCoSo!);
    await phieuMauProvider.deleteByCoSoId(currentIdCoSo!);
    await bKCoSoSXKDProvider.deleteByCoSoId(currentIdCoSo!);
  }

  Future<(String, String)> xacNhanToServer(body,
      {bool isRetryWithSignIn = false}) async {
    print('$body');

    ResponseModel<String> request =
        await xacnhanTukekhaiRepository.xacNhanTuKeKhaiCsSxkd(body);
    print(request);
    if (request.statusCode == ApiConstants.errorToken && !isRetryWithSignIn) {
      var resp = await authRepository.getToken(
          userName: AppPref.userName, password: AppPref.password);
      AppPref.extraToken = resp.body?.accessToken;
      await xacNhanToServer(body, isRetryWithSignIn: true);
    }
    if (request.statusCode == ApiConstants.success) {
      ResponseCmmModel resp =
          ResponseCmmModel.fromJson(jsonDecode(request.body!));
      if (resp.responseCode == ApiConstants.responseSuccess) {
        String siteUrl =
            resp.objectData != null ? resp.objectData.toString() : "";
        return ("true", siteUrl);
      } else {
        if (resp.responseCode == ApiConstants.invalidModelSate) {
          return ("Dữ liệu đầu vào không đúng định dạng.", "");
        } else if (resp.responseCode == ApiConstants.khoaCAPI) {
          return ("Khóa CAPI đang bật.", "");
        } else if (resp.responseCode == ApiConstants.duLieuDongBoRong) {
          return ("${resp.responseMessage}", "");
        } else {
          return ("Lỗi cập nhật thông tin:${resp.responseMessage}", "");
        }
      }
    } else if (request.statusCode == HttpStatus.requestTimeout) {
      return ('Request timeout.', "");
    } else if (request.statusCode == 401) {
      return ('Tài khoản đã hết hạn, vui lòng đăng nhập và đồng bộ lại.', "");
    } else if (request.statusCode == ApiConstants.errorDisconnect) {
      return ('Kết nối mạng đã bị ngắt. Vui lòng kiểm tra lại.', "");
    } else if (request.statusCode == ApiConstants.errorException) {
      return ('Có lỗi: ${request.message}', "");
    } else if (request.statusCode == HttpStatus.requestTimeout) {
      return ('Request timeout.', "");
    } else if (request.statusCode == HttpStatus.internalServerError) {
      return ('Có lỗi: ${request.message}', "");
    } else if (request.statusCode == ApiConstants.errorServer) {
      return ('CKhông thể kết nối đến máy chủ', "");
    } else {
      return (
        'Đã có lỗi xảy ra, vui lòng kiểm tra kết nối internet và thử lại',
        ""
      );
    }
  }

  String? validatePassword(String? password) {
    if (password == null || password.trim().isEmpty) {
      return 'Vui lòng nhập mật khẩu đăng nhập hiện tại của điều tra viên.';
    }
    return null;
  }

  String? validateCurrentPassword(String? p1) {
    var bytes = utf8.encode(p1 ?? ""); // data being hashed
    var md5Cover = md5.convert(bytes);
    String currentPass = mainMenuController.userModel.value.matKhau ?? "";

    if ('$md5Cover' != currentPass) {
      return 'Mật khẩu không khớp với mật khẩu hiện tại';
    } else if (p1 == null) {
      return 'Vui lòng nhập mật khẩu đăng nhập hiện tại của điều tra viên.';
    } else {
      return null;
    }
  }

  String? validateMobileCosoSxkd(String? value) {
    var resValidMobi = Valid.validateMobile(value);
    return resValidMobi;
  }

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
