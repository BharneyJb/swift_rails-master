import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/services/api_service.dart';
import '../../../core/services/storage_service.dart';
import '../../../core/utils/api_endpoints.dart';
import '../../../data/models/user_model.dart';
import '../../../routes/app_routes.dart';

class ProfileController extends GetxController {
  final ApiService _apiService = Get.find();
  final StorageService _storageService = Get.find();

  final Rx<UserModel?> currentUser = Rx<UserModel?>(null);

  // Edit Profile Form
  final editProfileFormKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final RxBool isUpdating = false.obs;
  final RxString? selectedImagePath = RxString('');

  @override
  void onInit() {
    super.onInit();
    loadUserData();
  }

  void loadUserData() {
    final userData = _storageService.userData;
    if (userData != null) {
      currentUser.value = UserModel.fromJson(userData);
      _populateEditForm();
    }
  }

  void _populateEditForm() {
    if (currentUser.value != null) {
      nameController.text = currentUser.value!.name;
      emailController.text = currentUser.value!.email;
      phoneController.text = currentUser.value?.phone ?? '';
      selectedImagePath?.value = currentUser.value?.avatar ?? '';
    }
  }

  Future<void> updateProfile() async {
    if (!editProfileFormKey.currentState!.validate()) return;

    try {
      isUpdating.value = true;

      final response = await _apiService.put(
        ApiEndpoints.updateProfile,
        data: {
          'name': nameController.text.trim(),
          'email': emailController.text.trim(),
          'phone': phoneController.text.trim(),
        },
      );

      if (response.statusCode == 200) {
        final updatedUserData = response.data['user'];
        await _storageService.saveUserData(updatedUserData);
        loadUserData();

        Get.back();
        Get.snackbar(
          'Success',
          'Profile updated successfully!',
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
      isUpdating.value = false;
    }
  }

  Future<void> pickImage() async {
    // Placeholder for image picker implementation
    // You can integrate image_picker package here
    Get.snackbar(
      'Info',
      'Image picker coming soon',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  Future<void> logout() async {
    await _storageService.logout();
    Get.offAllNamed(AppRoutes.LOGIN);
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    super.onClose();
  }
}
