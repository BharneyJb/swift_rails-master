import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import '../../../core/services/storage_service.dart';
import '../../../routes/app_routes.dart';

class SplashController extends GetxController {
  final StorageService _storageService = Get.find();

  @override
  void onInit() {
    super.onInit();
    debugPrint('SplashController: onInit called');
    _navigateToNextScreen();
  }

  void _navigateToNextScreen() async {
    debugPrint('SplashController: Starting 3 second delay');
    await Future.delayed(const Duration(seconds: 3));
    debugPrint('SplashController: Delay completed');

    try {
      final isFirstTime = _storageService.isFirstTime;
      final isLoggedIn = _storageService.isLoggedIn;
      debugPrint(
          'SplashController: isFirstTime=$isFirstTime, isLoggedIn=$isLoggedIn');

      if (isFirstTime) {
        debugPrint('SplashController: Navigating to ONBOARDING');
        Get.offAllNamed(AppRoutes.ONBOARDING);
        return;
      }

      if (isLoggedIn) {
        // Check whether the stored token has already expired
        final token = _storageService.token;
        if (token != null && _isTokenExpired(token)) {
          debugPrint('SplashController: Token expired — clearing session');
          await _storageService.clearSession();
          Get.offAllNamed(AppRoutes.LOGIN);
          return;
        }

        debugPrint('SplashController: Navigating to MAIN');
        Get.offAllNamed(AppRoutes.MAIN);
        return;
      }

      debugPrint('SplashController: Navigating to LOGIN');
      Get.offAllNamed(AppRoutes.LOGIN);
    } catch (e) {
      debugPrint('SplashController: Exception: $e — navigating to ONBOARDING');
      Get.offAllNamed(AppRoutes.ONBOARDING);
    }
  }

  /// Decodes the JWT payload (no library needed — just base64) and checks
  /// whether the `exp` claim is in the past. Returns true if expired.
  bool _isTokenExpired(String token) {
    try {
      final parts = token.split('.');
      if (parts.length != 3) return false;

      // JWT payload is base64url-encoded — pad to a multiple of 4
      String payload = parts[1];
      final remainder = payload.length % 4;
      if (remainder != 0) payload += '=' * (4 - remainder);

      final decoded =
          utf8.decode(base64Url.decode(payload.replaceAll('-', '+').replaceAll('_', '/')));
      final Map<String, dynamic> claims = json.decode(decoded);

      final exp = claims['exp'];
      if (exp == null) return false;

      final expiry =
          DateTime.fromMillisecondsSinceEpoch((exp as int) * 1000, isUtc: true);
      return DateTime.now().isAfter(expiry);
    } catch (e) {
      debugPrint('SplashController: Could not decode token: $e');
      return false;
    }
  }
}
