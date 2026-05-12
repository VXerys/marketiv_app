# Shared Widgets (`lib/shared/widgets/`)

Menyimpan semua widget reusable yang digunakan di lebih dari satu fitur, seperti Primary Button, Loading Shimmer, Empty State, dan Banner Status.

## Best Practices
1. Widget harus "dumb" (tidak tahu tentang UseCase atau Controller khusus), melainkan hanya menerima data via *constructor parameter* (props).
2. Ekstrak UI component yang sama agar desain tetap konsisten.
