---
name: escrow-keuangan
description: >
  Pola lengkap sistem keuangan dan escrow untuk Marketiv Flutter app. Gunakan skill ini
  SETIAP KALI user meminta kode terkait: deposit/top-up UMKM, withdrawal kreator, riwayat
  transaksi, saldo dompet, escrow campaign, escrow rate card order, kalkulasi komisi platform,
  atau status transaksi. Juga trigger saat user bertanya tentang collection TRANSACTIONS,
  alur dana escrow, cara UMKM bayar campaign, cara kreator tarik dana, atau bagaimana
  Midtrans webhook memperbarui status transaksi. PENTING: Flutter client TIDAK PERNAH
  menulis ke collection TRANSACTIONS — semua INSERT/UPDATE hanya via Appwrite Functions.
---

# Keuangan & Escrow — Marketiv

## Prinsip Mutlak

1. **Flutter client TIDAK PERNAH** `createDocument` atau `updateDocument` ke collection `TRANSACTIONS`
2. Semua pergerakan dana via **Appwrite Function** (server-side dengan API Key penuh)
3. Escrow hanya dilepas setelah validasi (views tervalidasi / collab post valid)
4. UMKM tidak bisa tarik dana yang sudah di-Escrow (kecuali campaign dibatalkan sebelum ada klaim)

## Komisi Platform

```
Campaign Mode  : UMKM bayar budget + 15% komisi → AppConstants.campaignFeePercent = 0.15
Rate Card Mode : UMKM bayar harga kontrak + 10% platform fee → AppConstants.rateCardFeePercent = 0.10
Kreator menerima harga penuh (tanpa potongan dari sisi kreator)
```

---

## 1. Entity & Model Transaksi

```dart
// domain/entities/transaction_entity.dart
class TransactionEntity {
  final String id;
  final String userId;
  final String? idReferensi;       // $id campaign atau order
  final String? tipeReferensi;     // 'Campaign' | 'RateCard'
  final double nominal;
  final String tipe;               // 'Deposit'|'Withdrawal'|'Fee'|'Refund'|'Pencairan'
  final String status;             // 'Pending'|'Escrow'|'Success'|'Failed'|'Refunded'
  final String? midtransOrderId;
  final String? keterangan;
  final DateTime createdAt;

  const TransactionEntity({
    required this.id,
    required this.userId,
    this.idReferensi,
    this.tipeReferensi,
    required this.nominal,
    required this.tipe,
    required this.status,
    this.midtransOrderId,
    this.keterangan,
    required this.createdAt,
  });

  // Helper: apakah nominal masuk atau keluar?
  bool get isIncoming => tipe == 'Pencairan' || tipe == 'Refund';
}

// data/models/transaction_model.dart
class TransactionModel {
  // ... fields sama dengan entity

  factory TransactionModel.fromDocument(Map<String, dynamic> data) {
    return TransactionModel(
      id: data['\$id'],
      userId: data['user_id'] as String,
      idReferensi: data['id_referensi'] as String?,
      tipeReferensi: data['tipe_referensi'] as String?,
      nominal: (data['nominal'] as num).toDouble(),
      tipe: data['tipe'] as String,
      status: data['status'] as String,
      midtransOrderId: data['midtrans_order_id'] as String?,
      keterangan: data['keterangan'] as String?,
      createdAt: DateTime.parse(data['\$createdAt']),
    );
  }

  TransactionEntity toEntity() => TransactionEntity(
    id: id,
    userId: userId,
    idReferensi: idReferensi,
    tipeReferensi: tipeReferensi,
    nominal: nominal,
    tipe: tipe,
    status: status,
    midtransOrderId: midtransOrderId,
    keterangan: keterangan,
    createdAt: createdAt,
  );
}
```

---

## 2. KeuanganController — UMKM

```dart
class KeuanganUMKMController extends GetxController {
  final GetTransactionHistoryUseCase _getHistoryUseCase;
  final CreateDepositUseCase _createDepositUseCase;

  final _transactions = <TransactionEntity>[].obs;
  final _isLoading    = false.obs;
  final _filter       = 'Semua'.obs;

  List<TransactionEntity> get transactions => _transactions;
  bool get isLoading                       => _isLoading.value;
  String get filter                        => _filter.value;

  final List<String> filters = ['Semua', 'Deposit', 'Fee', 'Refund'];

  @override
  void onInit() {
    super.onInit();
    loadTransactions();
  }

  Future<void> loadTransactions({String? tipe}) async {
    _isLoading.value = true;
    final result = await _getHistoryUseCase(GetTransactionsParams(tipe: tipe));
    result.fold(
      (failure) => Get.snackbar('Gagal Memuat', failure.message),
      (data) => _transactions.value = data,
    );
    _isLoading.value = false;
  }

  void setFilter(String newFilter) {
    _filter.value = newFilter;
    loadTransactions(tipe: newFilter == 'Semua' ? null : newFilter);
  }

  // Deposit dipicu setelah Midtrans berhasil — tidak langsung ke TRANSACTIONS
  // Alur: Tombol bayar → CreateDepositUseCase → Appwrite Function → snap_token → WebView
}
```

---

## 3. KeuanganController — Kreator

```dart
class KeuanganKreatorController extends GetxController {
  final GetWalletBalanceUseCase _getBalanceUseCase;
  final GetTransactionHistoryUseCase _getHistoryUseCase;
  final WithdrawUseCase _withdrawUseCase;

  final _saldo        = 0.0.obs;
  final _transactions = <TransactionEntity>[].obs;
  final _isLoading    = false.obs;
  final _isWithdrawing = false.obs;

  double get saldo        => _saldo.value;
  bool get isLoading      => _isLoading.value;
  bool get isWithdrawing  => _isWithdrawing.value;
  bool get canWithdraw    => _saldo.value >= 10000; // minimum Rp 10.000

  @override
  void onInit() {
    super.onInit();
    _loadAll();
  }

  Future<void> _loadAll() async {
    _isLoading.value = true;
    await Future.wait([_loadBalance(), _loadTransactions()]);
    _isLoading.value = false;
  }

  Future<void> _loadBalance() async {
    final result = await _getBalanceUseCase(NoParams());
    result.fold((_) {}, (saldo) => _saldo.value = saldo);
  }

  Future<void> _loadTransactions() async {
    final result = await _getHistoryUseCase(const GetTransactionsParams());
    result.fold((_) {}, (data) => _transactions.value = data);
  }

  Future<void> withdraw(WithdrawParams params) async {
    if (!canWithdraw) {
      Get.snackbar('Saldo Tidak Cukup', 'Minimum penarikan adalah Rp 10.000.');
      return;
    }
    if (params.nominal > _saldo.value) {
      Get.snackbar('Saldo Tidak Cukup',
          'Saldo kamu Rp ${NumberFormat.compact(locale: "id").format(_saldo.value)}.');
      return;
    }

    _isWithdrawing.value = true;
    final result = await _withdrawUseCase(params);
    result.fold(
      (failure) => Get.snackbar('Gagal Menarik Dana', failure.message,
          backgroundColor: AppColors.danger, colorText: Colors.white),
      (_) {
        Get.snackbar('Permintaan Diproses',
            'Dana akan masuk ke rekening kamu dalam 1-3 hari kerja.',
            backgroundColor: AppColors.success, colorText: Colors.white);
        _loadAll(); // refresh saldo + histori
      },
    );
    _isWithdrawing.value = false;
  }
}
```

---

## 4. DataSource — Read Only TRANSACTIONS

```dart
// KeuanganRemoteDataSource — hanya READ ke TRANSACTIONS
class KeuanganRemoteDataSourceImpl {
  final Databases _databases;
  final Functions _functions;

  // Ambil riwayat transaksi user
  Future<List<TransactionModel>> getTransactionHistory({
    required String userId,
    String? tipe,
    int limit = 20,
    int offset = 0,
  }) async {
    try {
      final queries = [
        Query.equal('user_id', userId),
        Query.orderDesc('\$createdAt'),
        Query.limit(limit),
        Query.offset(offset),
      ];
      if (tipe != null) queries.add(Query.equal('tipe', tipe));

      final result = await _databases.listDocuments(
        databaseId: AppConstants.databaseId,
        collectionId: AppConstants.colTransactions,
        queries: queries,
      );
      return result.documents
          .map((d) => TransactionModel.fromDocument(d.data))
          .toList();
    } on AppwriteException catch (e) {
      throw _mapException(e);
    }
  }

  // Ambil saldo dompet kreator dari collection USERS
  Future<double> getWalletBalance(String userId) async {
    try {
      final result = await _databases.listDocuments(
        databaseId: AppConstants.databaseId,
        collectionId: AppConstants.colUsers,
        queries: [Query.equal('user_id', userId), Query.limit(1)],
      );
      if (result.documents.isEmpty) throw NotFoundException('Profil tidak ditemukan.');
      return (result.documents.first.data['dompet_saldo'] as num).toDouble();
    } on AppwriteException catch (e) {
      throw _mapException(e);
    }
  }

  // Request deposit — panggil Appwrite Function, dapat snap_token
  Future<String> createDepositRequest({
    required String orderId,
    required double amount,
    required String itemName,
    required String userId,
  }) async {
    try {
      final execution = await _functions.createExecution(
        functionId: 'midtrans-create-fn',
        body: jsonEncode({
          'order_id':  orderId,
          'amount':    amount,
          'item_name': itemName,
          'user_id':   userId,
        }),
        method: 'POST',
      );
      if (execution.responseStatusCode != 200) {
        throw ServerException('Gagal membuat transaksi pembayaran.');
      }
      final data = jsonDecode(execution.responseBody);
      return data['snap_token'] as String;
    } on AppwriteException catch (e) {
      throw _mapException(e);
    }
  }

  // Request withdrawal — via Appwrite Function
  Future<void> requestWithdrawal(WithdrawParams params) async {
    try {
      final execution = await _functions.createExecution(
        functionId: 'withdraw-fn',
        body: jsonEncode({
          'user_id':        params.userId,
          'nominal':        params.nominal,
          'nama_bank':      params.namaBank,
          'nomor_rekening': params.nomorRekening,
          'nama_pemilik':   params.namaPemilik,
        }),
        method: 'POST',
      );
      if (execution.responseStatusCode != 200) {
        final err = jsonDecode(execution.responseBody);
        throw ServerException(err['error'] ?? 'Gagal memproses penarikan dana.');
      }
    } on AppwriteException catch (e) {
      throw _mapException(e);
    }
  }
}
```

---

## 5. RiwayatTransaksiPage

```dart
// lib/features/keuangan/presentation/pages/riwayat_transaksi_page.dart
class RiwayatTransaksiPage extends StatelessWidget {
  const RiwayatTransaksiPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<KeuanganUMKMController>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Riwayat Transaksi', style: AppTextStyles.h3),
        backgroundColor: AppColors.surface,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Filter chips
          Obx(() => SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md, vertical: AppSpacing.sm),
            child: Row(
              children: controller.filters.map((f) => Padding(
                padding: const EdgeInsets.only(right: AppSpacing.sm),
                child: ChoiceChip(
                  label: Text(f),
                  selected: controller.filter == f,
                  onSelected: (_) => controller.setFilter(f),
                  selectedColor: AppColors.primary100,
                ),
              )).toList(),
            ),
          )),

          // List transaksi
          Expanded(
            child: Obx(() {
              if (controller.isLoading) return const LoadingShimmer();
              if (controller.transactions.isEmpty) {
                return const EmptyStateWidget(
                  message: 'Belum ada transaksi.',
                  icon: Icons.receipt_long_outlined,
                );
              }
              return ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                itemCount: controller.transactions.length,
                itemBuilder: (_, index) =>
                    TransactionItem(transaction: controller.transactions[index]),
              );
            }),
          ),
        ],
      ),
    );
  }
}
```

---

## 6. TransactionItem Widget

```dart
class TransactionItem extends StatelessWidget {
  final TransactionEntity transaction;
  const TransactionItem({super.key, required this.transaction});

  static const _tipeLabel = {
    'Deposit':    'Top-up Dana',
    'Withdrawal': 'Penarikan Dana',
    'Fee':        'Komisi Platform',
    'Refund':     'Pengembalian Dana',
    'Pencairan':  'Pencairan Escrow',
  };

  @override
  Widget build(BuildContext context) {
    final isIncoming = transaction.isIncoming;
    final amountColor = isIncoming ? AppColors.success : AppColors.danger;
    final amountPrefix = isIncoming ? '+' : '-';

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        boxShadow: [BoxShadow(
            color: Colors.black.withOpacity(0.04), blurRadius: 4)],
      ),
      child: Row(
        children: [
          // Icon tipe
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: amountColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
            ),
            child: Icon(
              isIncoming ? Icons.arrow_downward : Icons.arrow_upward,
              color: amountColor,
              size: 20,
            ),
          ),
          const SizedBox(width: AppSpacing.md),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(_tipeLabel[transaction.tipe] ?? transaction.tipe,
                    style: AppTextStyles.labelMedium),
                if (transaction.keterangan != null)
                  Text(transaction.keterangan!,
                      style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.grey500),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                Text(
                  DateFormat('dd MMM yyyy, HH:mm', 'id')
                      .format(transaction.createdAt),
                  style: AppTextStyles.bodySmall.copyWith(color: AppColors.grey500),
                ),
              ],
            ),
          ),

          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '$amountPrefix Rp ${NumberFormat.compact(locale: 'id').format(transaction.nominal)}',
                style: AppTextStyles.labelMedium.copyWith(color: amountColor),
              ),
              StatusBadge(status: transaction.status),
            ],
          ),
        ],
      ),
    );
  }
}
```

---

## 7. WithdrawParams

```dart
class WithdrawParams {
  final String userId;
  final double nominal;
  final String namaBank;
  final String nomorRekening;
  final String namaPemilik;

  const WithdrawParams({
    required this.userId,
    required this.nominal,
    required this.namaBank,
    required this.nomorRekening,
    required this.namaPemilik,
  });
}
```
