import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MainController extends GetxController {
  final RxInt currentIndex = 0.obs;

  DateTime? _lastBackPressTime;

  void changePage(int index) {
    currentIndex.value = index;
  }

  /// Returns true when the app should exit (second back-press within 2 s).
  Future<bool> onHomeBackPress() async {
    final now = DateTime.now();
    if (_lastBackPressTime == null ||
        now.difference(_lastBackPressTime!) > const Duration(seconds: 2)) {
      _lastBackPressTime = now;
      Get.snackbar(
        '',
        'Press back again to exit',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.black87,
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
        duration: const Duration(seconds: 2),
        titleText: const SizedBox.shrink(),
        messageText: const Text(
          'Press back again to exit',
          style: TextStyle(color: Colors.white),
        ),
      );
      return false;
    }
    return true;
  }
}
