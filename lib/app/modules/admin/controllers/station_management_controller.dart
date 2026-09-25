import 'package:get/get.dart';
import '../../../core/services/api_service.dart';
import '../../../core/utils/api_endpoints.dart';
import '../../../data/models/station_model.dart';

class StationManagementController extends GetxController {
  final ApiService _apiService = Get.find();

  final RxList<StationModel> stations = <StationModel>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchStations();
  }

  Future<void> fetchStations() async {
    try {
      isLoading.value = true;
      final response = await _apiService.get(ApiEndpoints.stations);
      final List data = response.data;
      stations.assignAll(data.map((e) => StationModel.fromJson(e)).toList());
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch stations: ${e.toString()}',
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> createStation(StationModel station) async {
    try {
      isLoading.value = true;
      final response = await _apiService.post(ApiEndpoints.stations, data: station.toJson());
      if (response.statusCode == 201 || response.statusCode == 200) {
        await fetchStations();
        return true;
      }
      return false;
    } catch (e) {
      Get.snackbar('Error', 'Failed to create station: ${e.toString()}',
          snackPosition: SnackPosition.BOTTOM);
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> updateStation(int id, StationModel station) async {
    try {
      isLoading.value = true;
      final response = await _apiService.put(
        '/stations/$id',
        data: station.toJson(),
      );
      if (response.statusCode == 200) {
        await fetchStations();
        return true;
      }
      return false;
    } catch (e) {
      Get.snackbar('Error', 'Failed to update station: ${e.toString()}',
          snackPosition: SnackPosition.BOTTOM);
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> deleteStation(int id) async {
    try {
      isLoading.value = true;
      final response = await _apiService.delete('/stations/$id');
      if (response.statusCode == 200 || response.statusCode == 204) {
        await fetchStations();
        return true;
      }
      return false;
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete station: ${e.toString()}',
          snackPosition: SnackPosition.BOTTOM);
      return false;
    } finally {
      isLoading.value = false;
    }
  }
}
