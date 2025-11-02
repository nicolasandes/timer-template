class TimeFormatter {
  /// Formats seconds into MM:SS format
  static String formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  /// Formats seconds into HH:MM:SS format
  static String formatTimeWithHours(int seconds) {
    final hours = seconds ~/ 3600;
    final minutes = (seconds % 3600) ~/ 60;
    final remainingSeconds = seconds % 60;

    if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
    }
    return formatTime(seconds);
  }

  /// Converts MM:SS string to seconds
  static int parseTime(String timeString) {
    final parts = timeString.split(':');
    if (parts.length != 2) return 0;

    final minutes = int.tryParse(parts[0]) ?? 0;
    final seconds = int.tryParse(parts[1]) ?? 0;

    return (minutes * 60) + seconds;
  }

  // Prevent instantiation
  TimeFormatter._();
}
