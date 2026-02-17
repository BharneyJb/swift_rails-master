import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:iconsax/iconsax.dart';
import '../../../config/theme/app_colors.dart';

class TicketDetailsView extends StatelessWidget {
  final Map<String, dynamic>? ticket;
  
  const TicketDetailsView({super.key, this.ticket});

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> ticketData = ticket ?? (Get.arguments as Map<String, dynamic>?) ?? {};
    
    String formatTime(String? dateTimeString) {
      if (dateTimeString == null || dateTimeString.isEmpty) return '00:00';
      try {
        if (dateTimeString.contains('T')) {
          return dateTimeString.split('T')[1].substring(0, 5);
        } else if (dateTimeString.length >= 5) {
          return dateTimeString.substring(0, 5);
        }
        return dateTimeString;
      } catch (e) {
        return '00:00';
      }
    }

    final date = ticketData['date']?.toString().split('T')[0] ?? '';
    final departureTime = formatTime(ticketData['bookingDepartureTime']?.toString());
    final arrivalTime = formatTime(ticketData['bookingArrivalTime']?.toString());
    final departureStation = ticketData['departureStation']?.toString() ?? 'Departure';
    final arrivalStation = ticketData['arrivalStation']?.toString() ?? 'Arrival';
    final trainName = ticketData['trainName']?.toString() ?? ticketData['scheduleName']?.toString() ?? 'Train';
    final seatInfos = ticketData['seatNumbers']?.toString() ?? 'Unassigned';

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
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    // Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Ticket #${ticketData['id']}',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            ticketData['travelClass'] ?? 'Standard',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 32),
                    
                    // Route Details
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                departureStation,
                                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                departureTime,
                                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Column(
                            children: [
                              const Icon(Iconsax.arrow_right_1, color: AppColors.textSecondary),
                              Text(
                                date,
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
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
                                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.right,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                arrivalTime,
                                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    
                    // Train info
                    Row(
                      children: [
                        const Icon(Icons.train, size: 20, color: AppColors.textSecondary),
                        const SizedBox(width: 8),
                        Text(
                          'Train: $trainName',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.event_seat, size: 20, color: AppColors.textSecondary),
                        const SizedBox(width: 8),
                        Text(
                          'Seat: $seatInfos',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                    
                    const Divider(height: 32),
                    
                    // QR Code
                    Center(
                      child: QrImageView(
                        data: 'TICKET-${ticketData['id']}',
                        version: QrVersions.auto,
                        size: 200.0,
                      ),
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
}
