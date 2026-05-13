import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/constants/app_text_styles.dart';
import 'primary_button.dart';

class EmptyStateWidget extends StatelessWidget {
  final String message;
  final String? submessage;
  final VoidCallback? onAction;
  final String? actionLabel;
  final IconData icon;

  const EmptyStateWidget({
    super.key,
    required this.message,
    this.submessage,
    this.onAction,
    this.actionLabel,
    this.icon = Icons.inbox_outlined,
  });

  factory EmptyStateWidget.error({
    required String message,
    String? submessage,
    VoidCallback? onRetry,
  }) {
    return EmptyStateWidget(
      message: message,
      submessage: submessage,
      onAction: onRetry,
      actionLabel: 'Coba Lagi',
      icon: Icons.wifi_off_outlined,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 64,
              color: AppColors.grey300,
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              message,
              style: AppTextStyles.bodyLarge.copyWith(
                color: AppColors.grey700,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            if (submessage != null) ...[
              const SizedBox(height: AppSpacing.sm),
              Text(
                submessage!,
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.grey500,
                ),
                textAlign: TextAlign.center,
              ),
            ],
            if (onAction != null) ...[
              const SizedBox(height: AppSpacing.lg),
              PrimaryButton(
                label: actionLabel ?? 'Aksi',
                onPressed: onAction,
                isOutlined: true,
                width: 160,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
