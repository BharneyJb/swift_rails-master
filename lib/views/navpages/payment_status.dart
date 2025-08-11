// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers

import 'package:flutter/material.dart';

class PaymentStatus extends StatefulWidget {
  const PaymentStatus({ Key? key }) : super(key: key);

  @override
  _PaymentStatusState createState() => _PaymentStatusState();
}

class _PaymentStatusState extends State<PaymentStatus> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            InkWell(
                  onTap: () => Navigator.pop(context),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Container(
                          // padding: EdgeInsets.only(bottom: 12),
                          child: Icon(Icons.arrow_back),
                        ),
                        SizedBox(
                          width: 10.0,
                        ),
                        Text(
                          "Payment Status",
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 18.0),
                        )
                      ],
                    ),
                  ),
                ),
              SizedBox(
                height: 50.0,
              ),
               Column(
                mainAxisAlignment: MainAxisAlignment.center,
                 children: [
                   Image.asset("assets/images/success.png"),
                 ],
               )      
          ],
        ),
      ),
    );
  }
}