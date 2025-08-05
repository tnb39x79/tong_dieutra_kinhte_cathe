import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gov_statistics_investigation_economic/common/common.dart';
import 'package:gov_statistics_investigation_economic/config/config.dart'; 

import 'change_pass_controller.dart';

class ChangePassScreen extends GetView<ChangePassController> {
  const ChangePassScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => controller.unFocus(context),
      child: Scaffold(
        body: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    return Container(
      width: Get.width,
      height: Get.height,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 32),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _title(),
            _formInput(),
            _button(),
          ],
        ),
      ),
    );
  }

  Widget _title() {
    return Text(
      'change_pass_title'.tr.toUpperCase(),
      style: styleLargeBold.copyWith(color: warningColor),
    );
  }

  Widget _formInput() {
    return Form(
      key: controller.formKey,
      child: Column(
        children: [
          WidgetFieldInput(
            controller: controller.getEditingController('current_pass'),
            hint: 'hint_current_pass'.tr,
            bgColor: Colors.white,
            label: 'current_pass'.tr,
            validator: controller.validateCurrentPassword,
          ),
          const Divider(color: greyBorder, height: AppValues.padding * 2),
          WidgetFieldInput(
            controller: controller.getEditingController('new_pass'),
            hint: 'hint_new_pass'.tr,
            bgColor: Colors.white,
            label: 'new_pass'.tr,
            validator: controller.validateNewPass,
          ),
          const SizedBox(height: AppValues.padding),
          WidgetFieldInput(
            controller: controller.getEditingController('confirm_new_pass'),
            hint: 'hint_confirm_new_pass'.tr,
            bgColor: Colors.white,
            label: 'confirm_new_pass'.tr,
            validator: controller.validateConfirmPassword,
          ),
        ],
      ),
    );
  }

  Widget _button() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppValues.padding * 2),
      child: WidgetButton(
        title: 'change_pass'.tr,
        onPressed: controller.onPressChangePass,
      ),
    );
  }
}
