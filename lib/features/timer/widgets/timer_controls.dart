import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/timer_state.dart';
import '../providers/timer_controller.dart';

class TimerControls extends ConsumerWidget {
  const TimerControls({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timerState = ref.watch(timerControllerProvider);
    final controller = ref.read(timerControllerProvider.notifier);

    if (timerState.isCompleted) {
      return _buildCompletedControls(context, controller);
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // Reset button
        _ControlButton(
          icon: Icons.refresh,
          label: 'Reset',
          onPressed: () => controller.reset(),
          color: Colors.grey,
        ),

        // Play/Pause button
        _ControlButton(
          icon: timerState.isActive ? Icons.pause : Icons.play_arrow,
          label: timerState.isActive ? 'Pause' : 'Start',
          onPressed: () {
            if (timerState.isActive) {
              controller.pause();
            } else if (timerState.isPaused) {
              controller.resume();
            } else {
              controller.start();
            }
          },
          isPrimary: true,
          size: 80,
        ),

        // Stop button
        _ControlButton(
          icon: Icons.stop,
          label: 'Stop',
          onPressed: () => _showStopConfirmation(context, controller),
          color: Colors.red,
        ),
      ],
    );
  }

  Widget _buildCompletedControls(
      BuildContext context, TimerController controller) {
    return Column(
      children: [
        ElevatedButton.icon(
          onPressed: () => controller.reset(),
          icon: const Icon(Icons.replay),
          label: const Text('Start Again'),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 20),
          ),
        ),
        const SizedBox(height: 16),
        TextButton.icon(
          onPressed: () => controller.stop(),
          icon: const Icon(Icons.home),
          label: const Text('Back to Home'),
        ),
      ],
    );
  }

  void _showStopConfirmation(BuildContext context, TimerController controller) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Stop Workout?'),
        content: const Text(
          'Are you sure you want to stop the workout? Your progress will not be saved.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              controller.stop();
              Navigator.pop(context);
            },
            child: const Text(
              'Stop',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}

class _ControlButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;
  final bool isPrimary;
  final Color? color;
  final double size;

  const _ControlButton({
    required this.icon,
    required this.label,
    required this.onPressed,
    this.isPrimary = false,
    this.color,
    this.size = 64,
  });

  @override
  Widget build(BuildContext context) {
    final buttonColor = color ?? Theme.of(context).colorScheme.primary;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Material(
          color: isPrimary ? buttonColor : buttonColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(size / 2),
          child: InkWell(
            onTap: onPressed,
            borderRadius: BorderRadius.circular(size / 2),
            child: Container(
              width: size,
              height: size,
              alignment: Alignment.center,
              child: Icon(
                icon,
                size: size * 0.5,
                color: isPrimary ? Colors.white : buttonColor,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: Colors.grey,
              ),
        ),
      ],
    );
  }
}
