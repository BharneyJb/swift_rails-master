import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/services/storage_service.dart';
import '../../../routes/app_routes.dart';

class OnboardingController extends GetxController {
  final StorageService _storageService = Get.find();
  final PageController pageController = PageController();
  final RxInt currentPage = 0.obs;

  final List<OnboardingModel> pages = [
    OnboardingModel(
      title: 'Book Your Journey',
      description: 'Search and book train tickets easily with just a few taps',
      image: 'assets/images/Frame.png',
    ),
    OnboardingModel(
      title: 'Choose Your Seat',
      description: 'Select your preferred seat from available options',
      image: 'assets/images/Frame2.png',
    ),
    OnboardingModel(
      title: 'Travel with Ease',
      description: 'Get your QR ticket and enjoy a seamless travel experience',
      image: 'assets/images/Frame4.png',
    ),
  ];

  void onPageChanged(int index) {
    currentPage.value = index;
  }

  void nextPage() {
    if (currentPage.value < pages.length - 1) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      completeOnboarding();
    }
  }

  void skipOnboarding() {
    completeOnboarding();
  }

  void completeOnboarding() async {
    await _storageService.setFirstTime(false);
    Get.offAllNamed(AppRoutes.LOGIN);
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}

class OnboardingModel {
  final String title;
  final String description;
  final String image;

  OnboardingModel({
    required this.title,
    required this.description,
    required this.image,
  });
}
