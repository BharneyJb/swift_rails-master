import 'package:flutter/material.dart';

class TripHistoryView extends StatelessWidget {
  const TripHistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trip History'),
      ),
      body: const Center(
        child: Text('Trip History Screen'),
      ),
    );
  }
}
