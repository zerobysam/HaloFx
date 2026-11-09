import 'dart:async';

import 'package:flutter/material.dart';
import 'package:halofx/core/theme/app_colors.dart';
import 'package:halofx/core/widgets/halo_dashboard_cards.dart';
import 'package:halofx/model/dashboard_mock_data.dart';

class SessionStatusCard extends StatefulWidget {
  const SessionStatusCard({super.key});

  @override
  State<SessionStatusCard> createState() => _SessionStatusCardState();
}

class _SessionStatusCardState extends State<SessionStatusCard> {
  Timer? _ticker;

  @override
  void initState() {
    super.initState();
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now().toUtc();
    final active =
        defaultMarketSessions.where((s) => s.isActiveAt(now)).toList();
    final next = defaultMarketSessions
        .map((s) => MapEntry(s, s.nextStart(now)))
        .where((e) => !e.key.isActiveAt(now))
        .toList()
      ..sort((a, b) => a.value.compareTo(b.value));

    final current = active.isNotEmpty ? active.first : null;
    final nextEntry = next.isNotEmpty ? next.first : null;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0C1C25), Color(0xFF10182A)],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Expanded(
            child: _StatusColumn(
              title: current?.name ?? 'Market',
              subtitle: current == null ? 'Currently quiet' : 'SESSION LIVE',
              color: current?.color ?? AppColors.textSecondary,
              value: current == null
                  ? 'No session'
                  : 'Ends ${_countdown(current.nextEnd(now).difference(now))}',
              isLive: current != null,
            ),
          ),
          Container(width: 1, height: 58, color: AppColors.border),
          const SizedBox(width: 14),
          Expanded(
            child: _StatusColumn(
              title: nextEntry?.key.name ?? 'Next session',
              subtitle: 'NEXT UP',
              color: AppColors.purpleBright,
              value: nextEntry == null
                  ? '—'
                  : 'Starts in ${_countdown(nextEntry.value.difference(now))}',
              isLive: false,
            ),
          ),
        ],
      ),
    );
  }

  String _countdown(Duration duration) {
    if (duration.isNegative) return '00:00:00';
    final h = duration.inHours.toString().padLeft(2, '0');
    final m = (duration.inMinutes % 60).toString().padLeft(2, '0');
    final s = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return '$h:$m:$s';
  }
}

class _StatusColumn extends StatelessWidget {
  const _StatusColumn({
    required this.title,
    required this.subtitle,
    required this.color,
    required this.value,
    required this.isLive,
  });

  final String title;
  final String subtitle;
  final Color color;
  final String value;
  final bool isLive;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Flexible(
              child: Text(
                '$title Session',
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                ),
              ),
            ),
            if (isLive) ...[
              const SizedBox(width: 5),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.green.withOpacity(.13),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  'LIVE',
                  style: TextStyle(
                    color: AppColors.green,
                    fontSize: 8,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 7),
        Text(
          subtitle,
          style: TextStyle(
            color: color,
            fontSize: 9,
            fontWeight: FontWeight.w700,
            letterSpacing: .5,
          ),
        ),
        const SizedBox(height: 3),
        FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: Text(
            value,
            style: TextStyle(
              color: isLive ? AppColors.green : AppColors.textPrimary,
              fontSize: 13,
              fontWeight: FontWeight.w700,
              fontFeatures: const [],
            ),
          ),
        ),
      ],
    );
  }
}
