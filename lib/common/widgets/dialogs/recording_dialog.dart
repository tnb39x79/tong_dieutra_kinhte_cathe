import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gov_statistics_investigation_economic/common/extensions/stringx.dart';
import 'package:gov_statistics_investigation_economic/common/widgets/button/i_button.dart';
import 'package:gov_statistics_investigation_economic/common/widgets/dialogs/recording_dialog_controller.dart';
import 'package:gov_statistics_investigation_economic/config/constants/app_colors.dart';
import 'package:gov_statistics_investigation_economic/config/constants/app_styles.dart';
import 'package:gov_statistics_investigation_economic/config/constants/app_values.dart'; 

/// Modern Recording Dialog Widget
///
/// A clean, modern UI dialog for audio recording functionality with:
/// - Recording controls (start/stop buttons)
/// - Visual feedback and animations
/// - Timer display
/// - Error handling and user feedback
/// - Integration with VietnameseSTTService
class RecordingDialog extends StatelessWidget {
  const RecordingDialog({
    super.key,
    this.onTextRecognized,
    this.title = 'Ghi âm',
    this.hint = 'Nhấn để bắt đầu ghi âm...',
    this.capitalize = true,
  });

  /// Callback when text is successfully recognized
  final Function(String recognizedText)? onTextRecognized;

  /// Dialog title
  final String title;

  /// Hint text when not recording
  final String hint;

  /// Whether to capitalize the recognized text
  final bool capitalize;

  @override
  Widget build(BuildContext context) {
    // Create controller instance
    final controller = Get.put(RecordingDialogController());

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppValues.borderLv3),
      ),
      insetPadding: const EdgeInsets.symmetric(horizontal: AppValues.padding),
      elevation: 8,
      backgroundColor: Colors.white,
      child: Container(
        width: Get.width,
        padding: const EdgeInsets.all(AppValues.padding),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildHeader(controller),
            const SizedBox(height: AppValues.padding),
            _buildRecordingArea(controller),
            const SizedBox(height: AppValues.padding),
            _buildControls(controller),
            const SizedBox(height: 12),
            _buildStatus(controller),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(RecordingDialogController controller) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: styleLargeBold.copyWith(color: primaryColor),
          ),
        ),
        IconButton(
          onPressed: () => _handleCancel(controller),
          icon: const Icon(Icons.close, color: greyColor, size: 24),
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
        ),
      ],
    );
  }

  Widget _buildRecordingArea(RecordingDialogController controller) {
    return Obx(() => Container(
          height: 140,
          width: double.infinity,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(AppValues.borderLv2),
            border: Border.all(
              color: controller.isRecording ? primaryColor : greyBorder,
              width: controller.isRecording ? 2 : 1,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildMicrophoneIcon(controller),
              const SizedBox(height: 12),
              if (controller.isRecording) _buildTimer(controller),
              if (controller.isCheckingModel || controller.isLoadingModel)
                Text(
                  controller.isCheckingModel
                      ? 'Đang kiểm tra mô hình...'
                      : 'Đang tải mô hình AI...',
                  style: styleSmall.copyWith(color: primaryColor),
                )
              else if (!controller.isRecording && !controller.isInitializing)
                Text(
                  'Nhấn nút ghi âm để bắt đầu',
                  style: styleSmall.copyWith(color: greyColor),
                ),
            ],
          ),
        ));
  }

  Widget _buildMicrophoneIcon(RecordingDialogController controller) {
    return Obx(() {
      if (controller.isRecording) {
        return TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.9, end: 1.1),
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeInOut,
          builder: (context, scale, child) {
            return Transform.scale(
              scale: scale,
              child: Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  color: primaryColor.withOpacity(0.15),
                  shape: BoxShape.circle,
                  border: Border.all(
                      color: primaryColor.withOpacity(0.3), width: 2),
                ),
                child: const Icon(
                  Icons.mic,
                  size: 32,
                  color: primaryColor,
                ),
              ),
            );
          },
        );
      } else if (controller.isProcessing ||
          controller.isCheckingModel ||
          controller.isLoadingModel) {
        return Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            color: primaryLightColor.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
            strokeWidth: 3,
          ),
        );
      } else {
        return Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            color: controller.isInitializing
                ? greyColor.withOpacity(0.1)
                : primaryColor.withOpacity(0.1),
            shape: BoxShape.circle,
            border: Border.all(
                color: controller.isInitializing
                    ? greyBorder
                    : primaryColor.withOpacity(0.3),
                width: 1),
          ),
          child: Icon(
            Icons.mic,
            size: 32,
            color: controller.isInitializing ? greyColor : primaryColor,
          ),
        );
      }
    });
  }

  Widget _buildTimer(RecordingDialogController controller) {
    return Obx(() => Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(AppValues.borderLv1),
          ),
          child: Text(
            controller.formatDuration(controller.recordingTime),
            style: styleMediumBold.copyWith(color: primaryColor),
          ),
        ));
  }

  Widget _buildControls(RecordingDialogController controller) {
    return Obx(() {
      if (controller.isInitializing) {
        return Column(
          children: [
            const SizedBox(
              width: 28,
              height: 28,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
                strokeWidth: 3,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Đang khởi tạo dịch vụ...',
              style: styleMedium.copyWith(color: greyColor),
            ),
          ],
        );
      }

      return Row(
        children: [
          Expanded(
            child: IButton(
              label: controller.isCanceling ? "Đang hủy..." : "Hủy",
              type: IButtonType.outline,
              onPressed: controller.isCanceling
                  ? null
                  : () => _handleCancel(controller),
              borderColor: primaryColor.withValues(alpha: 0.3),
              textStyle: styleMedium.copyWith(color: greyColor),
              leftIcon: controller.isCanceling
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(greyColor),
                        strokeWidth: 2,
                      ),
                    )
                  : const Icon(
                      Icons.close,
                      size: 18,
                      color: greyColor,
                    ),
              height: AppValues.buttonHeight,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            flex: 2,
            child: IButton(
              label: controller.getRecordButtonLabel(),
              type: IButtonType.inline,
              onPressed: () => _handleRecording(controller),
              backgroundColor:
                  controller.isRecording ? errorColor : primaryColor,
              disabledColor: backgroundDisableColor,
              textStyle: styleMedium.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
              leftIcon: Icon(
                controller.isRecording ? Icons.stop : Icons.mic,
                size: 20,
                color: Colors.white,
              ),
              height: AppValues.buttonHeight,
            ),
          ),
        ],
      );
    });
  }

  /// Handle cancel button press - stop recording and close dialog
  Future<void> _handleCancel(RecordingDialogController controller) async {
    try {
      // Cancel any active recording
      await controller.cancelRecording();

      // Clean up controller and close dialog
      Get.delete<RecordingDialogController>();
      Get.back();
    } catch (e) {
      // Force close even if there's an error
      Get.delete<RecordingDialogController>();
      Get.back();
    }
  }

  Future<void> _handleRecording(RecordingDialogController controller) async {
    try {
      String? recognizedText = await controller.toggleRecording();
      if (capitalize) recognizedText = recognizedText?.capitalizeFirstLetter();

      if (recognizedText != null && recognizedText.isNotEmpty) {
        // Call callback with recognized text
        onTextRecognized?.call(recognizedText);

        // Close dialog after a short delay
        await Future.delayed(const Duration(milliseconds: 500));
        Get.delete<RecordingDialogController>();
        Get.back(result: recognizedText);
      }
    } catch (e) {
      // Handle recording errors gracefully
      controller.reset();
    }
  }

  Widget _buildStatus(RecordingDialogController controller) {
    return Column(
      children: [
        Obx(() => AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: Text(
                controller.statusText,
                key: ValueKey(controller.statusText),
                style: styleMedium.copyWith(
                  color: controller.isRecording ? primaryColor : greyColor,
                  fontWeight: controller.isRecording
                      ? FontWeight.w600
                      : FontWeight.w400,
                ),
                textAlign: TextAlign.center,
              ),
            )),
        const SizedBox(height: 8),
        // Model loading progress indicator
        Obx(() {
          if (controller.isCheckingModel || controller.isLoadingModel) {
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppValues.borderLv1),
                border: Border.all(color: primaryColor.withOpacity(0.3)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      controller.isCheckingModel
                          ? 'Đang kiểm tra mô hình...'
                          : controller.initializationProgress.isNotEmpty
                              ? controller.initializationProgress
                              : 'Đang tải mô hình AI...',
                      style: styleSmall.copyWith(color: primaryColor),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            );
          }
          return const SizedBox.shrink();
        }),
        const SizedBox(height: 4),
        // Error message
        Obx(() {
          if (controller.errorText.isNotEmpty) {
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: errorColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppValues.borderLv1),
                border: Border.all(color: errorColor.withOpacity(0.3)),
              ),
              child: Text(
                controller.errorText,
                style: styleSmall.copyWith(color: errorColor),
                textAlign: TextAlign.center,
              ),
            );
          }
          return const SizedBox.shrink();
        }),
      ],
    );
  }
}

/// Static method to show the recording dialog
Future<String?> showRecordingDialog({
  String? title,
  String? hint,
  Function(String)? onTextRecognized,
  bool capitalize = true,
}) async {
  return await Get.dialog<String>(
    RecordingDialog(
      title: title ?? 'Ghi âm',
      hint: hint ?? 'Nhấn để bắt đầu ghi âm...',
      onTextRecognized: onTextRecognized,
      capitalize: capitalize,
    ),
    barrierDismissible: false,
    barrierColor: Colors.black54,
  );
}
