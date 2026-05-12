---
name: rate-card-mode
description: >
  Pola lengkap Rate Card Mode (fixed price + live chat) untuk Marketiv Flutter app.
  Gunakan skill ini SETIAP KALI user meminta kode terkait Rate Card Mode, termasuk:
  direktori kreator, profil kreator, live chat (ChatRoomPage), custom offer widget,
  order flow negosiasi, status order, manajemen rate card kreator (maks 3 paket),
  atau submit URL collab post. Juga trigger saat user bertanya tentang Appwrite Realtime
  untuk chat, cara kirim pesan, cara buat CustomOffer, atau cara menampilkan status order.
  Rate Card Mode adalah SATU-SATUNYA tempat live chat aktif di Marketiv.
---

# Rate Card Mode — Marketiv

## Prinsip Utama

- **Live Chat HANYA aktif di Rate Card Mode** — di ChatRoomPage via Appwrite Realtime
- **Rate Card maks 3 paket per kreator** — enforce di RateCardController
- **Custom Offer** dikunci via MessageModel dengan `tipe_pesan = 'CustomOffer'`
- `offer_data` disimpan sebagai JSON string di Appwrite (Appwrite tidak support JSONB)

## Status Order Flow

```
Negosiasi → Menunggu Pembayaran → Escrow → [Revisi] → Menunggu Verifikasi → Selesai
                                          ↘ Dibatalkan
                                          ↘ Dispute → Admin intervensi
```

---

## 1. KreatorDirectoryPage (Sisi UMKM)

```dart
// lib/features/rate_card/presentation/pages/kreator_directory_page.dart
class KreatorDirectoryPage extends StatelessWidget {
  const KreatorDirectoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<KreatorDirectoryController>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Cari Kreator', style: AppTextStyles.h3),
        backgroundColor: AppColors.surface,
        elevation: 0,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: _SearchBar(controller: controller),
          ),
          Expanded(
            child: Obx(() {
              if (controller.isLoading) return const LoadingShimmer();
              if (controller.hasError) {
                return EmptyStateWidget.error(
                  message: controller.errorMessage,
                  onRetry: controller.loadKreators,
                );
              }
              if (controller.kreators.isEmpty) {
                return const EmptyStateWidget(
                  message: 'Kreator tidak ditemukan.',
                  icon: Icons.person_search,
                );
              }
              return ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                itemCount: controller.kreators.length,
                itemBuilder: (_, index) => KreatorCard(
                  kreator: controller.kreators[index],
                  onTap: () => Get.toNamed(Routes.kreatorProfile,
                      arguments: controller.kreators[index].userId),
                ),
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

## 2. Rate Card Management (Sisi Kreator)

```dart
// RateCardController — enforce maks 3 paket
class RateCardController extends GetxController {
  final GetRateCardsUseCase _getRateCardsUseCase;
  final CreateRateCardUseCase _createRateCardUseCase;
  final DeleteRateCardUseCase _deleteRateCardUseCase;

  final _rateCards = <RateCardEntity>[].obs;
  final _isLoading = false.obs;

  List<RateCardEntity> get rateCards => _rateCards;
  bool get isLoading => _isLoading.value;
  bool get canAddMore => _rateCards.length < 3; // Maks 3 paket

  Future<void> createRateCard(CreateRateCardParams params) async {
    // Cek batas 3 paket SEBELUM create
    if (!canAddMore) {
      Get.snackbar(
        'Batas Tercapai',
        'Kamu sudah memiliki 3 paket. Hapus salah satu untuk menambah paket baru.',
        backgroundColor: AppColors.warning,
        colorText: Colors.white,
      );
      return;
    }

    _isLoading.value = true;
    final result = await _createRateCardUseCase(params);
    result.fold(
      (failure) => Get.snackbar('Gagal Menyimpan', failure.message),
      (card) {
        _rateCards.add(card);
        Get.back();
        Get.snackbar('Berhasil', 'Paket baru berhasil ditambahkan.',
            backgroundColor: AppColors.success, colorText: Colors.white);
      },
    );
    _isLoading.value = false;
  }

  Future<void> deleteRateCard(String id) async {
    final confirmed = await ConfirmDialog.show(
      title: 'Hapus Paket?',
      message: 'Paket yang sudah dihapus tidak dapat dipulihkan.',
      confirmLabel: 'Ya, Hapus',
      isDangerous: true,
    );
    if (confirmed != true) return;

    _isLoading.value = true;
    final result = await _deleteRateCardUseCase(id);
    result.fold(
      (failure) => Get.snackbar('Gagal Menghapus', failure.message),
      (_) {
        _rateCards.removeWhere((c) => c.id == id);
        Get.snackbar('Dihapus', 'Paket berhasil dihapus.');
      },
    );
    _isLoading.value = false;
  }
}
```

---

## 3. ChatRoomPage — Live Chat via Appwrite Realtime

```dart
// lib/features/chat/presentation/pages/chat_room_page.dart
// ⚠️ Realtime HANYA aktif di halaman ini
class ChatRoomPage extends StatelessWidget {
  const ChatRoomPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ChatController>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Obx(() => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(controller.peerName, style: AppTextStyles.labelMedium),
            StatusBadge(status: controller.orderStatus),
          ],
        )),
        backgroundColor: AppColors.surface,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Pesan list
          Expanded(
            child: Obx(() {
              if (controller.isLoading) return const LoadingShimmer(itemCount: 5);
              return ListView.builder(
                controller: controller.scrollController,
                reverse: true, // terbaru di bawah
                padding: const EdgeInsets.all(AppSpacing.md),
                itemCount: controller.messages.length,
                itemBuilder: (_, index) {
                  final msg = controller.messages[
                      controller.messages.length - 1 - index]; // reverse
                  return MessageBubble(
                    message: msg,
                    isSender: msg.senderId == StorageService.getUserId(),
                  );
                },
              );
            }),
          ),

          // Custom Offer button (hanya UMKM)
          if (StorageService.getRole() == 'UMKM')
            Obx(() => controller.orderStatus == 'Negosiasi'
                ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                    child: OutlinedButton.icon(
                      onPressed: () => _showCustomOfferSheet(context, controller),
                      icon: const Icon(Icons.local_offer_outlined, size: 18),
                      label: const Text('Kirim Penawaran'),
                      style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.primary500),
                    ),
                  )
                : const SizedBox.shrink()),

          // Input bar
          _ChatInputBar(controller: controller),
        ],
      ),
    );
  }

  void _showCustomOfferSheet(BuildContext context, ChatController controller) {
    Get.bottomSheet(
      CustomOfferSheet(controller: controller),
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
    );
  }
}
```

---

## 4. MessageBubble Widget

```dart
class MessageBubble extends StatelessWidget {
  final MessageEntity message;
  final bool isSender;

  const MessageBubble({super.key, required this.message, required this.isSender});

  @override
  Widget build(BuildContext context) {
    switch (message.tipePesan) {
      case 'System':
        return _SystemMessage(message: message);
      case 'CustomOffer':
        return _CustomOfferBubble(message: message, isSender: isSender);
      default:
        return _TextBubble(message: message, isSender: isSender);
    }
  }
}

class _TextBubble extends StatelessWidget {
  final MessageEntity message;
  final bool isSender;

  const _TextBubble({required this.message, required this.isSender});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.75),
        margin: const EdgeInsets.only(bottom: AppSpacing.sm),
        padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md, vertical: AppSpacing.sm),
        decoration: BoxDecoration(
          color: isSender ? AppColors.primary500 : AppColors.grey100,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(AppSpacing.radiusMd),
            topRight: const Radius.circular(AppSpacing.radiusMd),
            bottomLeft: Radius.circular(isSender ? AppSpacing.radiusMd : 0),
            bottomRight: Radius.circular(isSender ? 0 : AppSpacing.radiusMd),
          ),
        ),
        child: Text(
          message.konten,
          style: AppTextStyles.bodyMedium.copyWith(
              color: isSender ? Colors.white : AppColors.grey900),
        ),
      ),
    );
  }
}

class _SystemMessage extends StatelessWidget {
  final MessageEntity message;
  const _SystemMessage({required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
        padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md, vertical: AppSpacing.xs),
        decoration: BoxDecoration(
          color: AppColors.grey100,
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        ),
        child: Text(message.konten,
            style: AppTextStyles.bodySmall.copyWith(color: AppColors.grey500)),
      ),
    );
  }
}
```

---

## 5. CustomOffer Bubble + Sheet

```dart
class _CustomOfferBubble extends StatelessWidget {
  final MessageEntity message;
  final bool isSender;

  const _CustomOfferBubble({required this.message, required this.isSender});

  @override
  Widget build(BuildContext context) {
    final offer = jsonDecode(message.offerData!) as Map<String, dynamic>;
    final controller = Get.find<ChatController>();

    return Align(
      alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: AppSpacing.md),
        constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.80),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          border: Border.all(color: AppColors.primary200),
          boxShadow: [BoxShadow(
              color: Colors.black.withOpacity(0.05), blurRadius: 4)],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: AppColors.primary50,
                borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(AppSpacing.radiusMd)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.local_offer, color: AppColors.primary500, size: 18),
                  const SizedBox(width: AppSpacing.sm),
                  Text('Penawaran Proyek',
                      style: AppTextStyles.labelMedium.copyWith(
                          color: AppColors.primary600)),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(offer['judul_proyek'] ?? '', style: AppTextStyles.labelMedium),
                  const SizedBox(height: AppSpacing.xs),
                  Text(offer['scope_pekerjaan'] ?? '',
                      style: AppTextStyles.bodySmall.copyWith(color: AppColors.grey500)),
                  const SizedBox(height: AppSpacing.md),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text('Harga', style: AppTextStyles.bodySmall.copyWith(color: AppColors.grey500)),
                        Text(
                          NumberFormat.currency(locale: 'id', symbol: 'Rp ', decimalDigits: 0)
                              .format(offer['harga_final']),
                          style: AppTextStyles.labelMedium.copyWith(color: AppColors.success),
                        ),
                      ]),
                      Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                        Text('Deadline', style: AppTextStyles.bodySmall.copyWith(color: AppColors.grey500)),
                        Text(offer['deadline'] ?? '-', style: AppTextStyles.labelMedium),
                      ]),
                    ],
                  ),
                  // Tombol Terima/Tolak hanya tampil untuk Kreator
                  if (!isSender && StorageService.getRole() == 'KREATOR') ...[
                    const SizedBox(height: AppSpacing.md),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => controller.respondOffer(message.id, false),
                            style: OutlinedButton.styleFrom(
                                foregroundColor: AppColors.danger,
                                side: const BorderSide(color: AppColors.danger)),
                            child: const Text('Tolak'),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () => controller.respondOffer(message.id, true),
                            style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.success),
                            child: const Text('Terima',
                                style: TextStyle(color: Colors.white)),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

---

## 6. ChatController — Realtime Subscription

```dart
class ChatController extends GetxController {
  final ChatRemoteDataSource _dataSource;
  final String orderId;

  ChatController({required ChatRemoteDataSource dataSource, required this.orderId})
      : _dataSource = dataSource;

  final _messages    = <MessageEntity>[].obs;
  final _isLoading   = true.obs;
  final _orderStatus = ''.obs;
  final _peerName    = ''.obs;

  List<MessageEntity> get messages    => _messages;
  bool get isLoading                  => _isLoading.value;
  String get orderStatus              => _orderStatus.value;
  String get peerName                 => _peerName.value;

  final scrollController = ScrollController();
  final messageController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    _loadInitialData();
    _subscribeRealtime(); // Realtime HANYA di sini
  }

  Future<void> _loadInitialData() async {
    _isLoading.value = true;
    // Load messages + order detail
    final msgs = await _dataSource.fetchMessages(orderId);
    _messages.value = msgs.map((m) => m.toEntity()).toList();
    _isLoading.value = false;
    _scrollToBottom();
  }

  void _subscribeRealtime() {
    _dataSource.subscribeToMessages(orderId, (messages) {
      _messages.value = messages.map((m) => m.toEntity()).toList();
      _scrollToBottom();
    });
  }

  Future<void> sendMessage() async {
    final text = messageController.text.trim();
    if (text.isEmpty) return;
    messageController.clear();

    await _dataSource.sendMessage(
      orderId: orderId,
      senderId: StorageService.getUserId()!,
      konten: text,
      tipePesan: 'Text',
    );
    // Realtime akan trigger update otomatis
  }

  Future<void> sendCustomOffer(Map<String, dynamic> offerData) async {
    await _dataSource.sendMessage(
      orderId: orderId,
      senderId: StorageService.getUserId()!,
      konten: 'Penawaran proyek: ${offerData['judul_proyek']}',
      tipePesan: 'CustomOffer',
      offerData: jsonEncode(offerData),
    );
  }

  Future<void> respondOffer(String messageId, bool accepted) async {
    // Update status order: accepted → 'Menunggu Pembayaran'
    await _dataSource.respondToOffer(orderId: orderId, accepted: accepted);
    if (accepted) {
      _orderStatus.value = 'Menunggu Pembayaran';
      // Kirim pesan System
      await _dataSource.sendMessage(
        orderId: orderId,
        senderId: 'system',
        konten: 'Penawaran diterima. Menunggu pembayaran dari UMKM.',
        tipePesan: 'System',
      );
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          0, // reverse: true → 0 = bottom
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void onClose() {
    _dataSource.cancelSubscription(); // WAJIB cancel subscription
    scrollController.dispose();
    messageController.dispose();
    super.onClose();
  }
}
```

---

## 7. Kirim Pesan ke Appwrite

```dart
// ChatRemoteDataSource
Future<void> sendMessage({
  required String orderId,
  required String senderId,
  required String konten,
  required String tipePesan,
  String? offerData,
}) async {
  final umkmId    = /* ambil dari order document */;
  final kreatorId = /* ambil dari order document */;

  await _databases.createDocument(
    databaseId: AppConstants.databaseId,
    collectionId: AppConstants.colMessages,
    documentId: ID.unique(),
    data: {
      'order_id':   orderId,
      'sender_id':  senderId,
      'tipe_pesan': tipePesan,
      'konten':     konten,
      'offer_data': offerData,
      'is_read':    false,
    },
    permissions: [
      Permission.read(Role.user(umkmId)),
      Permission.read(Role.user(kreatorId)),
      Permission.update(Role.user(senderId)), // untuk mark as read
    ],
  );
}
```

---

## 8. offer_data Format

```dart
// Encode saat kirim
final offerData = jsonEncode({
  'judul_proyek':    'Video Promosi Sambal Matah',
  'scope_pekerjaan': '1 video TikTok 60 detik + 1 Reels IG',
  'harga_final':     350000.0,
  'deadline':        '2026-06-01',
});

// Decode saat tampil
final offer = jsonDecode(message.offerData!) as Map<String, dynamic>;
final harga  = (offer['harga_final'] as num).toDouble();
```
