import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../config/theme/app_colors.dart';
import '../controllers/booking_management_controller.dart';

class ManageBookingsView extends GetView<BookingManagementController> {
  const ManageBookingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Bookings'),
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.bookings.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.bookings.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.book_online, size: 64, color: AppColors.textSecondary),
                const SizedBox(height: 16),
                const Text('No bookings found'),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => controller.fetchBookings(),
                  child: const Text('Refresh'),
                ),
              ],
            ),
          );
        }

        return Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columnSpacing: 20,
                  columns: const [
                    DataColumn(label: Text('ID')),
                    DataColumn(label: Text('Passenger')),
                    DataColumn(label: Text('Train')),
                    DataColumn(label: Text('Date')),
                    DataColumn(label: Text('Status')),
                    DataColumn(label: Text('Action')),
                  ],
                  rows: controller.bookings.map((booking) {
                    return DataRow(
                      cells: [
                        DataCell(Text(booking['id'].toString())),
                        DataCell(Text(booking['passenger_name'] ?? 'N/A')),
                        DataCell(Text(booking['train_name'] ?? 'N/A')),
                        DataCell(Text(booking['booking_date'] ?? 'N/A')),
                        DataCell(
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: booking['status'] == 'Confirmed'
                                  ? Colors.green.withValues(alpha: 0.1)
                                  : Colors.orange.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              booking['status'] ?? 'Pending',
                              style: TextStyle(
                                color: booking['status'] == 'Confirmed' ? Colors.green : Colors.orange,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        DataCell(
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _confirmCancel(booking['id']),
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  void _confirmCancel(dynamic id) {
    Get.defaultDialog(
      title: 'Cancel Booking',
      middleText: 'Are you sure you want to cancel booking #$id?',
      textConfirm: 'Cancel',
      textCancel: 'No',
      confirmTextColor: Colors.white,
      buttonColor: Colors.red,
      onConfirm: () async {
        final success = await controller.cancelBooking(id as int);
        if (success) {
          Get.back();
          Get.snackbar('Success', 'Booking cancelled successfully');
        }
      },
    );
  }
}
