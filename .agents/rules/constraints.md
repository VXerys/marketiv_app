---
trigger: model_decision
description: Batasan sistem Marketiv (Hard Constraints) yang tidak boleh dilanggar
---

# Marketiv Hard Constraints

1. **Zero Chat di Campaign Mode**: Sama sekali tidak boleh ada interaksi obrolan, form komentar, maupun tautan langsung ke WhatsApp pada alur *Campaign Mode*.
2. **Manajemen Media Besar**: Aset video atau file besar (> 100MB) **dilarang** diunggah ke Appwrite Storage. Pengguna wajib memasukkan tautan eksternal (contoh: URL Google Drive, Dropbox, TikTok, atau Instagram) dan string URL tersebut harus divalidasi oleh client Flutter.
3. **Batas Maksimal Rate Card**: Setiap kreator hanya boleh memiliki maksimum 3 paket Rate Card. Aplikasi wajib memvalidasi hal ini dengan query *count* via `RateCardController` sebelum mengizinkan pembuatan paket baru.
4. **Uniqueness Submission**: Appwrite tidak mendukung fitur *unique constraint* multi-kolom secara bawaan. Oleh karena itu, duplikasi klaim (1 kreator, 1 campaign) wajib dicek secara manual (melalui `listDocuments`) sebelum mengeksekusi pembuatan dokumen *submission* baru.