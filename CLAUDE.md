# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This repository serves as a template for building interval timer applications with Flutter. The `main` branch contains a basic Flutter scaffold, while the `claude/jumping-rope-timer-app-011CUiBdMCDdAW1G7cAk64gb` branch contains a complete interval timer app implementation with Supabase backend integration.

### Main Branch
Basic Flutter counter app template - starting point for new Flutter projects.

### Claude Branch (Interval Timer App)
A fully-featured interval timer app designed for HIIT workouts, Tabata training, jump rope sessions, and other interval-based exercises. Includes cloud sync via Supabase, offline storage with Hive, audio alerts, and workout history tracking.

## Important Setup (Interval Timer Branch)

### Supabase Configuration
The app requires Supabase credentials. Create a local config file that won't be committed:

1. Create `lib/core/config/supabase_config.local.dart` (this file is gitignored):
```dart
class SupabaseConfig {
  static const String supabaseUrl = 'YOUR_SUPABASE_PROJECT_URL';
  static const String supabaseAnonKey = 'YOUR_SUPABASE_ANON_KEY';

  SupabaseConfig._();
}
```

2. The default `supabase_config.dart` contains placeholder values and serves as a template.

### Supabase Database Setup
Create these tables in your Supabase project:

```sql
-- Workout Presets
CREATE TABLE workout_presets (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES auth.users(id),
  name TEXT NOT NULL,
  work_duration INTEGER NOT NULL,
  rest_duration INTEGER NOT NULL,
  rounds INTEGER NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Workout History
CREATE TABLE workout_history (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES auth.users(id),
  preset_id UUID REFERENCES workout_presets(id),
  completed_rounds INTEGER NOT NULL,
  total_duration INTEGER NOT NULL,
  completed_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);
```

### Assets
Audio and image assets should be placed in:
- `assets/audio/` - Timer beep sounds
- `assets/images/` - App icons and images

## Development Commands

### Setup
```bash
flutter pub get                                          # Install dependencies
flutter pub run build_runner build --delete-conflicting-outputs  # Generate code (Riverpod/Hive) - only needed in interval timer branch
```

### Running the App
```bash
flutter run                  # Run on connected device/emulator
flutter run -d chrome        # Run in Chrome browser
flutter run -d <device-id>   # Run on specific device
```

### Testing
```bash
flutter test                             # Run all tests
flutter test test/widget_test.dart       # Run specific test file
flutter test --coverage                  # Run tests with coverage
```

### Code Quality
```bash
flutter analyze                          # Run static analysis
flutter pub outdated                     # Check for outdated dependencies
flutter pub upgrade --major-versions     # Upgrade dependencies
```

### Building
```bash
flutter build apk              # Build Android APK
flutter build appbundle        # Build Android App Bundle
flutter build ios              # Build iOS app
flutter build web              # Build web app
flutter build windows          # Build Windows app
flutter build macos            # Build macOS app
flutter build linux            # Build Linux app
```

## Project Structure

- `lib/main.dart` - Entry point and main application widget
- `test/` - Widget and unit tests
- `pubspec.yaml` - Dependencies and project configuration
- `analysis_options.yaml` - Dart analyzer configuration with flutter_lints

## Technical Details

### Main Branch
- **SDK Version**: Dart ^3.5.4
- **Flutter**: Uses Material Design 3 (useMaterial3: true)
- **Linting**: Configured with package:flutter_lints/flutter.yaml
- **Platform Support**: Android, iOS, Web, Windows, macOS, Linux

### Interval Timer Branch Dependencies
**Core**
- `flutter_riverpod: ^2.5.1` - State management
- `supabase_flutter: ^2.5.6` - Backend (auth, database, real-time)
- `hive: ^2.2.3` + `hive_flutter: ^1.1.0` - Local storage

**Media & Feedback**
- `just_audio: ^0.9.37` - Audio playback for timer alerts
- `vibration: ^1.8.4` - Haptic feedback
- `flutter_local_notifications: ^17.1.2` - Workout reminders

**Background Processing**
- `flutter_foreground_task: ^8.0.0` - Keep timer running in background

**UI & Utilities**
- `google_fonts: ^6.2.1` - Inter font family
- `flutter_svg: ^2.0.10+1` - SVG asset support
- `intl: ^0.19.0` - Date/time formatting
- `uuid: ^4.4.0` - Unique ID generation
- `equatable: ^2.0.5` - Value equality

**Dev Dependencies**
- `build_runner: ^2.4.9` - Code generation
- `hive_generator: ^2.0.1` - Hive adapters
- `riverpod_generator: ^2.4.0` - Riverpod providers
- `riverpod_lint: ^2.3.10` - Riverpod linting

**Linting Rules** (interval timer branch)
- `prefer_const_constructors`, `prefer_const_literals_to_create_immutables`
- `prefer_final_fields`, `prefer_single_quotes`
- `avoid_print`, `sort_pub_dependencies`
- Excludes generated files: `*.g.dart`, `*.freezed.dart`

## Architecture Notes

### Main Branch
Basic Flutter template with single-file structure using StatelessWidget/StatefulWidget with local state management.

### Interval Timer Branch Architecture

The interval timer app follows a feature-first architecture with clean separation of concerns:

**State Management**
- Riverpod for dependency injection and state management
- StateNotifier pattern for timer logic and business logic
- Providers located in `/lib/features/*/providers/` and `/lib/providers/`

**Data Layer**
- Models in `/lib/models/` using Equatable for value comparison
- Services in `/lib/services/` for Supabase, audio playback, and local storage
- Dual storage strategy: Hive for offline-first local storage, Supabase for cloud sync

**Feature Structure**
```
lib/
├── core/                    # Shared utilities and configuration
│   ├── config/             # Supabase credentials (gitignored)
│   ├── constants/          # Enums, timer states
│   ├── theme/              # AppTheme with Material 3, Google Fonts
│   └── utils/              # Time formatting utilities
├── features/               # Feature modules (timer, presets, history)
│   └── [feature]/
│       ├── providers/      # Riverpod StateNotifiers
│       ├── screens/        # UI screens
│       └── widgets/        # Feature-specific widgets
├── models/                 # Data models (WorkoutPreset, WorkoutHistory)
├── providers/              # Global providers
└── services/               # External integrations
```

**Key Design Patterns**
- Feature-first architecture for scalability
- Repository pattern via services layer
- Offline-first with Hive, sync to Supabase when online
- Provider pattern for dependency injection
- Value objects with Equatable for immutability

**Timer Implementation**
- `TimerController` (StateNotifier) manages timer state with Dart Timer
- Audio feedback via just_audio package
- Vibration via vibration package
- Phase transitions (work/rest) with automatic round progression
- Countdown beeps at last 3 seconds of each interval

**Supabase Configuration**
- Credentials stored in `lib/core/config/supabase_config.dart` (template file in repo)
- Actual credentials should be in `supabase_config.local.dart` (gitignored)
- Database schema defined in branch README:
  - `workout_presets` table: user presets with durations and rounds
  - `workout_history` table: completed workout tracking

**Theme & UI**
- Material 3 design with custom color scheme
- Google Fonts (Inter) for typography
- Dark mode support via system theme detection
- Custom colors for work (green) and rest (amber) phases
