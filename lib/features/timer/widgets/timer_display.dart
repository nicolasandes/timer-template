import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:math' as math;

import '../../../core/constants/timer_state.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/time_formatter.dart';
import '../providers/timer_controller.dart';

class TimerDisplay extends ConsumerWidget {
  const TimerDisplay({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timerState = ref.watch(timerControllerProvider);
    final size = MediaQuery.of(context).size.width * 0.7;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Preset name
        if (timerState.preset != null)
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              timerState.preset!.name,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
              textAlign: TextAlign.center,
            ),
          ),

        // Round counter
        Text(
          'Round ${timerState.currentRound} / ${timerState.totalRounds}',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Colors.grey,
              ),
        ),
        const SizedBox(height: 32),

        // Circular timer
        SizedBox(
          width: size,
          height: size,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Background circle
              CustomPaint(
                size: Size(size, size),
                painter: _CirclePainter(
                  progress: 1.0,
                  color: Colors.grey.withOpacity(0.2),
                  strokeWidth: 12,
                ),
              ),

              // Progress circle
              CustomPaint(
                size: Size(size, size),
                painter: _CirclePainter(
                  progress: timerState.progress,
                  color: timerState.phase == IntervalPhase.work
                      ? AppTheme.workColor
                      : AppTheme.restColor,
                  strokeWidth: 12,
                ),
              ),

              // Center content
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Phase label
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                    decoration: BoxDecoration(
                      color: (timerState.phase == IntervalPhase.work
                              ? AppTheme.workColor
                              : AppTheme.restColor)
                          .withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      timerState.phase == IntervalPhase.work ? 'WORK' : 'REST',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: timerState.phase == IntervalPhase.work
                                ? AppTheme.workColor
                                : AppTheme.restColor,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2,
                          ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Time remaining
                  Text(
                    TimeFormatter.formatTime(timerState.remainingSeconds),
                    style: Theme.of(context).textTheme.displayLarge?.copyWith(
                          fontSize: 72,
                          fontWeight: FontWeight.bold,
                          fontFeatures: [
                            const FontFeature.tabularFigures(),
                          ],
                        ),
                  ),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 48),

        // Status message
        if (timerState.isCompleted)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '🎉 Workout Complete!',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppTheme.primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
      ],
    );
  }
}

class _CirclePainter extends CustomPainter {
  final double progress;
  final Color color;
  final double strokeWidth;

  _CirclePainter({
    required this.progress,
    required this.color,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    const startAngle = -math.pi / 2; // Start from top
    final sweepAngle = 2 * math.pi * progress;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(_CirclePainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.color != color;
  }
}
