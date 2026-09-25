import 'package:get/get.dart';
import '../../../core/services/api_service.dart';
import '../../../core/utils/api_endpoints.dart';

class AdminController extends GetxController {
  final ApiService _apiService = Get.find();

  final RxInt totalTrains = 0.obs;
  final RxInt totalStations = 0.obs;
  final RxInt totalBookings = 0.obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchDashboardSummaries();
  }

  Future<void> fetchDashboardSummaries() async {
    try {
      isLoading.value = true;

      // Perform parallel calls for efficiency
      final results = await Future.wait([
        _apiService.get(ApiEndpoints.trains),
        _apiService.get(ApiEndpoints.stations),
        _apiService.get(ApiEndpoints.bookings),
      ]);

      final trainsData = results[0].data as List;
      final stationsData = results[1].data as List;
      final bookingsData = results[2].data as List;

      totalTrains.value = trainsData.length;
      totalStations.value = stationsData.length;
      totalBookings.value = bookingsData.length;
    } catch (e) {
      Get.snackbar('Error', 'Failed to load dashboard summaries: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }
}
