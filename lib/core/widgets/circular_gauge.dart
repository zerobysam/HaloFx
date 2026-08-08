import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class CircularGauge extends StatelessWidget {
  final double progress; // 0..1
  final double size;
  final double strokeWidth;
  final Color color;
  final Widget? center;

  const CircularGauge({
    super.key,
    required this.progress,
    this.size = 40,
    this.strokeWidth = 5,
    this.color = AppColors.success,
    this.center,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: Size(size, size),
            painter: _GaugePainter(progress: progress.clamp(0, 1), color: color, strokeWidth: strokeWidth),
          ),
          if (center != null) center!,
        ],
      ),
    );
  }
}

class _GaugePainter extends CustomPainter {
  final double progress;
  final Color color;
  final double strokeWidth;

  _GaugePainter({required this.progress, required this.color, required this.strokeWidth});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    final bgPaint = Paint()
      ..color = AppColors.divider
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;
    canvas.drawCircle(center, radius, bgPaint);

    final fgPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    const startAngle = -1.5708; // -90deg
    final sweep = 6.28319 * progress; // 2*pi * progress
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), startAngle, sweep, false, fgPaint);
  }

  @override
  bool shouldRepaint(covariant _GaugePainter oldDelegate) =>
      oldDelegate.progress != progress || oldDelegate.color != color;
}
