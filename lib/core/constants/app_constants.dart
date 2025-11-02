class AppConstants {
  // Timer Defaults
  static const int defaultWorkDuration = 60; // seconds
  static const int defaultRestDuration = 60; // seconds
  static const int defaultRounds = 10;
  static const int minDuration = 5; // seconds
  static const int maxDuration = 3600; // 1 hour
  static const int minRounds = 1;
  static const int maxRounds = 100;

  // Audio
  static const String countdownBeepPath = 'assets/audio/beep.mp3';
  static const String startBeepPath = 'assets/audio/start.mp3';
  static const String endBeepPath = 'assets/audio/end.mp3';

  // Database
  static const String workoutPresetsTable = 'workout_presets';
  static const String workoutHistoryTable = 'workout_history';

  // Local Storage
  static const String localPresetsBox = 'local_presets';
  static const String settingsBox = 'settings';

  // Settings Keys
  static const String soundEnabledKey = 'sound_enabled';
  static const String vibrationEnabledKey = 'vibration_enabled';
  static const String keepScreenOnKey = 'keep_screen_on';

  // Prevent instantiation
  AppConstants._();
}
