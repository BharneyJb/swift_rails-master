// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:swyft_rails/views/main/home_screen.dart';
import 'package:swyft_rails/views/navpages/schedule_screen.dart';
import 'package:swyft_rails/views/main/search_screen.dart';
import 'package:swyft_rails/views/main/settings_screen.dart';

class Startpage extends StatefulWidget {
  const Startpage({Key? key}) : super(key: key);

  @override
  _StartpageState createState() => _StartpageState();
}

class _StartpageState extends State<Startpage> {
  static const Color _purple = Color(0xff4001a8);

  int _currentIndex = 0;

  final List<Widget> _screens = [
    HomeScreen(),
    SearchScreen(),
    ScheduleScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (value) {
          setState(() => _currentIndex = value);
        },
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        shadowColor: Colors.black12,
        elevation: 8,
        // The colour of the pill around the active icon
        indicatorColor: _purple,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        animationDuration: const Duration(milliseconds: 350),
        destinations: [
          NavigationDestination(
            icon: Icon(Icons.home_outlined, color: Colors.grey.shade500, size: 26),
            selectedIcon: Icon(Icons.home_rounded, color: Colors.white, size: 26),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.search_outlined, color: Colors.grey.shade500, size: 26),
            selectedIcon: Icon(Icons.search_rounded, color: Colors.white, size: 26),
            label: 'Search',
          ),
          NavigationDestination(
            icon: Icon(Icons.event_note_outlined, color: Colors.grey.shade500, size: 26),
            selectedIcon: Icon(Icons.event_note_rounded, color: Colors.white, size: 26),
            label: 'Schedule',
          ),
          NavigationDestination(
            icon: Icon(Icons.manage_accounts_outlined, color: Colors.grey.shade500, size: 26),
            selectedIcon: Icon(Icons.manage_accounts_rounded, color: Colors.white, size: 26),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
