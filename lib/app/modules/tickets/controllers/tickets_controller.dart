import 'package:flutter/foundation.dart';
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
        // API may return a bare array or {bookings: [...]}
        final dynamic raw = response.data;
        if (raw is List) {
          tickets.value = raw;
        } else if (raw is Map) {
          tickets.value = raw['bookings'] ?? raw['data'] ?? [];
        } else {
          tickets.value = [];
        }
      }
    } catch (e) {
      debugPrint('Error fetching tickets: $e');
      // Keep empty list on error (e.g. 404 = no bookings yet)
      tickets.value = [];
    } finally {
      isLoading.value = false;
    }
  }
}
