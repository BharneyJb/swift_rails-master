// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:swyft_rails/views/navpages/home_screen.dart';
import 'package:swyft_rails/views/navpages/schedule_screen.dart';
import 'package:swyft_rails/views/navpages/passenger_details.dart';
import 'package:swyft_rails/views/navpages/search_screen.dart';
import 'package:swyft_rails/views/navpages/settings_screen.dart';

class Startpage extends StatefulWidget {
  const Startpage({Key? key}) : super(key: key);

  @override
  _StartpageState createState() => _StartpageState();
}

class _StartpageState extends State<Startpage> {
  int currentIndex = 0;

  List screenList = [
    HomeScreen(),
   SearchScreen(),
    ScheduleScreen(),
    SettingsScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screenList[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Color(0xff4001a8),
        currentIndex: currentIndex,
        onTap: (value) {
          setState(() {
            currentIndex = value;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_filled, size: 40.0, color: Colors.grey),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search, size: 40.0, color: Colors.grey),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.schedule, size: 40.0, color: Colors.grey),
            label: 'Schedule',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined, size: 40.0, color: Colors.grey),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
