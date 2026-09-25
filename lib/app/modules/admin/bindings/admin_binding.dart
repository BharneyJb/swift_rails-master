import 'package:get/get.dart';
import '../controllers/admin_controller.dart';
import '../controllers/train_management_controller.dart';
import '../controllers/station_management_controller.dart';
import '../controllers/booking_management_controller.dart';
import '../controllers/fare_management_controller.dart';

class AdminBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AdminController>(() => AdminController());
    Get.lazyPut<TrainManagementController>(() => TrainManagementController());
    Get.lazyPut<StationManagementController>(() => StationManagementController());
    Get.lazyPut<BookingManagementController>(() => BookingManagementController());
    Get.lazyPut<FareManagementController>(() => FareManagementController());
  }
}
