# EcoInspect (CNC Manager)

EcoInspect is a cross-platform Flutter application for managing CNC operations and sustainability-related operational data. It uses **BLoC** for state management and **Supabase** for authentication and backend data storage.

https://github.com/user-attachments/assets/091649f4-f52a-4279-a53a-3e5755e6651f

## Features

- **Authentication**: Sign in/out and session persistence (Supabase).
- **Dashboard**: Central overview after login.
- **CNC Management**: Manage CNC-related records.
- **Energy Tracking**: Capture and review energy-related data.
- **Events**: Log and view operational events.
- **Maintenance**: Track maintenance actions.
- **True Cost**: Workflows related to cost calculations.

## Tech Stack

- **Flutter / Dart**
- **State management**: `flutter_bloc` + `equatable`
- **Backend**: `supabase_flutter`
- **Device integration**: `image_picker`, `permission_handler`

## Prerequisites

- Flutter SDK (compatible with the Dart SDK constraint in `pubspec.yaml`)
- A Supabase project (URL + anon key)

## Getting Started

### 1) Install dependencies

```bash
flutter pub get
```

### 2) Configure Supabase

This app currently initializes Supabase using constants defined in `lib/constants.dart`.

1. Create a project at https://supabase.com
2. Go to **Project Settings → API**
3. Copy your **Project URL** and **anon key**
4. Update the following values in `lib/constants.dart`:

- `kSupabaseUrl`
- `kSupabaseAnonKey`

### 3) Run the app

```bash
flutter run
```

To run on a specific platform:

```bash
flutter run -d chrome
flutter run -d windows
flutter run -d android
flutter run -d ios
```

## Build

```bash
flutter build apk
flutter build appbundle
flutter build ios
flutter build web
flutter build windows
```

## Project Structure

```text
lib/
  main.dart                # App entry point, routing based on auth state
  constants.dart           # App constants + Supabase config
  model/                   # Data models
  view/                    # UI screens/widgets
  viewmodel/               # Cubits + state (BLoC)
```

## State Management

The app is organized using multiple Cubits (see `lib/viewmodel/`) provided at the root via `MultiBlocProvider` in `main.dart`.

## Testing

```bash
flutter test
```

## Security Notes

- **Do not commit secrets**. The Supabase anon key is a public client key, but you should still treat configuration carefully.
- Consider moving configuration to environment-based setup (for example build-time `--dart-define` values) for production deployments.

## Contributing

1. Create a feature branch.
2. Keep changes focused and consistent with the existing architecture (`view/`, `viewmodel/`, `model/`).
3. Run `flutter analyze` and `flutter test` before opening a PR.

## License

This project is currently unlicensed. Add a license file if you intend to distribute it.
