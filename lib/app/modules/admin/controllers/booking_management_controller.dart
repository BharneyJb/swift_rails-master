import 'package:get/get.dart';
import '../../../core/services/api_service.dart';
import '../../../core/utils/api_endpoints.dart';

class BookingManagementController extends GetxController {
  final ApiService _apiService = Get.find();

  final RxList<dynamic> bookings = <dynamic>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchBookings();
  }

  Future<void> fetchBookings() async {
    try {
      isLoading.value = true;
      final response = await _apiService.get(ApiEndpoints.bookings);
      final List data = response.data;
      bookings.assignAll(data);
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch bookings: ${e.toString()}',
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> cancelBooking(int id) async {
    try {
      isLoading.value = true;
      final response = await _apiService.delete('/bookings/$id');
      if (response.statusCode == 200 || response.statusCode == 204) {
        await fetchBookings();
        return true;
      }
      return false;
    } catch (e) {
      Get.snackbar('Error', 'Failed to cancel booking: ${e.toString()}',
          snackPosition: SnackPosition.BOTTOM);
      return false;
    } finally {
      isLoading.value = false;
    }
  }
}
