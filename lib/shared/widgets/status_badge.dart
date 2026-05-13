import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/constants/app_text_styles.dart';

class StatusBadge extends StatelessWidget {
  final String status;

  const StatusBadge({super.key, required this.status});

  (String, Color, Color) _getConfig(String status) {
    switch (status) {
      case 'Draft':
        return ('Draft', AppColors.grey100, AppColors.grey700);
      case 'Aktif':
        return ('Aktif', const Color(0xFFDCFCE7), AppColors.success);
      case 'Penuh':
        return ('Penuh', const Color(0xFFFEF9C3), AppColors.warning);
      case 'Selesai':
        return ('Selesai', const Color(0xFFDBEAFE), AppColors.info);
      case 'Dibatalkan':
        return ('Dibatalkan', const Color(0xFFFEE2E2), AppColors.danger);
      case 'Pending':
        return ('Menunggu', const Color(0xFFFEF9C3), AppColors.warning);
      case 'Valid':
        return ('Valid ✓', const Color(0xFFDCFCE7), AppColors.success);
      case 'Fraud':
        return ('Terindikasi', const Color(0xFFFEE2E2), AppColors.danger);
      case 'Dispute':
        return ('Sengketa', const Color(0xFFFEE2E2), AppColors.danger);
      case 'Escrow':
        return ('Escrow', const Color(0xFFDBEAFE), AppColors.info);
      case 'Success':
        return ('Berhasil', const Color(0xFFDCFCE7), AppColors.success);
      case 'Failed':
        return ('Gagal', const Color(0xFFFEE2E2), AppColors.danger);
      case 'Negosiasi':
        return ('Negosiasi', const Color(0xFFFEF9C3), AppColors.warning);
      case 'Menunggu Pembayaran':
        return ('Menunggu Bayar', const Color(0xFFFEF9C3), AppColors.warning);
      default:
        return (status, AppColors.grey100, AppColors.grey700);
    }
  }

  @override
  Widget build(BuildContext context) {
    final config = _getConfig(status);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: config.$2,
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
      ),
      child: Text(
        config.$1,
        style: AppTextStyles.labelSmall.copyWith(
          color: config.$3,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
