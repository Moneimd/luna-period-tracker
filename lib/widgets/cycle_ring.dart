// lib/widgets/cycle_ring.dart

import 'dart:math';
import 'package:flutter/material.dart';
import '../utils/theme.dart';

class CycleRing extends StatelessWidget {
  final int cycleLength;
  final int currentDay;
  final String phase;
  final bool isActive;

  const CycleRing({
    super.key,
    required this.cycleLength,
    required this.currentDay,
    required this.phase,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    final progress = cycleLength > 0
        ? (currentDay / cycleLength).clamp(0.0, 1.0)
        : 0.0;

    return SizedBox(
      width: 200,
      height: 200,
      child: CustomPaint(
        size: const Size(200, 200),
        painter: _RingPainter(progress: progress, phase: phase),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (isActive)
                const Icon(Icons.water_drop, color: AppTheme.primary, size: 28),
              Text(
                currentDay > 0 ? 'Jour $currentDay' : '--',
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textDark,
                ),
              ),
              Text(
                cycleLength > 0 ? 'sur $cycleLength jours' : 'Aucun cycle',
                style: const TextStyle(
                  fontSize: 12,
                  color: AppTheme.textMedium,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  final double progress;
  final String phase;

  _RingPainter({required this.progress, required this.phase});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 12;
    const strokeWidth = 14.0;

    // Background ring
    final bgPaint = Paint()
      ..color = Colors.grey.shade100
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, bgPaint);

    // Progress ring
    Color ringColor;
    switch (phase) {
      case 'menstrual':
        ringColor = AppTheme.primary;
        break;
      case 'ovulation':
        ringColor = AppTheme.fertile;
        break;
      case 'premenstrual':
        ringColor = Colors.purple;
        break;
      default:
        ringColor = AppTheme.primaryLight;
    }

    if (progress > 0) {
      final progressPaint = Paint()
        ..color = ringColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        -pi / 2,
        2 * pi * progress,
        false,
        progressPaint,
      );
    }
  }

  @override
  bool shouldRepaint(_RingPainter old) =>
      old.progress != progress || old.phase != phase;
}
