// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:swyft_rails/models/schedule.dart';
import 'package:swyft_rails/models/station.dart';
import 'package:swyft_rails/services/notification_service.dart';
import 'package:swyft_rails/services/user_service.dart';
import 'package:swyft_rails/views/main/notifications_screen.dart';
import 'package:swyft_rails/views/main/settings_screen.dart';
import 'package:swyft_rails/views/utils/schedule_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const Color _purple = Color(0xff4001a8);
  static const Color _purpleLight = Color(0xff5a1ec8);

  DateTime _selectedDate = DateTime.now();
  String _firstName = '';
  String _initials = '?';
  String? _avatarPath;
  int _notificationCount = 0;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final name = await UserService.getUserName();
    final initials = await UserService.getInitials();
    final avatar = await UserService.getAvatarPath();
    final count = await NotificationService.getCount();
    if (mounted) {
      setState(() {
        _firstName = name ?? '';
        _initials = initials;
        _avatarPath = avatar;
        _notificationCount = count;
      });
    }
  }

  // List of trips from database
  final List<Schedule> schedules = [
    Schedule(
      id: 1,
      name: "Morning Express",
      distance: 120.5,
      stationId: 101,
      station: Station(
          id: 101,
          name: "Lagos Central",
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          stationCode: 'M12',
          city: 'Lagos'),
      departureStation: "Abuja Terminal",
      arrivalTime: DateTime.now().add(Duration(hours: 2)),
      departureTime: DateTime.now(),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
    Schedule(
      id: 2,
      name: "Evening Commuter",
      distance: 85.3,
      stationId: 102,
      station: Station(
          id: 102,
          name: "Ibadan Junction",
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          stationCode: 'IBJ15',
          city: 'Ibadan'),
      departureStation: "Lagos Central",
      arrivalTime: DateTime.now().add(Duration(hours: 3, minutes: 30)),
      departureTime: DateTime.now().add(Duration(hours: 1)),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
    Schedule(
      id: 3,
      name: "Night Sleeper",
      distance: 250.0,
      stationId: 103,
      station: Station(
          id: 103,
          name: "Kano Terminal",
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          stationCode: 'KN20',
          city: 'Kano'),
      departureStation: "Abuja Terminal",
      arrivalTime: DateTime.now().add(Duration(hours: 8)),
      departureTime: DateTime.now().add(Duration(hours: 4)),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
    Schedule(
      id: 4,
      name: "Weekend Express",
      distance: 95.7,
      stationId: 104,
      station: Station(
          id: 104,
          name: "Port Harcourt Central",
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          stationCode: 'PHC08',
          city: 'Port Harcourt'),
      departureStation: "Calabar Station",
      arrivalTime: DateTime.now().add(Duration(hours: 2, minutes: 45)),
      departureTime: DateTime.now().add(Duration(hours: 30)),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
    Schedule(
      id: 5,
      name: "Business Class",
      distance: 180.2,
      stationId: 105,
      station: Station(
          id: 105,
          name: "Enugu Central",
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          stationCode: 'ENG12',
          city: 'Enugu'),
      departureStation: "Onitsha Terminal",
      arrivalTime: DateTime.now().add(Duration(hours: 4, minutes: 15)),
      departureTime: DateTime.now().add(Duration(hours: 2)),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
    Schedule(
      id: 6,
      name: "Local Shuttle",
      distance: 45.8,
      stationId: 106,
      station: Station(
          id: 106,
          name: "Kaduna Junction",
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          stationCode: 'KDJ09',
          city: 'Kaduna'),
      departureStation: "Zaria Station",
      arrivalTime: DateTime.now().add(Duration(hours: 1, minutes: 20)),
      departureTime: DateTime.now().add(Duration(hours: 15)),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
  ];

  void _goToNotifications() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => NotificationsScreen()),
    );
    // Refresh badge count after returning
    final count = await NotificationService.getCount();
    if (mounted) setState(() => _notificationCount = count);
  }

  void _goToSettings() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => SettingsScreen()),
    ).then((_) => _loadUserData());
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: CustomScrollView(
        slivers: [
          // ── Purple header ──────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [_purple, _purpleLight],
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(32),
                  bottomRight: Radius.circular(32),
                ),
              ),
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Avatar
                          GestureDetector(
                            onTap: _goToSettings,
                            child: Stack(
                              children: [
                                Container(
                                  width: 58,
                                  height: 58,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        color: Colors.white.withOpacity(0.6),
                                        width: 2.5),
                                  ),
                                  child: ClipOval(
                                    child: _avatarPath != null
                                        ? Image.asset(
                                            _avatarPath!,
                                            fit: BoxFit.cover,
                                          )
                                        : Container(
                                            color: Colors.white.withOpacity(0.15),
                                            child: Center(
                                              child: Text(
                                                _initials,
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 22,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                  ),
                                ),
                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: Container(
                                    width: 18,
                                    height: 18,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white,
                                      border: Border.all(color: _purple, width: 1),
                                    ),
                                    child: Icon(Icons.camera_alt_rounded,
                                        size: 10, color: _purple),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(width: 14),

                          // Greeting
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _firstName.isNotEmpty
                                      ? 'Hi, $_firstName 👋'
                                      : 'Welcome 👋',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: -0.3,
                                  ),
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  'Where are you travelling today?',
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.75),
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Action icons
                          Row(
                            children: [
                              GestureDetector(
                                onTap: _goToNotifications,
                                child: Stack(
                                  clipBehavior: Clip.none,
                                  children: [
                                    _iconButton(Icons.notifications_outlined),
                                    if (_notificationCount > 0)
                                      Positioned(
                                        top: -4,
                                        right: -4,
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 5, vertical: 2),
                                          decoration: BoxDecoration(
                                            color: Colors.red.shade500,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            border: Border.all(
                                                color: _purple, width: 1.5),
                                          ),
                                          child: Text(
                                            _notificationCount > 99
                                                ? '99+'
                                                : '$_notificationCount',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 9,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 10),
                              GestureDetector(
                                onTap: () async {
                                  DateTime? selected = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(1990),
                                    lastDate: DateTime(2100),
                                    builder: (context, child) => Theme(
                                      data: Theme.of(context).copyWith(
                                        colorScheme: const ColorScheme.light(
                                          primary: _purple,
                                          onPrimary: Colors.white,
                                        ),
                                      ),
                                      child: child!,
                                    ),
                                  );
                                  if (selected != null) {
                                    setState(() => _selectedDate = selected);
                                  }
                                },
                                child: _iconButton(Icons.calendar_today_outlined),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // ── Body content ───────────────────────────────────────────────
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Promo card
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  elevation: 4,
                  clipBehavior: Clip.antiAlias,
                  child: Image.asset(
                    'assets/images/Frame2.png',
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                ),

                const SizedBox(height: 28),

                // Section header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _selectedDate.year == DateTime.now().year &&
                              _selectedDate.month == DateTime.now().month &&
                              _selectedDate.day == DateTime.now().day
                          ? "Today's Trips"
                          : "Trips for ${_selectedDate.toLocal().toString().split(' ')[0]}",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    Text(
                      '${schedules.length} trips',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Schedule cards
                ...schedules.map((s) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: ScheduleCard(schedule: s),
                    )),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _iconButton(IconData icon) {
    return Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withOpacity(0.15),
        border: Border.all(
            color: Colors.white.withOpacity(0.3), width: 1.5),
      ),
      child: Icon(icon, color: Colors.white, size: 20),
    );
  }
}
