---
trigger: model_decision
description: Aturan penggunaan fitur AI (OpenAI) melalui Appwrite Functions
---

# AI Integration Rules (OpenAI)

1. **AI Brief Assistant**:
   - Trigger melalui tombol "✨ Bantu Saya dengan AI" di form pembuatan campaign.
   - Seluruh pemanggilan OpenAI API (GPT-4o-mini) wajib melalui Appwrite Function (`generate-brief-fn`).
   - `OPENAI_API_KEY` **DILARANG** disimpan di sisi client Flutter.
2. **Parameter Input**:
   - Kirim `nama_produk`, `niche`, dan `deskripsi_singkat` ke function.
   - Tampilkan hasil *brief* di *TextField* dan izinkan pengguna untuk mengeditnya kembali.
3. **Labeling**:
   - Tandai konten yang dihasilkan AI dengan label: "✨ Draf oleh AI — silakan edit sesuai kebutuhan Anda".
4. **AI Fraud Detection**:
   - Fitur deteksi kecurangan dijalankan secara otomatis di sisi server (`validate-submission-fn`) saat kreator mengunggah bukti tayang.
   - Hasil deteksi AI akan memberikan tanda (*flag*) bagi admin untuk ditinjau secara manual.