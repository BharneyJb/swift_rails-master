import 'package:get/get.dart';

class NotificationsController extends GetxController {
  final RxList notifications = [].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchNotifications();
  }

  Future<void> fetchNotifications() async {
    isLoading.value = true;
    // Fetch from API
    await Future.delayed(const Duration(seconds: 1));
    notifications.value = [];
    isLoading.value = false;
  }
}
