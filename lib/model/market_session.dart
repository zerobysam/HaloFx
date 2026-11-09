import 'package:flutter/material.dart';

class MarketSession {
  const MarketSession({
    required this.name,
    required this.startHourUtc,
    required this.endHourUtc,
    required this.color,
  });

  final String name;
  final int startHourUtc;
  final int endHourUtc;
  final Color color;

  bool get crossesMidnight => endHourUtc <= startHourUtc;

  bool isActiveAt(DateTime utc) {
    final hour = utc.hour + utc.minute / 60;
    if (crossesMidnight) {
      return hour >= startHourUtc || hour < endHourUtc;
    }
    return hour >= startHourUtc && hour < endHourUtc;
  }

  DateTime nextStart(DateTime utc) {
    final todayStart = DateTime.utc(
      utc.year,
      utc.month,
      utc.day,
      startHourUtc,
    );
    if (todayStart.isAfter(utc)) return todayStart;
    return todayStart.add(const Duration(days: 1));
  }

  DateTime nextEnd(DateTime utc) {
    final start = isActiveAt(utc)
        ? (crossesMidnight && utc.hour < endHourUtc
            ? DateTime.utc(utc.year, utc.month, utc.day - 1, startHourUtc)
            : DateTime.utc(utc.year, utc.month, utc.day, startHourUtc))
        : nextStart(utc);
    var end = DateTime.utc(
      start.year,
      start.month,
      start.day,
      endHourUtc,
    );
    if (!end.isAfter(start)) end = end.add(const Duration(days: 1));
    return end;
  }

  String get hoursLabel =>
      '${_hourLabel(startHourUtc)} – ${_hourLabel(endHourUtc)}';

  static String _hourLabel(int hour) => '${hour.toString().padLeft(2, '0')}:00';
}
