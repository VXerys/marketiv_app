---
trigger: model_decision
description: Aturan kritis untuk menjaga performa rendering dan efisiensi memori aplikasi Marketiv
---

# Performance Rules

> [!IMPORTANT]
> Performa adalah prioritas utama untuk menjaga pengalaman pengguna yang mulus (*jank-free*) pada perangkat UMKM yang beragam.

### 1. Larangan Logika di Dalam Build
- **ATURAN MUTLAK**: Jangan pernah menempatkan logika perhitungan berat, inisialisasi list/map, atau transformasi data kompleks (seperti *chunking* atau *filtering*) langsung di dalam metode `build()`.
- **Rasional**: Metode `build()` dipanggil berkali-kali oleh Flutter (saat animasi, pergantian state, atau munculnya keyboard). Menaruh logika di sini akan membuat aplikasi patah-patah (*jank*) dan boros baterai.
- **Solusi**: Pindahkan ke constructor menggunakan *initializer list*, atau simpan hasilnya di dalam variabel state di Controller (GetX).

### 2. Optimasi Rendering List
- Selalu gunakan `ListView.builder` atau `SliverList` untuk daftar yang panjang atau dinamis.
- Hindari penggunaan `Column(children: list.map(...).toList())` karena akan merender seluruh item sekaligus ke memori, meskipun tidak terlihat di layar.

### 3. Manajemen Gambar & Media
- Gunakan `CachedNetworkImage` untuk semua gambar jarak jauh agar tidak terjadi pengunduhan ulang yang sia-sia.
- Berikan dimensi (`width` & `height`) yang pasti jika memungkinkan untuk mencegah *layout shift* saat gambar dimuat.

### 4. Pencegahan Memory Leak
- Tutup (*dispose*) selalu objek `StreamController`, `TextEditingController`, dan `Realtime` subscription di dalam metode `onClose()` pada GetX Controller.