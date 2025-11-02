import 'package:equatable/equatable.dart';
import '../core/constants/timer_state.dart';
import 'workout_preset.dart';

class TimerStateModel extends Equatable {
  final TimerStatus status;
  final IntervalPhase phase;
  final int currentRound;
  final int totalRounds;
  final int remainingSeconds;
  final int totalSeconds;
  final WorkoutPreset? preset;

  const TimerStateModel({
    required this.status,
    required this.phase,
    required this.currentRound,
    required this.totalRounds,
    required this.remainingSeconds,
    required this.totalSeconds,
    this.preset,
  });

  /// Initial state
  factory TimerStateModel.initial() {
    return const TimerStateModel(
      status: TimerStatus.initial,
      phase: IntervalPhase.work,
      currentRound: 0,
      totalRounds: 0,
      remainingSeconds: 0,
      totalSeconds: 0,
    );
  }

  /// Create from preset
  factory TimerStateModel.fromPreset(WorkoutPreset preset) {
    return TimerStateModel(
      status: TimerStatus.initial,
      phase: IntervalPhase.work,
      currentRound: 1,
      totalRounds: preset.rounds,
      remainingSeconds: preset.workDuration,
      totalSeconds: preset.workDuration,
      preset: preset,
    );
  }

  /// Check if timer is active
  bool get isActive => status == TimerStatus.running;

  /// Check if timer is paused
  bool get isPaused => status == TimerStatus.paused;

  /// Check if timer is completed
  bool get isCompleted => status == TimerStatus.completed;

  /// Get progress percentage (0.0 to 1.0)
  double get progress {
    if (totalSeconds == 0) return 0.0;
    return (totalSeconds - remainingSeconds) / totalSeconds;
  }

  /// Copy with method
  TimerStateModel copyWith({
    TimerStatus? status,
    IntervalPhase? phase,
    int? currentRound,
    int? totalRounds,
    int? remainingSeconds,
    int? totalSeconds,
    WorkoutPreset? preset,
  }) {
    return TimerStateModel(
      status: status ?? this.status,
      phase: phase ?? this.phase,
      currentRound: currentRound ?? this.currentRound,
      totalRounds: totalRounds ?? this.totalRounds,
      remainingSeconds: remainingSeconds ?? this.remainingSeconds,
      totalSeconds: totalSeconds ?? this.totalSeconds,
      preset: preset ?? this.preset,
    );
  }

  @override
  List<Object?> get props => [
        status,
        phase,
        currentRound,
        totalRounds,
        remainingSeconds,
        totalSeconds,
        preset,
      ];
}
