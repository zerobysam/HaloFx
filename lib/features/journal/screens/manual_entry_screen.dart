import 'package:flutter/material.dart';
import 'package:halofx/features/accounts/models/trading_account.dart';

import '../../../core/theme/app_colors.dart';

class ManualEntryScreen extends StatelessWidget {
  final TradingAccount account;

  const ManualEntryScreen({super.key, required this.account});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.bgPrimary,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 24),
              Text(
                'Manual Entry',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Enter your details by hand. Fill in each field below and save when you are done.',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white70,
                ),
              ),
              SizedBox(height: 24),
              Text(
                'Placeholder content goes here.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
