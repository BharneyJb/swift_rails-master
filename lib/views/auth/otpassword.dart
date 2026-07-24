// ignore_for_file: prefer_const_constructors, library_private_types_in_public_api

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:swyft_rails/services/user_service.dart';
import 'package:swyft_rails/views/startpage.dart';

class Otpassword extends StatefulWidget {
  const Otpassword({Key? key}) : super(key: key);

  @override
  _OtpasswordState createState() => _OtpasswordState();
}

class _OtpasswordState extends State<Otpassword> {
  static const Color _purple = Color(0xff4001a8);

  final TextEditingController _pinController = TextEditingController();
  String _userEmail = '';
  bool _pinFilled = false;

  // Resend countdown
  int _resendSeconds = 60;
  Timer? _resendTimer;

  @override
  void initState() {
    super.initState();
    _loadUserEmail();
    _startResendTimer();
    _pinController.addListener(() {
      setState(() => _pinFilled = _pinController.text.length == 6);
    });
  }

  Future<void> _loadUserEmail() async {
    final name = await UserService.getUserName();
    if (mounted) {
      setState(() => _userEmail = name != null ? '$name\'s account' : 'your account');
    }
  }

  void _startResendTimer() {
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) {
        t.cancel();
        return;
      }
      setState(() {
        if (_resendSeconds > 0) {
          _resendSeconds--;
        } else {
          t.cancel();
        }
      });
    });
  }

  void _resendCode() {
    setState(() => _resendSeconds = 60);
    _startResendTimer();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('A new passcode has been sent.'),
        backgroundColor: _purple,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  void dispose() {
    _pinController.dispose();
    _resendTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    // Pin cell themes
    const borderRadius = BorderRadius.all(Radius.circular(14));
    final defaultPinTheme = PinTheme(
      width: 52,
      height: 56,
      textStyle: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: borderRadius,
        border: Border.all(color: Colors.grey.shade300, width: 1.5),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyWith(
      decoration: BoxDecoration(
        color: _purple.withOpacity(0.05),
        borderRadius: borderRadius,
        border: Border.all(color: _purple, width: 2),
      ),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: BoxDecoration(
        color: _purple.withOpacity(0.08),
        borderRadius: borderRadius,
        border: Border.all(color: _purple.withOpacity(0.5), width: 1.5),
      ),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Back button
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.grey.shade300, width: 1.5),
                    ),
                    child: Icon(Icons.arrow_back_ios_new_rounded,
                        size: 16, color: Colors.grey.shade700),
                  ),
                ),

                SizedBox(height: size.height * 0.06),

                // Purple badge icon
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _purple,
                  ),
                  child: Icon(Icons.lock_rounded, color: Colors.white, size: 26),
                ),
                const SizedBox(height: 20),

                Text(
                  'Welcome back',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Enter your 6-digit passcode for\n$_userEmail',
                  style: TextStyle(
                    color: Colors.grey.shade500,
                    fontSize: 15,
                    height: 1.5,
                  ),
                ),

                SizedBox(height: size.height * 0.07),

                // Pinput
                Center(
                  child: Pinput(
                    length: 6,
                    controller: _pinController,
                    defaultPinTheme: defaultPinTheme,
                    focusedPinTheme: focusedPinTheme,
                    submittedPinTheme: submittedPinTheme,
                    showCursor: true,
                    cursor: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(bottom: 9),
                          width: 22,
                          height: 2,
                          decoration: BoxDecoration(
                            color: _purple,
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: size.height * 0.07),

                // Sign In button
                SizedBox(
                  width: double.infinity,
                  height: 58,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _purple,
                      disabledBackgroundColor: Colors.grey.shade300,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: _pinFilled ? 2 : 0,
                    ),
                    onPressed: _pinFilled
                        ? () => Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (_) => Startpage()),
                            )
                        : null,
                    child: Text(
                      'Sign In',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 28),

                // Resend / Forgot passcode row
                Center(
                  child: _resendSeconds > 0
                      ? RichText(
                          text: TextSpan(
                            style: TextStyle(
                                color: Colors.grey.shade500, fontSize: 14),
                            children: [
                              TextSpan(text: 'Resend code in '),
                              TextSpan(
                                text: '${_resendSeconds}s',
                                style: TextStyle(
                                  color: _purple,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        )
                      : GestureDetector(
                          onTap: _resendCode,
                          child: Text(
                            'Resend passcode',
                            style: TextStyle(
                              color: _purple,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                ),

                const SizedBox(height: 12),

                Center(
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      'Forgot passcode?',
                      style: TextStyle(
                        color: Colors.grey.shade500,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
