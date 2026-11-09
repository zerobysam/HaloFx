import 'package:flutter/material.dart';
import 'core/theme/app_colors.dart';
import 'features/onboarding/screens/onboarding_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HaloFx',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: AppColors.bgPrimary,
      ),
      home: const OnboardingScreen(),
    );
  }
}
