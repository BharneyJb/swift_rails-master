// ignore_for_file: prefer_const_constructors, library_private_types_in_public_api
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  final _formKey = GlobalKey<FormState>();

  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController ninController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  bool _ninVerified = false;
  bool _verifyingNin = false;
  String? _ninError;

  PhoneNumber number = PhoneNumber(isoCode: 'NG');

  @override
  void initState() {
    super.initState();
    ninController.addListener(() {
      if (_ninVerified) {
        setState(() {
          _ninVerified = false;
        });
      }
    });
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    ninController.dispose();
    dobController.dispose();
    phoneController.dispose();
    emailController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(const Duration(days: 365 * 18)),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xff4001a8),
              onPrimary: Colors.white,
              onSurface: Colors.black87,
            ),
          ),
          child: child!,
        );
      },
    );
    if (pickedDate != null) {
      String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
      dobController.text = formattedDate;
    }
  }

  Future<void> _verifyNin() async {
    final nin = ninController.text.trim();
    if (nin.length != 11 || !RegExp(r'^\d+$').hasMatch(nin)) {
      setState(() {
        _ninError = 'NIN must be exactly 11 digits';
      });
      return;
    }
    setState(() {
      _verifyingNin = true;
      _ninError = null;
    });

    // Simulate verification delay
    await Future.delayed(const Duration(milliseconds: 1500));

    setState(() {
      _verifyingNin = false;
      _ninVerified = true;
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('NIN verified successfully!'),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Input Details',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Input your personal details to set up your account',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 32),
                InputField(
                  controller: firstNameController,
                  hintText: 'First Name',
                  labelText: 'First Name',
                  prefixIcon: const Icon(Icons.person_outline, color: Color(0xff4001a8)),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter your first name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                InputField(
                  controller: lastNameController,
                  hintText: 'Last Name',
                  labelText: 'Last Name',
                  prefixIcon: const Icon(Icons.person_outline, color: Color(0xff4001a8)),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter your last name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                InputField(
                  controller: emailController,
                  hintText: 'name@example.com',
                  labelText: 'Email Address',
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: const Icon(Icons.email_outlined, color: Color(0xff4001a8)),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter your email';
                    }
                    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                    if (!emailRegex.hasMatch(value.trim())) {
                      return 'Please enter a valid email address';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                InputField(
                  controller: ninController,
                  hintText: '11-digit NIN',
                  labelText: 'National Identification Number (NIN)',
                  keyboardType: TextInputType.number,
                  prefixIcon: const Icon(Icons.fingerprint_outlined, color: Color(0xff4001a8)),
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(11)
                  ],
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter your NIN';
                    }
                    if (value.length != 11) {
                      return 'NIN must be exactly 11 digits';
                    }
                    if (!_ninVerified) {
                      return 'Please verify your NIN';
                    }
                    return _ninError;
                  },
                  suffixIcon: _verifyingNin
                      ? const Padding(
                          padding: EdgeInsets.all(12.0),
                          child: SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Color(0xff4001a8)),
                            ),
                          ),
                        )
                      : _ninVerified
                          ? const Icon(Icons.check_circle, color: Colors.green)
                          : TextButton(
                              onPressed: _verifyNin,
                              child: const Text(
                                'Verify',
                                style: TextStyle(
                                  color: Color(0xff4001a8),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () => _selectDate(context),
                  child: AbsorbPointer(
                    absorbing: true,
                    child: InputField(
                      controller: dobController,
                      hintText: 'YYYY-MM-DD',
                      labelText: 'Date of Birth',
                      prefixIcon: const Icon(Icons.calendar_today_outlined, color: Color(0xff4001a8)),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please select your date of birth';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.grey.shade300,
                      width: 1.0,
                    ),
                  ),
                  child: InternationalPhoneNumberInput(
                    onInputChanged: (PhoneNumber number) {
                      this.number = number;
                    },
                    selectorConfig: const SelectorConfig(
                      selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                    ),
                    ignoreBlank: false,
                    autoValidateMode: AutovalidateMode.disabled,
                    selectorTextStyle: const TextStyle(color: Colors.black),
                    initialValue: number,
                    textFieldController: phoneController,
                    formatInput: true,
                    keyboardType: const TextInputType.numberWithOptions(
                      signed: true,
                      decimal: true,
                    ),
                    inputBorder: InputBorder.none,
                    searchBoxDecoration: const InputDecoration(
                      hintText: 'Search by country name or dial code',
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 60),
                    backgroundColor: const Color(0xff4001a8),
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      if (!_ninVerified) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Please verify your NIN first'),
                            backgroundColor: Colors.red,
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                        return;
                      }

                      // Store the user's first name
                      await UserService.storeUserName(firstNameController.text.trim());

                      if (mounted) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) {
                            return Verification(email: emailController.text.trim());
                          }),
                        );
                      }
                    }
                  },
                  child: const Text(
                    'Sign Up',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                const Center(
                  child: Text(
                    'By continuing, you agree to Swift Rails Terms of service and Privacy Profile',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
