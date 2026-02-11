import 'package:get/get.dart';
import '../../../core/services/api_service.dart';
import '../../../core/utils/api_endpoints.dart';
import '../../../data/models/schedule_model.dart';
import '../../../data/models/station_model.dart';

class TrainSearchController extends GetxController {
  final ApiService _apiService = Get.find();

  final RxList<StationModel> stations = <StationModel>[].obs;
  final Rx<StationModel?> fromStation = Rx<StationModel?>(null);
  final Rx<StationModel?> toStation = Rx<StationModel?>(null);
  final Rx<DateTime> selectedDate = DateTime.now().obs;
  final RxList<ScheduleModel> searchResults = <ScheduleModel>[].obs;
  final RxBool isSearching = false.obs;
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
      
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['stations'] ?? [];
        stations.value = data.map((e) => StationModel.fromJson(e)).toList();
      }
    } catch (e) {
      print('Error fetching stations: $e');
      _loadMockStations();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> searchTrains() async {
    if (fromStation.value == null || toStation.value == null) {
      Get.snackbar(
        'Error',
        'Please select both departure and arrival stations',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    try {
      isSearching.value = true;
      final response = await _apiService.get(
        ApiEndpoints.schedulesByRoute(fromStation.value!.id, toStation.value!.id),
        queryParameters: {
          'date': selectedDate.value.toIso8601String(),
        },
      );
      
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['schedules'] ?? [];
        searchResults.value = data.map((e) => ScheduleModel.fromJson(e)).toList();
      }
    } catch (e) {
      print('Error searching trains: $e');
      _loadMockSearchResults();
    } finally {
      isSearching.value = false;
    }
  }

  void swapStations() {
    final temp = fromStation.value;
    fromStation.value = toStation.value;
    toStation.value = temp;
  }

  void selectDate(DateTime date) {
    selectedDate.value = date;
  }

  void _loadMockStations() {
    stations.value = [
      StationModel(id: 1, name: 'Lagos Central', city: 'Lagos', code: 'LOS'),
      StationModel(id: 2, name: 'Ibadan Terminal', city: 'Ibadan', code: 'IBD'),
      StationModel(id: 3, name: 'Abuja Station', city: 'Abuja', code: 'ABJ'),
      StationModel(id: 4, name: 'Kano Junction', city: 'Kano', code: 'KAN'),
      StationModel(id: 5, name: 'Port Harcourt', city: 'Port Harcourt', code: 'PHC'),
    ];
  }

  void _loadMockSearchResults() {
    searchResults.value = [
      ScheduleModel(
        id: 1,
        trainName: 'Express 101',
        from: fromStation.value?.name ?? 'Lagos',
        to: toStation.value?.name ?? 'Ibadan',
        departureTime: selectedDate.value.add(const Duration(hours: 8)),
        arrivalTime: selectedDate.value.add(const Duration(hours: 10)),
        price: 5000,
        availableSeats: 45,
      ),
      ScheduleModel(
        id: 2,
        trainName: 'Business 202',
        from: fromStation.value?.name ?? 'Lagos',
        to: toStation.value?.name ?? 'Ibadan',
        departureTime: selectedDate.value.add(const Duration(hours: 14)),
        arrivalTime: selectedDate.value.add(const Duration(hours: 16)),
        price: 7500,
        availableSeats: 20,
      ),
    ];
  }
}
