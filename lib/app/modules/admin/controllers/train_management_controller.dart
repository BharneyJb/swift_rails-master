import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/services/api_service.dart';
import '../../../core/utils/api_endpoints.dart';
import '../../../data/models/train_model.dart';

class TrainManagementController extends GetxController {
  final ApiService _apiService = Get.find();

  final RxList<TrainModel> trains = <TrainModel>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchTrains();
  }

  Future<void> fetchTrains() async {
    try {
      isLoading.value = true;
      final response = await _apiService.get(ApiEndpoints.trains);
      final List data = response.data;
      trains.assignAll(data.map((e) => TrainModel.fromJson(e)).toList());
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch trains: ${e.toString()}',
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> createTrain(TrainModel train) async {
    try {
      isLoading.value = true;
      final response = await _apiService.post(ApiEndpoints.trains, data: train.toJson());
      if (response.statusCode == 201 || response.statusCode == 200) {
        await fetchTrains();
        return true;
      }
      return false;
    } catch (e) {
      Get.snackbar('Error', 'Failed to create train: ${e.toString()}',
          snackPosition: SnackPosition.BOTTOM);
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> updateTrain(int id, TrainModel train) async {
    try {
      isLoading.value = true;
      final response = await _apiService.put(
        '/trains/$id', // Using direct path as endpoint is generic
        data: train.toJson(),
      );
      if (response.statusCode == 200) {
        await fetchTrains();
        return true;
      }
      return false;
    } catch (e) {
      Get.snackbar('Error', 'Failed to update train: ${e.toString()}',
          snackPosition: SnackPosition.BOTTOM);
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> deleteTrain(int id) async {
    try {
      isLoading.value = true;
      final response = await _apiService.delete('/trains/$id');
      if (response.statusCode == 200 || response.statusCode == 204) {
        await fetchTrains();
        return true;
      }
      return false;
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete train: ${e.toString()}',
          snackPosition: SnackPosition.BOTTOM);
      return false;
    } finally {
      isLoading.value = false;
    }
  }
}
