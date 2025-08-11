import 'package:flutter/material.dart';
import 'package:internationalization/internationalization.dart';
import 'package:swyft_rails/models/schedule.dart';
import 'package:swyft_rails/models/station.dart';
import 'package:swyft_rails/screens/passenger_details_screen.dart';
import 'package:swyft_rails/views/navpages/passenger_details.dart';

class ScheduleCard extends StatelessWidget {
  final Schedule schedule;

  const ScheduleCard({Key? key, required this.schedule}) : super(key: key);

  String formatDateTime(DateTime dt) {
    return DateFormat('hh:mm a').format(dt);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const PassengerDetailsScreen(),
          ),
        );
      },
      child: Card(
        color: Colors.grey.shade200,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Left Side: Departure
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Departure Time',
                            style: TextStyle(
                                fontSize: 16.0, color: Theme.of(context).primaryColor)),
                        SizedBox(height: 10.0),
                        Text(
                          schedule.departureStation, // e.g., 'LOS'
                          style: TextStyle(fontSize: 15.0),
                        ),
                        SizedBox(height: 10.0),
                        Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: Colors.grey.shade300,
                              child: Image.asset('assets/icon/icon.png'),
                            ),
                            SizedBox(width: 5.0),
                            Text('Train: ${schedule.name}',
                                style: TextStyle(
                                    fontSize: 14.0, color: Colors.grey)),
                          ],
                        ),
                      ],
                    ),
                  ),

                  SizedBox(width: 16),

                  // Right Side: Arrival
                  Expanded(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text('Arrival Time',
                            style: TextStyle(
                                fontSize: 16.0, color: Theme.of(context).primaryColor)),
                        SizedBox(height: 10.0),
                        Text(
                          schedule.station.name, // e.g., 'ABK'
                          style: TextStyle(fontSize: 16.0),
                        ),
                        SizedBox(height: 15.0),
                        Text(
                          "${schedule.distance.toStringAsFixed(1)} km",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return "${dateTime.year}-${_pad(dateTime.month)}-${_pad(dateTime.day)} ${_pad(dateTime.hour)}:${_pad(dateTime.minute)}";
  }

  String _pad(int value) => value.toString().padLeft(2, '0');
}
