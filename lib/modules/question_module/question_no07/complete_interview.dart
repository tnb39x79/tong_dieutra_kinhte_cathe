import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gov_statistics_investigation_economic/common/common.dart';
import 'package:gov_statistics_investigation_economic/common/widgets/dialogs/recording_dialog.dart';
import 'package:gov_statistics_investigation_economic/common/widgets/input/widget_field_input_mix.dart';
import 'package:gov_statistics_investigation_economic/common/widgets/input/widget_field_input_text.dart';
import 'package:gov_statistics_investigation_economic/common/widgets/loadings/loading_overlay_helper.dart';
import 'package:gov_statistics_investigation_economic/config/constants/app_colors.dart';
import 'package:gov_statistics_investigation_economic/config/constants/app_define.dart';
import 'package:gov_statistics_investigation_economic/config/constants/app_styles.dart';
import 'package:gov_statistics_investigation_economic/config/constants/app_values.dart';
import 'package:gov_statistics_investigation_economic/modules/modules.dart';
import 'package:gov_statistics_investigation_economic/modules/question_module/question_no07/question_phieu_tb_controller.dart';

import 'package:gov_statistics_investigation_economic/resource/database/table/filed_common.dart';

import '/resource/services/location/location_provider.dart';

class CompletedResult {
  final bool isEdited;
  final Map<dynamic, dynamic> completeInfo;

  CompletedResult({
    required this.isEdited,
    required this.completeInfo,
  });
}

class CompleteInterviewScreen extends StatefulWidget {
  const CompleteInterviewScreen({super.key, this.lyDoKetThucPv = 0});

  final int? lyDoKetThucPv;
  @override
  State<CompleteInterviewScreen> createState() =>
      _CompleteInterviewScreenState();
}

class _CompleteInterviewScreenState extends State<CompleteInterviewScreen> {
  final QuestionPhieuTBController controller =
      Get.find<QuestionPhieuTBController>();

  final _formKey = GlobalKey<FormState>();
  final hoTenController = TextEditingController();
  final soDienThoaiController = TextEditingController();
  final _giaiTrinhController = TextEditingController();
  final _lyDoThoiGianController = TextEditingController();
  final _lyDoDinhViController = TextEditingController();
  final _latController = TextEditingController();
  final _lngController = TextEditingController();

  bool _isFirstLoading = true;
  bool _allowEdit = true;
  bool _isEdited = false;
  Map<dynamic, dynamic> completeInfo = <dynamic, dynamic>{}.obs;
  Map<dynamic, dynamic> completeInfoNew = <dynamic, dynamic>{}.obs;

  @override
  void initState() {
    super.initState();
    completeInfo = controller.completeInfo;

    _initData();
    hoTenController.addListener(_setEdited);
    soDienThoaiController.addListener(_setEdited);
    _giaiTrinhController.addListener(_setEdited);
    _lyDoThoiGianController.addListener(_setEdited);
    _lyDoDinhViController.addListener(_setEdited);
  }

  @override
  void dispose() {
    hoTenController.removeListener(_setEdited);
    soDienThoaiController.removeListener(_setEdited);
    _giaiTrinhController.removeListener(_setEdited);
    _lyDoThoiGianController.removeListener(_setEdited);
    _lyDoDinhViController.removeListener(_setEdited);
    _giaiTrinhController.dispose();
    _lyDoThoiGianController.dispose();
    _lyDoDinhViController.dispose();
    _latController.dispose();
    _lngController.dispose();
    super.dispose();
  }

  void _setEdited() {
    if (!_isEdited) {
      setState(() {
        _isEdited = true;
      });
    }
  }

  _initData() async {
    hoTenController.text = controller.tblPhieu.value.nguoiTraLoi ?? '';
    soDienThoaiController.text = controller.tblPhieu.value.soDienThoai ?? '';
    _latController.text = completeInfo?[columnViDo].toString() ?? '';
    _lngController.text = completeInfo?[columnKinhDo].toString() ?? '';
    // _giaiTrinhController.text = completeInfo?[columnGhiChu].ghiChu ?? '';
    //_lyDoThoiGianController.text =  controller.tblPhieu.value.giaiTrinhThoiGianPV ?? '';
    _lyDoDinhViController.text = completeInfo?[giaiTrinhToaDo] ?? '';

    if (completeInfo?[columnViDo] != null &&
        completeInfo?[columnKinhDo] != null) {
    } else {
      await _fetchLocation(firstLoading: true);
    }

    //  final isEdit = controller.tblBkTonGiao.value.maTrangThaiDT ==   AppDefine.hoanThanhPhongVan;
    if (mounted) {
      setState(() {
        //  _allowEdit = !isEdit;
        _isFirstLoading = false;
      });
    }
  }

  Future<void> _fetchLocation({
    bool firstLoading = false,
  }) async {
    final hasPermission = await _checkAndFetchLocation();
    if (hasPermission != true) return;

    if (_isUpdatingCoordinates()) {
      final confirm = await _showDialogUpdateLocation();
      if (confirm != true) {
        return;
      }
    }

    LoadingOverlayHelper.show(context);
    try {
      final pos = await LocationProVider.getLocation();
      _latController.text = pos.latitude.toString();
      _lngController.text = pos.longitude.toString();
      onChangeText(null, giaiTrinhToaDo);
      _setEdited();
    } catch (_) {
      // Handle error if needed
      _latController.text = '';
      _lngController.text = '';
      controller.showError("Không thể lấy vị trí");
    } finally {
      LoadingOverlayHelper.hide();
    }
  }

  Future<bool?> _checkAndFetchLocation() async {
    final hasPermission = await LocationProVider.checkPermission();
    if (hasPermission) {
      return true;
    }
    final granted = await LocationProVider.requestPermission();
    if (granted) {
      return true;
    } else {
      _showGpsPermissionDialog();
    }
    return null;
  }

  Widget _buildLatLngSection() {
    return Column(
      children: [
        const SizedBox(height: 8),
        Row(
          children: [
            TextQuestion("Vị trí điều tra"),
            const Spacer(),
            Center(
              child: IntrinsicWidth(
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.location_pin),
                      label: const Text("Lấy tọa độ"),
                      onPressed: _fetchLocation,
                      style: ElevatedButton.styleFrom(
                          side: const BorderSide(
                              width: 1.0, color: primaryLightColor),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(AppValues.borderLv5),
                          ),
                          foregroundColor: primaryColor),
                    )),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: WidgetSmallFieldInput(
                controller: _lngController,
                hint: 'Trống',
                enable: false,
                label: "Kinh độ",
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: WidgetSmallFieldInput(
                controller: _latController,
                hint: 'Trống',
                enable: false,
                label: "Vĩ độ",
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildFormFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        buildFormThongTinNguoiPV(),
        if (!_isFirstLoading) buildLyDo(),
        _buildLatLngSection(),
        const SizedBox(height: 16),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Hoàn thành phiếu",
          style: styleMediumBold.copyWith(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: primaryColor,
        iconTheme: const IconThemeData(color: Colors.white),
        leading: const SizedBox(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IgnorePointer(
                ignoring: false,
                child: _buildFormFields(),
              ),
              Row(
                children: [
                  Expanded(
                    child: WidgetButton(
                      title: 'Hủy',
                      onPressed: () =>
                          Get.back(result: ['cancel', widget.lyDoKetThucPv.toString()]),
                      buttonType: BtnType.outline,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: WidgetButton(
                      title: 'Đồng ý',
                      onPressed: _onPressCompleteInterview,
                    ),
                  ),
                ],
              ),
              SizedBox(height: Get.mediaQuery.viewPadding.bottom + 16),
            ],
          )),
        ),
      ),
    );
  }

  Widget buildFormThongTinNguoiPV() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      TextQuestion("Người cung cấp thông tin"),
      WidgetFieldInputText(
        controller: hoTenController,
        maxLength: 250,
        hint: 'Nhập Họ và tên người cung cấp thông tin',
        onChanged: (String? value) => onChangeText(value, columnNguoiTraLoi),
        validator: (String? value) =>
            onValidate(value, fieldName: columnNguoiTraLoi),
        onMicrophoneTap: () => onMicrophoneTap(columnNguoiTraLoi),
        enable: true,
      ),
      const SizedBox(height: 16),
      WidgetFieldInputText(
        controller: soDienThoaiController,
        hint: 'Nhập số điện thoại người cung cấp thông tin',
        keyboardType: TextInputType.number,
        maxLength: 11,
        onChanged: (String? value) => onChangeText(value, columnSoDienThoai),
        validator: Valid.validateMobile,
      ),
    ]);
  }

  buildLyDo() {
    if (!_hasCoordinates()) {
      return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        TextQuestion("Nhập lý do định vị không chính xác"),
        WidgetFieldInputText(
          controller: _lyDoDinhViController,
          hint: 'Nhập lý do định vị không chính xác',
          maxLine: 3,
          minLine: 3,
          maxLength: 500,
          enable: true,
          onChanged: (String? value) => onChangeText(value, giaiTrinhToaDo),
          validator: (String? value) =>
              onValidate(value, fieldName: giaiTrinhToaDo),
          onMicrophoneTap: () => onMicrophoneTap(giaiTrinhToaDo),
        )
      ]);
    }
    return SizedBox();
  }

  onChangeText(String? value, String fieldName) {
    if (fieldName == columnNguoiTraLoi) {
      String result;
      result = value ?? '';

      int maxL = 250;
      // Truncate if necessary
      if (result.length > maxL) {
        result = result.substring(0, maxL);
        controller.onChangeCompleted(fieldName, value);
      }
    } else if (fieldName == giaiTrinhToaDo) {
      String result;
      result = value ?? '';

      int maxL = 500;
      // Truncate if necessary
      if (result.length > maxL) {
        result = result.substring(0, maxL);
        controller.onChangeCompleted(fieldName, value);
      }
    } else {
      controller.onChangeCompleted(fieldName, value);
    }
  }

  onValidate(String? text, {bool? isRequired, String? fieldName}) {
    if (isRequired != null && isRequired && (text == null || text.isEmpty)) {
      return 'Vui lòng nhập giá trị.';
    }
    return null;
  }
  // Future<void> onMicrophoneTap(TextEditingController controller) async {
  //   try {
  //     // Show the modern recording dialog
  //     final recognizedText = await showRecordingDialog(
  //       title: 'Ghi âm câu trả lời',
  //       hint: 'Nhấn để bắt đầu ghi âm câu trả lời...',
  //       onTextRecognized: (text) {
  //         log('Text recognized in dialog: "$text"');
  //       },
  //     );

  //     // If we got text back, use it to fill the form field
  //     if (recognizedText != null && recognizedText.isNotEmpty) {
  //       // Update the form field with the recognized text
  //       controller.value = controller.value.copyWith(
  //         text: recognizedText,
  //         selection: TextSelection.fromPosition(
  //           TextPosition(offset: recognizedText.length),
  //         ),
  //       );
  //     }
  //   } catch (e, stackTrace) {
  //     log('onMicrophoneTap error: $e $stackTrace');
  //   }
  // }

  _onPressCompleteInterview() async {
    // if (_isConditionalInterviewTime() && _lyDoThoiGianController.text.isEmpty) {
    //   controller.showError("Vui lòng nhập lý do thời gian phỏng vấn ngắn");
    //   return;
    // }
    if (controller.validateEmptyString(hoTenController.text) ||
        hoTenController.text.isEmpty) {
      controller.showError("Vui lòng nhập Họ và tên người cung cấp thông tin");
      return;
    }
    if (controller.validateEmptyString(soDienThoaiController.text) ||
        soDienThoaiController.text.isEmpty) {
      controller
          .showError("Vui lòng nhập Số điện thoại người cung cấp thông tin");
      return;
    }
    if (!_hasCoordinates() && _lyDoDinhViController.text.isEmpty) {
      controller.showError("Vui lòng nhập lý do định vị không chính xác");
      return;
    }

    completeInfoNew = controller.completeInfo;

    mapDataInfo(columnNguoiTraLoi, hoTenController.text);
    mapDataInfo(columnSoDienThoai, soDienThoaiController.text);

    mapDataInfo(columnKinhDo, _lngController.text);
    mapDataInfo(columnViDo, _latController.text);

    /// kiểm tra nếu phiếu đã có kinh độ và vĩ độ thì cập nhật lý do định vị không chính xác = null
    if (completeInfo?[columnKinhDo] != null &&
        completeInfo?[columnViDo] != null) {
      mapDataInfo(giaiTrinhToaDo, null);
    } else {
      mapDataInfo(columnKinhDo, _lngController.text);
      mapDataInfo(columnViDo, _latController.text);
    }

    // if (_lyDoThoiGianController.text.isNotEmpty) {
    //   newPhieu.giaiTrinhThoiGianPV = _lyDoThoiGianController.text;
    // }

    if (_lyDoDinhViController.text.isNotEmpty) {
      mapDataInfo(giaiTrinhToaDo, _lyDoDinhViController.text);
    }

    /// cập nhật mới có toạ độ -> xoá lý do
    if (completeInfo?[columnKinhDo] != null &&
        completeInfo?[columnViDo] != null) {
      mapDataInfo(giaiTrinhToaDo, null);
    }

    Get.back(
      result: CompletedResult(
          isEdited: _allowEdit,
          completeInfo: completeInfoNew),
    );
  }

  mapDataInfo(key, value) {
    Map<String, dynamic> map = Map<String, dynamic>.from(completeInfoNew);
    map.update(key, (val) => value, ifAbsent: () => value);
    completeInfoNew = map;
    return completeInfoNew;
  }

  /// ----- validate ------
  ///
  // /// Kiểm tra thời gian phỏng vấn có ngắn hơn thời gian tối thiểu không
  // bool _isConditionalInterviewTime() {
  //   try {
  //     final requiredTime = AppPref.tokenModel?.thoiGianPVToiThieu ?? '0';
  //     final start = DateTime.parse(widget.tlbPhieu.thoiGianBD ?? '');
  //     final end = DateTime.parse(widget.tlbPhieu.thoiGianKT ?? '');
  //     final seconds = end.difference(start).inSeconds;

  //     if (seconds < int.parse(requiredTime)) {
  //       return true;
  //     }
  //     return false;
  //   } catch (e) {
  //     log('Error in _isConditionalInterviewTime: ${e.toString()}');
  //     return false; // Default to false if there's an error
  //   }
  // }

  /// Kiểm tra có toạ độ hay không
  bool _hasCoordinates() {
    return _latController.text.isNotEmpty && _lngController.text.isNotEmpty;
  }

  /// Kiểm tra xem có phải đang cập nhật toạ độ hay không
  ///
  /// Nếu có show cảnh báo cập nhật toạ độ
  bool _isUpdatingCoordinates() {
    return (completeInfo?[columnKinhDo] != null &&
        completeInfo?[columnViDo] != null);
  }

  /// ---- pop up confirmation ------
  ///
  /// Cảnh báo không có quyền truy cập GPS

  _showGpsPermissionDialog() async {
    return await Get.dialog(
      DialogWidget(
        onPressedPositive: () => LocationProVider.openSetting(),
        onPressedNegative: Get.back,
        title: 'Không có quyền truy cập vị trí',
        content:
            'Cần có quyền truy cập vị trí để cập nhật vị trí điều tra. Bạn có muốn mở cài đặt để cấp quyền?',
      ),
    );
  }

  /// Cảnh báo cập nhật toạ độ
  Future<bool> _showDialogUpdateLocation() async {
    return await Get.dialog(
      DialogWidget(
        onPressedPositive: () => Get.back(result: true),
        onPressedNegative: () => Get.back(result: false),
        title: 'Cập nhật tọa độ',
        content:
            'Đơn vị đã có kinh độ, vĩ độ, bạn có muốn cập nhật tọa độ mới cho đơn vị không?',
      ),
    );
  }

  Future<void> onMicrophoneTap(String fieldName) async {
    try {
      // Show the modern recording dialog
      final recognizedText = await showRecordingDialog(
        title: 'Ghi âm câu trả lời',
        hint: 'Nhấn để bắt đầu ghi âm câu trả lời...',
        onTextRecognized: (text) {
          log('Text recognized in dialog: "$text"');
        },
      );

      // If we got text back, use it to fill the form field
      if (recognizedText != null && recognizedText.isNotEmpty) {
        // Update the form field with the recognized text
        onChangeText(recognizedText, fieldName);
      }
    } catch (e, stackTrace) {
      log('onMicrophoneTap error: $e $stackTrace');
    }
  }
}
