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
    debugPrint('SplashController: Starting 5 second delay');
    await Future.delayed(const Duration(seconds: 5));
    debugPrint('SplashController: Delay completed');

    try {
      debugPrint('SplashController: isFirstTime = ${_storageService.isFirstTime}');
      debugPrint('SplashController: isLoggedIn = ${_storageService.isLoggedIn}');
      if (_storageService.isFirstTime) {
        debugPrint('SplashController: Navigating to ONBOARDING');
        Get.offAllNamed(AppRoutes.ONBOARDING);
      } else if (_storageService.isLoggedIn) {
        debugPrint('SplashController: Navigating to MAIN');
        Get.offAllNamed(AppRoutes.MAIN);
      } else {
        debugPrint('SplashController: Navigating to LOGIN');
        Get.offAllNamed(AppRoutes.LOGIN);
      }
    } catch (e) {
      debugPrint(
          'SplashController: Exception occurred: $e, navigating to ONBOARDING');
      Get.offAllNamed(AppRoutes.ONBOARDING);
    }
  }
}
