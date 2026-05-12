---
name: ai-brief-assistant
description: >
  Pola lengkap fitur AI Brief Assistant untuk Marketiv Flutter app — tombol "✨ Bantu
  dengan AI" di form buat campaign yang memanggil Appwrite Function generate-brief-fn
  (yang kemudian memanggil OpenAI gpt-4o-mini di server). Gunakan skill ini SETIAP KALI
  user meminta kode terkait: AI Brief Assistant, tombol AI di form campaign, generate
  deskripsi otomatis, atau integrasi OpenAI di Flutter. PENTING: OPENAI_API_KEY tidak
  pernah ada di Flutter client — semua panggilan OpenAI lewat Appwrite Function.
  Juga trigger saat user bertanya "bagaimana cara panggil OpenAI dari Flutter" —
  jawabannya selalu lewat Appwrite Function, bukan langsung.
---

# AI Brief Assistant — Marketiv

## Prinsip Mutlak

- **OPENAI_API_KEY** → hanya di Appwrite Function environment variable
- Flutter **TIDAK PERNAH** memanggil `https://api.openai.com` langsung
- Flutter hanya memanggil `functions.createExecution(functionId: 'generate-brief-fn', ...)`
- Hasil AI selalu bisa diedit UMKM — bukan output final

## Alur

```
UMKM tap "✨ Bantu dengan AI"
  → CreateCampaignController.generateAiBrief()
  → GenerateBriefUseCase → GenerateBriefDataSource
  → AppwriteService.functions.createExecution('generate-brief-fn', payload)
  → Appwrite Function panggil OpenAI gpt-4o-mini (server-side)
  → Response balik ke Flutter
  → Isi TextField deskripsi_brief + tampilkan label "Draf oleh AI"
  → UMKM bebas edit
```

---

## 1. DataSource — Panggil generate-brief-fn

```dart
// lib/features/campaign/data/datasources/ai_brief_datasource.dart
class AiBriefRemoteDataSource {
  final Functions _functions;

  AiBriefRemoteDataSource({required Functions functions})
      : _functions = functions;

  Future<String> generateBrief(GenerateBriefParams params) async {
    try {
      final execution = await _functions.createExecution(
        functionId: 'generate-brief-fn',
        body: jsonEncode({
          'nama_produk':  params.namaProduk,
          'niche':        params.niche,
          'deskripsi':    params.deskripsiSingkat, // boleh null
        }),
        method: 'POST',
      );

      if (execution.responseStatusCode != 200) {
        final err = jsonDecode(execution.responseBody);
        throw ServerException(
            err['error'] ?? 'AI Brief gagal dibuat. Silakan isi manual.');
      }

      final data = jsonDecode(execution.responseBody) as Map<String, dynamic>;
      return data['brief'] as String;
    } on AppwriteException catch (e) {
      switch (e.code) {
        case 401: throw UnauthorizedException('Sesi habis. Silakan login kembali.');
        default:  throw ServerException('Gagal menghubungi layanan AI: ${e.message}');
      }
    }
  }
}
```

---

## 2. Params & UseCase

```dart
// domain/usecases/generate_brief_usecase.dart
class GenerateBriefParams {
  final String namaProduk;
  final String niche;
  final String? deskripsiSingkat;

  const GenerateBriefParams({
    required this.namaProduk,
    required this.niche,
    this.deskripsiSingkat,
  });
}

class GenerateBriefUseCase {
  final AiBriefRepository _repository;
  GenerateBriefUseCase(this._repository);

  Future<Either<Failure, String>> call(GenerateBriefParams params) {
    return _repository.generateBrief(params);
  }
}
```

---

## 3. Controller — generateAiBrief()

```dart
// Di CreateCampaignController — tambahkan method ini

final _isGeneratingBrief = false.obs;
final _isAiGenerated     = false.obs;

bool get isGeneratingBrief => _isGeneratingBrief.value;
bool get isAiGenerated     => _isAiGenerated.value;

Future<void> generateAiBrief() async {
  // Validasi nama produk & niche dulu
  if (judulController.text.trim().isEmpty) {
    Get.snackbar('Isi Nama Produk Dulu',
        'Masukkan nama produk sebelum menggunakan AI Brief.');
    return;
  }
  if (_selectedNiche.value.isEmpty) {
    Get.snackbar('Pilih Kategori Dulu',
        'Pilih kategori produk sebelum menggunakan AI Brief.');
    return;
  }

  _isGeneratingBrief.value = true;

  final result = await _generateBriefUseCase(
    GenerateBriefParams(
      namaProduk: judulController.text.trim(),
      niche: _selectedNiche.value,
      deskripsiSingkat: deskripsiController.text.trim().isNotEmpty
          ? deskripsiController.text.trim()
          : null,
    ),
  );

  result.fold(
    (failure) => Get.snackbar(
      'AI Brief Gagal',
      failure.message,
      backgroundColor: AppColors.warning,
      colorText: Colors.white,
    ),
    (brief) {
      deskripsiController.text = brief;
      _isAiGenerated.value = true;
      // Pindah cursor ke akhir teks
      deskripsiController.selection = TextSelection.fromPosition(
        TextPosition(offset: deskripsiController.text.length),
      );
    },
  );

  _isGeneratingBrief.value = false;
}

// Reset flag AI saat user mulai edit manual
void onDeskripsiChanged(String _) {
  if (_isAiGenerated.value) {
    // Tidak reset flag — biarkan label tetap tampil
    // Label hanya menginformasikan bahwa teks awalnya dari AI
  }
}
```

---

## 4. UI — Tombol AI + Label Draf AI

```dart
// Di _Step1InfoProduk widget — bagian deskripsi

// TextField deskripsi dengan tombol AI di dalam
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    // Label + tombol AI di kanan
    Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('Ceritakan Produk & Instruksi untuk Kreator *',
            style: AppTextStyles.labelMedium),
        Obx(() => controller.isGeneratingBrief
            ? const SizedBox(
                width: 18, height: 18,
                child: CircularProgressIndicator(
                    strokeWidth: 2, color: AppColors.primary500))
            : TextButton.icon(
                onPressed: controller.generateAiBrief,
                icon: const Text('✨', style: TextStyle(fontSize: 14)),
                label: Text('Bantu dengan AI',
                    style: AppTextStyles.labelSmall.copyWith(
                        color: AppColors.primary500)),
                style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: const Size(0, 32)),
              )),
      ],
    ),
    const SizedBox(height: AppSpacing.xs),

    // TextField
    TextField(
      controller: controller.deskripsiController,
      onChanged: controller.onDeskripsiChanged,
      maxLines: 6,
      maxLength: 1000,
      decoration: const InputDecoration(
        hintText: 'Contoh: Produk kami adalah sambal matah khas Bali yang...',
        alignLabelWithHint: true,
        border: OutlineInputBorder(),
      ),
    ),

    // Label "Draf oleh AI" — tampil setelah AI generate
    Obx(() => controller.isAiGenerated
        ? Padding(
            padding: const EdgeInsets.only(top: AppSpacing.xs),
            child: Row(
              children: [
                const Text('✨ ', style: TextStyle(fontSize: 12)),
                Text(
                  'Draf oleh AI — silakan edit sesuai kebutuhan Anda',
                  style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.primary500,
                      fontStyle: FontStyle.italic),
                ),
              ],
            ),
          )
        : const SizedBox.shrink()),
  ],
),
```

---

## 5. Loading State — Saat AI Sedang Generate

```dart
// Tombol di bagian lain halaman bisa di-disable saat AI loading
Obx(() => PrimaryButton(
  label: 'Selanjutnya',
  // Disable tombol navigasi selama AI bekerja
  onPressed: controller.isGeneratingBrief ? null : controller.nextStep,
  isLoading: controller.isGeneratingBrief,
))
```

---

## 6. Appwrite Function — generate-brief-fn (Node.js, referensi)

> Kode berikut berjalan di **Appwrite Function server**, bukan di Flutter.
> Letakkan di folder Appwrite Functions project. OPENAI_API_KEY di environment variable Function.

```javascript
// functions/generate-brief-fn/src/main.js
import OpenAI from 'openai';

export default async ({ req, res }) => {
  const openai = new OpenAI({ apiKey: process.env.OPENAI_API_KEY });

  let body;
  try {
    body = JSON.parse(req.body);
  } catch {
    return res.json({ error: 'Request tidak valid.' }, 400);
  }

  const { nama_produk, niche, deskripsi } = body;
  if (!nama_produk || !niche) {
    return res.json({ error: 'nama_produk dan niche wajib diisi.' }, 400);
  }

  const prompt = `
Kamu adalah copywriter profesional yang membantu UMKM Indonesia membuat brief pemasaran 
untuk kreator konten video pendek (TikTok/Instagram Reels).

Buat brief pemasaran yang jelas dan mudah dipahami kreator berdasarkan info berikut:
- Nama Produk: ${nama_produk}
- Kategori: ${niche}
${deskripsi ? `- Info Tambahan: ${deskripsi}` : ''}

Brief harus mencakup:
1. Deskripsi singkat produk (2-3 kalimat)
2. Target audience
3. Pesan utama yang ingin disampaikan
4. Gaya konten yang diinginkan (tone, mood)
5. Hal-hal yang WAJIB ditampilkan di video
6. Hal-hal yang TIDAK boleh ditampilkan

Tulis dalam Bahasa Indonesia yang natural dan mudah dipahami. Maksimal 300 kata.
  `.trim();

  try {
    const completion = await openai.chat.completions.create({
      model: 'gpt-4o-mini',
      messages: [{ role: 'user', content: prompt }],
      max_tokens: 600,
      temperature: 0.7,
    });

    const brief = completion.choices[0]?.message?.content ?? '';
    return res.json({ brief });
  } catch (err) {
    return res.json({ error: 'Layanan AI sedang tidak tersedia. Coba lagi nanti.' }, 500);
  }
};
```

---

## 7. Binding — Tambahkan AiBrief ke CampaignBinding

```dart
// Tambahkan ke lib/features/campaign/presentation/bindings/campaign_binding.dart

// DataSource AI Brief
Get.lazyPut<AiBriefRemoteDataSource>(
  () => AiBriefRemoteDataSource(functions: AppwriteService.functions),
);

// Repository AI Brief
Get.lazyPut<AiBriefRepository>(
  () => AiBriefRepositoryImpl(Get.find<AiBriefRemoteDataSource>()),
);

// UseCase
Get.lazyPut(() => GenerateBriefUseCase(Get.find()));

// Inject ke CreateCampaignController
Get.lazyPut<CreateCampaignController>(
  () => CreateCampaignController(
    createCampaignUseCase: Get.find(),
    createDepositUseCase: Get.find(),
    generateBriefUseCase: Get.find(), // ← tambahkan ini
  ),
);
```
