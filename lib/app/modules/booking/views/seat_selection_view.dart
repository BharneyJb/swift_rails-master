import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../config/theme/app_colors.dart';
import '../../../routes/app_routes.dart';
import '../controllers/booking_controller.dart';

class SeatSelectionView extends GetView<BookingController> {
  const SeatSelectionView({super.key});

  @override
  Widget build(BuildContext context) {
    final schedule = Get.arguments;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Seats'),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // Seat Legend
                  _buildLegend(context),
                  const SizedBox(height: 24),
                  
                  // Seat Layout
                  _buildSeatLayout(schedule?.price ?? 5000),
                ],
              ),
            ),
          ),
          
          // Bottom Bar
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Total Price',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                          Obx(() => Text(
                            '₦${controller.totalPrice.value.toStringAsFixed(0)}',
                            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                              color: AppColors.primary,
                            ),
                          )),
                        ],
                      ),
                      Obx(() => ElevatedButton(
                        onPressed: controller.selectedSeats.isEmpty
                            ? null
                            : () => Get.toNamed(AppRoutes.PASSENGER_DETAILS, arguments: schedule),
                        child: Text('Continue (${controller.selectedSeats.length})'),
                      )),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegend(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildLegendItem(context, 'Available', AppColors.seatAvailable),
        _buildLegendItem(context, 'Selected', AppColors.seatSelected),
        _buildLegendItem(context, 'Booked', AppColors.seatBooked),
      ],
    );
  }

  Widget _buildLegendItem(BuildContext context, String label, Color color) {
    return Row(
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(6),
          ),
        ),
        const SizedBox(width: 8),
        Text(label, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }

  Widget _buildSeatLayout(double price) {
    return Column(
      children: List.generate(10, (row) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildSeat('${row + 1}A', price),
              _buildSeat('${row + 1}B', price),
              const SizedBox(width: 40), // Aisle
              _buildSeat('${row + 1}C', price),
              _buildSeat('${row + 1}D', price),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildSeat(String seatNumber, double price) {
    return Obx(() {
      final isSelected = controller.isSeatSelected(seatNumber);
      final isBooked = seatNumber.endsWith('A') && int.parse(seatNumber.substring(0, seatNumber.length - 1)) % 3 == 0;
      
      return GestureDetector(
        onTap: isBooked ? null : () => controller.toggleSeat(seatNumber, price),
        child: Container(
          width: 48,
          height: 48,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            color: isBooked
                ? AppColors.seatBooked
                : isSelected
                    ? AppColors.seatSelected
                    : AppColors.seatAvailable,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text(
              seatNumber,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      );
    });
  }
}
