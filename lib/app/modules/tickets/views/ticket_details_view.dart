import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:iconsax/iconsax.dart';
import '../../../config/theme/app_colors.dart';

class TicketDetailsView extends StatelessWidget {
  final Map<String, dynamic>? ticket;

  const TicketDetailsView({
    super.key,
    this.ticket,
  });

  String formatTime(String? dateTimeString) {
    if (dateTimeString == null || dateTimeString.isEmpty) {
      return '--:--';
    }

    try {
      final dateTime = DateTime.parse(dateTimeString).toLocal();

      final hour = dateTime.hour.toString().padLeft(2, '0');
      final minute = dateTime.minute.toString().padLeft(2, '0');

      return '$hour:$minute';
    } catch (e) {
      return '--:--';
    }
  }

  String formatDate(String? dateTimeString) {
    if (dateTimeString == null || dateTimeString.isEmpty) {
      return '';
    }

    try {
      final dateTime = DateTime.parse(dateTimeString).toLocal();

      const months = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec',
      ];

      return '${dateTime.day} ${months[dateTime.month - 1]} ${dateTime.year}';
    } catch (e) {
      return '';
    }
  }

  String formatAmount(dynamic amount) {
    if (amount == null) return '₦0';

    final value = double.tryParse(amount.toString()) ?? 0;

    return '₦${value.toStringAsFixed(0)}';
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> ticketData =
        ticket ?? (Get.arguments as Map<String, dynamic>?) ?? {};

    final bookingId = ticketData['id'];

    final departureStation =
        ticketData['fromStation']?.toString() ?? 'Departure';

    final arrivalStation = ticketData['toStation']?.toString() ?? 'Arrival';

    final departureTime = formatTime(ticketData['departureTime']?.toString());

    final arrivalTime = formatTime(ticketData['arrivalTime']?.toString());

    final date = formatDate(ticketData['date']?.toString());

    final trainNumber = ticketData['trainNumber']?.toString() ??
        ticketData['trainName']?.toString() ??
        'Train';

    final seat = ticketData['seats']?.toString() ?? 'Unassigned';

    final passengerType = ticketData['passengerTypes']?.toString() ?? 'Adult';

    final travelClass = ticketData['travelClass']?.toString() ?? 'Standard';

    final totalAmount = ticketData['totalAmount'];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ticket Details'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Card(
              elevation: 4,
              shadowColor: Colors.black12,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    // Booking ID + Travel Class
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Ticket #$bookingId',
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            travelClass,
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.bold,
                                    ),
                          ),
                        ),
                      ],
                    ),

                    const Divider(height: 32),

                    // Route
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                departureStation,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                departureTime,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.copyWith(
                                      color: AppColors.textSecondary,
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                          ),
                          child: Column(
                            children: [
                              const Icon(
                                Iconsax.arrow_right_1,
                                color: AppColors.textSecondary,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                date,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                      color: AppColors.textSecondary,
                                    ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                arrivalStation,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                textAlign: TextAlign.right,
                              ),
                              const SizedBox(height: 6),
                              Text(
                                arrivalTime,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.copyWith(
                                      color: AppColors.textSecondary,
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 28),

                    // Train
                    _infoRow(
                      context,
                      Icons.train,
                      'Train',
                      trainNumber,
                    ),

                    const SizedBox(height: 12),

                    // Seat
                    _infoRow(
                      context,
                      Icons.event_seat,
                      'Seat',
                      seat,
                    ),

                    const SizedBox(height: 12),

                    // Passenger type
                    _infoRow(
                      context,
                      Icons.person_outline,
                      'Passenger',
                      passengerType,
                    ),

                    const SizedBox(height: 12),

                    // Amount
                    _infoRow(
                      context,
                      Icons.payments_outlined,
                      'Amount Paid',
                      formatAmount(totalAmount),
                    ),

                    const Divider(height: 32),

                    // QR Code
                    QrImageView(
                      data: 'BOOKING-$bookingId',
                      version: QrVersions.auto,
                      size: 200,
                    ),

                    const SizedBox(height: 16),

                    Text(
                      'Scan this QR code at the station',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(
    BuildContext context,
    IconData icon,
    String label,
    String value,
  ) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: AppColors.textSecondary,
        ),
        const SizedBox(width: 10),
        Text(
          '$label: ',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
              ),
        ),
        Expanded(
          child: Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
        ),
      ],
    );
  }
}
