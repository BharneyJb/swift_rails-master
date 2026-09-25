import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../config/theme/app_colors.dart';
import '../controllers/train_management_controller.dart';
import '../../../data/models/train_model.dart';

class ManageTrainsView extends GetView<TrainManagementController> {
  const ManageTrainsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Trains'),
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.trains.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.trains.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.train, size: 64, color: AppColors.textSecondary),
                const SizedBox(height: 16),
                const Text('No trains found'),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => _showTrainForm(context),
                  child: const Text('Add First Train'),
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
                itemCount: controller.trains.length,
                itemBuilder: (context, index) {
                  final train = controller.trains[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      leading: const Icon(Icons.train),
                      title: Text(train.trainName),
                      subtitle: Text('No. ${train.trainNumber} | ${train.trainType}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            onPressed: () => _showTrainForm(context, train: train),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _confirmDelete(train.id),
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
            onPressed: () => _showTrainForm(context),
            child: const Text('Add New Train'),
          ),
        ),
      ),
    );
  }

  void _confirmDelete(int id) {
    Get.defaultDialog(
      title: 'Confirm Delete',
      middleText: 'Are you sure you want to delete this train? This action cannot be undone.',
      textConfirm: 'Delete',
      textCancel: 'Cancel',
      confirmTextColor: Colors.white,
      buttonColor: Colors.red,
      onConfirm: () async {
        final success = await controller.deleteTrain(id);
        if (success) {
          Get.back();
          Get.snackbar('Success', 'Train deleted successfully');
        }
      },
    );
  }

  void _showTrainForm(BuildContext context, {TrainModel? train}) {
    final isEditing = train != null;
    final nameController = TextEditingController(text: train?.trainName);
    final numberController = TextEditingController(text: train?.trainNumber);
    final typeController = TextEditingController(text: train?.trainType);

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
                isEditing ? 'Edit Train' : 'Add New Train',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Train Name', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: numberController,
                decoration: const InputDecoration(labelText: 'Train Number', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: typeController,
                decoration: const InputDecoration(labelText: 'Train Type (e.g. Express)', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    final newTrain = TrainModel(
                      id: train?.id ?? 0,
                      trainName: nameController.text,
                      trainNumber: numberController.text,
                      trainType: typeController.text,
                    );

                    bool success;
                    if (isEditing) {
                      success = await controller.updateTrain(train!.id, newTrain);
                    } else {
                      success = await controller.createTrain(newTrain);
                    }

                    if (success) {
                      Get.back();
                      Get.snackbar('Success', isEditing ? 'Train updated' : 'Train created');
                    }
                  },
                  child: Text(isEditing ? 'Update Train' : 'Create Train'),
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
