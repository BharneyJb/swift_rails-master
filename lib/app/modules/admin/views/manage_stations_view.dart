import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../config/theme/app_colors.dart';
import '../controllers/station_management_controller.dart';
import '../../../data/models/station_model.dart';

class ManageStationsView extends GetView<StationManagementController> {
  const ManageStationsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Stations'),
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.stations.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.stations.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.location_city, size: 64, color: AppColors.textSecondary),
                const SizedBox(height: 16),
                const Text('No stations found'),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => _showStationForm(context),
                  child: const Text('Add First Station'),
                ),
              ],
            ),
          );
        }

        return Column(
          children: [
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: controller.stations.length,
                itemBuilder: (context, index) {
                  final station = controller.stations[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      leading: const Icon(Icons.location_on),
                      title: Text(station.name),
                      subtitle: Text('${station.city} | ${station.code}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            onPressed: () => _showStationForm(context, station: station),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _confirmDelete(station.id),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            _buildBottomBar(context),
          ],
        );
      }),
    );
  }

  Widget _buildBottomBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () => _showStationForm(context),
            child: const Text('Add New Station'),
          ),
        ),
      ),
    );
  }

  void _confirmDelete(int id) {
    Get.defaultDialog(
      title: 'Confirm Delete',
      middleText: 'Are you sure you want to delete this station? This action cannot be undone.',
      textConfirm: 'Delete',
      textCancel: 'Cancel',
      confirmTextColor: Colors.white,
      buttonColor: Colors.red,
      onConfirm: () async {
        final success = await controller.deleteStation(id);
        if (success) {
          Get.back();
          Get.snackbar('Success', 'Station deleted successfully');
        }
      },
    );
  }

  void _showStationForm(BuildContext context, {StationModel? station}) {
    final isEditing = station != null;
    final nameController = TextEditingController(text: station?.name);
    final cityController = TextEditingController(text: station?.city);
    final codeController = TextEditingController(text: station?.code);
    final addressController = TextEditingController(text: station?.address);

    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isEditing ? 'Edit Station' : 'Add New Station',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Station Name', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: cityController,
                decoration: const InputDecoration(labelText: 'City', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: codeController,
                decoration: const InputDecoration(labelText: 'Station Code', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: addressController,
                decoration: const InputDecoration(labelText: 'Address (Optional)', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    final newStation = StationModel(
                      id: station?.id ?? 0,
                      name: nameController.text,
                      city: cityController.text,
                      code: codeController.text,
                      address: addressController.text,
                    );

                    bool success;
                    if (isEditing) {
                      success = await controller.updateStation(station.id, newStation);
                    } else {
                      success = await controller.createStation(newStation);
                    }

                    if (success) {
                      Get.back();
                      Get.snackbar('Success', isEditing ? 'Station updated' : 'Station created');
                    }
                  },
                  child: Text(isEditing ? 'Update Station' : 'Create Station'),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
