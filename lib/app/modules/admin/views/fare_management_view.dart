import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../config/theme/app_colors.dart';
import '../controllers/fare_management_controller.dart';
import '../../../data/models/travel_class_model.dart';

class FareManagementView extends GetView<FareManagementController> {
  const FareManagementView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fare Management'),
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.fares.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.fares.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.money, size: 64, color: AppColors.textSecondary),
                const SizedBox(height: 16),
                const Text('No fare data available'),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => controller.fetchFares(),
                  child: const Text('Refresh'),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.fares.length,
          itemBuilder: (context, index) {
            final fare = controller.fares[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                title: Text(fare.travelClass, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text('Adult: ₦${fare.adultAmount.toStringAsFixed(0)} | Child: ₦${fare.childAmount.toStringAsFixed(0)}'),
                trailing: IconButton(
                  icon: const Icon(Icons.edit, color: AppColors.primary),
                  onPressed: () => _showFareForm(context, fare),
                ),
              ),
            );
          },
        );
      }),
    );
  }

  void _showFareForm(BuildContext context, TravelClassModel fare) {
    final adultController = TextEditingController(text: fare.adultAmount.toString());
    final childController = TextEditingController(text: fare.childAmount.toString());

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
                'Update Fare: ${fare.travelClass}',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),
              TextField(
                controller: adultController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Adult Amount (₦)', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: childController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Child Amount (₦)', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    final updatedFare = TravelClassModel(
                      travelClassId: fare.travelClassId,
                      travelClass: fare.travelClass,
                      adultAmount: double.tryParse(adultController.text) ?? fare.adultAmount,
                      childAmount: double.tryParse(childController.text) ?? fare.childAmount,
                    );

                    final success = await controller.updateFare(updatedFare);
                    if (success) {
                      Get.back();
                      Get.snackbar('Success', 'Fare updated successfully');
                    }
                  },
                  child: const Text('Update Pricing'),
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
