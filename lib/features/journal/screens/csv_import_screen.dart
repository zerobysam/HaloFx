import 'package:flutter/material.dart';
import 'package:halofx/core/theme/app_colors.dart';
import 'package:halofx/features/accounts/models/trading_account.dart';

class CsvImportScreen extends StatelessWidget {
  final TradingAccount account;

  const CsvImportScreen({super.key, required this.account});

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
                'Import from CSV',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Choose a CSV file from your device. We will map the columns before importing.',
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
