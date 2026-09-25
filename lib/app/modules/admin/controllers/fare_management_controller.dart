import 'package:get/get.dart';
import '../../../core/services/api_service.dart';
import '../../../core/utils/api_endpoints.dart';
import '../../../data/models/travel_class_model.dart';

class FareManagementController extends GetxController {
  final ApiService _apiService = Get.find();

  final RxList<TravelClassModel> fares = <TravelClassModel>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchFares();
  }

  Future<void> fetchFares() async {
    try {
      isLoading.value = true;
      final response = await _apiService.get(ApiEndpoints.fares);
      final List data = response.data;
      fares.assignAll(data.map((e) => TravelClassModel.fromJson(e)).toList());
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch fares: ${e.toString()}',
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> updateFare(TravelClassModel fare) async {
    try {
      isLoading.value = true;
      final response = await _apiService.put(
        '/fares/${fare.travelClassId}',
        data: fare.toJson(),
      );
      if (response.statusCode == 200) {
        await fetchFares();
        return true;
      }
      return false;
    } catch (e) {
      Get.snackbar('Error', 'Failed to update fare: ${e.toString()}',
          snackPosition: SnackPosition.BOTTOM);
      return false;
    } finally {
      isLoading.value = false;
    }
  }
}
