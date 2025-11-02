import 'package:hive_flutter/hive_flutter.dart';
import '../core/constants/app_constants.dart';
import '../models/workout_preset.dart';

class StorageService {
  Box<Map>? _presetsBox;
  Box? _settingsBox;

  /// Initialize Hive boxes
  Future<void> init() async {
    _presetsBox = await Hive.openBox<Map>(AppConstants.localPresetsBox);
    _settingsBox = await Hive.openBox(AppConstants.settingsBox);
  }

  // ==================== Settings ====================

  /// Get a setting value
  T? getSetting<T>(String key, {T? defaultValue}) {
    return _settingsBox?.get(key, defaultValue: defaultValue) as T?;
  }

  /// Save a setting value
  Future<void> saveSetting(String key, dynamic value) async {
    await _settingsBox?.put(key, value);
  }

  /// Check if sound is enabled
  bool get isSoundEnabled {
    return getSetting<bool>(
      AppConstants.soundEnabledKey,
      defaultValue: true,
    ) ?? true;
  }

  /// Check if vibration is enabled
  bool get isVibrationEnabled {
    return getSetting<bool>(
      AppConstants.vibrationEnabledKey,
      defaultValue: true,
    ) ?? true;
  }

  /// Check if keep screen on is enabled
  bool get isKeepScreenOn {
    return getSetting<bool>(
      AppConstants.keepScreenOnKey,
      defaultValue: true,
    ) ?? true;
  }

  // ==================== Local Presets ====================

  /// Get all local presets
  List<WorkoutPreset> getLocalPresets() {
    if (_presetsBox == null) return [];

    return _presetsBox!.values
        .map((map) => WorkoutPreset.fromJson(Map<String, dynamic>.from(map)))
        .toList();
  }

  /// Save a local preset
  Future<void> saveLocalPreset(WorkoutPreset preset) async {
    await _presetsBox?.put(preset.id, preset.toJson());
  }

  /// Delete a local preset
  Future<void> deleteLocalPreset(String presetId) async {
    await _presetsBox?.delete(presetId);
  }

  /// Clear all local presets
  Future<void> clearLocalPresets() async {
    await _presetsBox?.clear();
  }

  /// Close all boxes
  Future<void> close() async {
    await _presetsBox?.close();
    await _settingsBox?.close();
  }
}
