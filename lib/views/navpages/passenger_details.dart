// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, library_private_types_in_public_api, avoid_init_to_null, unused_import

import 'package:flutter/material.dart';
import 'package:swyft_rails/views/navpages/ticket_details.dart';

import 'package:swyft_rails/views/utils/custom_dropdown.dart';
import 'package:swyft_rails/views/utils/input_field.dart';
import 'package:swyft_rails/views/utils/seat_layout.dart';

class PassengerDetails extends StatefulWidget {
  const PassengerDetails({Key? key}) : super(key: key);

  @override
  _PassengerDetailsState createState() => _PassengerDetailsState();
}

class _PassengerDetailsState extends State<PassengerDetails> {
   final TextEditingController firstNameController = TextEditingController();

  final TextEditingController ninController = TextEditingController();

  final TextEditingController emailController = TextEditingController();

  final TextEditingController phoneController = TextEditingController();
  final List<String> coachList = ['1', '2', '3'];
  // final List<String> classList = [
  // "First Class",
  // "Business Class",
  // "Standard Class"
  // ];
  var itemList2 = ["First Class", "Business Class", "Standard Class"];

  String? _selectedCoach = '1';
  String? _selectedClass = 'First Class';
  String? _selectedSeat = 'qw';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: () => Navigator.pop(context),
                child: Container(
                  padding: EdgeInsets.only(bottom: 12),
                  child: Icon(Icons.arrow_back),
                ),
              ),
              Text(
                'Passenger Details',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('departure time',
                          style: TextStyle(
                              fontSize: 16.0, color: Colors.purple.shade900)),
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
                              child: Image.asset('assets/icon/Frame3.png')),
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
                            fontSize: 16.0, color: Colors.purple.shade900),
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
                        style: TextStyle(fontSize: 28),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: CustomDropdown(
                      itemList: coachList,
                      selectedItem: _selectedCoach!,
                      onChanged: (value) {
                        setState(() {
                          _selectedCoach = value;
                        });
                      },
                      iconData: Icons.person_2_outlined,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    flex: 2,
                    child: CustomDropdown(
                      itemList: itemList2,
                      selectedItem: _selectedClass!,
                      onChanged: (value) {
                        setState(() {
                          _selectedClass = value;
                        });
                      },
                      iconData: Icons.notes_outlined,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20.0,
              ),
              CustomDropdown(
                itemList: ['qw', 'er', 'ty'],
                selectedItem: _selectedSeat!,
                onChanged: (value) {
                  setState(() {
                    _selectedSeat = value;
                  });
                },
                iconData: Icons.security_update_warning_outlined,
              ),
              SizedBox(
                height: 30.0,
              ),
              Text(
                "Contact Details",
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: 20.0,
              ),
              Row(
                children: [
                  Text(
                    "For yourself /",
                    style: TextStyle(fontWeight: FontWeight.w600,
                        color: Color.fromRGBO(142, 141, 141, 100),
                        fontSize: 14),
                  ),
                  Text(
                    "Seat No :C03/22",
                    style: TextStyle(fontWeight: FontWeight.w600,
                        color: Color.fromRGBO(64, 1, 168, 100), fontSize: 14),
                  )
                ],
              ),
              SizedBox(
                height: 10.0,
              ),
              InputField(controller: firstNameController, hintText: "First Name", labelText: "First Name"),
              SizedBox(
                height: 15.0,
              ),
              InputField(controller: emailController, hintText: "Email", labelText: "Email", ),
              SizedBox(
                height: 15.0,
              ),
              InputField(controller: ninController, hintText: "NIN", labelText: "NIN"),
               SizedBox(
                height: 15.0,
              ),
              Row(
                children: [
                  Text(
                    "Other Passenger /",
                    style: TextStyle(fontWeight: FontWeight.w600,
                        color: Color.fromRGBO(142, 141, 141, 100),
                        fontSize: 14),
                  ),
                  Text(
                    "Seat No :C03/22",
                    style: TextStyle(fontWeight: FontWeight.w600,
                        color: Color.fromRGBO(64, 1, 168, 100), fontSize: 14),
                  )
                ],
              ),
              SizedBox(
                height: 10.0,
              ),
              InputField(controller: firstNameController, hintText: "First Name", labelText: "First Name"),
              SizedBox(
                height: 15.0,
              ),
              InputField(controller: emailController, hintText: "Email", labelText: "Email"),
              SizedBox(
                height: 15.0,
              ),
              InputField(controller: ninController, hintText: "NIN", labelText: "NIN"),
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
                      return TicketDetails();
                    }),
                  ),
                  child: Text(
                    'Purchase Ticket',
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
