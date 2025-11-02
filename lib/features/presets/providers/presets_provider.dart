import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../models/workout_preset.dart';
import '../../../providers/service_providers.dart';

// Presets Provider (combining local and cloud)
final presetsProvider = FutureProvider<List<WorkoutPreset>>((ref) async {
  final supabase = ref.watch(supabaseServiceProvider);
  final storage = ref.watch(storageServiceProvider);

  // Get local presets
  final localPresets = storage.getLocalPresets();

  // Try to get cloud presets if authenticated
  if (supabase.isAuthenticated) {
    try {
      final cloudPresets = await supabase.fetchPresets();
      // Combine and deduplicate (cloud presets take precedence)
      final allPresets = [...cloudPresets, ...localPresets];
      final uniquePresets = <String, WorkoutPreset>{};
      for (final preset in allPresets) {
        uniquePresets[preset.id] = preset;
      }
      return uniquePresets.values.toList();
    } catch (e) {
      // If cloud fetch fails, return local presets
      return localPresets;
    }
  }

  return localPresets;
});

// Presets Controller for CRUD operations
class PresetsController extends StateNotifier<AsyncValue<List<WorkoutPreset>>> {
  PresetsController(this._ref) : super(const AsyncValue.loading()) {
    loadPresets();
  }

  final Ref _ref;

  /// Load all presets
  Future<void> loadPresets() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final supabase = _ref.read(supabaseServiceProvider);
      final storage = _ref.read(storageServiceProvider);

      final localPresets = storage.getLocalPresets();

      if (supabase.isAuthenticated) {
        try {
          final cloudPresets = await supabase.fetchPresets();
          final allPresets = [...cloudPresets, ...localPresets];
          final uniquePresets = <String, WorkoutPreset>{};
          for (final preset in allPresets) {
            uniquePresets[preset.id] = preset;
          }
          return uniquePresets.values.toList();
        } catch (e) {
          return localPresets;
        }
      }

      return localPresets;
    });
  }

  /// Create a new preset
  Future<void> createPreset(WorkoutPreset preset) async {
    final supabase = _ref.read(supabaseServiceProvider);
    final storage = _ref.read(storageServiceProvider);

    // Save to cloud if authenticated
    if (supabase.isAuthenticated) {
      try {
        await supabase.createPreset(preset);
      } catch (e) {
        // If cloud save fails, save locally
        await storage.saveLocalPreset(preset);
      }
    } else {
      // Save locally if not authenticated
      await storage.saveLocalPreset(preset);
    }

    await loadPresets();
  }

  /// Update a preset
  Future<void> updatePreset(WorkoutPreset preset) async {
    final supabase = _ref.read(supabaseServiceProvider);
    final storage = _ref.read(storageServiceProvider);

    if (supabase.isAuthenticated && preset.userId != null) {
      try {
        await supabase.updatePreset(preset);
      } catch (e) {
        await storage.saveLocalPreset(preset);
      }
    } else {
      await storage.saveLocalPreset(preset);
    }

    await loadPresets();
  }

  /// Delete a preset
  Future<void> deletePreset(String presetId) async {
    final supabase = _ref.read(supabaseServiceProvider);
    final storage = _ref.read(storageServiceProvider);

    if (supabase.isAuthenticated) {
      try {
        await supabase.deletePreset(presetId);
      } catch (e) {
        // Also try to delete locally
        await storage.deleteLocalPreset(presetId);
      }
    }

    await storage.deleteLocalPreset(presetId);
    await loadPresets();
  }
}

final presetsControllerProvider =
    StateNotifierProvider<PresetsController, AsyncValue<List<WorkoutPreset>>>(
        (ref) {
  return PresetsController(ref);
});
