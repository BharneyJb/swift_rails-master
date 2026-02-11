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

  Future<void> fetchUpcomingSchedules() async {
    try {
      isLoading.value = true;
      final response = await _apiService.get(ApiEndpoints.schedules);
      
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['schedules'] ?? [];
        upcomingSchedules.value = data.map((e) => ScheduleModel.fromJson(e)).toList();
      }
    } catch (e) {
      print('Error fetching schedules: $e');
      // Use mock data for development
      _loadMockSchedules();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchPopularRoutes() async {
    try {
      final response = await _apiService.get('${ApiEndpoints.schedules}/popular');
      
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['routes'] ?? [];
        popularRoutes.value = data.map((e) => ScheduleModel.fromJson(e)).toList();
      }
    } catch (e) {
      print('Error fetching popular routes: $e');
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

  void _loadMockSchedules() {
    // Mock data for development
    upcomingSchedules.value = [
      ScheduleModel(
        id: 1,
        trainName: 'Morning Express',
        from: 'Lagos',
        to: 'Ibadan',
        departureTime: DateTime.now().add(const Duration(hours: 2)),
        arrivalTime: DateTime.now().add(const Duration(hours: 4)),
        price: 5000,
        availableSeats: 45,
      ),
      ScheduleModel(
        id: 2,
        trainName: 'Evening Commuter',
        from: 'Abuja',
        to: 'Kaduna',
        departureTime: DateTime.now().add(const Duration(hours: 5)),
        arrivalTime: DateTime.now().add(const Duration(hours: 7)),
        price: 3500,
        availableSeats: 32,
      ),
    ];
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
