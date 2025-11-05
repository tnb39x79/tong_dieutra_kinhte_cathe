import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gov_statistics_investigation_economic/common/widgets/appbars/appbar_header.dart';
import 'package:gov_statistics_investigation_economic/common/widgets/dialogs/dialog_widget.dart';
import 'package:gov_statistics_investigation_economic/common/widgets/loadings/loading_full_screen.dart';
import 'package:gov_statistics_investigation_economic/modules/dashboard_module/download_model_ai/enhanced_ai_download_controller.dart';
import 'package:gov_statistics_investigation_economic/modules/dashboard_module/download_model_ai/widgets/ai_model_section_widget.dart';
import 'package:gov_statistics_investigation_economic/resource/services/network_service/network_service.dart';

import '/config/constants/app_colors.dart';
import '/config/constants/app_styles.dart';
import '/config/constants/app_values.dart';  

/// Enhanced AI Download Screen
///
/// Modern list-based interface for downloading multiple AI models with:
/// - Sections for different model types (suggestions, STT)
/// - Individual download progress tracking
/// - Modern UI following app design patterns
/// - Responsive layout with proper spacing
class EnhancedAiDownloadScreen extends GetView<EnhancedAiDownloadController> {
  const EnhancedAiDownloadScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return LoadingFullScreen(
      loading: controller.loadingSubject,
      child: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) {
          if (didPop) return;
          controller.backHome();
        },
        child: Scaffold(
          appBar: AppBarHeader(
            title: 'Tải dữ liệu AI',
            onPressedLeading: controller.backHome,
            iconLeading: const Icon(Icons.arrow_back_ios_new_rounded),
          ),
          body: _buildBody(),
        ),
      ),
    );
  }

  Widget _buildBody() {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                _buildHeader(),
                _buildModelsList(),
              ],
            ),
          ),
        ),
        _buildFooter(),
      ],
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(AppValues.padding),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            primaryColor.withValues(alpha: 0.1),
            primaryLightColor.withValues(alpha: 0.05),
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppValues.padding / 2),
                decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.circular(AppValues.borderLv1),
                ),
                child: const Icon(
                  Icons.smart_toy,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: AppValues.padding),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Mô hình AI',
                      style: styleLargeBold.copyWith(color: blackText),
                    ),
                    Text(
                      'Tải xuống các mô hình AI để sử dụng offline',
                      style: styleSmall.copyWith(color: greyColor),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          _buildOverallProgress(),
        ],
      ),
    );
  }

  Widget _buildOverallProgress() {
    return Obx(() {
      // Access reactive variables directly
      final isDownloading1 =
          controller.isDownloadingRx(ModelType.suggestions).value;
      final isDownloading2 =
          controller.isDownloadingRx(ModelType.speechToText).value;
      final isAnyDownloading = isDownloading1 || isDownloading2;

      final progress1 =
          controller.downloadProgressRx(ModelType.suggestions).value;
      final progress2 =
          controller.downloadProgressRx(ModelType.speechToText).value;
      final overallProgress = (progress1 + progress2) / 2;

      if (!isAnyDownloading && overallProgress == 0) {
        return const SizedBox.shrink();
      }

      return Container(
        padding: const EdgeInsets.all(AppValues.padding),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppValues.borderLv1),
          border: Border.all(color: greyBorder),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Tiến độ tổng thể',
                  style: styleSmallBold.copyWith(color: blackText),
                ),
                Text(
                  '${overallProgress.toInt()}%',
                  style: styleSmallBold.copyWith(color: primaryColor),
                ),
              ],
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: overallProgress / 100,
              backgroundColor: greyColor.withValues(alpha: 0.2),
              valueColor: const AlwaysStoppedAnimation<Color>(primaryColor),
              minHeight: 4,
            ),
          ],
        ),
      );
    });
  }

  Widget _buildModelsList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(vertical: AppValues.padding),
      itemCount: controller.getAllModelTypes().length,
      itemBuilder: (context, index) {
        final modelType = controller.getAllModelTypes()[index];
        return _buildModelSection(modelType);
      },
    );
  }

  Widget _buildModelSection(ModelType modelType) {
    return Obx(() {
      // Access reactive variables directly
      final downloadProgress = controller.downloadProgressRx(modelType).value;
      final isDownloading = controller.isDownloadingRx(modelType).value;
      final isDownloaded = controller.isDownloadedRx(modelType).value;
      final downloadStatus = controller.downloadStatusRx(modelType).value;

      // Check if Link 2 is available for this model type (reactive)
      final hasLink2 =
          controller.getServerFileUrlRx(modelType).value.isNotEmpty;

      return AiModelSectionWidget(
        title: controller.getModelTitle(modelType),
        description: controller.getModelDescription(modelType),
        icon: controller.getModelIcon(modelType),
        downloadSize: controller.getModelSize(modelType),
        downloadProgress: downloadProgress,
        isDownloading: isDownloading,
        isDownloaded: isDownloaded,
        downloadStatus: downloadStatus,
        onDownload: () => _handleDownload(modelType, linkType: 1),
        onRedownload: () => _handleRedownload(modelType, linkType: 1),
        onCancel: isDownloading && controller.canCancelDownload(modelType)
            ? () => _handleCancel(modelType)
            : null,
        hasLink2: hasLink2,
        onDownloadLink2:
            hasLink2 ? () => _handleDownload(modelType, linkType: 2) : null,
        onRedownloadLink2:
            hasLink2 ? () => _handleRedownload(modelType, linkType: 2) : null,
        modelType: modelType,
      );
    });
  }

  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.all(AppValues.padding),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: greyBorder, width: 1),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildNetworkStatus(),
          const SizedBox(height: 8),
          _buildActionButtons(),
        ],
      ),
    );
  }

  Widget _buildNetworkStatus() {
    // Use reactive network status for real-time updates
    final networkService = Get.find<NetworkService>();

    return Obx(() {
      final isConnected = networkService.isConnected;

      return Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppValues.padding,
          vertical: AppValues.padding / 2,
        ),
        decoration: BoxDecoration(
          color: isConnected
              ? successColor.withValues(alpha: 0.1)
              : errorColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(AppValues.borderLv1),
        ),
        child: Row(
          children: [
            Icon(
              isConnected ? Icons.wifi : Icons.wifi_off,
              color: isConnected ? successColor : errorColor,
              size: 16,
            ),
            const SizedBox(width: 8),
            Text(
              isConnected ? 'Đã kết nối internet' : 'Không có kết nối internet',
              style: styleSmall.copyWith(
                color: isConnected ? successColor : errorColor,
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: controller.backHome,
            icon: const Icon(
              Icons.home,
              color: primaryColor,
            ),
            label: Text('Về trang chính',
                style: styleSmall.copyWith(color: primaryColor)),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: primaryColor),
              foregroundColor: greyColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppValues.borderLv5),
              ),
              padding: const EdgeInsets.symmetric(vertical: 10),
            ),
          ),
        ),
        const SizedBox(width: AppValues.padding),
        Expanded(
          child: Obx(() {
            // Access reactive variables directly
            final isDownloading1 =
                controller.isDownloadingRx(ModelType.suggestions).value;
            final isDownloading2 =
                controller.isDownloadingRx(ModelType.speechToText).value;
            final isAnyDownloading = isDownloading1 || isDownloading2;

            return ElevatedButton.icon(
              onPressed: isAnyDownloading ? null : _downloadAllModels,
              icon: Icon(
                isAnyDownloading ? Icons.downloading : Icons.download,
                color: Colors.white,
              ),
              label: Text(isAnyDownloading ? 'Đang tải...' : 'Tải tất cả'),
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppValues.borderLv5),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            );
          }),
        ),
      ],
    );
  }

  void _handleDownload(ModelType modelType, {int linkType = 1}) {
    controller.downloadModel(modelType, linkType: linkType);
  }

  void _handleRedownload(ModelType modelType, {int linkType = 1}) {
    _showRedownloadConfirmation(modelType, linkType: linkType);
  }

  void _handleCancel(ModelType modelType) {
    _showCancelConfirmation(modelType);
  }

  void _showRedownloadConfirmation(ModelType modelType, {int linkType = 1}) {
    final linkText = linkType == 2 ? 'Link 2 (Server File)' : 'Link 1';
    Get.dialog(
      DialogWidget(
        title: 'Xác nhận tải lại',
        content:
            'Bạn có muốn tải lại mô hình ${controller.getModelTitle(modelType)} từ $linkText? Dữ liệu hiện tại sẽ bị ghi đè.',
        onPressedPositive: () {
          Get.back();
          controller.redownloadModel(modelType, linkType: linkType);
        },
        onPressedNegative: () => Get.back(),
        confirmText: 'Tải lại',
      ),
    );
  }

  void _showCancelConfirmation(ModelType modelType) {
    Get.dialog(
      DialogWidget(
        title: 'Xác nhận hủy tải xuống',
        content:
            'Bạn có muốn hủy tải xuống mô hình ${controller.getModelTitle(modelType)}? Tiến độ hiện tại sẽ bị mất.',
        onPressedPositive: () {
          Get.back();
          controller.cancelDownloadWithFeedback(modelType);
        },
        onPressedNegative: () => Get.back(),
        confirmText: 'Hủy tải xuống',
      ),
    );
  }

  void _downloadAllModels() {
    for (final modelType in controller.getAllModelTypes()) {
      if (!controller.isDownloaded(modelType) &&
          !controller.isDownloading(modelType)) {
        controller.downloadModel(modelType, linkType: 1); // Default to Link 1
      }
    }
  }
}
