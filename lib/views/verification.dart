// ignore_for_file: library_private_types_in_public_api, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:swyft_rails/views/otpassword.dart';


class Verification extends StatefulWidget {
  const Verification({ Key? key }) : super(key: key);

  @override
  _VerificationState createState() => _VerificationState();
}

class _VerificationState extends State<Verification> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 100),
          child: Container(
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: Image.asset('assets/images/Envelopes.png'),
                ),
                SizedBox(
                  height: 40.0,
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 45),
                  child: Text('Account Verification',
                    style: TextStyle(fontSize: 28.0,
                    fontWeight: FontWeight.bold),
                  ),
                ),
                
                Padding(
                  padding: const EdgeInsets.only(right: 80),
                  child: Text('A verification link has been sent to ',
                  style: TextStyle(color: Colors.grey, fontSize: 14),),
                ),
                SizedBox(
                  height: 60,
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
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
                        return Otpassword();
                      }),
                    ),
                    child: Text(
                      'Continue',
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                  ),
                ),
              ]
            ),
          ),
        ),
      ),
      
    );
  }
}