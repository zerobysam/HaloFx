import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../models/calculator_access_level.dart';
import '../models/calculator_item.dart';

/// A single calculator card in the grid. [animationDelay] staggers
/// this card's fade+slide entrance relative to its grid position.
class CalculatorGridCard extends StatefulWidget {
  final CalculatorItem item;
  final VoidCallback onTap;
  final Duration animationDelay;

  const CalculatorGridCard({
    super.key,
    required this.item,
    required this.onTap,
    this.animationDelay = Duration.zero,
  });

  @override
  State<CalculatorGridCard> createState() => _CalculatorGridCardState();
}

class _CalculatorGridCardState extends State<CalculatorGridCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;
  double _pressScale = 1.0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 380),
    );
    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _slide = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    Future.delayed(widget.animationDelay, () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fade,
      child: SlideTransition(
        position: _slide,
        child: GestureDetector(
          onTapDown: (_) => setState(() => _pressScale = 0.96),
          onTapUp: (_) => setState(() => _pressScale = 1.0),
          onTapCancel: () => setState(() => _pressScale = 1.0),
          onTap: widget.onTap,
          child: AnimatedScale(
            scale: _pressScale,
            duration: const Duration(milliseconds: 120),
            curve: Curves.easeOut,
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.bgElevated,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                          color: widget.item.iconColor.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          widget.item.icon,
                          color: widget.item.iconColor,
                          size: 70,
                        ),
                      ),
                      if (widget.item.accessLevel != CalculatorAccessLevel.free)
                        Positioned(
                          top: -4,
                          right: -4,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: AppColors.bgSecondary,
                              shape: BoxShape.circle,
                              border: Border.all(color: AppColors.border),
                            ),
                            child: Icon(
                              widget.item.accessLevel == CalculatorAccessLevel.premium
                                  ? Icons.workspace_premium_rounded
                                  : Icons.lock_outline_rounded,
                              size: 12,
                              color: widget.item.accessLevel == CalculatorAccessLevel.premium
                                  ? AppColors.gold
                                  : AppColors.textTertiary,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const Spacer(),
                  Text(
                    widget.item.title,
                    textAlign: TextAlign.center,
                    style: AppTypography.headlineSmall.copyWith(fontSize: 16),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.item.subtitle,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.bodySmall.copyWith(
                      fontSize: 11.5,
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
