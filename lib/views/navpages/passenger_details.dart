// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, library_private_types_in_public_api, avoid_init_to_null

import 'package:flutter/material.dart';
import 'package:swyft_rails/views/navpages/ticket_details.dart';
import 'package:swyft_rails/views/utils/custom_dropdown.dart';
import 'package:swyft_rails/views/utils/form_validators.dart';
import 'package:swyft_rails/views/utils/input_field.dart';

class PassengerDetails extends StatefulWidget {
  const PassengerDetails({Key? key}) : super(key: key);

  @override
  State<PassengerDetails> createState() => _PassengerDetailsState();
}

class _PassengerDetailsState extends State<PassengerDetails> {
  // ── Separate controllers per section ──────────────────────────────────────
  final TextEditingController _selfFirstNameController =
      TextEditingController();
  final TextEditingController _selfEmailController = TextEditingController();
  final TextEditingController _selfNinController = TextEditingController();

  final TextEditingController _otherFirstNameController =
      TextEditingController();
  final TextEditingController _otherEmailController = TextEditingController();
  final TextEditingController _otherNinController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  final List<String> coachList = ['1', '2', '3'];
  final List<String> itemList2 = [
    "First Class",
    "Business Class",
    "Standard Class"
  ];

  String? _selectedCoach = '1';
  String? _selectedClass = 'First Class';
  String? _selectedSeat = 'qw';

  @override
  void dispose() {
    _selfFirstNameController.dispose();
    _selfEmailController.dispose();
    _selfNinController.dispose();
    _otherFirstNameController.dispose();
    _otherEmailController.dispose();
    _otherNinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Form(
            key: _formKey,
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
                SizedBox(height: 20),
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
                        SizedBox(height: 10.0),
                        Text('LOS', style: TextStyle(fontSize: 30.0)),
                        SizedBox(height: 10.0),
                        Row(
                          children: [
                            CircleAvatar(
                                backgroundColor: Colors.grey.shade300,
                                child: Image.asset('assets/icon/Frame3.png')),
                            SizedBox(width: 10.0),
                            Text('Train No: L1',
                                style: TextStyle(
                                    fontSize: 16.0, color: Colors.grey)),
                          ],
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('arrival time',
                            style: TextStyle(
                                fontSize: 16.0,
                                color: Colors.purple.shade900)),
                        SizedBox(height: 10.0),
                        Text('ABK', style: TextStyle(fontSize: 30.0)),
                        SizedBox(height: 10.0),
                        Text('#3,500.00', style: TextStyle(fontSize: 28)),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: CustomDropdown(
                        itemList: coachList,
                        selectedItem: _selectedCoach!,
                        onChanged: (value) =>
                            setState(() => _selectedCoach = value),
                        iconData: Icons.person_2_outlined,
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      flex: 2,
                      child: CustomDropdown(
                        itemList: itemList2,
                        selectedItem: _selectedClass!,
                        onChanged: (value) =>
                            setState(() => _selectedClass = value),
                        iconData: Icons.notes_outlined,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20.0),
                CustomDropdown(
                  itemList: ['qw', 'er', 'ty'],
                  selectedItem: _selectedSeat!,
                  onChanged: (value) => setState(() => _selectedSeat = value),
                  iconData: Icons.security_update_warning_outlined,
                ),
                SizedBox(height: 30.0),
                Text(
                  "Contact Details",
                  style:
                      TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 20.0),

                // ── For yourself ──────────────────────────────────────
                Row(
                  children: [
                    Text(
                      "For yourself /",
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Color.fromRGBO(142, 141, 141, 100),
                          fontSize: 14),
                    ),
                    Text(
                      "Seat No :C03/22",
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Color.fromRGBO(64, 1, 168, 100),
                          fontSize: 14),
                    ),
                  ],
                ),
                SizedBox(height: 10.0),
                InputField(
                  controller: _selfFirstNameController,
                  hintText: "First Name",
                  labelText: "First Name",
                  validator: FormValidators.name,
                ),
                SizedBox(height: 15.0),
                InputField(
                  controller: _selfEmailController,
                  hintText: "Email",
                  labelText: "Email",
                  keyboardType: TextInputType.emailAddress,
                  validator: FormValidators.email,
                ),
                SizedBox(height: 15.0),
                InputField(
                  controller: _selfNinController,
                  hintText: "NIN",
                  labelText: "NIN",
                  keyboardType: TextInputType.number,
                  inputFormatters: [FormValidators.ninFormatter],
                  validator: FormValidators.nin,
                ),
                SizedBox(height: 15.0),

                // ── Other passenger ───────────────────────────────────
                Row(
                  children: [
                    Text(
                      "Other Passenger /",
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Color.fromRGBO(142, 141, 141, 100),
                          fontSize: 14),
                    ),
                    Text(
                      "Seat No :C03/22",
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Color.fromRGBO(64, 1, 168, 100),
                          fontSize: 14),
                    ),
                  ],
                ),
                SizedBox(height: 10.0),
                InputField(
                  controller: _otherFirstNameController,
                  hintText: "First Name",
                  labelText: "First Name",
                  validator: FormValidators.name,
                ),
                SizedBox(height: 15.0),
                InputField(
                  controller: _otherEmailController,
                  hintText: "Email",
                  labelText: "Email",
                  keyboardType: TextInputType.emailAddress,
                  validator: FormValidators.email,
                ),
                SizedBox(height: 15.0),
                InputField(
                  controller: _otherNinController,
                  hintText: "NIN",
                  labelText: "NIN",
                  keyboardType: TextInputType.number,
                  inputFormatters: [FormValidators.ninFormatter],
                  validator: FormValidators.nin,
                ),
                SizedBox(height: 30.0),

                Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      fixedSize: Size(370, 70),
                      backgroundColor: Color(0xff4001a8),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50)),
                    ),
                    onPressed: () {
                      if (_formKey.currentState?.validate() ?? false) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const TicketDetails()),
                        );
                      }
                    },
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
      ),
    );
  }
}
