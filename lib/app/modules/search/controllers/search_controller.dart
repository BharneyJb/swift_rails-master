import 'package:flutter/foundation.dart';
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
        // API may return a bare array or {stations: [...]}
        final dynamic raw = response.data;
        final List<dynamic> data = raw is List
            ? raw
            : (raw is Map ? (raw['stations'] ?? raw['data'] ?? []) : []);
        stations.value =
            data.map((e) => StationModel.fromJson(e as Map<String, dynamic>)).toList();
      }
    } catch (e) {
      debugPrint('Error fetching stations: $e');
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
        final dynamic raw = response.data;
        final List<dynamic> data = raw is List
            ? raw
            : (raw is Map ? (raw['schedules'] ?? raw['data'] ?? []) : []);
        searchResults.value =
            data.map((e) => ScheduleModel.fromJson(e as Map<String, dynamic>)).toList();
      }
    } catch (e) {
      debugPrint('Error searching trains: $e');
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

  Future<void> searchByCriteria({
    required String fromName,
    required String toName,
    required DateTime date,
  }) async {
    final from = _findStationByName(fromName);
    final to = _findStationByName(toName);

    if (from == null || to == null) {
      Get.snackbar(
        'Error',
        'Could not resolve stations for the selected route',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    fromStation.value = from;
    toStation.value = to;
    selectedDate.value = date;

    await searchTrains();
  }

  StationModel? _findStationByName(String name) {
    return stations.firstWhereOrNull(
      (s) => s.name.toLowerCase().trim() == name.toLowerCase().trim(),
    );
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
