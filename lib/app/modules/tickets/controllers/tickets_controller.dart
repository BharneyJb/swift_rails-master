import 'package:get/get.dart';
import '../../../core/services/api_service.dart';
import '../../../core/utils/api_endpoints.dart';

class TicketsController extends GetxController {
  final ApiService _apiService = Get.find();

  final RxList tickets = [].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchTickets();
  }

  Future<void> fetchTickets() async {
    try {
      isLoading.value = true;
      final response = await _apiService.get(ApiEndpoints.bookings);
      
      if (response.statusCode == 200) {
        tickets.value = response.data['bookings'] ?? [];
      }
    } catch (e) {
      print('Error fetching tickets: $e');
      // Mock data for development
      tickets.value = [];
    } finally {
      isLoading.value = false;
    }
  }
}
