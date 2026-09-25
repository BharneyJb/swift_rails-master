import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../config/theme/app_colors.dart';
import '../../../routes/app_routes.dart';
import '../controllers/booking_controller.dart';
import '../../../data/models/schedule_model.dart';

class ClassSelectionView extends StatefulWidget {
  const ClassSelectionView({super.key});

  @override
  State<ClassSelectionView> createState() => _ClassSelectionViewState();
}

class _ClassSelectionViewState extends State<ClassSelectionView> {
  final BookingController controller = Get.find<BookingController>();

  @override
  void initState() {
    super.initState();
    final schedule = Get.arguments as ScheduleModel?;
    if (schedule != null) {
      controller.initForSchedule(schedule);
    } else {
      Get.snackbar('Error', 'No schedule selected', snackPosition: SnackPosition.BOTTOM);
      Get.back();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Travel Class'),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.fareOptions.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.info_outline, size: 64, color: AppColors.textSecondary),
                const SizedBox(height: 16),
                const Text('No travel classes available'),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => controller.fetchFareOptions(),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(20),
          itemCount: controller.fareOptions.length,
          itemBuilder: (context, index) {
            final travelClass = controller.fareOptions[index];
            final isSelected = controller.selectedTravelClass.value == travelClass;

            return Card(
              margin: const EdgeInsets.only(bottom: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(
                  color: isSelected ? AppColors.primary : AppColors.border,
                  width: isSelected ? 2 : 1,
                ),
              ),
              child: InkWell(
                onTap: () {
                  controller.selectTravelClass(travelClass);
                  Get.toNamed(AppRoutes.SEAT_SELECTION);
                },
                borderRadius: BorderRadius.circular(16),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              travelClass.travelClass,
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: isSelected ? AppColors.primary : null,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Icon(Icons.person, size: 16, color: AppColors.textSecondary),
                                const SizedBox(width: 4),
                                Text(
                                  'Adult: ₦${travelClass.adultAmount.toStringAsFixed(0)}',
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                                const SizedBox(width: 16),
                                const Icon(Icons.child_care, size: 16, color: AppColors.textSecondary),
                                const SizedBox(width: 4),
                                Text(
                                  'Child: ₦${travelClass.childAmount.toStringAsFixed(0)}',
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      if (isSelected)
                        const Icon(Icons.check_circle, color: AppColors.primary)
                      else
                        const Icon(Icons.radio_button_unchecked, color: AppColors.textSecondary),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
