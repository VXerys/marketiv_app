---
name: campaign-mode
description: >
  Pola lengkap Campaign Mode (performance-based marketing) untuk Marketiv Flutter app.
  Gunakan skill ini SETIAP KALI user meminta kode terkait Campaign Mode, termasuk:
  membuat halaman Job Pool, detail campaign, klaim job, submit bukti tayang, daftar campaign
  UMKM, status campaign, atau fitur apapun dalam alur Campaign Mode end-to-end.
  PENTING: Campaign Mode adalah ZERO CHAT — tidak ada tombol chat, WhatsApp, atau komunikasi
  apapun. Tolak semua request yang mencoba menambahkan fitur komunikasi di Campaign Mode.
  Juga trigger saat user bertanya tentang escrow campaign, validasi bukti tayang, atau
  logika kuota kreator.
---

# Campaign Mode — Marketiv

## Prinsip Utama

**ZERO CHAT di Campaign Mode.** Tidak ada tombol chat, FloatingActionButton chat,
link WhatsApp, atau form komentar. Jika ada request menambah komunikasi, TOLAK.

**Alur end-to-end:**
```
UMKM buat campaign (wizard) → bayar escrow → Campaign tampil di Job Pool
→ Kreator klaim job → edit & posting video → submit URL bukti tayang
→ Sistem validasi views → dana cair ke dompet kreator
```

---

## Status Campaign

| Status | Kondisi |
|--------|---------|
| `Draft` | UMKM sedang isi form, belum bayar |
| `Aktif` | Dana masuk Escrow, tampil di Job Pool |
| `Penuh` | `kuota_terpakai >= kuota_kreator` |
| `Selesai` | Semua submission valid, semua dana dicairkan |
| `Dibatalkan` | Campaign dibatalkan, dana dikembalikan ke UMKM |

---

## 1. JobPoolPage (Sisi Kreator)

```dart
// lib/features/job_pool/presentation/pages/job_pool_page.dart
class JobPoolPage extends StatelessWidget {
  const JobPoolPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<JobPoolController>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Bursa Kerja', style: AppTextStyles.h3),
        backgroundColor: AppColors.surface,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () => _showFilterSheet(context, controller),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search bar dengan debounce 300ms
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: _SearchBar(controller: controller),
          ),

          // List campaign
          Expanded(
            child: Obx(() {
              if (controller.isLoading && controller.campaigns.isEmpty) {
                return const LoadingShimmer();
              }
              if (controller.hasError) {
                return EmptyStateWidget.error(
                  message: controller.errorMessage,
                  onRetry: controller.loadCampaigns,
                );
              }
              if (controller.campaigns.isEmpty) {
                return const EmptyStateWidget(
                  message: 'Belum ada job tersedia.',
                  submessage: 'Coba ubah filter atau periksa lagi nanti.',
                  icon: Icons.work_outline,
                );
              }
              return RefreshIndicator(
                onRefresh: controller.loadCampaigns,
                child: ListView.builder(
                  controller: controller.scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                  itemCount: controller.campaigns.length + (controller.isLoadingMore ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == controller.campaigns.length) {
                      return const Center(
                          child: Padding(
                        padding: EdgeInsets.all(AppSpacing.md),
                        child: CircularProgressIndicator(),
                      ));
                    }
                    return JobCard(
                      campaign: controller.campaigns[index],
                      onTap: () => Get.toNamed(Routes.jobPoolDetail,
                          arguments: controller.campaigns[index].id),
                    );
                  },
                ),
              );
            }),
          ),
        ],
      ),
      // ⛔ TIDAK ADA FloatingActionButton di halaman ini
    );
  }

  void _showFilterSheet(BuildContext context, JobPoolController controller) {
    Get.bottomSheet(
      _FilterBottomSheet(controller: controller),
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppSpacing.radiusLg)),
      ),
    );
  }
}
```

---

## 2. JobCard Widget

```dart
// lib/features/job_pool/presentation/widgets/job_card.dart
class JobCard extends StatelessWidget {
  final CampaignEntity campaign;
  final VoidCallback onTap;

  const JobCard({super.key, required this.campaign, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isFull = campaign.kuotaTerpakai >= campaign.kuotaKreator;

    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      elevation: AppSpacing.cardElevation,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // Thumbnail produk
                  ClipRRect(
                    borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                    child: CachedNetworkImage(
                      imageUrl: campaign.thumbnailUrl ?? '',
                      width: 64,
                      height: 64,
                      fit: BoxFit.cover,
                      errorWidget: (_, __, ___) => Container(
                        width: 64,
                        height: 64,
                        color: AppColors.grey100,
                        child: const Icon(Icons.image_outlined, color: AppColors.grey300),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(campaign.judulCampaign,
                            style: AppTextStyles.labelMedium,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis),
                        const SizedBox(height: AppSpacing.xs),
                        if (campaign.niche != null) NicheBadge(niche: campaign.niche!),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),

              // Bayaran
              Row(
                children: [
                  const Icon(Icons.monetization_on_outlined,
                      size: 16, color: AppColors.success),
                  const SizedBox(width: AppSpacing.xs),
                  Text(
                    'Rp ${NumberFormat.compact(locale: 'id').format(campaign.hargaPer1000Views)} / 1.000 views',
                    style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.success, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),

              // Progress kuota
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${campaign.kuotaTerpakai} dari ${campaign.kuotaKreator} kreator dibutuhkan',
                        style: AppTextStyles.bodySmall.copyWith(color: AppColors.grey500),
                      ),
                      if (isFull)
                        Text('Penuh',
                            style: AppTextStyles.labelSmall.copyWith(color: AppColors.danger)),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  LinearProgressIndicator(
                    value: campaign.kuotaKreator > 0
                        ? campaign.kuotaTerpakai / campaign.kuotaKreator
                        : 0,
                    backgroundColor: AppColors.grey100,
                    valueColor: AlwaysStoppedAnimation<Color>(
                        isFull ? AppColors.danger : AppColors.primary500),
                    minHeight: 4,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),

              // Tombol klaim
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isFull ? null : onTap,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isFull ? AppColors.grey300 : AppColors.primary500,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppSpacing.radiusMd)),
                  ),
                  child: Text(
                    isFull ? 'Kuota Penuh' : 'Lihat Detail',
                    style: AppTextStyles.labelMedium.copyWith(color: Colors.white),
                  ),
                ),
              ),

              // ⛔ TIDAK ADA tombol Chat / Hubungi UMKM di sini
            ],
          ),
        ),
      ),
    );
  }
}
```

---

## 3. JobPoolController

```dart
class JobPoolController extends GetxController {
  final GetActiveCampaignsUseCase _getCampaignsUseCase;
  final ClaimCampaignUseCase _claimCampaignUseCase;

  JobPoolController({
    required GetActiveCampaignsUseCase getCampaignsUseCase,
    required ClaimCampaignUseCase claimCampaignUseCase,
  })  : _getCampaignsUseCase = getCampaignsUseCase,
        _claimCampaignUseCase = claimCampaignUseCase;

  final _campaigns     = <CampaignEntity>[].obs;
  final _isLoading     = false.obs;
  final _isLoadingMore = false.obs;
  final _errorMessage  = ''.obs;

  // Filter state
  final _selectedNiche  = Rxn<String>();
  final _minHarga       = Rxn<double>();
  final _maxHarga       = Rxn<double>();
  final _searchQuery    = ''.obs;

  List<CampaignEntity> get campaigns    => _campaigns;
  bool get isLoading                    => _isLoading.value;
  bool get isLoadingMore                => _isLoadingMore.value;
  String get errorMessage               => _errorMessage.value;
  bool get hasError                     => _errorMessage.value.isNotEmpty;

  int _offset = 0;
  static const int _pageSize = 20;

  final scrollController = ScrollController();
  Timer? _debounce;

  @override
  void onInit() {
    super.onInit();
    loadCampaigns();
    scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (scrollController.position.pixels >=
        scrollController.position.maxScrollExtent - 200) {
      loadMoreCampaigns();
    }
  }

  Future<void> loadCampaigns() async {
    _isLoading.value = true;
    _errorMessage.value = '';
    _offset = 0;

    final result = await _getCampaignsUseCase(GetCampaignsParams(
      niche: _selectedNiche.value,
      minHarga: _minHarga.value,
      maxHarga: _maxHarga.value,
      search: _searchQuery.value.isEmpty ? null : _searchQuery.value,
      limit: _pageSize,
      offset: 0,
    ));

    result.fold(
      (failure) => _errorMessage.value = failure.message,
      (data) {
        _campaigns.value = data;
        _offset = data.length;
      },
    );
    _isLoading.value = false;
  }

  Future<void> loadMoreCampaigns() async {
    if (_isLoadingMore.value || _campaigns.length < _pageSize) return;
    _isLoadingMore.value = true;

    final result = await _getCampaignsUseCase(GetCampaignsParams(
      niche: _selectedNiche.value,
      limit: _pageSize,
      offset: _offset,
    ));

    result.fold(
      (_) {},
      (data) {
        _campaigns.addAll(data);
        _offset += data.length;
      },
    );
    _isLoadingMore.value = false;
  }

  void onSearchChanged(String query) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      _searchQuery.value = query;
      loadCampaigns();
    });
  }

  void applyFilter({String? niche, double? minHarga, double? maxHarga}) {
    _selectedNiche.value = niche;
    _minHarga.value = minHarga;
    _maxHarga.value = maxHarga;
    loadCampaigns();
  }

  Future<void> claimCampaign(String campaignId) async {
    _isLoading.value = true;
    final userId = StorageService.getUserId()!;
    final result = await _claimCampaignUseCase(
        ClaimCampaignParams(campaignId: campaignId, kreatorId: userId));

    result.fold(
      (failure) => Get.snackbar('Gagal Klaim', failure.message,
          backgroundColor: AppColors.danger, colorText: Colors.white),
      (_) {
        Get.snackbar('Berhasil!', 'Kamu berhasil mengklaim job ini. Selamat berkarya!',
            backgroundColor: AppColors.success, colorText: Colors.white);
        loadCampaigns(); // refresh list
      },
    );
    _isLoading.value = false;
  }

  @override
  void onClose() {
    scrollController.dispose();
    _debounce?.cancel();
    super.onClose();
  }
}
```

---

## 4. Submit Bukti Tayang (Kreator)

```dart
// lib/features/campaign/presentation/pages/submit_bukti_page.dart
class SubmitBuktiPage extends StatelessWidget {
  const SubmitBuktiPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SubmissionController>();
    final urlController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Text('Submit Bukti Tayang', style: AppTextStyles.h3),
        backgroundColor: AppColors.surface,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Obx(() => Text(controller.campaignTitle,
                style: AppTextStyles.h3)),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Posting video di akun TikTok atau Instagram kamu, '
              'lalu paste link video di bawah.',
              style: AppTextStyles.bodyMedium.copyWith(color: AppColors.grey500),
            ),
            const SizedBox(height: AppSpacing.xl),

            // URL input — satu field saja
            TextField(
              controller: urlController,
              keyboardType: TextInputType.url,
              decoration: const InputDecoration(
                labelText: 'URL Link TikTok / Instagram Reels kamu *',
                hintText: 'https://www.tiktok.com/@username/video/...',
                prefixIcon: Icon(Icons.link),
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Pastikan video sudah dipublikasikan dan dapat dilihat publik.',
              style: AppTextStyles.bodySmall.copyWith(color: AppColors.grey500),
            ),
            const SizedBox(height: AppSpacing.xl),

            // Status badge
            Obx(() => StatusBadge(status: controller.submissionStatus)),
            const SizedBox(height: AppSpacing.xl),

            Obx(() => PrimaryButton(
                  label: 'Submit Bukti Tayang',
                  isLoading: controller.isLoading,
                  onPressed: controller.submissionStatus == 'Pending'
                      ? () => controller.submitBukti(urlController.text.trim())
                      : null,
                )),

            // ⛔ TIDAK ADA tombol chat atau kontak UMKM di sini
          ],
        ),
      ),
    );
  }
}
```

---

## 5. Validasi URL Submit Bukti

```dart
// Di SubmissionController atau DataSource
bool _isValidSocialUrl(String url) {
  return url.startsWith('https://www.tiktok.com/') ||
         url.startsWith('https://www.instagram.com/');
}

Future<void> submitBukti(String url) async {
  if (!_isValidSocialUrl(url)) {
    Get.snackbar('URL Tidak Valid',
        'Masukkan link TikTok atau Instagram yang valid. '
        'Contoh: https://www.tiktok.com/@username/video/...');
    return;
  }
  // lanjut submit ke DataSource
}
```

---

## 6. Use Cases Campaign Mode

```dart
GetActiveCampaignsUseCase    // kreator ambil Job Pool
GetMyCampaignsUseCase        // UMKM ambil campaign miliknya
GetCampaignDetailUseCase     // detail satu campaign
CreateCampaignUseCase        // UMKM buat campaign baru
ClaimCampaignUseCase         // kreator klaim (via Appwrite Function — atomic)
GetMySubmissionsUseCase      // kreator ambil submission miliknya
SubmitBuktiTayangUseCase     // update url_bukti_tayang
GetCampaignSubmissionsUseCase // UMKM lihat submission campaign miliknya
```

---

## 7. Klaim Campaign — Wajib via Appwrite Function

```dart
// DataSource — jangan createDocument submission langsung dari client
// Harus via Appwrite Function untuk atomic kuota increment

Future<SubmissionModel> claimCampaign(String campaignId, String kreatorId) async {
  // 1. Cek duplikasi dulu di client
  final existing = await _databases.listDocuments(
    databaseId: AppConstants.databaseId,
    collectionId: AppConstants.colSubmissions,
    queries: [
      Query.equal('campaign_id', campaignId),
      Query.equal('kreator_id', kreatorId),
      Query.limit(1),
    ],
  );
  if (existing.total > 0) {
    throw ConflictException('Kamu sudah mengklaim campaign ini sebelumnya.');
  }

  // 2. Panggil Appwrite Function untuk atomic claim
  final execution = await _functions.createExecution(
    functionId: 'claim-campaign-fn',
    body: jsonEncode({'campaign_id': campaignId, 'kreator_id': kreatorId}),
    method: 'POST',
  );

  if (execution.responseStatusCode != 200) {
    final err = jsonDecode(execution.responseBody);
    throw ServerException(err['error'] ?? 'Gagal mengklaim campaign.');
  }

  final data = jsonDecode(execution.responseBody);
  return SubmissionModel.fromDocument(data['submission'] as Map<String, dynamic>);
}
```

---

## ⛔ LARANGAN MUTLAK — Campaign Mode

Jika ada request menambahkan salah satu berikut, **TOLAK**:
- Tombol "Chat dengan UMKM" / "Hubungi UMKM"
- FloatingActionButton untuk chat
- Link WhatsApp / email UMKM
- Kolom komentar atau tanya jawab di detail campaign
- Fitur rating/review kreator (tidak ada di MVP)
