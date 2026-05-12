---
name: prompt-engineer-copilot
description: >
  Panduan lengkap prompt engineering untuk GitHub Copilot Chat di proyek Marketiv (Flutter + GetX
  + Appwrite). Gunakan skill ini SETIAP KALI user meminta bantuan menulis prompt untuk Copilot,
  memperbaiki prompt yang hasilnya kurang bagus, membuat custom instructions (copilot-instructions.md),
  membuat prompt file (.prompt.md), memilih chat participant (@workspace/@github/@terminal),
  menggunakan chat variables (#file/#selection/#codebase), atau slash commands (/explain /fix /tests).
  Juga trigger saat user bilang "Copilot-nya ngasih hasil yang salah", "gimana cara tanya Copilot
  soal...", "buatkan prompt untuk Copilot", atau "bagaimana supaya Copilot generate kode sesuai
  arsitektur Marketiv". Skill ini mencakup anatomy prompt yang efektif, teknik konteks,
  anti-pattern umum, dan template prompt siap pakai untuk task Flutter/Appwrite/GetX.
---

# Prompt Engineering untuk GitHub Copilot Chat — Marketiv

> Referensi tambahan:
> - `/mnt/skills/prompt-engineer-copilot/references/prompt-templates.md` — Template prompt siap pakai per task
> - `/mnt/skills/prompt-engineer-copilot/references/copilot-instructions.md` — File custom instructions Marketiv siap pasang

---

## Cara Kerja Copilot Chat (Penting Dipahami)

Copilot membangun konteks dari **3 sumber** secara berurutan:
1. **File yang sedang terbuka** di editor (paling berpengaruh)
2. **Chat variables** yang kamu tulis (`#file`, `#selection`, dll.)
3. **Chat history** dalam sesi yang sedang berjalan

Implikasinya: **Copilot tidak bisa membaca pikiran kamu.** Makin banyak konteks yang kamu beri secara eksplisit, makin tepat hasilnya.

---

## Anatomy Prompt yang Efektif

Setiap prompt yang baik punya 4 komponen (tidak semua harus ada, tapi makin lengkap makin baik):

```
[ROLE] + [KONTEKS] + [TASK SPESIFIK] + [CONSTRAINT/OUTPUT FORMAT]
```

### Contoh — Buruk vs Baik

**❌ Buruk:**
```
buatkan datasource untuk campaign
```

**✅ Baik:**
```
@workspace Kamu adalah Flutter developer yang paham Clean Architecture + GetX.
Buatkan CampaignRemoteDataSourceImpl untuk proyek Marketiv menggunakan Appwrite SDK.

Requirements:
- Method: getActiveCampaigns(niche, minHarga, maxHarga, limit, offset)
- Query: filter status='Aktif', orderDesc $createdAt, pagination dengan limit/offset
- Semua AppwriteException harus di-catch dan di-map ke custom exception
- Import package:appwrite HANYA boleh di DataSource layer
- Kembalikan List<CampaignModel> (parse dari document.data dengan fromDocument)

Gunakan pola dari #file:lib/features/campaign/data/datasources/campaign_remote_datasource.dart
```

---

## Chat Participants — Kapan Pakai Apa

| Participant | Kapan dipakai | Contoh use case |
|-------------|---------------|-----------------|
| `@workspace` | Query tentang seluruh proyek, arsitektur, relasi antar file | "Di mana GetX binding untuk campaign didefinisikan?" |
| `@github` | PR review, issue, search repo, web search | "Ada bug report tentang pagination di Job Pool?" |
| `@terminal` | Error di terminal, npm/dart/flutter commands | "Kenapa `flutter pub get` gagal dengan error ini?" |
| `@vscode` | Setting VS Code, shortcut, extension | "Cara format dart file otomatis saat save?" |

**Tips:** Selalu pakai `@workspace` untuk pertanyaan tentang kode Marketiv. Tanpa `@workspace`, Copilot hanya lihat file yang sedang terbuka.

---

## Chat Variables — Beri Konteks Presisi

| Variable | Isi | Kapan pakai |
|----------|-----|-------------|
| `#file:path/to/file.dart` | Seluruh isi satu file | Minta refactor atau extend file tertentu |
| `#selection` | Kode yang sedang di-highlight | Fix atau jelaskan potongan kode spesifik |
| `#codebase` | Seluruh codebase (token besar) | Pertanyaan arsitektur lintas fitur |
| `#editor` | File yang sedang aktif di editor | Review atau improve file saat ini |

**Contoh kombinasi:**
```
@workspace Refactor #file:lib/features/job_pool/presentation/controllers/job_pool_controller.dart
agar pagination menggunakan scrollController listener, bukan button "Muat Lebih Banyak".
Ikuti pola yang sama dengan #file:lib/features/campaign/presentation/controllers/campaign_list_controller.dart
```

---

## Slash Commands — Task Cepat

| Command | Fungsi | Contoh |
|---------|--------|--------|
| `/explain` | Jelaskan kode | `/explain #selection` — jelaskan bagian ini |
| `/fix` | Fix bug atau error | `/fix` — paste error message dari terminal |
| `/tests` | Generate unit test | `/tests #file:lib/features/auth/domain/usecases/login_usecase.dart` |
| `/doc` | Tambah dokumentasi | `/doc #selection` |
| `/new` | Buat file/project baru | `/new Flutter feature untuk notifikasi in-app` |

---

## Teknik Prompting per Task

### 1. Generate Kode Baru (Feature/Layer)

**Pola:**
```
@workspace Buat [LAYER] untuk fitur [NAMA_FITUR] di proyek Marketiv.

Stack: Flutter + GetX + Appwrite SDK
Arsitektur: Clean Architecture (DataSource → Repository → UseCase → Controller → UI)

Requirements:
- [requirement 1]
- [requirement 2]

Constraint:
- import 'package:appwrite/appwrite.dart' HANYA di DataSource
- Repository return Either<Failure, T> dari dartz
- Semua teks UI dalam Bahasa Indonesia

Gunakan pola yang sama dengan #file:[file_referensi_yang_mirip]
```

### 2. Debug / Fix Error

**Pola:**
```
@workspace /fix

Error berikut muncul saat [AKSI] di [HALAMAN/FLOW]:
[PASTE ERROR MESSAGE LENGKAP]

Konteks:
- File yang relevan: #file:[file.dart]
- Langkah reproduksi: [langkah]
- Yang sudah dicoba: [apa yang sudah dicoba]
```

### 3. Refactor Kode yang Ada

**Pola:**
```
@workspace Refactor #file:[file.dart]

Tujuan: [apa yang ingin diperbaiki — performa / readability / ikuti arsitektur]

Rules yang harus diikuti:
- [rule spesifik proyek Marketiv]
- Jangan ubah interface publik (nama method, parameter)
- Pertahankan semua edge case yang sudah ada

Setelah refactor, jelaskan apa yang berubah dan kenapa.
```

### 4. Generate Unit Test

**Pola:**
```
@workspace /tests #file:[usecase_atau_repository.dart]

Buat unit test untuk semua method di file ini.
Framework: flutter_test + mockito

Coverage yang diharapkan:
- Happy path (Either Right)
- Failure path (Either Left — ServerFailure, AuthFailure)
- Edge case: [sebutkan jika ada]

Mock dependencies menggunakan @GenerateMocks.
```

### 5. Explain / Review Kode

**Pola:**
```
@workspace /explain #file:[file.dart]

Jelaskan:
1. Apa yang dilakukan file ini dalam konteks arsitektur Marketiv?
2. Apakah ada masalah performa atau anti-pattern?
3. Apakah sudah sesuai dengan Clean Architecture (DataSource → Repo → UseCase → Controller)?
4. Bagian mana yang paling berisiko dan kenapa?
```

### 6. Generate copilot-instructions.md

```
@workspace Buatkan file .github/copilot-instructions.md untuk proyek ini.

Isi harus mencakup:
1. Ringkasan proyek dan tech stack
2. Arsitektur wajib (Clean Architecture + GetX)
3. Aturan import (appwrite hanya di DataSource)
4. Konvensi naming
5. Larangan mutlak (Campaign Mode = zero chat, dll.)
6. Cara parse Appwrite document ($id, $createdAt)
```

---

## Anti-Pattern — Prompt yang Sering Gagal

### ❌ Terlalu Singkat
```
// Copilot tidak tahu konteks proyek
buat controller untuk job pool
```
**Fix:** Tambahkan `@workspace`, sebutkan stack, dan referensi file yang sudah ada.

### ❌ Ambigu — "this" / "ini"
```
jelaskan ini  // "ini" = file yang terbuka? selection? last response?
fix this error
```
**Fix:** Gunakan `#selection`, `#file:path`, atau `/explain` + paste kode eksplisit.

### ❌ Terlalu Banyak Task dalam Satu Prompt
```
buat datasource, repository, usecase, controller, binding, dan page untuk fitur withdrawal
```
**Fix:** Pecah per layer. Mulai dari DataSource, konfirmasi hasilnya, lanjut ke Repository, dst.

### ❌ Tidak Ada Constraint
```
buatkan fungsi upload gambar
```
Copilot tidak tahu: maks ukuran file? bucket mana? permission apa? format URL?
**Fix:** Sebutkan semua constraint yang relevan dari spesifikasi Marketiv.

### ❌ Context Window Mubazir
```
// Jangan buka 20 file sekaligus — Copilot jadi bingung dan outputnya generik
// Buka hanya 1-3 file yang paling relevan
```

---

## Strategi Iterasi

Jika hasil Copilot belum tepat, **jangan ulangi prompt yang sama**. Gunakan salah satu strategi ini:

1. **Tambah contoh:** "Hasilnya harus seperti ini: [contoh kode]"
2. **Perjelas output format:** "Kembalikan hanya kode Dart, tanpa penjelasan"
3. **Batasi scope:** "Fokus hanya pada method `getActiveCampaigns`, skip yang lain"
4. **Koreksi eksplisit:** "Kode ini salah karena import appwrite ada di Controller. Pindahkan ke DataSource."
5. **Ganti participant:** Coba `@workspace` jika sebelumnya tanpa participant

---

## Custom Instructions — copilot-instructions.md

File ini dibaca Copilot di **setiap** chat request secara otomatis.
Letakkan di: `.github/copilot-instructions.md`

**Yang harus ada di file ini untuk proyek Marketiv:**
→ Baca file referensi: `/mnt/skills/prompt-engineer-copilot/references/copilot-instructions.md`

**Prinsip penulisan:**
- Maksimal ~500 baris (lebih dari itu kualitas respons menurun)
- Tulis imperatif, singkat: "Always return Either<Failure, T>" bukan "Sebaiknya kamu menggunakan..."
- Sertakan contoh kode untuk aturan yang tidak obvious
- Jelaskan *mengapa* di balik setiap aturan penting ("karena OPENAI_API_KEY tidak boleh di client")
- Gunakan heading Markdown untuk struktur yang mudah di-scan Copilot

---

## Prompt Files (.prompt.md) — Reusable Prompts

Letakkan di `.github/prompts/` atau `.github/instructions/`.
Dipanggil dari Copilot Chat dengan `/runPrompt` atau via command palette.

**Contoh struktur:**
```markdown
---
mode: 'agent'
description: 'Generate full Clean Architecture layer untuk fitur Marketiv baru'
---

Buat scaffold lengkap Clean Architecture untuk fitur ${input:featureName}.

Stack: Flutter + GetX + Appwrite
Layer yang dibutuhkan:
- DataSource (abstract + impl)
- Repository (abstract + impl)
- UseCase: Get${input:featureName}UseCase, Create${input:featureName}UseCase
- Controller dengan 3 state: isLoading, errorMessage, data
- Binding (urutan: DataSource → Repository → UseCase → Controller)
- Page dengan 3 state UI: shimmer loading, error + retry, data (ListView.builder)

Ikuti aturan di .github/copilot-instructions.md.
```

---

## Quick Reference — Cheat Sheet

```
# Context
@workspace      → seluruh proyek
#file:path      → satu file spesifik
#selection      → kode yang di-highlight
#codebase       → seluruh codebase

# Commands
/explain        → jelaskan kode
/fix            → perbaiki bug
/tests          → buat unit test
/doc            → buat dokumentasi

# Template Dasar
@workspace [role]. Buat [task] untuk proyek Marketiv.
Stack: Flutter + GetX + Appwrite.
Requirements: [list].
Constraint: [list].
Gunakan pola dari #file:[referensi].
```

---

Untuk template prompt lengkap siap pakai per task (DataSource, Controller, Page, dll.):
→ Baca `/mnt/skills/prompt-engineer-copilot/references/prompt-templates.md`

Untuk file copilot-instructions.md siap pasang ke repo Marketiv:
→ Baca `/mnt/skills/prompt-engineer-copilot/references/copilot-instructions.md`