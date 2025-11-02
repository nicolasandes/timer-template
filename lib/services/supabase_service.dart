import 'package:supabase_flutter/supabase_flutter.dart';
import '../core/constants/app_constants.dart';
import '../models/workout_preset.dart';
import '../models/workout_history.dart';

class SupabaseService {
  final SupabaseClient _client = Supabase.instance.client;

  // Get current user
  User? get currentUser => _client.auth.currentUser;

  // Check if user is authenticated
  bool get isAuthenticated => currentUser != null;

  // Auth stream
  Stream<AuthState> get authStateChanges => _client.auth.onAuthStateChange;

  // ==================== Auth Methods ====================

  /// Sign up with email and password
  Future<AuthResponse> signUp({
    required String email,
    required String password,
  }) async {
    return await _client.auth.signUp(
      email: email,
      password: password,
    );
  }

  /// Sign in with email and password
  Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    return await _client.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  /// Sign out
  Future<void> signOut() async {
    await _client.auth.signOut();
  }

  /// Reset password
  Future<void> resetPassword(String email) async {
    await _client.auth.resetPasswordForEmail(email);
  }

  // ==================== Workout Presets ====================

  /// Fetch all presets for the current user
  Future<List<WorkoutPreset>> fetchPresets() async {
    if (!isAuthenticated) throw Exception('User not authenticated');

    final response = await _client
        .from(AppConstants.workoutPresetsTable)
        .select()
        .eq('user_id', currentUser!.id)
        .order('created_at', ascending: false);

    return (response as List)
        .map((json) => WorkoutPreset.fromJson(json))
        .toList();
  }

  /// Create a new preset
  Future<WorkoutPreset> createPreset(WorkoutPreset preset) async {
    if (!isAuthenticated) throw Exception('User not authenticated');

    final presetWithUserId = preset.copyWith(userId: currentUser!.id);

    final response = await _client
        .from(AppConstants.workoutPresetsTable)
        .insert(presetWithUserId.toJson())
        .select()
        .single();

    return WorkoutPreset.fromJson(response);
  }

  /// Update a preset
  Future<WorkoutPreset> updatePreset(WorkoutPreset preset) async {
    if (!isAuthenticated) throw Exception('User not authenticated');

    final response = await _client
        .from(AppConstants.workoutPresetsTable)
        .update(preset.toJson())
        .eq('id', preset.id)
        .eq('user_id', currentUser!.id)
        .select()
        .single();

    return WorkoutPreset.fromJson(response);
  }

  /// Delete a preset
  Future<void> deletePreset(String presetId) async {
    if (!isAuthenticated) throw Exception('User not authenticated');

    await _client
        .from(AppConstants.workoutPresetsTable)
        .delete()
        .eq('id', presetId)
        .eq('user_id', currentUser!.id);
  }

  // ==================== Workout History ====================

  /// Fetch workout history for the current user
  Future<List<WorkoutHistory>> fetchHistory({int? limit}) async {
    if (!isAuthenticated) throw Exception('User not authenticated');

    var query = _client
        .from(AppConstants.workoutHistoryTable)
        .select()
        .eq('user_id', currentUser!.id)
        .order('completed_at', ascending: false);

    if (limit != null) {
      query = query.limit(limit);
    }

    final response = await query;

    return (response as List)
        .map((json) => WorkoutHistory.fromJson(json))
        .toList();
  }

  /// Save workout history
  Future<WorkoutHistory> saveHistory(WorkoutHistory history) async {
    if (!isAuthenticated) throw Exception('User not authenticated');

    final historyWithUserId = WorkoutHistory(
      id: history.id,
      userId: currentUser!.id,
      presetId: history.presetId,
      presetName: history.presetName,
      completedRounds: history.completedRounds,
      totalDuration: history.totalDuration,
      completedAt: history.completedAt,
    );

    final response = await _client
        .from(AppConstants.workoutHistoryTable)
        .insert(historyWithUserId.toJson())
        .select()
        .single();

    return WorkoutHistory.fromJson(response);
  }

  /// Delete a history entry
  Future<void> deleteHistory(String historyId) async {
    if (!isAuthenticated) throw Exception('User not authenticated');

    await _client
        .from(AppConstants.workoutHistoryTable)
        .delete()
        .eq('id', historyId)
        .eq('user_id', currentUser!.id);
  }

  /// Get workout statistics
  Future<Map<String, dynamic>> getStatistics() async {
    if (!isAuthenticated) throw Exception('User not authenticated');

    final history = await fetchHistory();

    if (history.isEmpty) {
      return {
        'total_workouts': 0,
        'total_duration': 0,
        'total_rounds': 0,
        'average_duration': 0,
      };
    }

    final totalWorkouts = history.length;
    final totalDuration = history.fold<int>(
      0,
      (sum, item) => sum + item.totalDuration,
    );
    final totalRounds = history.fold<int>(
      0,
      (sum, item) => sum + item.completedRounds,
    );

    return {
      'total_workouts': totalWorkouts,
      'total_duration': totalDuration,
      'total_rounds': totalRounds,
      'average_duration': totalDuration ~/ totalWorkouts,
    };
  }
}
