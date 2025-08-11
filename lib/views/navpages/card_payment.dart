// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:swyft_rails/views/navpages/payment_status.dart';
import 'package:swyft_rails/views/utils/input_field.dart';

class CardPayment extends StatefulWidget {
  const CardPayment({Key? key}) : super(key: key);

  @override
  _CardPaymentState createState() => _CardPaymentState();
}

class _CardPaymentState extends State<CardPayment> {
  TextEditingController cardController = TextEditingController();
  TextEditingController cvvController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        title: Text(
          "Ticket Details",
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18.0),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              SizedBox(
                height: 15.0,
              ),
              InputField(
                controller: cardController,
                hintText: "Card Number",
                labelText: "Card Number",
              ),
              SizedBox(
                height: 8.0,
              ),
              Row(
                children: [
                  Expanded(
                    child: InputField(
                      controller: cvvController,
                      hintText: "CVV",
                      labelText: "CVV",
                    ),
                  ),
                  SizedBox(
                    width: 12.0,
                  ),
                  Expanded(
                    child: InputField(
                      controller: dateController,
                      hintText: "Exp",
                      labelText: "Exp",
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 30.0,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.maxFinite, 70),
                  backgroundColor: Color(0xff4001a8),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50)),
                ),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) {
                    return PaymentStatus();
                  }),
                ),
                child: Text(
                  'Pay #14,685',
                  style: TextStyle(color: Colors.white, fontSize: 15),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
