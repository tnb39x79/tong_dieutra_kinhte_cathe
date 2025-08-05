import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gov_statistics_investigation_economic/common/widgets/button/button.dart';
import 'package:gov_statistics_investigation_economic/config/config.dart';

class DialogLogPermission extends StatelessWidget {
  const DialogLogPermission({
    Key? key,
    required this.onPressedPositive,
    required this.onPressedNegative,
  }) : super(key: key);
  final Function() onPressedPositive;
  final Function() onPressedNegative;
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppValues.padding),
      ),
      insetPadding: const EdgeInsets.symmetric(horizontal: AppValues.padding),
      elevation: 0,
      backgroundColor: Colors.white,
      child: Container(
        width: Get.width,
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Cấp quyền ứng dụng',
              style: styleLargeBold.copyWith(color: warningColor),
            ),
            const SizedBox(height: 30),
            Text(
              'Vui lòng xác nhận những quyền sau để phục vụ cho kì điều tra:',
              style: styleMediumBold.copyWith(color: greyColor),
              textAlign: TextAlign.start,
            ),
            const SizedBox(height: 24),
            const ListTile(
              leading: Icon(Icons.storage),
              title: Text('Quyền truy cập bộ nhớ'),
              subtitle: Text('Lưu dữ liệu câu hỏi'),
            ),
            const ListTile(
              leading: Icon(Icons.location_on),
              title: Text('Quyền truy cập vị trí'),
              subtitle: Text('Cập nhật vị trí điều tra'),
            ),
            const SizedBox(height: 24),
            _buttonActions(),
          ],
        ),
      ),
    );
  }

  Widget _buttonActions() {
    return Row(
      children: [
        Expanded(
          child: WidgetButtonBorder(
              title: 'cancel'.tr, onPressed: onPressedNegative),
        ),
        const SizedBox(width: AppValues.padding),
        Expanded(
          child: WidgetButton(title: "Kế tiếp", onPressed: onPressedPositive),
        ),
      ],
    );
  }
}
