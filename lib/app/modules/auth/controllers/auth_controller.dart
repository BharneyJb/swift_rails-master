import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/services/api_service.dart';
import '../../../core/services/storage_service.dart';
import '../../../core/utils/api_endpoints.dart';
import '../../../routes/app_routes.dart';

class AuthController extends GetxController {
  final ApiService _apiService = Get.find();
  final StorageService _storageService = Get.find();

  // Login Form
  final loginFormKey = GlobalKey<FormState>();
  final loginEmailController = TextEditingController();
  final loginPasswordController = TextEditingController();
  final RxBool isLoginPasswordVisible = false.obs;
  final RxBool isLoginLoading = false.obs;

  // Register Form
  final registerFormKey = GlobalKey<FormState>();
  final registerFirstNameController = TextEditingController();
  final registerSurnameController = TextEditingController();
  final registerEmailController = TextEditingController();
  final registerPhoneController = TextEditingController();
  final registerPasswordController = TextEditingController();
  final registerConfirmPasswordController = TextEditingController();
  final registerNinController = TextEditingController();
  final RxString registerGender = ''.obs;
  final Rx<DateTime?> registerDob = Rx<DateTime?>(null);
  final RxBool isRegisterPasswordVisible = false.obs;
  final RxBool isRegisterConfirmPasswordVisible = false.obs;
  final RxBool isRegisterLoading = false.obs;

  // Forgot Password Form
  final forgotPasswordFormKey = GlobalKey<FormState>();
  final forgotPasswordEmailController = TextEditingController();
  final RxBool isForgotPasswordLoading = false.obs;

  // OTP Form
  final otpController = TextEditingController();
  final RxBool isOtpLoading = false.obs;
  final RxString verificationEmail = ''.obs;

  // Reset Password Form
  final resetPasswordFormKey = GlobalKey<FormState>();
  final resetPasswordController = TextEditingController();
  final resetConfirmPasswordController = TextEditingController();
  final RxBool isResetPasswordVisible = false.obs;
  final RxBool isResetConfirmPasswordVisible = false.obs;
  final RxBool isResetPasswordLoading = false.obs;

  // ─── Toggle Visibility ─────────────────────────────────────────────────────

  void toggleLoginPasswordVisibility() =>
      isLoginPasswordVisible.value = !isLoginPasswordVisible.value;

  void toggleRegisterPasswordVisibility() =>
      isRegisterPasswordVisible.value = !isRegisterPasswordVisible.value;

  void toggleRegisterConfirmPasswordVisibility() =>
      isRegisterConfirmPasswordVisible.value =
          !isRegisterConfirmPasswordVisible.value;

  void toggleResetPasswordVisibility() =>
      isResetPasswordVisible.value = !isResetPasswordVisible.value;

  void toggleResetConfirmPasswordVisibility() =>
      isResetConfirmPasswordVisible.value =
          !isResetConfirmPasswordVisible.value;

  // ─── Login ─────────────────────────────────────────────────────────────────

  /// Login flow:
  ///  1. POST /login — get token + bare user stub
  ///  2. Save token & stub to storage immediately (so the next request is auth'd)
  ///  3. GET /customers — hydrate full profile (firstName, surname, phone, etc.)
  ///  4. Overwrite storage with full profile, set isLoggedIn = true
  ///  5. Navigate to MAIN
  Future<void> login() async {
    if (!loginFormKey.currentState!.validate()) return;
    try {
      isLoginLoading.value = true;

      final response = await _apiService.post(
        ApiEndpoints.login,
        data: {
          'email': loginEmailController.text.trim(),
          'password': loginPasswordController.text,
        },
      );

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;

        // 1 — save token immediately (authorises the next request)
        await _storageService.saveToken(data['token'] as String);

        // 2 — save bare user stub from login response
        final userStub = data['user'] as Map<String, dynamic>;
        await _storageService.saveUserData(userStub);

        // 3 — fetch the full profile now that we have a token
        await _fetchAndStoreFullProfile();

        // 4 — mark session as active
        await _storageService.setLoggedIn(true);

        Get.offAllNamed(AppRoutes.MAIN);
      }
    } catch (e) {
      Get.snackbar(
        'Login Failed',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoginLoading.value = false;
    }
  }

  /// Calls GET /customers and merges the full profile into storage.
  /// Returns true on success, false on error (non-fatal — bare stub is still usable).
  Future<bool> _fetchAndStoreFullProfile() async {
    try {
      final profileResponse = await _apiService.get(ApiEndpoints.profile);
      if (profileResponse.statusCode == 200) {
        final profileData = profileResponse.data as Map<String, dynamic>;
        await _storageService.saveUserData(profileData);
        return true;
      }
    } catch (e) {
      debugPrint('AuthController: Could not fetch full profile after login: $e');
    }
    return false;
  }

  // ─── Register ──────────────────────────────────────────────────────────────

  /// Registration flow:
  ///  1. POST /register — create account
  ///  2. On success → navigate to LOGIN, pre-fill email
  Future<void> register() async {
    if (!registerFormKey.currentState!.validate()) return;

    if (registerDob.value == null) {
      Get.snackbar(
        'Missing Field',
        'Please select your date of birth',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }

    if (registerGender.value.isEmpty) {
      Get.snackbar(
        'Missing Field',
        'Please select your gender',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }

    try {
      isRegisterLoading.value = true;

      final response = await _apiService.post(
        ApiEndpoints.register,
        data: {
          'firstName': registerFirstNameController.text.trim(),
          'surname': registerSurnameController.text.trim(),
          'email': registerEmailController.text.trim(),
          'phone': registerPhoneController.text.trim(),
          'gender': registerGender.value,
          'dob': _formatDate(registerDob.value!),
          'nin': registerNinController.text.trim(),
          'password': registerPasswordController.text,
        },
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        // Pre-fill the login email for convenience
        loginEmailController.text = registerEmailController.text.trim();

        Get.offNamed(AppRoutes.LOGIN);
        Get.snackbar(
          'Account Created!',
          'Registration successful. Please log in.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Registration Failed',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isRegisterLoading.value = false;
    }
  }

  String _formatDate(DateTime date) =>
      '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

  // ─── Forgot Password ───────────────────────────────────────────────────────

  Future<void> forgotPassword() async {
    if (!forgotPasswordFormKey.currentState!.validate()) return;

    try {
      isForgotPasswordLoading.value = true;

      // ── BACKEND COMMENTED OUT — endpoint not yet implemented ───────────────
      // final response = await _apiService.post(
      //   ApiEndpoints.forgotPassword,
      //   data: {'email': forgotPasswordEmailController.text.trim()},
      // );
      // if (response.statusCode == 200) {
      //   verificationEmail.value = forgotPasswordEmailController.text.trim();
      //   Get.toNamed(AppRoutes.VERIFY_OTP);
      // }
      // ── MOCK ──────────────────────────────────────────────────────────────
      verificationEmail.value = forgotPasswordEmailController.text.trim();
      Get.toNamed(AppRoutes.VERIFY_OTP);
      Get.snackbar(
        'Dev Mode',
        'OTP bypassed — any 6-digit code accepted',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isForgotPasswordLoading.value = false;
    }
  }

  // ─── Verify OTP ────────────────────────────────────────────────────────────

  Future<void> verifyOtp() async {
    if (otpController.text.length != 6) {
      Get.snackbar(
        'Error',
        'Please enter a valid 6-digit OTP',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    try {
      isOtpLoading.value = true;
      // ── MOCK ──────────────────────────────────────────────────────────────
      Get.toNamed(AppRoutes.RESET_PASSWORD);
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isOtpLoading.value = false;
    }
  }

  // ─── Reset Password ────────────────────────────────────────────────────────

  Future<void> resetPassword() async {
    if (!resetPasswordFormKey.currentState!.validate()) return;

    try {
      isResetPasswordLoading.value = true;
      // ── MOCK ──────────────────────────────────────────────────────────────
      Get.offAllNamed(AppRoutes.LOGIN);
      Get.snackbar(
        'Dev Mode',
        'Password reset (backend bypassed)',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isResetPasswordLoading.value = false;
    }
  }

  @override
  void onClose() {
    // Controllers are disposed here when the AuthController is removed from memory.
    // To avoid "used after disposed" errors during rapid navigation or rebuilds,
    // we ensure they are only disposed when the controller is truly finished.
    loginEmailController.dispose();
    loginPasswordController.dispose();
    registerFirstNameController.dispose();
    registerSurnameController.dispose();
    registerEmailController.dispose();
    registerPhoneController.dispose();
    registerPasswordController.dispose();
    registerConfirmPasswordController.dispose();
    registerNinController.dispose();
    forgotPasswordEmailController.dispose();
    otpController.dispose();
    resetPasswordController.dispose();
    resetConfirmPasswordController.dispose();
    super.onClose();
  }
}
