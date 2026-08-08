import 'package:flutter/material.dart';
import 'calculator_access_level.dart';

class CalculatorItem {
  final String id;
  final String title;
  final String subtitle;
  final IconData icon;
  final Color iconColor;
  final List<String> categories; // e.g. ['forex', 'futures']
  final bool isFavorite;
  final CalculatorAccessLevel accessLevel;
  final WidgetBuilder Function()? screenBuilder; // null = "coming soon"

  const CalculatorItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.iconColor,
    required this.categories,
    this.isFavorite = false,
    this.accessLevel = CalculatorAccessLevel.free,
    this.screenBuilder,
  });
}
