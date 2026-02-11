// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:swyft_rails/models/schedule.dart';
import 'package:swyft_rails/models/station.dart';
import 'package:swyft_rails/views/utils/schedule_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime _selectedDate = DateTime.now();

  //List of trips from databse
  List schedules = [
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
          city: 'Ibadan'),
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

  // List<Trip> get tripsForSelectedDate {
  //   return allTrips.where((trip) {
  //     return trip.date.year == _selectedDate.year &&
  //         trip.date.month == _selectedDate.month &&
  //         trip.date.day == _selectedDate.day;
  //   }).toList();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.topCenter,
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.grey,
                          backgroundImage:
                              AssetImage('assets/images/Avatars.png'),
                        ),
                        SizedBox(height: 10.0),
                        Text(
                          'Hi, Mycroft',
                          style: TextStyle(fontSize: 16.0, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25.0),
                          // shape: BoxShape.circle,
                          border: Border.all(color: Colors.grey, width: 2.0),
                        ),
                        child: IconButton.outlined(
                          color: Colors.grey.shade600,
                          onPressed: () {},
                          icon: const Icon(Icons.notifications_outlined),
                        ),
                      ),
                      const SizedBox(width: 10.0), // Spacing between icons
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25.0),
                          // shape: BoxShape.circle,
                          border: Border.all(color: Colors.grey, width: 2.0),
                        ),
                        child: IconButton.outlined(
                          color: Colors.grey.shade600,
                          onPressed: () async {
                            DateTime? selected = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(1990),
                              lastDate: DateTime(2100),
                            );

                            if (selected != null) {
                              setState(() {
                                _selectedDate = selected;
                              });
                            }
                          },
                          icon: const Icon(Icons.calendar_today_outlined),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: 20.0,
              ),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ClipRRect(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(10.0)),
                      child: Image.asset(
                        'assets/images/Frame2.png',
                        fit: BoxFit.contain,
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 30.0,
              ),
              Padding(
                padding: const EdgeInsets.only(right: 280.0),
                child: Text(
                  _selectedDate.year == DateTime.now().year &&
                          _selectedDate.month == DateTime.now().month &&
                          _selectedDate.day == DateTime.now().day
                      ? 'Today\'s Trips'
                      : "Trips for ${_selectedDate.toLocal().toString().split(' ')[0]}",
                  style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              ScheduleCard(schedule: schedules[0]),
              ScheduleCard(schedule: schedules[1]),
              ScheduleCard(schedule: schedules[2]),
              ScheduleCard(schedule: schedules[3]),
              ScheduleCard(schedule: schedules[4]),
              ScheduleCard(schedule: schedules[5]),
            ]),
          ),
        ),
      ),
    );
  }
}
