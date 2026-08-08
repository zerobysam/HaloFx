import 'package:flutter/material.dart';

class CalculationHistoryEntry {
  final String calculatorTitle;
  final String resultSummary;
  final IconData icon;
  final DateTime timestamp;

  const CalculationHistoryEntry({
    required this.calculatorTitle,
    required this.resultSummary,
    required this.icon,
    required this.timestamp,
  });
}
