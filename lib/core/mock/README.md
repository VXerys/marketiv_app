# Mock Data (`lib/core/mock/`)

Berisi class mock dan dummy data (biasanya Mock DataSource) untuk memfasilitasi pengembangan UI (contoh: menampilkan desain saat backend Appwrite belum siap).

## Best Practices
1. Gunakan toggle `AppConfig.useMockData` untuk switch antara RemoteDataSource dan MockDataSource.
2. Jangan hapus folder ini karena berguna untuk rapid prototyping UI.
