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
  final RxBool isLoadingProfile = false.obs;

  // Edit Profile Form
  final editProfileFormKey = GlobalKey<FormState>();
  final firstNameController = TextEditingController();
  final surnameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final ninController = TextEditingController();
  final RxString selectedGender = ''.obs;
  final Rx<DateTime?> selectedDob = Rx<DateTime?>(null);
  final RxBool isUpdating = false.obs;
  final RxString selectedImagePath = RxString('');

  @override
  void onInit() {
    super.onInit();
    // 1. Load whatever is cached in storage immediately (fast, no flicker)
    _loadFromStorage();
    // 2. Then refresh from the API in the background
    fetchFullProfile();
  }

  // ─── Data Loading ───────────────────────────────────────────────────────────

  void _loadFromStorage() {
    final userData = _storageService.userData;
    if (userData != null) {
      currentUser.value = UserModel.fromJson(userData);
      _populateEditForm();
    }
  }

  /// Calls GET /customers to get the latest profile from the server.
  /// Updates storage and the reactive [currentUser] on success.
  Future<void> fetchFullProfile() async {
    try {
      isLoadingProfile.value = true;
      final response = await _apiService.get(ApiEndpoints.profile);

      if (response.statusCode == 200) {
        final profileData = response.data as Map<String, dynamic>;
        await _storageService.saveUserData(profileData);
        currentUser.value = UserModel.fromJson(profileData);
        _populateEditForm();
      }
    } catch (e) {
      debugPrint('ProfileController: fetchFullProfile error: $e');
      // Non-fatal — cached data is still shown
    } finally {
      isLoadingProfile.value = false;
    }
  }

  void _populateEditForm() {
    final u = currentUser.value;
    if (u == null) return;
    firstNameController.text = u.firstName;
    surnameController.text = u.surname;
    emailController.text = u.email;
    phoneController.text = u.phone ?? '';
    ninController.text = u.nin ?? '';
    selectedGender.value = u.gender ?? '';
    if (u.dob != null && u.dob!.isNotEmpty) {
      selectedDob.value = DateTime.tryParse(u.dob!);
    }
    selectedImagePath.value = u.avatar ?? '';
  }

  // ─── Update Profile ─────────────────────────────────────────────────────────

  Future<void> updateProfile() async {
    if (!editProfileFormKey.currentState!.validate()) return;

    try {
      isUpdating.value = true;

      final Map<String, dynamic> payload = {
        'firstName': firstNameController.text.trim(),
        'surname': surnameController.text.trim(),
        'email': emailController.text.trim(),
        'phone': phoneController.text.trim(),
      };

      if (selectedGender.value.isNotEmpty) {
        payload['gender'] = selectedGender.value;
      }
      if (selectedDob.value != null) {
        payload['dob'] = _formatDate(selectedDob.value!);
      }
      if (ninController.text.trim().isNotEmpty) {
        payload['nin'] = ninController.text.trim();
      }

      final response = await _apiService.put(
        ApiEndpoints.updateProfile,
        data: payload,
      );

      if (response.statusCode == 200) {
        final responseData = response.data as Map<String, dynamic>;
        // The backend returns { message, user: {...} }
        final updatedUser = responseData.containsKey('user')
            ? responseData['user'] as Map<String, dynamic>
            : responseData;

        await _storageService.saveUserData(updatedUser);
        currentUser.value = UserModel.fromJson(updatedUser);
        _populateEditForm();

        // Propagate to HomeController if it is active
        try {
          final home = Get.find<dynamic>(tag: 'home');
          if (home != null && home.runtimeType.toString().contains('Home')) {
            home.loadUserData();
          }
        } catch (_) {
          // HomeController may not be registered — that's fine
        }

        Get.back();
        Get.snackbar(
          'Profile Updated',
          'Your profile has been updated successfully.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Update Failed',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isUpdating.value = false;
    }
  }

  // ─── Helpers ────────────────────────────────────────────────────────────────

  String _formatDate(DateTime date) =>
      '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

  Future<void> pickImage() async {
    Get.snackbar(
      'Coming Soon',
      'Avatar upload will be available in a future update',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  Future<void> logout() async {
    await _storageService.clearSession();
    Get.offAllNamed(AppRoutes.LOGIN);
  }

  @override
  void onClose() {
    firstNameController.dispose();
    surnameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    ninController.dispose();
    super.onClose();
  }
}
