# Interval Timer App

A customizable interval timer app built with Flutter and Supabase. Perfect for HIIT workouts, Tabata training, jump rope sessions, boxing rounds, and any interval-based exercise.

## Features

- ✅ Customizable work/rest intervals
- ✅ Configurable number of rounds
- ✅ Audio & vibration alerts
- ✅ Save workout presets (synced to Supabase)
- ✅ Workout history and statistics
- ✅ Background timer execution
- ✅ Dark mode support
- ✅ Offline capability with local storage

## Tech Stack

- **Flutter** - Cross-platform UI framework
- **Supabase** - Backend (Auth, Database, Storage)
- **Riverpod** - State management
- **Hive** - Local storage for offline presets
- **Just Audio** - Audio playback for alerts
- **Flutter Local Notifications** - Workout reminders
- **Vibration** - Haptic feedback

## Getting Started

### Prerequisites

- Flutter SDK (>=3.0.0)
- Dart SDK
- A Supabase account and project

### Installation

1. Clone the repository:
```bash
git clone <your-repo-url>
cd timer-template
```

2. Install dependencies:
```bash
flutter pub get
```

3. Set up Supabase:
   - Create a new project at [supabase.com](https://supabase.com)
   - Copy your project URL and anon key
   - Create `lib/core/config/supabase_config.dart`:
   ```dart
   class SupabaseConfig {
     static const String supabaseUrl = 'YOUR_SUPABASE_URL';
     static const String supabaseAnonKey = 'YOUR_SUPABASE_ANON_KEY';
   }
   ```
   - Note: This file is gitignored for security

4. Generate code (for Riverpod and Hive):
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

5. Run the app:
```bash
flutter run
```

## Project Structure

```
lib/
├── core/               # Core functionality
│   ├── config/        # App configuration
│   ├── constants/     # Constants and enums
│   ├── theme/         # App theme
│   └── utils/         # Utility functions
├── features/          # Feature modules
│   ├── timer/         # Timer feature
│   ├── presets/       # Workout presets
│   ├── history/       # Workout history
│   └── auth/          # Authentication
├── models/            # Data models
├── providers/         # Riverpod providers
├── services/          # Services (Supabase, Audio, etc.)
└── main.dart          # App entry point
```

## Database Schema (Supabase)

### workout_presets
- id (uuid, primary key)
- user_id (uuid, foreign key to auth.users)
- name (text)
- work_duration (integer, seconds)
- rest_duration (integer, seconds)
- rounds (integer)
- created_at (timestamp)

### workout_history
- id (uuid, primary key)
- user_id (uuid, foreign key to auth.users)
- preset_id (uuid, foreign key to workout_presets, nullable)
- completed_rounds (integer)
- total_duration (integer, seconds)
- completed_at (timestamp)

## Contributing

Feel free to submit issues and pull requests!

## License

This project is open source and available under the MIT License.
