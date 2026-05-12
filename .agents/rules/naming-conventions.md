---
trigger: model_decision
description: Aturan penamaan file, class, dan database field untuk konsistensi proyek
---

# Naming Conventions

1. **Database (Appwrite)**:
   - Koleksi: Jamak (contoh: `campaigns`, `submissions`, `users`).
   - Field: *snake_case* (contoh: `nama_lengkap`, `dompet_saldo`).
2. **Flutter (Dart)**:
   - File: *snake_case* (contoh: `campaign_remote_datasource.dart`).
   - Class: *PascalCase* (contoh: `CampaignController`).
   - Variable/Method: *camelCase* (contoh: `isLoading`, `loadCampaigns()`).
3. **Arsitektur**:
   - DataSource Impl: Akhiri dengan `RemoteDataSourceImpl`.
   - Repository Impl: Akhiri dengan `RepositoryImpl`.
   - UseCase: Awali dengan aksi (contoh: `GetCampaignsUseCase`, `CreateOrderUseCase`).
4. **UI Components**:
   - Widget: PascalCase (contoh: `PrimaryButton`, `CampaignCard`).
   - Konstanta Warna/Spacing: *camelCase* (contoh: `primary500`, `md`).