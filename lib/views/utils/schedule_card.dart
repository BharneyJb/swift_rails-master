import 'package:flutter/material.dart';
import 'package:swyft_rails/models/schedule.dart';
import 'package:swyft_rails/screens/passenger_details_screen.dart';

class ScheduleCard extends StatelessWidget {
  final Schedule schedule;

  const ScheduleCard({Key? key, required this.schedule}) : super(key: key);

  static const Color _purple = Color(0xff4001a8);
  static const Color _purpleDark = Color(0xff7c3aed);

  String _formatTime(DateTime dt) {
    final h = dt.hour;
    final m = dt.minute.toString().padLeft(2, '0');
    final period = h >= 12 ? 'PM' : 'AM';
    final hour12 = h == 0 ? 12 : (h > 12 ? h - 12 : h);
    return '$hour12:$m $period';
  }

  Duration get _duration =>
      schedule.arrivalTime.difference(schedule.departureTime);

  String get _durationLabel {
    final h = _duration.inHours;
    final m = _duration.inMinutes.remainder(60);
    if (h == 0) return '${m}m';
    return m == 0 ? '${h}h' : '${h}h ${m}m';
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => PassengerDetailsScreen(schedule: schedule),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.07),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Left purple gradient accent bar
              Container(
                width: 4,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    bottomLeft: Radius.circular(16),
                  ),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [_purple, _purpleDark],
                  ),
                ),
              ),

              // Card content
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ── Route row ────────────────────────────────────
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Departure
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  schedule.departureStation,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  _formatTime(schedule.departureTime),
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey.shade500,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Center: dotted line + train icon
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    _dot(),
                                    ..._dashes(),
                                    const Icon(Icons.train,
                                        size: 18, color: _purple),
                                    ..._dashes(),
                                    _dot(),
                                  ],
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  _durationLabel,
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.grey.shade500,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Arrival
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  schedule.station.name,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.end,
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  _formatTime(schedule.arrivalTime),
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey.shade500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      // ── Dashed divider ───────────────────────────────
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: _DashedDivider(),
                      ),

                      // ── Bottom row ───────────────────────────────────
                      Row(
                        children: [
                          // Train name chip
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: _purple.withOpacity(0.08),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                  color: _purple.withOpacity(0.25)),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.train_outlined,
                                    size: 12, color: _purple),
                                const SizedBox(width: 4),
                                Text(
                                  schedule.name,
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: _purple,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(width: 8),

                          // Distance
                          Text(
                            '${schedule.distance.toStringAsFixed(0)} km',
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey.shade500,
                            ),
                          ),

                          const Spacer(),

                          // Price (mocked — schedules don't carry a fare field)
                          Text(
                            '₦3,500',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.green.shade600,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 8),

                      // ── Availability row ─────────────────────────────
                      Row(
                        children: [
                          _availDot(Colors.green.shade500),
                          const SizedBox(width: 4),
                          Text(
                            'Available: 16',
                            style: TextStyle(
                                fontSize: 11, color: Colors.grey.shade600),
                          ),
                          const SizedBox(width: 12),
                          _availDot(Colors.red.shade400),
                          const SizedBox(width: 4),
                          Text(
                            'Full: 2',
                            style: TextStyle(
                                fontSize: 11, color: Colors.grey.shade600),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _dot() => Container(
        width: 5,
        height: 5,
        decoration: BoxDecoration(
          color: Colors.grey.shade400,
          shape: BoxShape.circle,
        ),
      );

  List<Widget> _dashes() => List.generate(
        4,
        (_) => Container(
          width: 5,
          height: 1.5,
          margin: const EdgeInsets.symmetric(horizontal: 1.5),
          color: Colors.grey.shade300,
        ),
      );

  Widget _availDot(Color color) => Container(
        width: 8,
        height: 8,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      );
}

class _DashedDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, constraints) {
        const dashW = 5.0;
        const gap = 4.0;
        final count = (constraints.maxWidth / (dashW + gap)).floor();
        return Row(
          children: List.generate(
            count,
            (_) => Container(
              width: dashW,
              height: 1,
              margin: const EdgeInsets.only(right: gap),
              color: Colors.grey.shade300,
            ),
          ),
        );
      },
    );
  }
}
