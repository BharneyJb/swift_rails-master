// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers

import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:swyft_rails/views/startpage.dart';
import 'package:swyft_rails/views/navpages/home_screen.dart';



class Otpassword extends StatefulWidget {
  const Otpassword({ Key? key }) : super(key: key);

  @override
  _OtpasswordState createState() => _OtpasswordState();
}

class _OtpasswordState extends State<Otpassword> {
  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 50,
      height: 50,
      textStyle: TextStyle(
        fontSize: 22,
        color: Colors.black
      ),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: Colors.grey.shade400),
      ),
    );
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.only(top: 45, left: 25),
        child: Container(
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Welcome back',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
              ),
              SizedBox(
                height: 10,
              ),
              Text('user email', style: TextStyle(color: Colors.grey, fontSize: 16),),
              SizedBox(
                height: 40,
              ),
              Pinput(
                length: 6,
                defaultPinTheme: defaultPinTheme,
                focusedPinTheme: defaultPinTheme.copyWith(
                  decoration: defaultPinTheme.decoration!.copyWith(
                    border: Border.all(color: Colors.purple.shade900),
                  ),
                ),
              ),
              SizedBox(
                  height: 60,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    fixedSize: Size(370, 70),
                    backgroundColor: Color(0xff4001a8),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50)),
                  ),
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) {
                      return Startpage();
                    }),
                  ),
                  child: Text(
                    'Sign In',
                    style: TextStyle(color: Colors.white, fontSize: 15),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 120),
                  child: TextButton(
                    style: ElevatedButton.styleFrom(
                      fixedSize: Size(150, 35),
                      backgroundColor: Colors.grey.shade300,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50)),
                    ),
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) {
                        return Otpassword();
                      }),
                    ), child: Text(
                      'Forgot Passcode',
                      style: TextStyle(color: Color(0xff4001a8), fontSize: 15),
                    ),
                  ),
                ),

            //    
            ],
          ),
        ),
      ),
    );
  }
}