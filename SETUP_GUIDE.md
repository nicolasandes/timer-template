# Setup Guide

This guide will help you set up the Interval Timer app on your local machine and configure Supabase.

## Prerequisites

- Flutter SDK (>=3.0.0) - [Install Flutter](https://docs.flutter.dev/get-started/install)
- Dart SDK (comes with Flutter)
- A code editor (VS Code, Android Studio, or IntelliJ IDEA)
- A Supabase account - [Sign up at supabase.com](https://supabase.com)

## Step 1: Clone the Repository

```bash
git clone <your-repo-url>
cd timer-template
```

## Step 2: Install Flutter Dependencies

```bash
flutter pub get
```

## Step 3: Set Up Supabase

### 3.1 Create a Supabase Project

1. Go to [supabase.com](https://supabase.com) and sign in
2. Click "New Project"
3. Fill in your project details:
   - Name: `interval-timer` (or your preferred name)
   - Database Password: Create a strong password
   - Region: Choose the closest to your users
4. Click "Create new project" and wait for it to initialize

### 3.2 Get Your Project Credentials

1. Go to Project Settings > API
2. Copy the following:
   - Project URL (looks like: `https://xxxxx.supabase.co`)
   - Anon/Public key (starts with `eyJ...`)

### 3.3 Configure the App

Create or edit `lib/core/config/supabase_config.dart`:

```dart
class SupabaseConfig {
  static const String supabaseUrl = 'https://your-project.supabase.co';
  static const String supabaseAnonKey = 'your-anon-key-here';

  SupabaseConfig._();
}
```

**IMPORTANT:** This file contains sensitive data. Never commit actual credentials to version control.

### 3.4 Set Up Database Schema

1. In your Supabase dashboard, go to the SQL Editor
2. Open the `supabase_schema.sql` file from this repository
3. Copy and paste the entire content into the SQL Editor
4. Click "Run" to execute the schema

This will create:
- `workout_presets` table with Row Level Security
- `workout_history` table with Row Level Security
- Necessary indexes for performance
- Helper functions for statistics

### 3.5 Enable Email Authentication (Optional)

1. Go to Authentication > Providers
2. Enable "Email" provider
3. Configure email templates if desired

## Step 4: Add Audio Files (Optional)

The app expects audio files for timer alerts. Create or download the following:

1. Create audio files:
   - `assets/audio/beep.mp3` - Countdown beep sound
   - `assets/audio/start.mp3` - Start interval sound
   - `assets/audio/end.mp3` - Workout complete sound

2. You can use any audio editing software or find free sound effects online from:
   - [Freesound.org](https://freesound.org/)
   - [ZapSplat](https://www.zapsplat.com/)

**Note:** The app will work without audio files, but you won't hear the alerts.

## Step 5: Run Code Generation

Generate necessary code for Riverpod and Hive:

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

## Step 6: Run the App

### For iOS Simulator:

```bash
flutter run -d ios
```

### For Android Emulator:

```bash
flutter run -d android
```

### For Chrome (Web):

```bash
flutter run -d chrome
```

## Step 7: Test the App

1. Try the quick start presets
2. Create a custom workout preset
3. Test the timer functionality
4. Sign up for an account (optional)
5. Verify presets sync to Supabase

## Troubleshooting

### "Supabase URL or Key not configured"

Make sure you've properly configured `lib/core/config/supabase_config.dart` with your actual credentials.

### "Table doesn't exist" errors

Run the SQL schema in your Supabase SQL Editor as described in Step 3.4.

### Build errors

Try these commands:

```bash
flutter clean
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
```

### Audio not playing

1. Verify audio files exist in `assets/audio/`
2. Check `pubspec.yaml` has the audio assets listed
3. Run `flutter pub get` after adding assets

## Platform-Specific Setup

### Android

- Minimum SDK: API 21 (Android 5.0)
- Permissions are already configured in the template

### iOS

- Minimum iOS version: 12.0
- Permissions for vibration are already configured

### Web

- Audio might have autoplay restrictions
- Vibration API not available on web

## Next Steps

- Customize the app theme in `lib/core/theme/app_theme.dart`
- Add more quick start presets
- Implement workout history screen
- Add user profile and settings
- Deploy to app stores

## Support

For issues or questions, please create an issue in the GitHub repository.
