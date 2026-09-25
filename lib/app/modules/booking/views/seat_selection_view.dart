import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../config/theme/app_colors.dart';
import '../../../routes/app_routes.dart';
import '../controllers/booking_controller.dart';
import '../../../data/models/seat_model.dart';
import '../../../data/models/coach_model.dart';

class SeatSelectionView extends GetView<BookingController> {
  const SeatSelectionView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Seat'),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.coachesWithSeats.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.event_seat, size: 64, color: AppColors.textSecondary),
                const SizedBox(height: 16),
                const Text('No seats available for this class'),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => controller.fetchSeatsForClass(),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        return Column(
          children: [
            // Coach Selector Tabs
            Expanded(
              child: DefaultTabController(
                length: controller.coachesWithSeats.length,
                child: Column(
                  children: [
                    TabBar(
                      isScrollable: true,
                      labelColor: AppColors.primary,
                      unselectedLabelColor: AppColors.textSecondary,
                      indicatorColor: AppColors.primary,
                      tabs: controller.coachesWithSeats.map((coach) => Tab(text: coach.code)).toList(),
                    ),
                    Expanded(
                      child: TabBarView(
                        children: controller.coachesWithSeats.map((coach) => _buildCoachSeats(context, coach)).toList(),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Bottom Bar
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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Selected Seat',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                Obx(() => Text(
                  controller.selectedSeat.value?.code ?? 'None',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                )),
                Obx(() => Text(
                  'Total: ₦${controller.totalPrice.toStringAsFixed(0)}',
                  style: Theme.of(context).textTheme.bodyMedium,
                )),
              ],
            ),
            Obx(() => ElevatedButton(
              onPressed: controller.selectedSeat.value == null
                  ? null
                  : () => Get.toNamed(AppRoutes.PASSENGER_DETAILS),
              child: const Text('Continue'),
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildCoachSeats(BuildContext context, CoachModel coach) {
    final seats = coach.seats;

    // Group seats into rows (assuming 4 seats per row: A, B, C, D)
    // This is a simplification; in a real app we'd use the code to determine position
    List<List<SeatModel>> rows = [];
    for (var i = 0; i < seats.length; i += 4) {
      rows.add(seats.sublist(i, i + 4 > seats.length ? seats.length : i + 4));
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          _buildLegend(context),
          const SizedBox(height: 32),
          // Train front indicator
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.border,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text('FRONT', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(height: 32),
          ...rows.map((row) => Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildSeat(row.length > 0 ? row[0] : null),
                if (row.length > 1) _buildSeat(row[1]),
                const SizedBox(width: 40), // Aisle
                if (row.length > 2) _buildSeat(row[2]),
                if (row.length > 3) _buildSeat(row[3]),
              ],
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildSeat(SeatModel? seat) {
    if (seat == null) return const SizedBox(width: 48);

    return Obx(() {
      final isSelected = controller.selectedSeat.value?.id == seat.id;
      final isAvailable = seat.status == 'Available';

      return GestureDetector(
        onTap: isAvailable ? () => controller.selectSeat(seat) : null,
        child: Container(
          width: 48,
          height: 48,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            color: !isAvailable
                ? AppColors.seatBooked
                : isSelected
                    ? AppColors.seatSelected
                    : AppColors.seatAvailable,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text(
              seat.code,
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

  Widget _buildLegend(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildLegendItem(context, 'Available', AppColors.seatAvailable),
        _buildLegendItem(context, 'Selected', AppColors.seatSelected),
        _buildLegendItem(context, 'Unavailable', AppColors.seatBooked),
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
}
