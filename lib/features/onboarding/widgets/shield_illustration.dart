import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class ShieldIllustration extends StatelessWidget {
  const ShieldIllustration({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 220,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Glow behind shield
          Container(
            width: 150,
            height: 150,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  AppColors.primary.withOpacity(0.30),
                  AppColors.primary.withOpacity(0.0),
                ],
              ),
            ),
          ),

          // Shield
          Positioned(
            left: 40,
            child: ShaderMask(
              shaderCallback: (bounds) => LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.white, AppColors.primaryLight, AppColors.primary],
              ).createShader(bounds),
              child: const Icon(
                Icons.shield_rounded,
                size: 92,
                color: Colors.white,
              ),
            ),
          ),
          Positioned(
            left: 62,
            top: 78,
            child: Icon(
              Icons.show_chart_rounded,
              size: 32,
              color: AppColors.bgPrimary,
            ),
          ),

          // Floating card 1 — headset / support-style stat card
          Positioned(
            top: 24,
            right: 20,
            child: _FloatingCard(
              width: 90,
              height: 46,
              child: Row(
                children: [
                  Icon(Icons.headset_mic_rounded, size: 16, color: AppColors.primaryLight),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(height: 4, width: 30, color: AppColors.textTertiary.withOpacity(0.5)),
                        const SizedBox(height: 4),
                        Container(height: 4, width: 20, color: AppColors.textTertiary.withOpacity(0.3)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Floating card 2 — growth chart card
          Positioned(
            bottom: 30,
            right: 10,
            child: _FloatingCard(
              width: 110,
              height: 60,
              child: Row(
                children: [
                  Icon(Icons.bar_chart_rounded, size: 20, color: AppColors.success),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(height: 4, width: 50, color: AppColors.textTertiary.withOpacity(0.5)),
                        const SizedBox(height: 5),
                        Container(height: 4, width: 34, color: AppColors.textTertiary.withOpacity(0.3)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          const Positioned(top: 12, left: 30, child: _Sparkle(size: 5)),
          const Positioned(bottom: 60, left: 20, child: _Sparkle(size: 4)),
        ],
      ),
    );
  }
}

class _FloatingCard extends StatelessWidget {
  final double width;
  final double height;
  final Widget child;

  const _FloatingCard({required this.width, required this.height, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.bgElevated,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.35),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: child,
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
