// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:swyft_rails/views/navpages/card_payment.dart';

class TicketDetails extends StatefulWidget {
  const TicketDetails({Key? key}) : super(key: key);

  @override
  _TicketDetailsState createState() => _TicketDetailsState();
}

class _TicketDetailsState extends State<TicketDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
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
                        width: 8.0,
                      ),
                      Text(
                        "Ticket Details",
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 18.0),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 15.0,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  "Train Details",
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16.0),
                ),
              ),
              // SizedBox(
              //   height: 5.0,
              // ),
              Card(
                margin: EdgeInsets.all(15),
                color: Colors.grey.shade200,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0)),
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('departure time',
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      color: Colors.purple.shade900)),
                              SizedBox(
                                height: 10.0,
                              ),
                              Text(
                                'LOS',
                                style: TextStyle(fontSize: 30.0),
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              Row(
                                children: [
                                  CircleAvatar(
                                    backgroundColor: Colors.grey.shade300,
                                    child:
                                        Image.asset('assets/icon/Frame3.png'),
                                  ),
                                  SizedBox(
                                    width: 10.0,
                                  ),
                                  Text('Train No: L1',
                                      style: TextStyle(
                                          fontSize: 16.0, color: Colors.grey)),
                                ],
                              )
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'arrival time',
                                style: TextStyle(
                                    fontSize: 16.0,
                                    color: Colors.purple.shade900),
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              Text(
                                'ABK',
                                style: TextStyle(fontSize: 30.0),
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              Text(
                                '#3,500.00',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 25.0,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Text(
                  "Passenger Details",
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16.0),
                ),
              ),

              Card(
                margin: EdgeInsets.all(15),
                color: Colors.grey.shade200,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0)),
                child: Padding(
                  padding: EdgeInsets.all(18.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Name",
                                style: TextStyle(
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.grey,
                                ),
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              Text(
                                "Email",
                                style: TextStyle(
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.grey,
                                ),
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              Text(
                                "Phone Number",
                                style: TextStyle(
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.grey,
                                ),
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              Text(
                                "Type",
                                style: TextStyle(
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.grey,
                                ),
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              Text(
                                "Coach Number",
                                style: TextStyle(
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "John Doe",
                                style: TextStyle(
                                    fontSize: 14.0,
                                    color: Color.fromRGBO(53, 53, 53, 100)),
                              ),
                              SizedBox(
                                height: 8.0,
                              ),
                              Text(
                                "JD@gmail.com",
                                style: TextStyle(
                                    fontSize: 14.0,
                                    color: Color.fromRGBO(53, 53, 53, 100)),
                              ),
                              SizedBox(
                                height: 8.0,
                              ),
                              Text(
                                "08103407697",
                                style: TextStyle(
                                    fontSize: 14.0,
                                    color: Color.fromRGBO(53, 53, 53, 100)),
                              ),
                              SizedBox(
                                height: 8.0,
                              ),
                              Text(
                                "Adult",
                                style: TextStyle(
                                    fontSize: 14.0,
                                    color: Color.fromRGBO(53, 53, 53, 100)),
                              ),
                              SizedBox(
                                height: 8.0,
                              ),
                              Text(
                                "C0/16",
                                style: TextStyle(
                                    fontSize: 14.0,
                                    color: Color.fromRGBO(53, 53, 53, 100)),
                              ),
                            ],
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Text(
                  "Price Details",
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16.0),
                ),
              ),

              Card(
                margin: EdgeInsets.all(15),
                color: Colors.grey.shade200,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0)),
                child: Padding(
                  padding: EdgeInsets.all(18.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Adult X 1",
                                style: TextStyle(
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.grey,
                                ),
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              Text(
                                "Child X 1",
                                style: TextStyle(
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.grey,
                                ),
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              Text(
                                "Convenience Fee",
                                style: TextStyle(
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.grey,
                                ),
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              Text(
                                "Bank Charges",
                                style: TextStyle(
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.grey,
                                ),
                              ),
                              SizedBox(
                                height: 15.0,
                              ),
                              Text(
                                "Total Fare",
                                style: TextStyle(
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.w600,
                                  color: Color.fromRGBO(64, 1, 168, 100),
                                ),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "#9000.00",
                                style: TextStyle(
                                    fontSize: 14.0,
                                    color: Color.fromRGBO(53, 53, 53, 100)),
                              ),
                              SizedBox(
                                height: 8.0,
                              ),
                              Text(
                                "#5000.00",
                                style: TextStyle(
                                    fontSize: 14.0,
                                    color: Color.fromRGBO(53, 53, 53, 100)),
                              ),
                              SizedBox(
                                height: 8.0,
                              ),
                              Text(
                                "#585.00",
                                style: TextStyle(
                                    fontSize: 14.0,
                                    color: Color.fromRGBO(53, 53, 53, 100)),
                              ),
                              SizedBox(
                                height: 8.0,
                              ),
                              Text(
                                "#100.00",
                                style: TextStyle(
                                    fontSize: 14.0,
                                    color: Color.fromRGBO(53, 53, 53, 100)),
                              ),
                              SizedBox(
                                height: 13.0,
                              ),
                              Text(
                                "#14,685.00",
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                    fontSize: 16.0,
                                    color: Color.fromRGBO(53, 53, 53, 100)),
                              ),
                            ],
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 30.0,
              ),
               Padding(
                 padding: const EdgeInsets.all(18.0),
                 child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    fixedSize: Size(370, 70),
                    backgroundColor: Color(0xff4001a8),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50)),
                  ),
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) {
                      return CardPayment();
                    }),
                  ),
                  child: Text(
                    'Pay #14,685',
                    style: TextStyle(color: Colors.white, fontSize: 15),
                  ),
                             ),
               ),
            ],
          ),
        ),
      ),
    );
  }
}
