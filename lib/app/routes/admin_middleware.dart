import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'app_routes.dart';
import '../core/services/storage_service.dart';

class AdminMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    final storage = Get.find<StorageService>();
    final userData = storage.userData;

    // Extract role from stored user data
    final String role = userData?['role'] ?? 'customer';

    if (role != 'admin') {
      Get.snackbar(
        'Access Denied',
        'You do not have administrative privileges to access this page.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return RouteSettings(name: AppRoutes.HOME);
    }

    return null; // Allow access
  }
}
