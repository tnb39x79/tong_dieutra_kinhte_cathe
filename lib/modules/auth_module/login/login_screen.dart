import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:gov_statistics_investigation_economic/common/common.dart';
import 'package:gov_statistics_investigation_economic/common/valid/valid.dart';
import 'package:gov_statistics_investigation_economic/common/widgets/input/widget_field_input.dart';
import 'package:gov_statistics_investigation_economic/config/config.dart';

import 'login_controller.dart';

class LoginScreen extends GetView<LoginController> {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LoadingFullScreen(
      loading: controller.loadingSubject,
      child: GestureDetector(
        onTap: () => controller.unFocus(context),
        child: Scaffold(
          body: _buildBody(),
        ),
      ),
    );
  }

  Widget _buildBody() {
    return Stack(children: [
      Container(
          width: Get.width,
          height: Get.height,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                AppImages.imgBackground,
              ),
              fit: BoxFit.cover,
            ),
          ),
          padding: EdgeInsets.only(top: Get.height * 0.12),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  AppImages.imgLogoCircle,
                  width: Get.width * 0.35,
                  height: Get.width * 0.35,
                ),
              ],
            ),
          )),
      Align(alignment: Alignment.bottomCenter, child: _formLogin()),
    ]);
  }

  Widget _formLogin() {
    return Container(
      width: Get.width,
      height: Get.height - Get.height * 0.2 - Get.width * 0.35,
      padding: const EdgeInsets.symmetric(horizontal: AppValues.padding),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(AppValues.borderLv4),
          topRight: Radius.circular(AppValues.borderLv4),
        ),
      ),
      child: Column(
        children: [
          SizedBox(height: Get.height * 0.04),
          _title(),
          SizedBox(height: Get.height * 0.04),
          _form(),
          const SizedBox(height: 24),
          _button(),
        ],
      ),
    );
  }

  Widget _title() {
    return Column(children: [
      Text('login'.tr.toUpperCase(),
          style: styleLargeBold.copyWith(color: warningColor)),
      Text('login_title'.tr, style: styleSmall),
    ]);
  }

  Widget _form() {
    return Form(
      key: controller.formKey,
      child: Column(
        children: [
          WidgetFieldInput(
            controller: controller.getEditingController(controller.keyUserName),
            hint: 'hint_user_name'.tr,
            bgColor: Colors.white,
            prefix: Image.asset(AppIcons.icProfile),
            validator: Valid.validateUserName, 
            inputFormatters: [
              TextInputFormatter.withFunction((oldValue, newValue) {
                return newValue.copyWith(text: newValue.text.toUpperCase());
              })
            ],
          ),
          const SizedBox(height: 12),
          WidgetFieldInput(
            controller: controller.getEditingController(controller.keyPass),
            hint: 'hint_pass'.tr,
            bgColor: Colors.white,
            prefix: Image.asset(AppIcons.icLockBorder),
            validator: Valid.validatePassword,
            isHideContent: true,
          ),
        ],
      ),
    );
  }

  Widget _button() {
    return WidgetButton(
      title: 'login'.tr,
      iconCenter: Image.asset(AppIcons.icRoute),
      onPressed: controller.onPressedLogin,
    );
  }
}
