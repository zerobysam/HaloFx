import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import 'candlestick_painter.dart';

class RocketIllustration extends StatelessWidget {
  const RocketIllustration({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 220,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background candlesticks
          Positioned.fill(
            child: CustomPaint(painter: const CandlestickPainter()),
          ),

          // Soft glow behind rocket
          Container(
            width: 160,
            height: 160,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  AppColors.primary.withOpacity(0.35),
                  AppColors.primary.withOpacity(0.0),
                ],
              ),
            ),
          ),

          // Rocket
          ShaderMask(
            shaderCallback: (bounds) => LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white,
                AppColors.primaryLight,
                AppColors.primary,
              ],
            ).createShader(bounds),
            child: const Icon(
              Icons.rocket_launch_rounded,
              size: 96,
              color: Colors.white,
            ),
          ),

          // A few sparkle accents
          const Positioned(top: 20, left: 70, child: _Sparkle(size: 6)),
          const Positioned(top: 45, right: 60, child: _Sparkle(size: 4)),
          const Positioned(bottom: 55, left: 50, child: _Sparkle(size: 5)),
        ],
      ),
    );
  }
}

class _Sparkle extends StatelessWidget {
  final double size;
  const _Sparkle({required this.size});

  @override
  Widget build(BuildContext context) {
    return Icon(
      Icons.auto_awesome,
      size: size * 2.2,
      color: AppColors.primaryLight.withOpacity(0.8),
    );
  }
}
