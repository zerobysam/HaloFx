import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/app_gradient_button.dart';
import '../../auth/screens/signup_screen.dart';
import '../../calculators/screens/calculators_hub_screen.dart';
import '../data/onboarding_slides.dart';
import '../widgets/onboarding_slide_content.dart';
import '../widgets/page_indicator_dots.dart';

/// Multi-slide onboarding flow. Slide content lives in
/// `data/onboarding_slides.dart`; each slide's UI is rendered by
/// `OnboardingSlideContent`, which also handles the per-slide
/// scroll-driven animation. This screen just owns the PageView,
/// the current-page state, and the fixed bottom controls
/// (dots, primary CTA, skip link).
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _goToNextOrFinish() {
    final isLastSlide = _currentIndex == onboardingSlides.length - 1;
    if (isLastSlide) {
      Navigator.of(
        context,
      ).push(MaterialPageRoute(builder: (_) => const SignupScreen()));
    } else {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 380),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  void _skipToCalculators() {
    Navigator.of(context).push(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 320),
        pageBuilder: (context, animation, __) => const CalculatorsHubScreen(),
        transitionsBuilder: (context, animation, __, child) {
          return FadeTransition(
            opacity: CurvedAnimation(parent: animation, curve: Curves.easeOut),
            child: child,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentData = onboardingSlides[_currentIndex];

    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              // Slides
              Expanded(
                child: AnimatedBuilder(
                  animation: _pageController,
                  builder: (context, _) {
                    return PageView.builder(
                      controller: _pageController,
                      itemCount: onboardingSlides.length,
                      onPageChanged: (i) => setState(() => _currentIndex = i),
                      itemBuilder: (context, index) {
                        double pageOffset = 0;
                        if (_pageController.hasClients &&
                            _pageController.position.haveDimensions) {
                          final page =
                              _pageController.page ?? _currentIndex.toDouble();
                          pageOffset = (page - index).abs();
                        } else {
                          pageOffset = index == _currentIndex ? 0 : 1;
                        }
                        return OnboardingSlideContent(
                          data: onboardingSlides[index],
                          pageOffset: pageOffset,
                        );
                      },
                    );
                  },
                ),
              ),

              // Page indicator
              PageIndicatorDots(
                count: onboardingSlides.length,
                activeIndex: _currentIndex,
              ),
              const SizedBox(height: 24),

              // Primary CTA — label + action change per slide
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: AppGradientButton(
                  key: ValueKey(currentData.primaryButtonLabel),
                  label: currentData.primaryButtonLabel,
                  onPressed: _goToNextOrFinish,
                ),
              ),
              const SizedBox(height: 16),

              // Skip link
              Center(
                child: TextButton(
                  onPressed: _skipToCalculators,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Skip to Calculators',
                        style: AppTypography.linkBold.copyWith(fontSize: 14),
                      ),
                      const SizedBox(width: 4),
                      const Icon(
                        Icons.arrow_forward_rounded,
                        size: 16,
                        color: AppColors.primaryLight,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}
