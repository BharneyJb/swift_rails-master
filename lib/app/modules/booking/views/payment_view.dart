import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../config/theme/app_colors.dart';
import '../../../routes/app_routes.dart';
import '../controllers/booking_controller.dart';

class PaymentView extends GetView<BookingController> {
  const PaymentView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Confirm Booking'),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Final Review',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 24),

              _buildBookingSummary(context),
              const SizedBox(height: 32),

              Text(
                'Payment Method',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 16),

              _buildPaymentOption(
                context,
                'Card Payment',
                'Pay with your registered debit/credit card',
                Icons.credit_card,
                true,
              ),
              const SizedBox(height: 12),

              _buildPaymentOption(
                context,
                'Bank Transfer',
                'Receive account details for transfer',
                Icons.account_balance,
                false,
              ),
              const SizedBox(height: 12),

              _buildPaymentOption(
                context,
                'USSD',
                'Generate USSD code for payment',
                Icons.dialpad,
                false,
              ),
              const SizedBox(height: 40),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    final success = await controller.confirmBooking();
                    if (success) {
                      Get.offAllNamed(AppRoutes.PAYMENT_SUCCESS);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text(
                    'Confirm & Book Now',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildBookingSummary(BuildContext context) {
    final schedule = controller.selectedSchedule.value;
    final travelClass = controller.selectedTravelClass.value;
    final seat = controller.selectedSeat.value;
    final coach = controller.selectedCoach.value;

    if (schedule == null || travelClass == null || seat == null) {
      return const Center(child: Text('No booking data available'));
    }

    return Card(
      elevation: 0,
      color: AppColors.primary.withValues(alpha: 0.05),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: AppColors.primary.withValues(alpha: 0.2)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _summaryRow(context, 'Train', schedule.trainName),
            _summaryRow(context, 'Route', '${schedule.from} → ${schedule.to}'),
            _summaryRow(context, 'Date', schedule.departureTime.toString().split(' ')[0]),
            _summaryRow(context, 'Class', travelClass.travelClass),
            _summaryRow(context, 'Coach', coach?.code ?? 'N/A'),
            _summaryRow(context, 'Seat', seat.code),
            const Divider(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total Amount',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
                Text(
                  '₦${controller.totalPrice.toStringAsFixed(0)}',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
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

  Widget _buildPaymentOption(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    bool isSelected,
  ) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isSelected ? AppColors.primary : AppColors.border,
          width: isSelected ? 2 : 1,
        ),
      ),
      child: ListTile(
        leading: Icon(icon, color: isSelected ? AppColors.primary : AppColors.textSecondary, size: 28),
        title: Text(title, style: TextStyle(fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
        subtitle: Text(subtitle),
        trailing: isSelected
          ? const Icon(Icons.check_circle, color: AppColors.primary)
          : const Icon(Icons.radio_button_unchecked, color: AppColors.textSecondary),
      ),
    );
  }
}
