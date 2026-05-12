# Features (`lib/features/`)

Setiap direktori di dalam `features/` merepresentasikan satu domain/modul fitur spesifik dari aplikasi Marketiv, diimplementasikan dengan Clean Architecture.

## Best Practices Clean Architecture:
Setiap folder fitur minimal memiliki struktur:
- `data/`: DataSource (remote/local), Models (JSON parsing), RepositoryImpl.
- `domain/`: Entities, Repository (abstract), UseCases.
- `presentation/`: Pages, Widgets spesifik fitur, Controllers (GetX), Bindings.
