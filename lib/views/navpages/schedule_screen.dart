// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({Key? key}) : super(key: key);

  @override
  _ScheduleScreenState createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Schedule',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
              ),
              SizedBox(
                height: 15.0,
              ),
              Row(
                children: [
                  Container(
                    width: 80,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey.shade400),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 15.0),
                      child: Row(children: [
                        Text(
                          "Date",
                          style: TextStyle(color: Colors.grey.shade600),
                        ),
                        Icon(
                          Icons.arrow_drop_down,
                          color: Colors.grey.shade600,
                        )
                      ]),
                    ),
                  ),
                  SizedBox(
                    width: 15.0,
                  ),
                  Container(
                    width: 100,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey.shade400),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 15.0),
                      child: Row(
                        children: [
                          Text(
                            "Location",
                            style: TextStyle(color: Colors.grey.shade600),
                          ),
                          Icon(
                            Icons.arrow_drop_down,
                            color: Colors.grey.shade600,
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 15.0,
                  ),
                  Container(
                    width: 80,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey.shade400),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 15.0),
                      child: Row(
                        children: [
                          Text(
                            "Class",
                            style: TextStyle(color: Colors.grey.shade600),
                          ),
                          Icon(
                            Icons.arrow_drop_down,
                            color: Colors.grey.shade600,
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 15.0,
              ),
              Card(
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
                          Text('departure time',
                              style: TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.purple.shade900),),
                          Text(
                                'arrival time',
                                style: TextStyle(
                                    fontSize: 16.0,
                                    color: Colors.purple.shade900),
                              ),
                        ],
                      ),         
                          SizedBox(
                            height: 10.0,
                          ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                              Text(
                            'LOS',
                            style: TextStyle(fontSize: 30.0),
                          ),
                          Text(
                                'ABK',
                                style: TextStyle(fontSize: 30.0),
                              ),
                        ]
                      ),    
                          SizedBox(
                            height: 10.0,
                          ),
                          Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: Colors.grey.shade300,
                                child: Image.asset('assets/icon/icon.png'),
                              ),
                              SizedBox(
                                width: 10.0,
                              ),
                              Text('Train No: L1',
                                  style: TextStyle(
                                      fontSize: 16.0, color: Colors.grey),),

                               Text(
                                '#3,500.00',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              )        
                            ],
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          Row(
                            children: [
                              Image.asset("assets/icon/green.png"),
                              SizedBox(width: 7.0,),
                              Text("Available"),
                              SizedBox(width: 7.0,),
                              Text("|", style: TextStyle(color: Colors.grey),),
                              Text("16",style: TextStyle(color: Colors.green),),
                              SizedBox(width: 10.0,),
                              Image.asset("assets/icon/red.png",),
                              SizedBox(width: 7.0,),
                              Text("Unavailable"),
                              SizedBox(width: 7.0,),
                              Text("|", style: TextStyle(color: Colors.grey),),
                              Text("16",style: TextStyle(color: Colors.red),),  
                            ],
                          )
                         
                        ],
                      )
                    
                  ),
                ),
              
            ],
          ),
        ),
      ),
    );
  }
}
