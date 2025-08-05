import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:gov_statistics_investigation_economic/common/common.dart';
import 'package:gov_statistics_investigation_economic/config/config.dart';
import 'package:gov_statistics_investigation_economic/config/constants/app_colors.dart';
import 'package:gov_statistics_investigation_economic/resource/resource.dart';
import 'package:gov_statistics_investigation_economic/resource/services/location/location_provider.dart';

class DialogCompletedFullscreen extends StatefulWidget {
  final Function(String?)? onChangeName;
  final Function(String?)? onChangePhone;
  final Function(String?)? onChangeNameDTV;
  final Function(String?)? onChangePhoneDTV;
  final Function(LocationModel?) onOk;
  final String title;
  final String? name;
  final String? phone;
  final String? nameDTV;
  final String? phoneDTV;
  final double? lat;
  final double? lng;
  final bool? hideDTVInfo;

  const DialogCompletedFullscreen(
      {super.key,
      this.onChangeName,
      this.onChangePhone,
      this.onChangeNameDTV,
      this.onChangePhoneDTV,
      this.name,
      this.phone,
      this.nameDTV,
      this.phoneDTV,
      required this.onOk,
      this.lat,
      this.lng,
      this.title = "Hoàn thành phiếu",
      this.hideDTVInfo});

  @override
  State<DialogCompletedFullscreen> createState() =>
      _DialogCompletedFullscreenState();
}

class _DialogCompletedFullscreenState extends State<DialogCompletedFullscreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController nameDtvController = TextEditingController();
  final TextEditingController phoneDtvController = TextEditingController();
  final TextEditingController latController = TextEditingController();
  final TextEditingController lngController = TextEditingController();

  bool _loading = false;
  LocationModel? location;

  @override
  void initState() {
    super.initState();

    // If the household already has the coordinates => the old coordinates show, otherwise the current coordinates
    _initState();
  }

  _initState() {
    nameController.text = widget.name ?? '';
    phoneController.text = widget.phone ?? '';
    nameDtvController.text = widget.nameDTV ?? '';
    phoneDtvController.text = widget.phoneDTV ?? '';
    if (widget.lat != null && widget.lng != null) {
      latController.text = widget.lat.toString();
      lngController.text = widget.lng.toString();
      location = LocationModel(latitude: widget.lat!, longitude: widget.lng!);

      setState(() {});

      return;
    }
    _getLatLng();
  }

  _getLatLng() async {
    try {
      setState(() {
        _loading = true;
      });
      await Future.delayed(const Duration(milliseconds: 500));
      await LocationProVider.requestPermission();
      bool resCheckLoc = await LocationProVider.requestLocationServices();
      if (resCheckLoc) {
        Position _location = await LocationProVider.getLocation();
        latController.text = _location.latitude.toString();
        lngController.text = _location.longitude.toString();

        location = LocationModel(
            latitude: _location.latitude, longitude: _location.longitude);
      }
      setState(() {
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _loading = false;
      });

      log('DialogCompletedQuestion, get location error: $e');
    }
  }

  Widget _buttonContent() {
    if (_loading) {
      return const SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(
          strokeWidth: 0.5,
        ),
      );
    }

    // return ElevatedButton(
    //   onPressed: _getLatLng,
    //   style: ButtonStyle(
    //     overlayColor: WidgetStateProperty.all(greyBorder),
    //     backgroundColor: WidgetStateProperty.all(greyBorder),
    //     foregroundColor: WidgetStateProperty.all(blackText),
    //   ),
    //   child: const Text('Lấy tọa độ'),
    // );

    return OutlinedButton.icon(
      icon: const Icon(Icons.location_pin),
      label: const Text("Lấy tọa độ"),
      onPressed: _getLatLng,
      style: ElevatedButton.styleFrom(
          side: const BorderSide(width: 1.0, color: primaryLightColor),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppValues.borderLv5),
          ),
          foregroundColor: primaryColor),
    );
  }

  _onTapOk() {
    widget.onOk(location);
  }

  @override
  Widget build(BuildContext context) {
    return DialogFullScreenWidget(
      onPressedPositive: _onTapOk,
      onPressedNegative: Get.back,
      title: widget.title,
      content: '',
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Người cung cấp thông tin', style: styleMediumBold),
          WidgetFieldInput(
            controller: nameController,
            hint: 'Nhập họ tên người cung cấp thông tin',
            onChanged: widget.onChangeName,
          ),
          const SizedBox(height: 4),
          WidgetFieldInput(
            controller: phoneController,
            hint: 'Nhập số điện thoại người cung cấp thông tin',
            onChanged: widget.onChangePhone,
            validator: Valid.validateMobile,
            keyboardType: TextInputType.number,
            maxLength: 11,
          ),
          if (widget.hideDTVInfo != null && widget.hideDTVInfo == false) ...[
            const SizedBox(height: 2),
            const Text('Điều tra viên', style: styleMediumBold),
            WidgetFieldInput(
              controller: nameDtvController,
              hint: 'Nhập họ tên tên điều tra viên',
              onChanged: widget.onChangeNameDTV,
            ),
            const SizedBox(height: 4),
            WidgetFieldInput(
              controller: phoneDtvController,
              hint: 'Nhập số điện thoại điều tra viên',
              onChanged: widget.onChangePhoneDTV,
              validator: Valid.validateMobile,
              keyboardType: TextInputType.number,
              maxLength: 11,
            ),
          ],
          const SizedBox(height: 2),
          Column(
            children: [
              _buttonContent(),
              Row(children: [
                Expanded(
                  child: WidgetSmallFieldInput(
                    controller: latController,
                    hint: 'Trống',
                    enable: false,
                    label: "Vĩ độ",
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: WidgetSmallFieldInput(
                    controller: lngController,
                    hint: 'Trống',
                    enable: false,
                    label: "Kinh độ",
                  ),
                )
              ]),
            ],
          )
        ],
      ),
    );
  }

  String? validateMobile(String? value) {
    String pattern = r'(^(?:[+0]9)?[0-9]{10}$)';
    RegExp regExp = RegExp(pattern);
    if (value!.isEmpty) {
      return 'Vui lòng nhập số điện thoại';
    } else if (!regExp.hasMatch(value)) {
      return 'Vui lòng nhập đúng số điện thoại';
    }
    return null;
  }

  @override
  void dispose() {
    super.dispose();
  }
}
