import 'package:get/get.dart';
import '../../../core/services/storage_service.dart';
import '../../../routes/app_routes.dart';

class SplashController extends GetxController {
  final StorageService _storageService = Get.find();

  @override
  void onInit() {
    super.onInit();
    print('SplashController: onInit called');
    _navigateToNextScreen();
  }

  void _navigateToNextScreen() async {
    print('SplashController: Starting 5 second delay');
    await Future.delayed(const Duration(seconds: 5));
    print('SplashController: Delay completed');

    try {
      print('SplashController: isFirstTime = ${_storageService.isFirstTime}');
      print('SplashController: isLoggedIn = ${_storageService.isLoggedIn}');
      if (_storageService.isFirstTime) {
        print('SplashController: Navigating to ONBOARDING');
        Get.offAllNamed(AppRoutes.ONBOARDING);
      } else if (_storageService.isLoggedIn) {
        print('SplashController: Navigating to MAIN');
        Get.offAllNamed(AppRoutes.MAIN);
      } else {
        print('SplashController: Navigating to LOGIN');
        Get.offAllNamed(AppRoutes.LOGIN);
      }
    } catch (e) {
      print(
          'SplashController: Exception occurred: $e, navigating to ONBOARDING');
      Get.offAllNamed(AppRoutes.ONBOARDING);
    }
  }
}
