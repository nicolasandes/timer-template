import 'package:flutter/material.dart';
import '../../../core/utils/time_formatter.dart';
import '../../../models/workout_preset.dart';

class QuickStartCard extends StatelessWidget {
  final WorkoutPreset preset;
  final VoidCallback onTap;

  const QuickStartCard({
    super.key,
    required this.preset,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              // Icon
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.timer,
                  color: Theme.of(context).colorScheme.primary,
                  size: 32,
                ),
              ),
              const SizedBox(width: 16),

              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      preset.name,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${preset.rounds} rounds • ${TimeFormatter.formatTime(preset.workDuration)} work / ${TimeFormatter.formatTime(preset.restDuration)} rest',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Total: ${TimeFormatter.formatTimeWithHours(preset.totalDuration)}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ],
                ),
              ),

              // Arrow
              Icon(
                Icons.play_circle_outline,
                color: Theme.of(context).colorScheme.primary,
                size: 32,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
