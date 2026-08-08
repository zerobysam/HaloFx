import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

/// Paints a row of simple candlestick bars used as background
/// decoration behind the rocket illustration on the onboarding screen.
class CandlestickPainter extends CustomPainter {
  const CandlestickPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final barPaint = Paint()
      ..color = AppColors.primary.withOpacity(0.55)
      ..style = PaintingStyle.fill;

    final wickPaint = Paint()
      ..color = AppColors.primary.withOpacity(0.35)
      ..strokeWidth = 2;

    // Relative candle definitions: [xFraction, bodyTopFraction, bodyBottomFraction, wickTopFraction, wickBottomFraction]
    final candles = [
      [0.06, 0.55, 0.75, 0.45, 0.85],
      [0.22, 0.35, 0.60, 0.25, 0.70],
      [0.78, 0.30, 0.50, 0.18, 0.62],
      [0.92, 0.50, 0.80, 0.40, 0.90],
    ];

    const bodyWidth = 10.0;

    for (final c in candles) {
      final x = size.width * c[0];
      final top = size.height * c[1];
      final bottom = size.height * c[2];
      final wickTop = size.height * c[3];
      final wickBottom = size.height * c[4];

      canvas.drawLine(Offset(x, wickTop), Offset(x, wickBottom), wickPaint);
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTRB(x - bodyWidth / 2, top, x + bodyWidth / 2, bottom),
          const Radius.circular(2),
        ),
        barPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
