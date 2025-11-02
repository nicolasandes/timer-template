import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vibration/vibration.dart';

import '../../../core/constants/timer_state.dart';
import '../../../models/timer_state_model.dart';
import '../../../models/workout_preset.dart';
import '../../../providers/service_providers.dart';

class TimerController extends StateNotifier<TimerStateModel> {
  TimerController(this._ref) : super(TimerStateModel.initial());

  final Ref _ref;
  Timer? _timer;

  /// Start the timer with a preset
  void startWithPreset(WorkoutPreset preset) {
    state = TimerStateModel.fromPreset(preset);
    start();
  }

  /// Start the timer
  void start() {
    if (state.status == TimerStatus.running) return;

    state = state.copyWith(status: TimerStatus.running);

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      _tick();
    });

    // Play start beep
    _playStartBeep();
    _vibrate();
  }

  /// Pause the timer
  void pause() {
    if (state.status != TimerStatus.running) return;

    _timer?.cancel();
    state = state.copyWith(status: TimerStatus.paused);
  }

  /// Resume the timer
  void resume() {
    if (state.status != TimerStatus.paused) return;
    start();
  }

  /// Reset the timer
  void reset() {
    _timer?.cancel();
    if (state.preset != null) {
      state = TimerStateModel.fromPreset(state.preset!);
    } else {
      state = TimerStateModel.initial();
    }
  }

  /// Stop the timer completely
  void stop() {
    _timer?.cancel();
    state = TimerStateModel.initial();
  }

  /// Timer tick logic
  void _tick() {
    if (state.remainingSeconds > 0) {
      // Countdown
      final newRemaining = state.remainingSeconds - 1;

      // Play beep on last 3 seconds
      if (newRemaining <= 3 && newRemaining > 0) {
        _playCountdownBeep();
        _vibrate();
      }

      state = state.copyWith(remainingSeconds: newRemaining);
    } else {
      // Time's up - switch phase or round
      _handlePhaseComplete();
    }
  }

  /// Handle phase completion
  void _handlePhaseComplete() {
    final preset = state.preset;
    if (preset == null) return;

    if (state.phase == IntervalPhase.work) {
      // Work phase complete, switch to rest
      state = state.copyWith(
        phase: IntervalPhase.rest,
        remainingSeconds: preset.restDuration,
        totalSeconds: preset.restDuration,
      );
      _playStartBeep();
      _vibrate();
    } else {
      // Rest phase complete, check if more rounds
      if (state.currentRound < state.totalRounds) {
        // Start next round
        state = state.copyWith(
          phase: IntervalPhase.work,
          currentRound: state.currentRound + 1,
          remainingSeconds: preset.workDuration,
          totalSeconds: preset.workDuration,
        );
        _playStartBeep();
        _vibrate();
      } else {
        // Workout complete!
        _timer?.cancel();
        state = state.copyWith(status: TimerStatus.completed);
        _playEndBeep();
        _vibrate(duration: 500);
      }
    }
  }

  /// Play countdown beep
  void _playCountdownBeep() {
    final audioService = _ref.read(audioServiceProvider);
    audioService.playCountdownBeep();
  }

  /// Play start beep
  void _playStartBeep() {
    final audioService = _ref.read(audioServiceProvider);
    audioService.playStartBeep();
  }

  /// Play end beep
  void _playEndBeep() {
    final audioService = _ref.read(audioServiceProvider);
    audioService.playEndBeep();
  }

  /// Vibrate device
  Future<void> _vibrate({int duration = 200}) async {
    try {
      final hasVibrator = await Vibration.hasVibrator();
      if (hasVibrator == true) {
        await Vibration.vibrate(duration: duration);
      }
    } catch (e) {
      // Vibration not supported, ignore
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

// Timer Controller Provider
final timerControllerProvider =
    StateNotifierProvider<TimerController, TimerStateModel>((ref) {
  return TimerController(ref);
});
