import 'package:flutter/material.dart';

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
class AiModelSectionWidget extends StatelessWidget {
  const AiModelSectionWidget({
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
        borderRadius: BorderRadius.circular(AppValues.borderLv2),
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
            color: primaryColor.withOpacity(0.1),
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
          color: warningColor.withOpacity(0.1),
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
          color: greyColor.withOpacity(0.1),
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
                backgroundColor: greyColor.withOpacity(0.2),
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
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
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
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: successColor.withOpacity(0.1),
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
        ),
        if (onRedownload != null) ...[
          const SizedBox(width: AppValues.padding),
          OutlinedButton.icon(
            onPressed: onRedownload,
            icon: const Icon(Icons.refresh, size: 16),
            label: const Text('Tải lại'),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: primaryColor),
              foregroundColor: primaryColor,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildDownloadButton() {
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
