/// Represents the current state of the timer
enum TimerStatus {
  initial,
  running,
  paused,
  completed,
}

/// Represents the current phase of the interval
enum IntervalPhase {
  work,
  rest,
  prepare, // Optional countdown before starting
}
