# Fitur Job Pool (`lib/features/job_pool/`)

Tempat kreator melihat dan mengklaim kampanye yang tersedia di sistem, serta melakukan pengiriman URL bukti tayang (Submission).

## Best Practices
1. Jangan ada batasan followers. Sistem menggunakan skema "siapa cepat dia dapat" asalkan kuota masih tersedia.
2. Manfaatkan real-time state jika diperlukan saat kuota habis diambil orang lain.
