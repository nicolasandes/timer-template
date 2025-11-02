import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/audio_service.dart';
import '../services/storage_service.dart';
import '../services/supabase_service.dart';

// Audio Service Provider
final audioServiceProvider = Provider<AudioService>((ref) {
  final service = AudioService();
  ref.onDispose(() => service.dispose());
  return service;
});

// Storage Service Provider
final storageServiceProvider = Provider<StorageService>((ref) {
  return StorageService();
});

// Supabase Service Provider
final supabaseServiceProvider = Provider<SupabaseService>((ref) {
  return SupabaseService();
});

// Auth State Provider
final authStateProvider = StreamProvider((ref) {
  final supabase = ref.watch(supabaseServiceProvider);
  return supabase.authStateChanges;
});

// Current User Provider
final currentUserProvider = Provider((ref) {
  final supabase = ref.watch(supabaseServiceProvider);
  return supabase.currentUser;
});

// Is Authenticated Provider
final isAuthenticatedProvider = Provider<bool>((ref) {
  final user = ref.watch(currentUserProvider);
  return user != null;
});
