# Fitur Notification (`lib/features/notification/`)

Menampilkan list in-app notifications untuk event seperti: deposit berhasil, pekerjaan diterima, bukti tayang divalidasi, dsb.

## Best Practices
1. Notifikasi didorong oleh trigger di server/Appwrite dan dibaca melalui collection notifikasi.
2. Sediakan kemampuan mark-as-read.
