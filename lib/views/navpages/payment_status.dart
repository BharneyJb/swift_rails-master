// Copyright 2024 Swift Rails. All rights reserved.

import 'package:flutter/material.dart';

class PaymentStatus extends StatefulWidget {
  const PaymentStatus({ super.key });

  @override
  State<PaymentStatus> createState() => _PaymentStatusState();
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
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Icon(Icons.arrow_back),
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
              const SizedBox(
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