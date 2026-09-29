import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import '../../../core/services/api_service.dart';
import '../../../core/services/storage_service.dart';
import '../../../core/utils/api_endpoints.dart';
import '../../../data/models/schedule_model.dart';
import '../../../data/models/user_model.dart';

class HomeController extends GetxController {
  final ApiService _apiService = Get.find();
  final StorageService _storageService = Get.find();

  final Rx<UserModel?> currentUser = Rx<UserModel?>(null);
  final RxList<ScheduleModel> upcomingSchedules = <ScheduleModel>[].obs;
  final RxList<ScheduleModel> popularRoutes = <ScheduleModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isRefreshing = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadUserData();
    fetchUpcomingSchedules();
    fetchPopularRoutes();
  }

  void loadUserData() {
    final userData = _storageService.userData;
    if (userData != null) {
      currentUser.value = UserModel.fromJson(userData);
    }
  }

  /// Called by ProfileController after a successful profile update so the
  /// home screen name/avatar updates without a full page reload.
  void refreshUser() => loadUserData();

  Future<void> fetchUpcomingSchedules() async {
    try {
      isLoading.value = true;
      // /schedules/upcoming returns only today's trains that:
      //   • depart after NOW
      //   • have at least one available seat on their train
      final response = await _apiService.get(ApiEndpoints.schedulesUpcoming);

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data is List
            ? response.data as List<dynamic>
            : [];
        upcomingSchedules.value = data
            .map((e) => ScheduleModel.fromJson(e as Map<String, dynamic>))
            .toList();
      }
    } catch (e) {
      debugPrint('Error fetching upcoming schedules: $e');
      // Leave list empty on error — don't show stale mock data
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchPopularRoutes() async {
    try {
      final response = await _apiService.get('${ApiEndpoints.schedules}/popular');

      if (response.statusCode == 200) {
        final dynamic raw = response.data;
        final List<dynamic> data = raw is List
            ? raw
            : (raw is Map ? (raw['routes'] ?? raw['schedules'] ?? raw['data'] ?? []) : []);
        popularRoutes.value =
            data.map((e) => ScheduleModel.fromJson(e as Map<String, dynamic>)).toList();
      }
    } catch (e) {
      debugPrint('Error fetching popular routes: $e');
      _loadMockPopularRoutes();
    }
  }

  Future<void> refreshData() async {
    isRefreshing.value = true;
    await Future.wait([
      fetchUpcomingSchedules(),
      fetchPopularRoutes(),
    ]);
    isRefreshing.value = false;
  }


  void _loadMockPopularRoutes() {
    popularRoutes.value = [
      ScheduleModel(
        id: 3,
        trainName: 'Business Class',
        from: 'Lagos',
        to: 'Kano',
        departureTime: DateTime.now().add(const Duration(days: 1)),
        arrivalTime: DateTime.now().add(const Duration(days: 1, hours: 8)),
        price: 12000,
        availableSeats: 20,
      ),
    ];
  }
}
