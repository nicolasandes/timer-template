import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_constants.dart';
import '../../../models/workout_preset.dart';
import '../../presets/screens/presets_screen.dart';
import '../providers/timer_controller.dart';
import '../widgets/timer_display.dart';
import '../widgets/timer_controls.dart';
import '../widgets/quick_start_card.dart';

class TimerHomeScreen extends ConsumerWidget {
  const TimerHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timerState = ref.watch(timerControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Interval Timer'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // TODO: Navigate to settings
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: timerState.preset != null
                  ? _buildTimerView(context, ref)
                  : _buildQuickStartView(context, ref),
            ),
          ],
        ),
      ),
      floatingActionButton: timerState.preset == null
          ? FloatingActionButton.extended(
              onPressed: () => _navigateToPresets(context, ref),
              icon: const Icon(Icons.list),
              label: const Text('My Presets'),
            )
          : null,
    );
  }

  Widget _buildTimerView(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        Expanded(
          child: Center(
            child: TimerDisplay(),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(24.0),
          child: TimerControls(),
        ),
      ],
    );
  }

  Widget _buildQuickStartView(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 16),
          Text(
            'Quick Start',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Choose a preset or create your own custom workout',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey,
                ),
          ),
          const SizedBox(height: 24),
          _buildQuickStartPresets(context, ref),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => _navigateToPresets(context, ref),
            icon: const Icon(Icons.add),
            label: const Text('Create Custom Workout'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStartPresets(BuildContext context, WidgetRef ref) {
    final quickPresets = [
      WorkoutPreset.create(
        name: 'Jump Rope Beginner',
        workDuration: 60,
        restDuration: 60,
        rounds: 10,
      ),
      WorkoutPreset.create(
        name: 'HIIT Classic',
        workDuration: 45,
        restDuration: 15,
        rounds: 8,
      ),
      WorkoutPreset.create(
        name: 'Tabata',
        workDuration: 20,
        restDuration: 10,
        rounds: 8,
      ),
      WorkoutPreset.create(
        name: 'Boxing Rounds',
        workDuration: 180,
        restDuration: 60,
        rounds: 5,
      ),
    ];

    return Column(
      children: quickPresets
          .map((preset) => Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: QuickStartCard(
                  preset: preset,
                  onTap: () => _startWorkout(ref, preset),
                ),
              ))
          .toList(),
    );
  }

  void _startWorkout(WidgetRef ref, WorkoutPreset preset) {
    ref.read(timerControllerProvider.notifier).startWithPreset(preset);
  }

  void _navigateToPresets(BuildContext context, WidgetRef ref) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const PresetsScreen(),
      ),
    );
  }
}
