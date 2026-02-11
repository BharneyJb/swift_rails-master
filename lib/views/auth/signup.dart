// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:swyft_rails/views/utils/input_field.dart';
import 'package:swyft_rails/services/user_service.dart';

import 'package:swyft_rails/views/auth/verification.dart';

class Signup extends StatefulWidget {
  const Signup({Key? key}) : super(key: key);

  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final GlobalKey _formKey = GlobalKey<FormState>();

  final TextEditingController firstNameController = TextEditingController();

  final TextEditingController lastNameController = TextEditingController();

  final TextEditingController ninController = TextEditingController();

  final TextEditingController dobController = TextEditingController();

  final TextEditingController phoneController = TextEditingController();

  final TextEditingController emailController = TextEditingController();

  bool isObscure = true;

  String initialCountry = 'NG';

  PhoneNumber number = PhoneNumber(isoCode: 'NG');

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context, 
      initialDate: DateTime.now(), 
      firstDate: DateTime(1900), 
      lastDate: DateTime.now()
      );
      if (pickedDate != null) {
        String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
        dobController.text = formattedDate;
      }
  }

  void getPhoneNumber(String phoneNumber) async {
    PhoneNumber number =
        await PhoneNumber.getRegionInfoFromPhoneNumber(phoneNumber, 'US');

    setState(() {
      this.number = number;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 60.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Input Details',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),

              SizedBox(
                height: 10,
              ),

              Text(
                'Input your personal details to set up your account',
                style: TextStyle(fontSize: 14, color: Colors.grey

                    // fontWeight: FontWeight.bold,

                    ),
              ),

              SizedBox(
                height: 20,
              ),

              InputField(
                  controller: firstNameController,
                  hintText: 'First Name',
                  labelText: 'First Name'),

              SizedBox(height: 36),

              InputField(
                  controller: lastNameController,
                  hintText: 'Last Name',
                  labelText: 'Last Name'),

              SizedBox(height: 36),

              InputField(
                  controller: emailController,
                  hintText: 'Email',
                  labelText: 'Email'),

              SizedBox(height: 36),

              InputField(
                  controller: ninController, hintText: 'NIN', labelText: 'NIN'),

              SizedBox(height: 36),

              GestureDetector(
                onTap: () => _selectDate(context),
                child: AbsorbPointer(
                  absorbing: true,
                  child: InputField(
                      controller: dobController,
                      hintText: 'Date of Birth',
                      labelText: 'Date of Birth'),
                ),
              ),

              SizedBox(height: 36),

              Form(
                child: Container(
                  // margin: EdgeInsets.symmetric(vertical: 50, ),

                  padding: EdgeInsets.symmetric(horizontal: 20),

                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,

                    borderRadius: BorderRadius.circular(5.0),

                    // border: Border.all(color: Colors.grey.shade300)
                  ),

                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      InternationalPhoneNumberInput(
                        onInputChanged: (PhoneNumber number) {
                          print(number.phoneNumber);
                        },
                        onInputValidated: (bool value) {
                          print(value);
                        },
                        selectorConfig: SelectorConfig(
                          selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                        ),
                        ignoreBlank: false,
                        autoValidateMode: AutovalidateMode.disabled,
                        selectorTextStyle: TextStyle(color: Colors.black),
                        initialValue: number,
                        textFieldController: phoneController,
                        formatInput: true,
                        keyboardType: TextInputType.numberWithOptions(
                          signed: true,
                          decimal: true,
                        ),
                        inputBorder: InputBorder.none,
                        onSaved: (PhoneNumber number) {
                          print('On Saved: $number');
                        },
                      ),
                    ],
                  ),
                ),
              ),

              // InputField(

              //     controller: phoneController,

              //     hintText: 'Mobile Number',

              //     labelText: 'Mobile Number'),

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
                onPressed: () async {
                  // Store the user's first name
                  if (firstNameController.text.isNotEmpty) {
                    await UserService.storeUserName(firstNameController.text);
                  }
                  
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) {
                      return Verification();
                    }),
                  );
                },
                child: Text(
                  'Sign Up',
                  style: TextStyle(color: Colors.white, fontSize: 15),
                ),
              ),
              SizedBox(
              height: 20,
            ),
              Text('By continuing, you agree to Swift Rails Terms of service and Privacy Profile',
              style: TextStyle(color: Colors.grey, fontSize: 14),)
            ],
          ),
        ),
      ),
    );
  }
}
