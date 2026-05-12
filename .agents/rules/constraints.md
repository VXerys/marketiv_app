---
trigger: model_decision
description: Batasan sistem Marketiv (Hard Constraints) yang tidak boleh dilanggar
---

# Marketiv Hard Constraints

1. **Zero Chat di Campaign Mode**: Sama sekali tidak boleh ada interaksi obrolan, form komentar, maupun tautan langsung ke WhatsApp pada alur *Campaign Mode*.
2. **Manajemen Media Besar**: Aset video atau file besar (> 100MB) **dilarang** diunggah ke Appwrite Storage. Pengguna wajib memasukkan tautan eksternal (URL Google Drive/Dropbox untuk UMKM, URL TikTok/Instagram untuk Kreator).
3. **Batas Maksimal Rate Card**: Setiap kreator hanya boleh memiliki maksimum 3 paket Rate Card. Tombol "+ Tambah Paket" wajib di-*disable* (bukan dihilangkan) jika sudah mencapai batas.
4. **Warning Banner Collab Post**: Di Rate Card Mode, banner "Wajib Collab Post" harus bersifat **sticky** (selalu tampil di atas area chat) dan **tidak boleh bisa ditutup/dismiss**.
5. **Privasi Kontak di Campaign Mode**: Di halaman detail job (Campaign Mode), kreator **dilarang** melihat informasi kontak (WA/Email) UMKM.
6. **Uniqueness Submission**: Duplikasi klaim (1 kreator, 1 campaign) wajib dicek secara manual via `listDocuments` sebelum membuat dokumen *submission* baru.
7. **Dana Transaksi**: Seluruh pergerakan dana wajib melalui Appwrite Functions. Client Flutter tidak boleh melakukan `createDocument` langsung ke koleksi `TRANSACTIONS`.