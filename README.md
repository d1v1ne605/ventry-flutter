# Ventry Flutter

Ventry is a Flutter inventory app for managing authentication, product catalogs,
SKU/SPU variants, categories, quick product creation, image uploads, and barcode
scanning.

## Tech Stack

- Flutter and Dart
- Bloc for feature state
- GetIt and Injectable for dependency injection
- GoRouter for navigation and auth redirects
- Dio and Retrofit for API access
- Freezed and json_serializable for request/response models
- Drift and SQLite for local attribute storage
- flutter_screenutil for responsive sizing

## Requirements

- Flutter SDK with Dart `^3.10.0`
- Android Studio or Xcode for mobile builds
- A running Ventry backend API

## Setup

Install dependencies:

```bash
flutter pub get
```

Create the root environment file:

```bash
cp lib/env/.env.development .env
```

Use `lib/env/.env.production` instead when building against production.

The app reads:

```env
BASE_URL=http://10.0.2.2:3000/v1
```

Common local values:

- Android emulator: `http://10.0.2.2:3000/v1`
- iOS simulator or macOS: `http://localhost:3000/v1`
- Physical device: `http://<your-machine-ip>:3000/v1`

## Generated Code

Regenerate Injectable, Retrofit, Freezed, JSON, and Drift files after changing
annotated classes:

```bash
dart run build_runner build --delete-conflicting-outputs
```

Regenerate launcher icons:

```bash
dart run flutter_launcher_icons
```

Regenerate native splash assets:

```bash
dart run flutter_native_splash:create
```

## Run

```bash
flutter run
```

Examples:

```bash
flutter run -d chrome
flutter run -d android
flutter run -d ios
```

## Verify

Format and analyze:

```bash
dart format lib test
flutter analyze
```

Run tests:

```bash
flutter test
```

## Project Structure

```text
lib/
  core/            Shared constants, theme, network, logging, database, widgets
  data/            Remote/local datasources, models, repository implementations
  domain/          Entities, repository contracts, use cases
  env/             Environment templates
  presentation/    Routes, screens, blocs, UI widgets
  injection.dart   GetIt entry point
  main.dart        App bootstrap
assets/
  icons/
  images/
  fonts/
```

## Notes

- Do not commit `.env`.
- Do not manually edit generated `*.g.dart`, `*.freezed.dart`, or
  `injection.config.dart` files.
- Keep models in the data layer and expose domain entities to use cases and UI.
