import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:gov_statistics_investigation_economic/modules/dashboard_module/download_model_ai/enhanced_ai_download_controller_v2.dart'; 

import '/config/constants/app_colors.dart';
import '/config/constants/app_styles.dart';
import '/config/constants/app_values.dart';

/// AI Model Section Widget
///
/// A reusable widget for displaying AI model download sections with:
/// - Modern card-based design following app patterns
/// - Download progress indicators
/// - Status management (not downloaded, downloading, downloaded)
/// - Individual download controls for each model type
class AiModelSectionWidgetV2 extends StatelessWidget {
  const AiModelSectionWidgetV2({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    required this.onDownload,
    this.downloadProgress = 0.0,
    this.isDownloading = false,
    this.isDownloaded = false,
    this.downloadSize,
    this.onRedownload,
    this.onCancel,
    this.downloadStatus,
    this.onDownloadLink2,
    this.onRedownloadLink2,
    this.hasLink2 = false,
    required this.modelType,
  });

  final String title;
  final String description;
  final IconData icon;
  final VoidCallback? onDownload;
  final double downloadProgress;
  final bool isDownloading;
  final bool isDownloaded;
  final String? downloadSize;
  final VoidCallback? onRedownload;
  final VoidCallback? onCancel;
  final String? downloadStatus;
  final VoidCallback? onDownloadLink2;
  final VoidCallback? onRedownloadLink2;
  final bool hasLink2;
  final ModelType modelType;

  String get _link1DownloadTitle {
    return 'Tải xuống link 1';
  }

  String get _link2DownloadTitle {
    return 'Tải xuống link 2';
  }

  String get _link1ReDownloadTitle {
    return 'Tải lại link 1';
  }

  String get _link2ReDownloadTitle {
    return 'Tải lại link 2';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: AppValues.padding,
        vertical: AppValues.padding / 2,
      ),
      padding: const EdgeInsets.all(AppValues.padding),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppValues.borderLv1),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            offset: const Offset(0, 4),
            spreadRadius: 2,
            blurRadius: 8,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: AppValues.padding),
          _buildDescription(),
          const SizedBox(height: AppValues.padding),
          _buildDownloadSection(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(AppValues.padding / 2),
          decoration: BoxDecoration(
            color: primaryColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(AppValues.borderLv1),
          ),
          child: Icon(
            icon,
            color: primaryColor,
            size: 24,
          ),
        ),
        const SizedBox(width: AppValues.padding),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: styleMediumBold.copyWith(color: blackText),
              ),
              if (downloadSize != null)
                Text(
                  'Kích thước: $downloadSize',
                  style: styleSmall.copyWith(color: greyColor),
                ),
            ],
          ),
        ),
        _buildStatusIcon(),
      ],
    );
  }

  Widget _buildStatusIcon() {
    if (isDownloaded) {
      return Container(
        padding: const EdgeInsets.all(4),
        decoration: const BoxDecoration(
          color: successColor,
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.check,
          color: Colors.white,
          size: 16,
        ),
      );
    } else if (isDownloading) {
      return Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: warningColor.withValues(alpha: 0.1),
          shape: BoxShape.circle,
        ),
        child: const SizedBox(
          width: 16,
          height: 16,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(warningColor),
          ),
        ),
      );
    } else {
      return Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: greyColor.withValues(alpha: 0.1),
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.download,
          color: greyColor,
          size: 16,
        ),
      );
    }
  }

  Widget _buildDescription() {
    return Text(
      description,
      style: styleSmall.copyWith(
        color: greyColor,
        height: 1.4,
      ),
    );
  }

  Widget _buildDownloadSection() {
    if (isDownloading) {
      return _buildDownloadProgress();
    } else if (isDownloaded) {
      return _buildDownloadedSection();
    } else {
      return _buildDownloadButton();
    }
  }

  Widget _buildDownloadProgress() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: LinearProgressIndicator(
                value: downloadProgress / 100,
                backgroundColor: greyColor.withValues(alpha: 0.2),
                valueColor: const AlwaysStoppedAnimation<Color>(primaryColor),
                minHeight: 6,
              ),
            ),
            const SizedBox(width: AppValues.padding),
            Text(
              '${downloadProgress.toInt()}%',
              style: styleSmallBold.copyWith(color: primaryColor),
            ),
          ],
        ),
        const SizedBox(height: AppValues.padding / 2),
        Row(
          children: [
            Expanded(
              child: Text(
                downloadStatus ?? 'Đang tải xuống...',
                style: styleSmall.copyWith(color: greyColor),
              ),
            ),
            if (onCancel != null) ...[
              const SizedBox(width: AppValues.padding),
              OutlinedButton.icon(
                onPressed: onCancel,
                icon: const Icon(Icons.close, size: 16),
                label: const Text('Hủy'),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.red),
                  foregroundColor: Colors.red,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }

  Widget _buildDownloadedSection() {
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: successColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(AppValues.borderLv1),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.check_circle,
                color: successColor,
                size: 16,
              ),
              const SizedBox(width: 8),
              Text(
                'Đã tải xuống',
                style: styleSmallBold.copyWith(color: successColor),
              ),
            ],
          ),
        ),
        if (onRedownload != null || onRedownloadLink2 != null) ...[
          const SizedBox(height: AppValues.padding),
          Row(
            children: [
              if (onRedownload != null) ...[
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: onRedownload,
                    icon: const Icon(Icons.refresh, size: 16),
                    label: AutoSizeText(_link1ReDownloadTitle, maxLines: 1),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: primaryColor),
                      foregroundColor: primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(AppValues.borderLv1),
                      ),
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 4),
                    ),
                  ),
                ),
              ],
              if (onRedownload != null &&
                  onRedownloadLink2 != null &&
                  hasLink2) ...[
                const SizedBox(width: AppValues.padding / 2),
              ],
              if (onRedownloadLink2 != null && hasLink2) ...[
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: onRedownloadLink2,
                    icon: const Icon(Icons.refresh, size: 16),
                    label: AutoSizeText(_link2ReDownloadTitle, maxLines: 1),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: warningColor),
                      foregroundColor: warningColor,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(AppValues.borderLv1),
                      ),
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 4),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildDownloadButton() {
    if (hasLink2 && onDownloadLink2 != null) {
      // Show two download buttons when Link 2 is available
      return Row(
        children: [
          Expanded(
            child: OutlinedButton.icon(
              onPressed: onDownload,
              icon: const Icon(Icons.download, size: 16),
              label: AutoSizeText(_link1DownloadTitle, maxLines: 1),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: primaryColor),
                foregroundColor: primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppValues.borderLv1),
                ),
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
              ),
            ),
          ),
          const SizedBox(width: AppValues.padding / 2),
          Expanded(
            child: OutlinedButton.icon(
              onPressed: onDownloadLink2,
              icon: const Icon(Icons.download, size: 16),
              label: AutoSizeText(_link2DownloadTitle, maxLines: 1),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: warningColor),
                foregroundColor: warningColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppValues.borderLv1),
                ),
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
              ),
            ),
          ),
        ],
      );
    } else {
      // Show single download button when only Link 1 is available
      return SizedBox(
        width: double.infinity,
        child: OutlinedButton.icon(
          onPressed: onDownload,
          icon: const Icon(Icons.download),
          label: const Text('Tải xuống'),
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: primaryColor),
            foregroundColor: primaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppValues.borderLv1),
            ),
            padding: const EdgeInsets.symmetric(vertical: 12),
          ),
        ),
      );
    }
  }
}
