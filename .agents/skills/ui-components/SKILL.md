---
name: ui-components
description: >
  Widget reusable dan design tokens untuk Marketiv Flutter app. Gunakan skill ini SETIAP KALI
  user meminta membuat widget UI baru, halaman baru, atau komponen visual apapun di Marketiv.
  Trigger saat ada permintaan: tombol, badge status, shimmer loading, empty state, error state,
  warning banner, kartu campaign, kartu kreator, bottom sheet, dialog konfirmasi, atau halaman
  apapun yang butuh styling. Juga trigger saat user bertanya tentang warna, typography, spacing,
  atau design tokens proyek Marketiv. Skill ini memastikan semua UI konsisten dengan brand
  Marketiv (orange primary, navy secondary, font Inter + Newsreader).
---

# UI Components — Marketiv

## Design Tokens

```dart
// Gunakan konstanta dari file berikut di lib/core/constants/

// 1. AppColors (app_colors.dart)
// Contoh: AppColors.primary500, AppColors.secondary500, AppColors.danger, dll.

// 2. AppSpacing (app_spacing.dart)
// Contoh: AppSpacing.sm, AppSpacing.md, AppSpacing.radiusMd, dll.

// 3. AppTextStyles (app_text_styles.dart)
// Contoh: AppTextStyles.h3 (Newsreader), AppTextStyles.bodyMedium (Inter), dll.
```

---

## PrimaryButton

```dart
// lib/shared/widgets/primary_button.dart
class PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isOutlined;
  final IconData? icon;
  final double? width;

  const PrimaryButton({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
    this.isOutlined = false,
    this.icon,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    final isDisabled = onPressed == null || isLoading;

    return SizedBox(
      width: width ?? double.infinity,
      height: 52,
      child: isOutlined
          ? OutlinedButton.icon(
              onPressed: isDisabled ? null : onPressed,
              icon: isLoading
                  ? const SizedBox(width: 18, height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2))
                  : (icon != null ? Icon(icon, size: 20) : const SizedBox.shrink()),
              label: Text(label, style: AppTextStyles.buttonText),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primary500,
                side: const BorderSide(color: AppColors.primary500),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSpacing.radiusMd)),
              ),
            )
          : ElevatedButton.icon(
              onPressed: isDisabled ? null : onPressed,
              icon: isLoading
                  ? const SizedBox(width: 18, height: 18,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: Colors.white))
                  : (icon != null ? Icon(icon, size: 20, color: Colors.white) : const SizedBox.shrink()),
              label: Text(label,
                  style: AppTextStyles.buttonText.copyWith(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: isDisabled ? AppColors.grey300 : AppColors.primary500,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSpacing.radiusMd)),
              ),
            ),
    );
  }
}
```

---

## StatusBadge

```dart
// lib/shared/widgets/status_badge.dart
class StatusBadge extends StatelessWidget {
  final String status;

  const StatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final config = _getConfig(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: config.bgColor,
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
      ),
      child: Text(
        config.label,
        style: AppTextStyles.labelSmall.copyWith(color: config.textColor),
      ),
    );
  }

  _BadgeConfig _getConfig(String status) {
    switch (status) {
      // Campaign status
      case 'Draft':          return _BadgeConfig('Draft', AppColors.grey100, AppColors.grey700);
      case 'Aktif':          return _BadgeConfig('Aktif', const Color(0xFFDCFCE7), AppColors.success);
      case 'Penuh':          return _BadgeConfig('Penuh', const Color(0xFFFEF9C3), AppColors.warning);
      case 'Selesai':        return _BadgeConfig('Selesai', const Color(0xFFDBEAFE), AppColors.info);
      case 'Dibatalkan':     return _BadgeConfig('Dibatalkan', const Color(0xFFFEE2E2), AppColors.danger);
      // Submission status
      case 'Pending':        return _BadgeConfig('Menunggu', const Color(0xFFFEF9C3), AppColors.warning);
      case 'Valid':          return _BadgeConfig('Valid ✓', const Color(0xFFDCFCE7), AppColors.success);
      case 'Fraud':          return _BadgeConfig('Fraud', const Color(0xFFFEE2E2), AppColors.danger);
      case 'Dispute':        return _BadgeConfig('Sengketa', const Color(0xFFFEE2E2), AppColors.danger);
      // Transaction status
      case 'Escrow':         return _BadgeConfig('Escrow', const Color(0xFFDBEAFE), AppColors.info);
      case 'Success':        return _BadgeConfig('Berhasil', const Color(0xFFDCFCE7), AppColors.success);
      case 'Failed':         return _BadgeConfig('Gagal', const Color(0xFFFEE2E2), AppColors.danger);
      case 'Refunded':       return _BadgeConfig('Dikembalikan', const Color(0xFFFEF9C3), AppColors.warning);
      // Order status
      case 'Negosiasi':      return _BadgeConfig('Negosiasi', const Color(0xFFFEF9C3), AppColors.warning);
      case 'Menunggu Pembayaran': return _BadgeConfig('Menunggu Bayar', const Color(0xFFFEF9C3), AppColors.warning);
      default:               return _BadgeConfig(status, AppColors.grey100, AppColors.grey700);
    }
  }
}

class _BadgeConfig {
  final String label;
  final Color bgColor;
  final Color textColor;
  const _BadgeConfig(this.label, this.bgColor, this.textColor);
}
```

---

## LoadingShimmer

```dart
// lib/shared/widgets/loading_shimmer.dart
import 'package:shimmer/shimmer.dart';

class LoadingShimmer extends StatelessWidget {
  final int itemCount;
  final double itemHeight;

  const LoadingShimmer({super.key, this.itemCount = 5, this.itemHeight = 120});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(AppSpacing.md),
      itemCount: itemCount,
      itemBuilder: (_, __) => Shimmer.fromColors(
        baseColor: AppColors.grey100,
        highlightColor: AppColors.grey300,
        child: Container(
          height: itemHeight,
          margin: const EdgeInsets.only(bottom: AppSpacing.md),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          ),
        ),
      ),
    );
  }
}

// Shimmer untuk satu card
class ShimmerCard extends StatelessWidget {
  final double height;
  const ShimmerCard({super.key, this.height = 120});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.grey100,
      highlightColor: AppColors.grey300,
      child: Container(
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        ),
      ),
    );
  }
}
```

---

## EmptyStateWidget

```dart
// lib/shared/widgets/empty_state_widget.dart
class EmptyStateWidget extends StatelessWidget {
  final String message;
  final String? submessage;
  final VoidCallback? onRetry;
  final String? retryLabel;
  final IconData icon;

  const EmptyStateWidget({
    super.key,
    required this.message,
    this.submessage,
    this.onRetry,
    this.retryLabel,
    this.icon = Icons.inbox_outlined,
  });

  // Konstruktor khusus untuk state error
  const EmptyStateWidget.error({
    super.key,
    required this.message,
    this.submessage,
    required this.onRetry,
  })  : retryLabel = 'Coba Lagi',
        icon = Icons.wifi_off_outlined;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 64, color: AppColors.grey300),
            const SizedBox(height: AppSpacing.md),
            Text(message,
                style: AppTextStyles.bodyLarge.copyWith(color: AppColors.grey700),
                textAlign: TextAlign.center),
            if (submessage != null) ...[
              const SizedBox(height: AppSpacing.sm),
              Text(submessage!,
                  style: AppTextStyles.bodySmall.copyWith(color: AppColors.grey500),
                  textAlign: TextAlign.center),
            ],
            if (onRetry != null) ...[
              const SizedBox(height: AppSpacing.lg),
              SizedBox(
                width: 160,
                child: PrimaryButton(
                  label: retryLabel ?? 'Coba Lagi',
                  onPressed: onRetry,
                  isOutlined: true,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
```

---

## WarningBanner

```dart
// lib/shared/widgets/warning_banner.dart
// Dipakai di form upload aset campaign
class WarningBanner extends StatelessWidget {
  final String message;
  final Color? color;
  final IconData icon;

  const WarningBanner({
    super.key,
    required this.message,
    this.color,
    this.icon = Icons.info_outline,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor = color ?? const Color(0xFFFFF7ED);
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(color: AppColors.warning.withOpacity(0.4)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.warning, size: 20),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(message,
                style: AppTextStyles.bodySmall.copyWith(color: AppColors.grey700)),
          ),
        ],
      ),
    );
  }
}

// Contoh penggunaan di CreateCampaignPage:
// WarningBanner(
//   message: '📌 Untuk video bahan mentah berukuran besar, WAJIB gunakan link '
//            'Google Drive/Dropbox. Marketiv tidak menyimpan file video secara internal.',
// )
```

---

## NicheBadge

```dart
// lib/shared/widgets/niche_badge.dart
class NicheBadge extends StatelessWidget {
  final String niche;
  const NicheBadge({super.key, required this.niche});

  static const _nicheEmoji = {
    'Kuliner': '🍜',
    'Fesyen': '👗',
    'Pariwisata': '🌴',
    'Edukasi': '📚',
    'Kecantikan': '💄',
    'Lainnya': '✨',
  };

  @override
  Widget build(BuildContext context) {
    final emoji = _nicheEmoji[niche] ?? '✨';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.primary50,
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
      ),
      child: Text('$emoji $niche',
          style: AppTextStyles.labelSmall.copyWith(color: AppColors.primary600)),
    );
  }
}
```

---

## ConfirmDialog — Dialog Konfirmasi Aksi Destruktif

```dart
// lib/shared/widgets/confirm_dialog.dart
class ConfirmDialog {
  static Future<bool?> show({
    required String title,
    required String message,
    String confirmLabel = 'Ya, Lanjutkan',
    String cancelLabel = 'Batal',
    bool isDangerous = false,
  }) {
    return Get.dialog<bool>(
      AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusLg)),
        title: Text(title, style: AppTextStyles.h3),
        content: Text(message, style: AppTextStyles.bodyMedium),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: Text(cancelLabel,
                style: AppTextStyles.labelMedium.copyWith(color: AppColors.grey500)),
          ),
          ElevatedButton(
            onPressed: () => Get.back(result: true),
            style: ElevatedButton.styleFrom(
              backgroundColor: isDangerous ? AppColors.danger : AppColors.primary500,
            ),
            child: Text(confirmLabel,
                style: AppTextStyles.labelMedium.copyWith(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

// Contoh penggunaan:
// final confirmed = await ConfirmDialog.show(
//   title: 'Batalkan Campaign?',
//   message: 'Dana escrow akan dikembalikan. Aksi ini tidak dapat dibatalkan.',
//   confirmLabel: 'Ya, Batalkan',
//   isDangerous: true,
// );
// if (confirmed == true) controller.cancelCampaign();
```

---

## Aturan UI Wajib

1. **ListView.builder** untuk semua list dinamis — BUKAN `Column + children.map()`
2. **CachedNetworkImage** untuk semua gambar remote — BUKAN `Image.network()`
3. Setiap halaman yang fetch data WAJIB 3 state: loading (shimmer), error (EmptyStateWidget.error), data
4. **Touch target minimum 48×48px** — jangan buat tombol kecil
5. **Semua teks dalam Bahasa Indonesia** yang sederhana
6. Warna dan ukuran dari design tokens — JANGAN hardcode `Color(0xFF...)` atau `fontSize: 14`
7. Gunakan `const` constructor untuk widget statis
