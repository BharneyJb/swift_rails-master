import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../../../routes/app_routes.dart';
import '../../../config/theme/app_colors.dart';
import '../controllers/booking_controller.dart';
import '../../../../views/utils/form_validators.dart';

class PassengerDetailsView extends GetView<BookingController> {
  const PassengerDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = Get.put(GlobalKey<FormState>());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Passenger Details'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Booking Summary Card
            Obx(() => _buildSummaryCard(context)),
            const SizedBox(height: 32),

            Text(
              'Passenger Information',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 24),

            Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Passenger Type Dropdown
                  Obx(() => DropdownButtonFormField<String>(
                    initialValue: controller.passengerType.value,
                    decoration: const InputDecoration(
                      labelText: 'Passenger Type',
                      prefixIcon: Icon(Iconsax.user),
                    ),
                    items: ['Adult', 'Child'].map((type) => DropdownMenuItem(
                      value: type,
                      child: Text(type),
                    )).toList(),
                    onChanged: (value) => controller.passengerType.value = value!,
                  )),
                  const SizedBox(height: 16),

                  // Phone Number
                  TextFormField(
                    controller: controller.phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      labelText: 'Phone Number',
                      hintText: '08012345678',
                      prefixIcon: Icon(Iconsax.call),
                    ),
                    validator: FormValidators.phone,
                    onChanged: (val) => controller.phone.value = val,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                  ),
                  const SizedBox(height: 16),

                  // Email
                  TextFormField(
                    controller: controller.emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      hintText: 'name@example.com',
                      prefixIcon: Icon(Iconsax.sms),
                    ),
                    validator: FormValidators.email,
                    onChanged: (val) => controller.email.value = val,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                  ),
                  const SizedBox(height: 16),

                  // NIN
                  TextFormField(
                    controller: controller.ninController,
                    decoration: const InputDecoration(
                      labelText: 'National Identification Number (NIN)',
                      hintText: '11-digit NIN',
                      prefixIcon: Icon(Iconsax.document_text),
                    ),
                    validator: (val) => (val == null || val.length < 11) ? 'Please enter a valid NIN' : null,
                    onChanged: (val) => controller.nin.value = val,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                  ),
                  const SizedBox(height: 32),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (formKey.currentState?.validate() ?? false) {
                          Get.toNamed(AppRoutes.PAYMENT);
                        }
                      },
                      child: const Text('Continue to Payment'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard(BuildContext context) {
    final schedule = controller.selectedSchedule.value;
    final travelClass = controller.selectedTravelClass.value;
    final seat = controller.selectedSeat.value;
    final coach = controller.selectedCoach.value;

    if (schedule == null || travelClass == null || seat == null) {
      return const SizedBox.shrink();
    }

    return Card(
      color: AppColors.primary.withValues(alpha: 0.05),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: AppColors.primary.withValues(alpha: 0.2)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Booking Summary',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
                const Icon(Icons.info_outline, size: 20, color: AppColors.primary),
              ],
            ),
            const Divider(height: 24),
            _summaryRow(context, 'Route', '${schedule.from} → ${schedule.to}'),
            _summaryRow(context, 'Train', schedule.trainName),
            _summaryRow(context, 'Coach', coach?.code ?? 'N/A'),
            _summaryRow(context, 'Seat', seat.code),
            _summaryRow(context, 'Class', travelClass.travelClass),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total Fare',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '₦${controller.totalPrice.toStringAsFixed(0)}',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _summaryRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary)),
          Text(value, style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}
