-- Supabase Database Schema for Interval Timer App
-- Run these commands in your Supabase SQL Editor

-- ==================== Enable Row Level Security ====================
-- This ensures users can only access their own data

-- ==================== Workout Presets Table ====================
CREATE TABLE IF NOT EXISTS workout_presets (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL,
  name TEXT NOT NULL,
  work_duration INTEGER NOT NULL CHECK (work_duration >= 5 AND work_duration <= 3600),
  rest_duration INTEGER NOT NULL CHECK (rest_duration >= 5 AND rest_duration <= 3600),
  rounds INTEGER NOT NULL CHECK (rounds >= 1 AND rounds <= 100),
  created_at TIMESTAMPTZ DEFAULT NOW() NOT NULL
);

-- Enable Row Level Security
ALTER TABLE workout_presets ENABLE ROW LEVEL SECURITY;

-- Policies for workout_presets
CREATE POLICY "Users can view their own presets"
  ON workout_presets FOR SELECT
  USING (auth.uid() = user_id);

CREATE POLICY "Users can insert their own presets"
  ON workout_presets FOR INSERT
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update their own presets"
  ON workout_presets FOR UPDATE
  USING (auth.uid() = user_id);

CREATE POLICY "Users can delete their own presets"
  ON workout_presets FOR DELETE
  USING (auth.uid() = user_id);

-- Index for faster queries
CREATE INDEX idx_workout_presets_user_id ON workout_presets(user_id);
CREATE INDEX idx_workout_presets_created_at ON workout_presets(created_at DESC);

-- ==================== Workout History Table ====================
CREATE TABLE IF NOT EXISTS workout_history (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL,
  preset_id UUID REFERENCES workout_presets(id) ON DELETE SET NULL,
  preset_name TEXT,
  completed_rounds INTEGER NOT NULL CHECK (completed_rounds >= 0),
  total_duration INTEGER NOT NULL CHECK (total_duration >= 0),
  completed_at TIMESTAMPTZ DEFAULT NOW() NOT NULL
);

-- Enable Row Level Security
ALTER TABLE workout_history ENABLE ROW LEVEL SECURITY;

-- Policies for workout_history
CREATE POLICY "Users can view their own history"
  ON workout_history FOR SELECT
  USING (auth.uid() = user_id);

CREATE POLICY "Users can insert their own history"
  ON workout_history FOR INSERT
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can delete their own history"
  ON workout_history FOR DELETE
  USING (auth.uid() = user_id);

-- Index for faster queries
CREATE INDEX idx_workout_history_user_id ON workout_history(user_id);
CREATE INDEX idx_workout_history_completed_at ON workout_history(completed_at DESC);
CREATE INDEX idx_workout_history_preset_id ON workout_history(preset_id);

-- ==================== Functions ====================

-- Function to get user statistics
CREATE OR REPLACE FUNCTION get_user_statistics(p_user_id UUID)
RETURNS JSON AS $$
DECLARE
  v_stats JSON;
BEGIN
  SELECT json_build_object(
    'total_workouts', COUNT(*),
    'total_duration', COALESCE(SUM(total_duration), 0),
    'total_rounds', COALESCE(SUM(completed_rounds), 0),
    'average_duration', COALESCE(AVG(total_duration)::INTEGER, 0),
    'this_week', (
      SELECT COUNT(*)
      FROM workout_history
      WHERE user_id = p_user_id
        AND completed_at >= DATE_TRUNC('week', NOW())
    ),
    'this_month', (
      SELECT COUNT(*)
      FROM workout_history
      WHERE user_id = p_user_id
        AND completed_at >= DATE_TRUNC('month', NOW())
    )
  )
  INTO v_stats
  FROM workout_history
  WHERE user_id = p_user_id;

  RETURN v_stats;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- ==================== Sample Data (Optional) ====================
-- Uncomment to insert sample presets for testing

-- INSERT INTO workout_presets (user_id, name, work_duration, rest_duration, rounds)
-- VALUES
--   (auth.uid(), 'Jump Rope Beginner', 60, 60, 10),
--   (auth.uid(), 'HIIT Classic', 45, 15, 8),
--   (auth.uid(), 'Tabata', 20, 10, 8),
--   (auth.uid(), 'Boxing Rounds', 180, 60, 5);
