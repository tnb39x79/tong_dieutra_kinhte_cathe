import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gov_statistics_investigation_economic/common/widgets/dialogs/dialog_completed_fullscreen.dart';
import 'package:rxdart/rxdart.dart';
import 'package:gov_statistics_investigation_economic/common/common.dart';
import 'package:gov_statistics_investigation_economic/common/widgets/dialogs/dialog_completed.dart';
import 'package:gov_statistics_investigation_economic/config/constants/app_colors.dart';
import 'package:gov_statistics_investigation_economic/resource/resource.dart';
import 'package:gov_statistics_investigation_economic/resource/services/location/location_provider.dart';

String kinhDoBase = 'KinhDo';
String viDoBase = "ViDo";
String soDienThoaiBase = 'SoDienThoai';
String nguoiTraLoiBase = "NguoiTraLoi";
String soDienThoaiDTVBase = 'SoDienThoaiDTV';
String hoTenDTVBase = "HoTenDTV";
String trangThaiCoSo = "TrangThaiCoSo";

abstract class BaseController extends FullLifeCycleController
    with FullLifeCycleMixin {
  final loadingSubject = BehaviorSubject<bool>.seeded(false);
  final errorSubject = BehaviorSubject<String>();

  // void setLoading(bool loading) {
  //   if (loading != isLoading) loadingSubject.add(loading);
  // }
  void setLoading(bool loading) {
    setSink.add(loading);
  }

  Sink<bool> get setSink => loadingSubject.sink;

  // Stream to listen to events
  Stream<bool> get stream => loadingSubject.stream;
  bool get isLoading => loadingSubject.value;

  void setError(String message) {
    errorSubject.add(message);
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  GlobalKey<ScaffoldState> get scaffoldKey => _scaffoldKey;
  void showError(msg) {
    return snackBar('Thông tin lỗi', msg, style: ToastSnackType.error);
  }

  // network
  bool get isConnected => NetworkService.connectionType != Network.none;

  ///tuannb; 10/06/2024: Nên tăng thời gian cho snackBar vì mặc định 3 giây ẩn thông báo nhanh quá ko kịp đọc
  ///duration: const Duration(seconds: 4),
  void snackBar(String title, String msg,
      {ToastSnackType style = ToastSnackType.normal,
      Duration durationSecond = const Duration(seconds: 6)}) {
    var colorTxt = style == ToastSnackType.normal
        ? successColor
        : style == ToastSnackType.error
            ? errorColor
            : Colors.black;
    if (style == ToastSnackType.warning) {
      colorTxt = warningColor;
    }
    Get.snackbar(
      title,
      msg,
      colorText: colorTxt,
      backgroundColor: Colors.grey.shade100,
      duration: durationSecond,
    );
  }

  Future toast(String msg,
      {ToastSnackType style = ToastSnackType.normal}) async {
    switch (style) {
      case ToastSnackType.error:
        break;
      case ToastSnackType.success:
        break;
      case ToastSnackType.normal:
      default:
        return;
    }
  }

  void unFocus(BuildContext context) {
    FocusScope.of(context).unfocus();
  }

  @override
  void onClose() async {
    await loadingSubject.drain();
    loadingSubject.close();
    await errorSubject.drain();
    errorSubject.close();
    super.onClose();
  }

  double? glat;
  double? glng;
  // handle completed question
  handleCompletedQuestion({
    required Map tableThongTinNPV,
    required Function(String?) onChangeName,
    required Function(String?) onChangePhone,
    required Function(String?) onChangeNameDTV,
    required Function(String?) onChangePhoneDTV,
    required Function(Map) onUpdate,
  }) {
    log("KINH do: ${tableThongTinNPV[kinhDoBase] ?? tableThongTinNPV[kinhDoBase]}");
    return Get.dialog(DialogCompletedFullscreen(
      hideDTVInfo: true,
      name: tableThongTinNPV[nguoiTraLoiBase] == 0
          ? null
          : tableThongTinNPV[nguoiTraLoiBase],
      phone: tableThongTinNPV[soDienThoaiBase] == 0
          ? null
          : tableThongTinNPV[soDienThoaiBase],
      nameDTV: tableThongTinNPV[hoTenDTVBase] == 0
          ? null
          : tableThongTinNPV[hoTenDTVBase],
      phoneDTV: tableThongTinNPV[soDienThoaiDTVBase] == 0
          ? null
          : tableThongTinNPV[soDienThoaiDTVBase],
      lat: tableThongTinNPV[kinhDoBase] ?? tableThongTinNPV[kinhDoBase],
      lng: tableThongTinNPV[viDoBase] ?? tableThongTinNPV[viDoBase],
      onChangeName: onChangeName,
      onChangePhone: onChangePhone,
      onChangeNameDTV: onChangeNameDTV,
      onChangePhoneDTV: onChangePhoneDTV,
      onOk: (position) async {
        var _phone = tableThongTinNPV[soDienThoaiBase];
        String? _name = tableThongTinNPV[nguoiTraLoiBase];
        var _phoneDtv = tableThongTinNPV[soDienThoaiDTVBase];
        String? _nameDtv = tableThongTinNPV[hoTenDTVBase];
        var valid = Valid.validatePhoneAndName(
            "$_phone", _name, "$_phoneDtv", _nameDtv);
        if (valid != null && valid != '') {
          return snackBar(
            'error_information'.tr,
            valid,
            style: ToastSnackType.error,
          );
        }
        Get.back();
        final isUpdateNewLocation =
            await _handleLocation(position, tableThongTinNPV, onUpdate);

        if (isUpdateNewLocation) {
          snackBar('Cập nhật tọa độ thành công', '');
        }

        // int _nexScreen = await generalInformationController.getIndexNexScreen(1);
        // setLoading(false);
        // generalInformationController.getNextScreen(_nexScreen);
      },
    ));
  }

  _handleLocation(
      LocationModel? position, Map answer, Function(Map) onUpdate) async {
    double? lat = answer[kinhDoBase];
    double? lng = answer[viDoBase];

    bool isUpdateWithNonePosition = true;
    bool isUpdateLocation = true;
    bool isUpdateNewLocation = false;

    Map<String, Object?> updateValues = {};

    if (position == null) {
      isUpdateWithNonePosition =
          await LocationProVider.requestLocationServices();
      if (!isUpdateWithNonePosition) return isUpdateWithNonePosition;
    }

    if (!isUpdateWithNonePosition) return isUpdateWithNonePosition;

    final isNewLocation = lat != null &&
        lng != null &&
        lat != position?.latitude &&
        lng != position?.longitude;
    glat = position?.latitude;
    glng = position?.longitude;
    if (isNewLocation) {
      isUpdateLocation = await handleUpdateLocation();
      if (isUpdateLocation) {
        updateValues.addAll({
          kinhDoBase: position?.latitude,
          viDoBase: position?.longitude,
        });

        isUpdateNewLocation = true;
      }
    } else {
      updateValues.addAll({
        kinhDoBase: position?.latitude,
        viDoBase: position?.longitude,
      });
    }

    // await Future.wait(
    //     updateValues.keys.map((e) => _updateAnswerToDB(e, updateValues[e])));

    onUpdate(updateValues);
    return isUpdateNewLocation;
  }

  handleNoneLocation() async {
    final isUpdate = await Get.dialog(DialogWidget(
      onPressedPositive: () => Get.back(result: false),
      onPressedNegative: () => Get.back(result: false),
      isCancelButton: false,
      content: "Tọa độ rỗng. Vui lòng lấy lại toạ độ.",
      title: "Tọa độ rỗng",
    ));

    return isUpdate;
  }

  handleUpdateLocation() async {
    final isUpdate = await Get.dialog(
      DialogWidget(
        onPressedPositive: () => Get.back(result: true),
        onPressedNegative: () => Get.back(result: false),
        title: 'Cập nhật tọa độ',
        content:
            'Đơn vị đã có kinh độ, vĩ độ, bạn có muốn cập nhật tọa độ mới cho đơn vị không ?',
      ),
    );

    return isUpdate;
  }

  getStartDate(String idHo, int maPhieu, DateTime startTime) {
    DateTime currentStartTime = startTime;
    String qStartTime = AppPref.getQuestionNoStartTime;
    if (qStartTime == '') {
      StartTimeModel startTimeModel = StartTimeModel(
          idHo: idHo, idPhieu: maPhieu, startTime: startTime.toIso8601String());
      AppPref.setQuestionNoStartTime = jsonEncode(startTimeModel);
      return startTime;
    } else {
      final jsonData = jsonDecode(qStartTime);
      // final startTimeModel = StartTimeModel.fromJson(map);
      StartTimeModel startTimeModel = StartTimeModel.fromJson(jsonData);
      if (idHo == startTimeModel.idHo && maPhieu == startTimeModel.idPhieu) {
        if (startTimeModel.startTime != null) {
          currentStartTime = DateTime.parse(startTimeModel.startTime!);
        }
      }
      return currentStartTime;
    }
  }
}
