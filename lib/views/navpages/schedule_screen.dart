import 'package:flutter/material.dart';
import 'package:swyft_rails/models/schedule.dart';
import 'package:swyft_rails/models/station.dart';
import 'package:swyft_rails/views/utils/schedule_card.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({Key? key}) : super(key: key);

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  static const Color _purple = Color(0xff4001a8);
  static const Color _purpleLight = Color(0xff5a1ec8);

  int _selectedFilter = 0;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  final List<String> _filters = [
    'All',
    'Today',
    'Tomorrow',
    'This Week',
    'Morning',
    'Evening',
  ];

  // Mock schedules
  final List<Schedule> _schedules = [
    Schedule(
      id: 1,
      name: 'Morning Express',
      distance: 120.5,
      stationId: 101,
      station: Station(
        id: 101,
        name: 'Lagos Central',
        stationCode: 'LGS',
        city: 'Lagos',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      departureStation: 'Abuja Terminal',
      departureTime: DateTime.now().copyWith(hour: 6, minute: 0),
      arrivalTime: DateTime.now().copyWith(hour: 8, minute: 30),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
    Schedule(
      id: 2,
      name: 'Evening Commuter',
      distance: 85.3,
      stationId: 102,
      station: Station(
        id: 102,
        name: 'Ibadan Junction',
        stationCode: 'IBJ',
        city: 'Ibadan',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      departureStation: 'Lagos Central',
      departureTime: DateTime.now().copyWith(hour: 17, minute: 0),
      arrivalTime: DateTime.now().copyWith(hour: 20, minute: 30),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
    Schedule(
      id: 3,
      name: 'Night Sleeper',
      distance: 250.0,
      stationId: 103,
      station: Station(
        id: 103,
        name: 'Kano Terminal',
        stationCode: 'KAN',
        city: 'Kano',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      departureStation: 'Abuja Terminal',
      departureTime: DateTime.now().copyWith(hour: 22, minute: 0),
      arrivalTime: DateTime.now().add(const Duration(hours: 8)).copyWith(
            hour: 6,
            minute: 0,
          ),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
    Schedule(
      id: 4,
      name: 'Weekend Express',
      distance: 95.7,
      stationId: 104,
      station: Station(
        id: 104,
        name: 'Port Harcourt Central',
        stationCode: 'PHC',
        city: 'Port Harcourt',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      departureStation: 'Calabar Station',
      departureTime: DateTime.now().copyWith(hour: 9, minute: 0),
      arrivalTime: DateTime.now().copyWith(hour: 11, minute: 45),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
    Schedule(
      id: 5,
      name: 'Business Class',
      distance: 180.2,
      stationId: 105,
      station: Station(
        id: 105,
        name: 'Enugu Central',
        stationCode: 'ENG',
        city: 'Enugu',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      departureStation: 'Onitsha Terminal',
      departureTime: DateTime.now().copyWith(hour: 7, minute: 30),
      arrivalTime: DateTime.now().copyWith(hour: 11, minute: 45),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
  ];

  List<Schedule> get _filtered {
    if (_searchQuery.isEmpty) return _schedules;
    final q = _searchQuery.toLowerCase();
    return _schedules.where((s) {
      return s.departureStation.toLowerCase().contains(q) ||
          s.station.name.toLowerCase().contains(q) ||
          s.name.toLowerCase().contains(q);
    }).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filtered;

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: CustomScrollView(
        slivers: [
          // ── Purple gradient header ──────────────────────────────────
          SliverToBoxAdapter(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [_purple, _purpleLight],
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(28),
                  bottomRight: Radius.circular(28),
                ),
              ),
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Schedules',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Find your next trip',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.72),
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Search bar
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: TextField(
                          controller: _searchController,
                          onChanged: (v) =>
                              setState(() => _searchQuery = v),
                          style: const TextStyle(fontSize: 14),
                          decoration: InputDecoration(
                            hintText:
                                'Search by station or train name…',
                            hintStyle: TextStyle(
                                color: Colors.grey.shade400,
                                fontSize: 13),
                            prefixIcon: Icon(Icons.location_on_outlined,
                                color: _purple, size: 20),
                            suffixIcon: _searchQuery.isNotEmpty
                                ? IconButton(
                                    icon: Icon(Icons.clear,
                                        color: Colors.grey.shade400,
                                        size: 18),
                                    onPressed: () {
                                      _searchController.clear();
                                      setState(() => _searchQuery = '');
                                    },
                                  )
                                : null,
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 14),
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),

                      // Filter chips
                      SizedBox(
                        height: 36,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: _filters.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(width: 8),
                          itemBuilder: (_, i) {
                            final selected = _selectedFilter == i;
                            return GestureDetector(
                              onTap: () =>
                                  setState(() => _selectedFilter = i),
                              child: AnimatedContainer(
                                duration:
                                    const Duration(milliseconds: 180),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 7),
                                decoration: BoxDecoration(
                                  color: selected
                                      ? Colors.white
                                      : Colors.white.withOpacity(0.22),
                                  borderRadius:
                                      BorderRadius.circular(20),
                                  border: Border.all(
                                    color: selected
                                        ? Colors.white
                                        : Colors.white.withOpacity(0.4),
                                    width: 1.2,
                                  ),
                                ),
                                child: Text(
                                  _filters[i],
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: selected
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                    color: selected
                                        ? _purple
                                        : Colors.white,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // ── Section header ──────────────────────────────────────────
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 8),
            sliver: SliverToBoxAdapter(
              child: Row(
                children: [
                  const Text(
                    'Available Trips',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: _purple,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${filtered.length}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Schedule cards ──────────────────────────────────────────
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
            sliver: filtered.isEmpty
                ? SliverToBoxAdapter(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(40.0),
                        child: Column(
                          children: [
                            Icon(Icons.train_outlined,
                                size: 48,
                                color: Colors.grey.shade300),
                            const SizedBox(height: 12),
                            Text(
                              'No trips found.',
                              style: TextStyle(
                                  color: Colors.grey.shade500),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                : SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (_, i) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: ScheduleCard(schedule: filtered[i]),
                      ),
                      childCount: filtered.length,
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
