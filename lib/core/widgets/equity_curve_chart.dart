import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

class EquityCurveChart extends StatelessWidget {
  final List<double> data;
  final List<String> dateLabels;
  final Color lineColor;

  const EquityCurveChart({
    super.key,
    required this.data,
    required this.dateLabels,
    this.lineColor = AppColors.primaryLight,
  });

  @override
  Widget build(BuildContext context) {
    final minV = data.reduce((a, b) => a < b ? a : b);
    final maxV = data.reduce((a, b) => a > b ? a : b);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        IntrinsicHeight(
          child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text('\$${(maxV / 1000).toStringAsFixed(0)}K', style: AppTypography.caption),
                const Spacer(),
                Text('\$${((maxV + minV) / 2 / 1000).toStringAsFixed(0)}K', style: AppTypography.caption),
                const Spacer(),
                Text('\$${(minV / 1000).toStringAsFixed(0)}K', style: AppTypography.caption),
              ],
            ),
            const SizedBox(width: 8),
            Expanded(
              child: SizedBox(
                height: 160,
                child: CustomPaint(
                  painter: _EquityCurvePainter(data: data, lineColor: lineColor),
                  child: Container(),
                ),
              ),
            ),
          ],
          ),
        ),
        const SizedBox(height: 6),
        Padding(
          padding: const EdgeInsets.only(left: 34),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: dateLabels.map((d) => Text(d, style: AppTypography.caption)).toList(),
          ),
        ),
      ],
    );
  }
}

class _EquityCurvePainter extends CustomPainter {
  final List<double> data;
  final Color lineColor;

  _EquityCurvePainter({required this.data, required this.lineColor});

  @override
  void paint(Canvas canvas, Size size) {
    if (data.length < 2) return;
    final minV = data.reduce((a, b) => a < b ? a : b);
    final maxV = data.reduce((a, b) => a > b ? a : b);
    final range = (maxV - minV) == 0 ? 1 : (maxV - minV);

    final points = <Offset>[];
    for (int i = 0; i < data.length; i++) {
      final x = size.width * (i / (data.length - 1));
      final y = size.height - ((data[i] - minV) / range) * size.height;
      points.add(Offset(x, y));
    }

    // Gridlines
    final gridPaint = Paint()
      ..color = AppColors.divider
      ..strokeWidth = 1;
    for (int i = 0; i <= 2; i++) {
      final y = size.height * (i / 2);
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    // Line path
    final linePath = Path()..moveTo(points.first.dx, points.first.dy);
    for (final p in points.skip(1)) {
      linePath.lineTo(p.dx, p.dy);
    }

    // Gradient fill under the line
    final fillPath = Path.from(linePath)
      ..lineTo(points.last.dx, size.height)
      ..lineTo(points.first.dx, size.height)
      ..close();

    final fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [lineColor.withOpacity(0.35), lineColor.withOpacity(0.0)],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    canvas.drawPath(fillPath, fillPaint);

    final linePaint = Paint()
      ..color = lineColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    canvas.drawPath(linePath, linePaint);

    // End-point dot
    canvas.drawCircle(points.last, 4, Paint()..color = lineColor);
    canvas.drawCircle(points.last, 4, Paint()
      ..color = lineColor.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6);
  }

  @override
  bool shouldRepaint(covariant _EquityCurvePainter oldDelegate) => oldDelegate.data != data;
}
