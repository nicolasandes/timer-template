/// Supabase Configuration
///
/// IMPORTANT: Replace these values with your actual Supabase project credentials
/// from https://supabase.com/dashboard/project/_/settings/api
///
/// For security, you can create a local file 'supabase_config.local.dart'
/// (which is gitignored) with your actual credentials.

class SupabaseConfig {
  static const String supabaseUrl = 'YOUR_SUPABASE_URL';
  static const String supabaseAnonKey = 'YOUR_SUPABASE_ANON_KEY';

  // Prevent instantiation
  SupabaseConfig._();
}
