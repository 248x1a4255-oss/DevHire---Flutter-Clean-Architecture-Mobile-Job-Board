# DevHire - Flutter Clean Architecture Mobile Job Board

An enterprise-ready mobile job board application architected using **Uncle Bob's Clean Architecture**, **Flutter BLoC** immutable state management, and a **Dual-Datasource** strategy (Remote Dio API + Local Offline SQLite/SharedPreferences cache).

---

## 🏛️ Clean Architecture Breakdown

```
lib/
├── core/
│   ├── error/              # Failures (Domain) & Exceptions (Data)
│   ├── network/            # Connectivity and client interceptors
│   ├── theme/              # Material 3 Design System & typography
│   └── usecases/           # Base UseCase contracts
│
└── features/
    └── jobs/
        ├── domain/         # Pure Business Logic (No Flutter Framework dependencies)
        │   ├── entities/   # Immutable Entities (Job, JobApplication) with Equatable
        │   ├── repositories/# Abstract repository contracts
        │   └── usecases/   # GetJobsUseCase, ToggleSaveJobUseCase, ApplyJobUseCase
        │
        ├── data/           # Data Layer & Infrastructure
        │   ├── models/     # JobModel & JobApplicationModel (JSON/SQLite mapping)
        │   ├── datasources/# JobRemoteDataSource (Dio) & JobLocalDataSource (Cache)
        │   └── repositories/# JobRepositoryImpl (Dual-datasource coordination)
        │
        └── presentation/   # UI Layer (Flutter widgets + BLoC)
            ├── bloc/       # JobBloc, JobEvent, JobState
            ├── pages/      # JobFeedPage, JobDetailPage
            └── widgets/    # JobCard, FeaturedJobCard, JobFilterSheet, JobApplicationSheet
```

---

## ⚡ Dual-Datasource Strategy
1. **Online State**: Tries the remote API client (`Dio`) with connection timeouts.
2. **Offline Fallback**: Upon network drop or server exception, seamlessly serves the local cached database without user interruption.
3. **Optimistic Local Caching**: Every successful remote payload automatically refreshes the local SQLite/cache store.

---

## 🚀 Running the Flutter App

```bash
# 1. Get Flutter dependencies
flutter pub get

# 2. Run static analysis
flutter analyze

# 3. Launch on iOS Simulator or Android Emulator
flutter run
```
