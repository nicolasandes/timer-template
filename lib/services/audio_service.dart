import 'package:just_audio/just_audio.dart';
import '../core/constants/app_constants.dart';

class AudioService {
  final AudioPlayer _player = AudioPlayer();
  bool _isEnabled = true;

  bool get isEnabled => _isEnabled;

  /// Enable/disable audio
  void setEnabled(bool enabled) {
    _isEnabled = enabled;
  }

  /// Play countdown beep (for last few seconds)
  Future<void> playCountdownBeep() async {
    if (!_isEnabled) return;

    try {
      await _player.setAsset(AppConstants.countdownBeepPath);
      await _player.play();
    } catch (e) {
      // Audio file might not exist yet, ignore error
      // In production, you'd have actual audio files
    }
  }

  /// Play start beep (beginning of work interval)
  Future<void> playStartBeep() async {
    if (!_isEnabled) return;

    try {
      await _player.setAsset(AppConstants.startBeepPath);
      await _player.play();
    } catch (e) {
      // Audio file might not exist yet, ignore error
    }
  }

  /// Play end beep (workout completed)
  Future<void> playEndBeep() async {
    if (!_isEnabled) return;

    try {
      await _player.setAsset(AppConstants.endBeepPath);
      await _player.play();
    } catch (e) {
      // Audio file might not exist yet, ignore error
    }
  }

  /// Dispose audio player
  void dispose() {
    _player.dispose();
  }
}
