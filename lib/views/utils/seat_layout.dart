// ignore_for_file: prefer_const_constructors, library_private_types_in_public_api

import 'package:flutter/material.dart';

class SeatLayout extends StatefulWidget {
  const SeatLayout({Key? key}) : super(key: key);

  @override
  _SeatLayoutState createState() => _SeatLayoutState();
}

class _SeatLayoutState extends State<SeatLayout> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 12),
      // height: 200,
      width: double.maxFinite,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: List.generate(
                  7,
                  (index) => Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset('assets/icon/seat-icon.png'),
                  ),
                ),
              ),
              Row(
                children: [
                  Column(
                    children: List.generate(
                      7,
                      (index) => Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.asset('assets/icon/seat-icon.png'),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Column(
                    children: List.generate(
                      7,
                      (index) => Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.asset('assets/icon/seat-icon.png'),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
