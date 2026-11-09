import 'package:flutter/material.dart';
import 'package:halofx/core/theme/app_colors.dart';
import 'package:halofx/model/market_session.dart';

const List<MarketSession> defaultMarketSessions = [
  MarketSession(
    name: 'Sydney',
    startHourUtc: 22,
    endHourUtc: 7,
    color: AppColors.purple,
  ),
  MarketSession(
    name: 'Tokyo',
    startHourUtc: 0,
    endHourUtc: 9,
    color: AppColors.blue,
  ),
  MarketSession(
    name: 'London',
    startHourUtc: 8,
    endHourUtc: 16,
    color: AppColors.green,
  ),
  MarketSession(
    name: 'New York',
    startHourUtc: 13,
    endHourUtc: 22,
    color: AppColors.orange,
  ),
];

class MarketSessionsCard extends StatelessWidget {
  final DateTime now;
  final List<MarketSession> sessions;
  final VoidCallback? onViewAll;

  const MarketSessionsCard({
    super.key,
    required this.now,
    this.sessions = defaultMarketSessions,
    this.onViewAll,
  });

  String _formatDuration(Duration duration) {
    final seconds = duration.inSeconds < 0 ? 0 : duration.inSeconds;
    final hours = seconds ~/ 3600;
    final minutes = (seconds % 3600) ~/ 60;
    final remainingSeconds = seconds % 60;

    return '${hours.toString().padLeft(2, '0')}:'
        '${minutes.toString().padLeft(2, '0')}:'
        '${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final utc = now.toUtc();

    final activeSessions =
        sessions.where((session) => session.isActiveAt(utc)).toList();

    final upcomingSessions =
        sessions.where((session) => !session.isActiveAt(utc)).toList()
          ..sort(
            (a, b) => a.nextStart(utc).compareTo(b.nextStart(utc)),
          );

    final nextSession = upcomingSessions.isNotEmpty
        ? upcomingSessions.first
        : sessions.reduce(
            (a, b) => a.nextStart(utc).isBefore(b.nextStart(utc)) ? a : b,
          );

    final currentSession =
        activeSessions.isNotEmpty ? activeSessions.last : null;

    final countdown = currentSession != null
        ? currentSession.nextEnd(utc).difference(utc)
        : nextSession.nextStart(utc).difference(utc);

    final currentHour = utc.hour + utc.minute / 60;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(13),
        border: Border.all(
          color: AppColors.border,
          width: .7,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Market Sessions',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              TextButton(
                onPressed: onViewAll,
                child: const Text(
                  'View all',
                  style: TextStyle(
                    color: AppColors.purple,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),

          // Session rows
          ...sessions.map((session) {
            final isActive = session.isActiveAt(utc);

            return Padding(
              padding: const EdgeInsets.only(bottom: 15),
              child: Row(
                children: [
                  Container(
                    width: 9,
                    height: 9,
                    decoration: BoxDecoration(
                      color: session.color,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: session.color.withOpacity(.3),
                          blurRadius: 6,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  SizedBox(
                    width: 88,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          session.name,
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          session.hoursLabel,
                          style: const TextStyle(
                            fontSize: 9,
                            color: AppColors.muted,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final width = constraints.maxWidth;
                        final start = session.startHourUtc / 24;
                        final end = session.endHourUtc / 24;

                        return SizedBox(
                          height: 14,
                          child: Stack(
                            alignment: Alignment.centerLeft,
                            children: [
                              Container(
                                width: width,
                                height: 4,
                                decoration: BoxDecoration(
                                  color: AppColors.border,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                              if (session.crossesMidnight) ...[
                                Positioned(
                                  left: 0,
                                  width: width * end,
                                  child: Container(
                                    height: 4,
                                    decoration: BoxDecoration(
                                      color: session.color,
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  left: width * start,
                                  width: width * (1 - start),
                                  child: Container(
                                    height: 4,
                                    decoration: BoxDecoration(
                                      color: session.color,
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                  ),
                                ),
                              ] else
                                Positioned(
                                  left: width * start,
                                  width: width * (end - start),
                                  child: Container(
                                    height: 4,
                                    decoration: BoxDecoration(
                                      color: session.color,
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                  ),
                                ),
                              Positioned(
                                left: (width * currentHour / 24)
                                    .clamp(0.0, width - 5),
                                child: Container(
                                  width: 5,
                                  height: 12,
                                  decoration: BoxDecoration(
                                    color: AppColors.text,
                                    borderRadius: BorderRadius.circular(3),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.white.withOpacity(.3),
                                        blurRadius: 4,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 7),
                  SizedBox(
                    width: 36,
                    child: Text(
                      isActive ? 'LIVE' : 'CLOSED',
                      textAlign: TextAlign.end,
                      style: TextStyle(
                        color: isActive ? AppColors.green : AppColors.muted,
                        fontSize: 8,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),

          // UTC timeline
          const Padding(
            padding: EdgeInsets.only(left: 107, right: 42),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('00:00',
                    style: TextStyle(fontSize: 9, color: AppColors.muted)),
                Text('06:00',
                    style: TextStyle(fontSize: 9, color: AppColors.muted)),
                Text('12:00',
                    style: TextStyle(fontSize: 9, color: AppColors.muted)),
                Text('18:00',
                    style: TextStyle(fontSize: 9, color: AppColors.muted)),
                Text('24:00',
                    style: TextStyle(fontSize: 9, color: AppColors.muted)),
              ],
            ),
          ),

          const SizedBox(height: 8),

          const Text(
            'All times displayed in UTC',
            style: TextStyle(
              fontSize: 9,
              color: AppColors.muted,
            ),
          ),
        ],
      ),
    );
  }
}
