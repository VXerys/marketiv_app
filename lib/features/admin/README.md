# Fitur Admin (`lib/features/admin/`)

Panel administratif yang di-load HANYA jika `role == ADMIN`. Digunakan untuk memvalidasi submission, dispute escrow, dll.

## Best Practices
1. Di Flutter Mobile App, fitur admin bersifat *read-only* atau fungsionalitas ringan. Operasional berat dilakukan via web.
2. Lindungi route halaman admin; jika user bukan admin, harus di-reject.
