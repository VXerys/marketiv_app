---
name: midtrans-integration
description: >
  Pola lengkap integrasi Midtrans payment gateway untuk Marketiv Flutter app.
  Gunakan skill ini SETIAP KALI user meminta kode terkait: pembayaran campaign,
  pembayaran rate card order, Midtrans Snap WebView, snap_token, webhook Midtrans,
  atau status pembayaran. Juga trigger saat user bertanya tentang cara UMKM bayar,
  cara buka halaman pembayaran, cara handle callback Midtrans, atau cara memastikan
  dana masuk escrow setelah pembayaran. PENTING: MIDTRANS_SERVER_KEY tidak pernah
  ada di Flutter client — semua logic server ada di Appwrite Function.
---

# Midtrans Integration — Marketiv

## Prinsip Mutlak

- **MIDTRANS_SERVER_KEY** → hanya di Appwrite Function environment variable, TIDAK di Flutter
- **MIDTRANS_CLIENT_KEY** → boleh di Flutter `.env` (hanya untuk WebView config, non-secret)
- Flutter client hanya: (1) minta `snap_token` via Appwrite Function, (2) buka WebView
- Semua update `TRANSACTIONS` dilakukan oleh Appwrite Function setelah webhook Midtrans

## Alur Pembayaran

```
Flutter tap "Bayar" 
  → DataSource panggil Appwrite Function (midtrans-create-fn)
  → Function request ke Midtrans API → dapat snap_token
  → Flutter buka MidtransWebViewPage(snapToken)
  → User bayar di WebView Midtrans
  → Midtrans kirim webhook ke Appwrite Function (midtrans-webhook-fn)
  → Function validasi signature → update status TRANSACTIONS → 'Escrow'
  → App refresh status via polling atau Appwrite Realtime
```

---

## 1. MidtransService — Buka Snap WebView

```dart
// lib/core/services/midtrans_service.dart
import 'package:webview_flutter/webview_flutter.dart';

class MidtransService {
  static void openSnapWebView({
    required String snapToken,
    required VoidCallback onSuccess,
    required VoidCallback onPending,
    required VoidCallback onError,
    required VoidCallback onClose,
  }) {
    Get.to(() => MidtransWebViewPage(
      snapToken: snapToken,
      onSuccess: onSuccess,
      onPending: onPending,
      onError: onError,
      onClose: onClose,
    ));
  }
}
```

---

## 2. MidtransWebViewPage

```dart
// lib/features/keuangan/presentation/pages/midtrans_webview_page.dart
class MidtransWebViewPage extends StatefulWidget {
  final String snapToken;
  final VoidCallback onSuccess;
  final VoidCallback onPending;
  final VoidCallback onError;
  final VoidCallback onClose;

  const MidtransWebViewPage({
    super.key,
    required this.snapToken,
    required this.onSuccess,
    required this.onPending,
    required this.onError,
    required this.onClose,
  });

  @override
  State<MidtransWebViewPage> createState() => _MidtransWebViewPageState();
}

class _MidtransWebViewPageState extends State<MidtransWebViewPage> {
  late final WebViewController _webViewController;
  bool _isLoading = true;

  // Gunakan Snap URL Midtrans (sandbox atau production)
  // MIDTRANS_IS_PRODUCTION=false → pakai app.sandbox.midtrans.com
  // MIDTRANS_IS_PRODUCTION=true  → pakai app.midtrans.com
  static const bool _isProduction = false; // baca dari .env di produksi
  static String get _snapBaseUrl => _isProduction
      ? 'https://app.midtrans.com/snap/v2/vtweb/'
      : 'https://app.sandbox.midtrans.com/snap/v2/vtweb/';

  @override
  void initState() {
    super.initState();
    _initWebView();
  }

  void _initWebView() {
    _webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(NavigationDelegate(
        onPageStarted: (_) => setState(() => _isLoading = true),
        onPageFinished: (_) => setState(() => _isLoading = false),
        onNavigationRequest: (request) {
          return _handleNavigation(request.url);
        },
      ))
      ..loadRequest(Uri.parse('$_snapBaseUrl${widget.snapToken}'));
  }

  NavigationDecision _handleNavigation(String url) {
    // Midtrans redirect ke URL callback setelah transaksi selesai
    if (url.contains('payment_type') || url.contains('transaction_status')) {
      if (url.contains('transaction_status=settlement') ||
          url.contains('transaction_status=capture')) {
        widget.onSuccess();
        Get.back();
        return NavigationDecision.prevent;
      }
      if (url.contains('transaction_status=pending')) {
        widget.onPending();
        Get.back();
        return NavigationDecision.prevent;
      }
      if (url.contains('transaction_status=deny') ||
          url.contains('transaction_status=expire') ||
          url.contains('transaction_status=cancel')) {
        widget.onError();
        Get.back();
        return NavigationDecision.prevent;
      }
    }
    return NavigationDecision.navigate;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Pembayaran', style: AppTextStyles.h3),
        backgroundColor: AppColors.surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            widget.onClose();
            Get.back();
          },
        ),
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _webViewController),
          if (_isLoading)
            const Center(child: CircularProgressIndicator(
              color: AppColors.primary500,
            )),
        ],
      ),
    );
  }
}
```

---

## 3. DataSource — Request Snap Token via Appwrite Function

```dart
// lib/features/keuangan/data/datasources/keuangan_remote_datasource.dart

/// Minta snap_token untuk kampanye baru
Future<String> createCampaignPaymentToken({
  required String campaignId,
  required double totalBayar,
  required String judulCampaign,
  required String userId,
}) async {
  try {
    final execution = await _functions.createExecution(
      functionId: 'midtrans-create-fn',
      body: jsonEncode({
        'order_id':    'CAMPAIGN-$campaignId-${DateTime.now().millisecondsSinceEpoch}',
        'amount':      totalBayar,
        'item_name':   judulCampaign,
        'user_id':     userId,
        'type':        'Campaign',       // untuk Function tahu konteksnya
        'reference_id': campaignId,
      }),
      method: 'POST',
    );

    if (execution.responseStatusCode != 200) {
      final err = jsonDecode(execution.responseBody);
      throw ServerException(err['error'] ?? 'Gagal membuat sesi pembayaran.');
    }

    final data = jsonDecode(execution.responseBody) as Map<String, dynamic>;
    return data['snap_token'] as String;
  } on AppwriteException catch (e) {
    throw _mapException(e);
  }
}

/// Minta snap_token untuk Rate Card Order
Future<String> createOrderPaymentToken({
  required String orderId,
  required double hargaFinal,
  required String judulProyek,
  required String userId,
}) async {
  try {
    final feePercent = AppConstants.rateCardFeePercent; // 0.10
    final totalBayar = hargaFinal * (1 + feePercent);

    final execution = await _functions.createExecution(
      functionId: 'midtrans-create-fn',
      body: jsonEncode({
        'order_id':     'ORDER-$orderId-${DateTime.now().millisecondsSinceEpoch}',
        'amount':        totalBayar,
        'item_name':     judulProyek,
        'user_id':       userId,
        'type':          'RateCard',
        'reference_id':  orderId,
      }),
      method: 'POST',
    );

    if (execution.responseStatusCode != 200) {
      final err = jsonDecode(execution.responseBody);
      throw ServerException(err['error'] ?? 'Gagal membuat sesi pembayaran.');
    }

    final data = jsonDecode(execution.responseBody) as Map<String, dynamic>;
    return data['snap_token'] as String;
  } on AppwriteException catch (e) {
    throw _mapException(e);
  }
}
```

---

## 4. Controller — Trigger Bayar dari UI

```dart
// Contoh di CreateCampaignController (Step 4)
Future<void> submitAndPay() async {
  _isLoading.value = true;

  // 1. Simpan draft campaign ke Appwrite dulu
  final campaignResult = await _createCampaignUseCase(
    CreateCampaignParams(
      judulCampaign: judulController.text,
      deskripsiBrief: deskripsiController.text,
      niche: selectedNiche,
      urlAsetEksternal: urlDriveController.text.isNotEmpty
          ? urlDriveController.text
          : null,
      kuotaKreator: int.parse(kuotaController.text),
      hargaPer1000Views: double.parse(hargaController.text.replaceAll('.', '')),
      totalBudgetEscrow: budgetKampanye,
      umkmId: StorageService.getUserId()!,
    ),
  );

  await campaignResult.fold(
    (failure) async {
      Get.snackbar('Gagal Menyimpan Campaign', failure.message,
          backgroundColor: AppColors.danger, colorText: Colors.white);
    },
    (campaign) async {
      // 2. Minta snap_token
      final tokenResult = await _createDepositUseCase(
        CreateDepositParams(
          campaignId: campaign.id,
          totalBayar: totalBayar,
          judulCampaign: campaign.judulCampaign,
          userId: StorageService.getUserId()!,
        ),
      );

      tokenResult.fold(
        (failure) => Get.snackbar('Gagal Memuat Pembayaran', failure.message),
        (snapToken) {
          // 3. Buka WebView Midtrans
          MidtransService.openSnapWebView(
            snapToken: snapToken,
            onSuccess: () {
              Get.snackbar(
                'Pembayaran Berhasil! 🎉',
                'Campaign kamu sedang diaktifkan. Kreator akan segera melamar.',
                backgroundColor: AppColors.success,
                colorText: Colors.white,
                duration: const Duration(seconds: 4),
              );
              Get.offAllNamed(Routes.campaignList);
            },
            onPending: () {
              Get.snackbar(
                'Menunggu Pembayaran',
                'Selesaikan pembayaran sebelum campaign aktif.',
                backgroundColor: AppColors.warning,
                colorText: Colors.white,
              );
              Get.offAllNamed(Routes.campaignList);
            },
            onError: () => Get.snackbar(
              'Pembayaran Gagal',
              'Silakan coba lagi atau pilih metode pembayaran lain.',
              backgroundColor: AppColors.danger,
              colorText: Colors.white,
            ),
            onClose: () {},
          );
        },
      );
    },
  );

  _isLoading.value = false;
}
```

---

## 5. Kalkulasi Biaya — Tampil di UI

```dart
// Tampilkan ringkasan biaya yang transparan ke UMKM

// Campaign Mode (15% komisi)
double get budgetKampanye   => hargaPer1000 * kuota * estimasiViewsPerKreator;
double get komisiCampaign   => budgetKampanye * AppConstants.campaignFeePercent;
double get totalBayarCampaign => budgetKampanye + komisiCampaign;

// Rate Card Mode (10% fee)
double get feeRateCard      => hargaFinal * AppConstants.rateCardFeePercent;
double get totalBayarOrder  => hargaFinal + feeRateCard;

// Format currency
String formatRupiah(double amount) =>
    NumberFormat.currency(locale: 'id', symbol: 'Rp ', decimalDigits: 0).format(amount);
```

---

## 6. Ringkasan Status Transaksi Midtrans → Appwrite

| Midtrans Status | Arti | Action di Appwrite Function |
|----------------|------|----------------------------|
| `settlement` / `capture` | Bayar berhasil | Status TRANSACTIONS → `Escrow`, Campaign/Order → `Aktif`/`Escrow` |
| `pending` | Menunggu bayar | Status TRANSACTIONS → `Pending` |
| `deny` / `cancel` / `expire` | Gagal/batal | Status TRANSACTIONS → `Failed` |
| `refund` | Dana dikembalikan | Status TRANSACTIONS → `Refunded` |

> ⚠️ Flutter **tidak perlu handle webhook** — itu urusan Appwrite Function. Flutter cukup polling status campaign/order, atau subscribe Realtime untuk update otomatis.

---

## 7. Polling Status Setelah Bayar (Fallback)

```dart
// Jika tidak pakai Realtime, polling status setiap 3 detik (maks 10x)
Future<void> pollCampaignStatus(String campaignId) async {
  int attempts = 0;
  const maxAttempts = 10;
  const interval = Duration(seconds: 3);

  while (attempts < maxAttempts) {
    await Future.delayed(interval);
    final result = await _getCampaignDetailUseCase(campaignId);
    result.fold(
      (_) {},
      (campaign) {
        if (campaign.status == 'Aktif') {
          Get.snackbar('Campaign Aktif!', 'Dana escrow berhasil dikunci.');
          return; // stop polling
        }
      },
    );
    attempts++;
  }
}
```
