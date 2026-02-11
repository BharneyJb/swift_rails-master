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
  final registerNameController = TextEditingController();
  final registerEmailController = TextEditingController();
  final registerPhoneController = TextEditingController();
  final registerPasswordController = TextEditingController();
  final registerConfirmPasswordController = TextEditingController();
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

  // Toggle Password Visibility
  void toggleLoginPasswordVisibility() {
    isLoginPasswordVisible.value = !isLoginPasswordVisible.value;
  }

  void toggleRegisterPasswordVisibility() {
    isRegisterPasswordVisible.value = !isRegisterPasswordVisible.value;
  }

  void toggleRegisterConfirmPasswordVisibility() {
    isRegisterConfirmPasswordVisible.value =
        !isRegisterConfirmPasswordVisible.value;
  }

  void toggleResetPasswordVisibility() {
    isResetPasswordVisible.value = !isResetPasswordVisible.value;
  }

  void toggleResetConfirmPasswordVisibility() {
    isResetConfirmPasswordVisible.value = !isResetConfirmPasswordVisible.value;
  }

  // Login
  Future<void> login() async {
    if (!loginFormKey.currentState!.validate()) return;

    try {
      isLoginLoading.value = true;

      print(
          'LOGIN: Attempting login with email: ${loginEmailController.text.trim()}');
      print(
          'LOGIN: API Endpoint: ${ApiEndpoints.baseUrl}${ApiEndpoints.login}');

      final response = await _apiService.post(
        ApiEndpoints.login,
        data: {
          'email': loginEmailController.text.trim(),
          'password': loginPasswordController.text,
        },
      );

      if (response.statusCode == 200) {
        final data = response.data;
        await _storageService.saveToken(data['token']);
        await _storageService.saveUserData(data['user']);
        await _storageService.setLoggedIn(true);

        Get.offAllNamed(AppRoutes.MAIN);
        Get.snackbar(
          'Success',
          'Login successful!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoginLoading.value = false;
    }
  }

  // Register
  Future<void> register() async {
    if (!registerFormKey.currentState!.validate()) return;

    try {
      isRegisterLoading.value = true;

      final response = await _apiService.post(
        ApiEndpoints.register,
        data: {
          'name': registerNameController.text.trim(),
          'email': registerEmailController.text.trim(),
          'phone': registerPhoneController.text.trim(),
          'password': registerPasswordController.text,
        },
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        Get.snackbar(
          'Success',
          'Registration successful! Please login.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        Get.offNamed(AppRoutes.LOGIN);
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isRegisterLoading.value = false;
    }
  }

  // Forgot Password
  Future<void> forgotPassword() async {
    if (!forgotPasswordFormKey.currentState!.validate()) return;

    try {
      isForgotPasswordLoading.value = true;

      final response = await _apiService.post(
        ApiEndpoints.forgotPassword,
        data: {
          'email': forgotPasswordEmailController.text.trim(),
        },
      );

      if (response.statusCode == 200) {
        verificationEmail.value = forgotPasswordEmailController.text.trim();
        Get.toNamed(AppRoutes.VERIFY_OTP);
        Get.snackbar(
          'Success',
          'OTP sent to your email',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      }
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

  // Verify OTP
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

      final response = await _apiService.post(
        ApiEndpoints.verifyOtp,
        data: {
          'email': verificationEmail.value,
          'otp': otpController.text,
        },
      );

      if (response.statusCode == 200) {
        Get.toNamed(AppRoutes.RESET_PASSWORD);
        Get.snackbar(
          'Success',
          'OTP verified successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      }
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

  // Reset Password
  Future<void> resetPassword() async {
    if (!resetPasswordFormKey.currentState!.validate()) return;

    try {
      isResetPasswordLoading.value = true;

      final response = await _apiService.post(
        ApiEndpoints.resetPassword,
        data: {
          'email': verificationEmail.value,
          'password': resetPasswordController.text,
          'otp': otpController.text,
        },
      );

      if (response.statusCode == 200) {
        Get.offAllNamed(AppRoutes.LOGIN);
        Get.snackbar(
          'Success',
          'Password reset successful! Please login.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      }
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
    loginEmailController.dispose();
    loginPasswordController.dispose();
    registerNameController.dispose();
    registerEmailController.dispose();
    registerPhoneController.dispose();
    registerPasswordController.dispose();
    registerConfirmPasswordController.dispose();
    forgotPasswordEmailController.dispose();
    otpController.dispose();
    resetPasswordController.dispose();
    resetConfirmPasswordController.dispose();
    super.onClose();
  }
}
