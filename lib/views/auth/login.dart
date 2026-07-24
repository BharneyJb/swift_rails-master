// ignore_for_file: library_private_types_in_public_api, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:swyft_rails/views/auth/signup.dart';
import 'package:swyft_rails/views/utils/input_field.dart';
import 'package:swyft_rails/services/user_service.dart';
import 'package:swyft_rails/views/auth/otpassword.dart';
import 'package:swyft_rails/views/forgot.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  static const Color _purple = Color(0xff4001a8);

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isObscure = true;
  String? _userName;

  @override
  void initState() {
    super.initState();
    _loadUserName();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _loadUserName() async {
    final userName = await UserService.getUserName();
    if (mounted) {
      setState(() => _userName = userName);
    }
  }

  void _signIn() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    // Placeholder auth flow: send the user to the passcode screen,
    // then on to the main app — matches the existing post-auth navigation.
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const Otpassword()),
    );
  }

  void _goToSignUp() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const Signup()),
    );
  }

  void _goToForgot() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const Forgot()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Custom circular back button
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                          color: Colors.grey.shade300, width: 1.5),
                    ),
                    child: Icon(
                      Icons.arrow_back_ios_new_rounded,
                      size: 16,
                      color: Colors.grey.shade700,
                    ),
                  ),
                ),

                const SizedBox(height: 28),

                // Purple badge
                Container(
                  width: 56,
                  height: 56,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: _purple,
                  ),
                  child: const Icon(
                    Icons.lock_open_rounded,
                    color: Colors.white,
                    size: 26,
                  ),
                ),
                const SizedBox(height: 20),

                // Heading
                Text(
                  _userName != null && _userName!.isNotEmpty
                      ? 'Welcome back, $_userName'
                      : 'Welcome back',
                  style: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Sign in with your email and password to continue your journey.',
                  style: TextStyle(
                    color: Colors.grey.shade500,
                    fontSize: 15,
                    height: 1.5,
                  ),
                ),

                const SizedBox(height: 32),

                // Email
                InputField(
                  controller: _emailController,
                  hintText: 'name@example.com',
                  labelText: 'Email Address',
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: const Icon(
                    Icons.email_outlined,
                    color: _purple,
                  ),
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

                // Password
                InputField(
                  controller: _passwordController,
                  hintText: 'Enter your password',
                  labelText: 'Password',
                  obscureText: _isObscure,
                  prefixIcon: const Icon(
                    Icons.lock_outline_rounded,
                    color: _purple,
                  ),
                  suffixIcon: IconButton(
                    onPressed: () =>
                        setState(() => _isObscure = !_isObscure),
                    icon: Icon(
                      _isObscure
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: Colors.grey.shade500,
                    ),
                    tooltip: _isObscure ? 'Show password' : 'Hide password',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 12),

                // Forgot password
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: _goToForgot,
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: const Text(
                      'Forgot password?',
                      style: TextStyle(
                        color: _purple,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Primary CTA
                SizedBox(
                  width: double.infinity,
                  height: 58,
                  child: ElevatedButton(
                    onPressed: _signIn,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _purple,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 2,
                    ),
                    child: const Text(
                      'Sign In',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Divider with "or"
                Row(
                  children: [
                    Expanded(
                      child: Divider(
                        color: Colors.grey.shade300,
                        thickness: 1,
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'OR',
                        style: TextStyle(
                          color: Colors.grey.shade500,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        color: Colors.grey.shade300,
                        thickness: 1,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Social sign-in row
                Row(
                  children: [
                    Expanded(
                      child: _socialButton(
                        icon: Icons.apple_rounded,
                        label: 'Apple',
                        background: Colors.black,
                        foreground: Colors.white,
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                  'Sign in with Apple will be wired up soon'),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _socialButton(
                        icon: Icons.g_mobiledata_rounded,
                        label: 'Google',
                        background: Colors.white,
                        foreground: Colors.black87,
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                  'Sign in with Google will be wired up soon'),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        },
                        hasBorder: true,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 32),

                // Footer — sign up link
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have an account? ",
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 14,
                        ),
                      ),
                      GestureDetector(
                        onTap: _goToSignUp,
                        child: const Text(
                          'Sign up',
                          style: TextStyle(
                            color: _purple,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 12),
                Center(
                  child: Text(
                    'By continuing, you agree to SwiftRails Terms of Service and Privacy Policy.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.grey.shade500,
                      fontSize: 11,
                      height: 1.4,
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

  Widget _socialButton({
    required IconData icon,
    required String label,
    required Color background,
    required Color foreground,
    required VoidCallback onTap,
    bool hasBorder = false,
  }) {
    return SizedBox(
      height: 52,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: background,
          foregroundColor: foreground,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
            side: hasBorder
                ? BorderSide(color: Colors.grey.shade300, width: 1.2)
                : BorderSide.none,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: foreground, size: 22),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: foreground,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
