---
description: Langkah-langkah implementasi fitur chat menggunakan Appwrite Realtime
---
# Workflow: Implement Realtime Chat

Fitur chat hanya berlaku untuk **Rate Card Mode** (Negosiasi Proyek).

1. **Setup Koleksi `MESSAGES`**: Pastikan koleksi memiliki atribut `order_id`, `sender_id`, `tipe_pesan`, `konten`, `offer_data`, dan `is_read`.
2. **DataSource Subscription**:
   - Gunakan `AppwriteService.realtime.subscribe()` pada *channel* koleksi pesan.
   - Filter *payload* event hanya untuk `order_id` yang sedang aktif di chat room.
3. **Controller Lifecycle**:
   - `onInit`: Panggil load pesan awal dan mulai *subscribe*.
   - `onClose`: Pastikan memanggil `subscription.close()` untuk mencegah kebocoran memori.
4. **Handling Custom Offer**:
   - Gunakan JSON *encoding/decoding* untuk field `offer_data`.
   - Tampilkan widget `CustomOfferBubble` jika `tipe_pesan == 'CustomOffer'`.
5. **UI Rendering**:
   - Gunakan `ListView.builder` dengan `reverse: true`.
   - Tampilkan *shimmer* saat pertama kali memuat riwayat pesan.
