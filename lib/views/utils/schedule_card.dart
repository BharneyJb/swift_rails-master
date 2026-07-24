import 'package:flutter/material.dart';
import 'package:swyft_rails/models/schedule.dart';
import 'package:swyft_rails/screens/passenger_details_screen.dart';

class ScheduleCard extends StatelessWidget {
  final Schedule schedule;

  const ScheduleCard({Key? key, required this.schedule}) : super(key: key);

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
                          schedule.departureStation,
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
                            Expanded(
                              child: Text(
                                'Train: ${schedule.name}',
                                style: TextStyle(fontSize: 14.0, color: Colors.grey),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
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
                          schedule.station.name,
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
}
