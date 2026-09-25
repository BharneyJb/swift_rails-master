import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../../../config/theme/app_colors.dart';
import '../../tickets/controllers/tickets_controller.dart';
import 'ticket_details_view.dart';

class MyTicketsView extends GetView<TicketsController> {
  const MyTicketsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Tickets'),
        automaticallyImplyLeading: false,
      ),
      body: Obx(() => controller.isLoading.value
          ? const Center(child: CircularProgressIndicator())
          : controller.tickets.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Iconsax.ticket,
                        size: 80,
                        color: AppColors.textSecondary.withValues(alpha: 0.5),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No tickets yet',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Book your first train journey',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(20),
                  itemCount: controller.tickets.length,
                  itemBuilder: (context, index) {
                    final ticket = controller.tickets[index] as Map<String, dynamic>;
                    return InkWell(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => TicketDetailsView(
                              ticket: ticket,
                            ),
                          ),
                        );
                      },
                      child: Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          side: const BorderSide(color: AppColors.border),
                        ),
                        elevation: 0,
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Ticket #${ticket['id'] ?? (index + 1)}',
                                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    ticket['travelClass'] ?? 'Standard',
                                    style: Theme.of(context).textTheme.bodySmall,
                                  ),
                                ],
                                ),
                              const SizedBox(height: 12),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        ticket['departureStation'] ?? 'Departure',
                                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        (ticket['bookingDepartureTime']?.toString().split('T').length ?? 0) > 1
                                            ? ticket['bookingDepartureTime'].toString().split('T')[1].substring(0, 5)
                                            : '00:00',
                                        style: Theme.of(context).textTheme.bodySmall,
                                      ),
                                    ],
                                  ),
                                  const Icon(Iconsax.arrow_right_1, color: AppColors.textSecondary),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        ticket['arrivalStation'] ?? 'Arrival',
                                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        (ticket['bookingArrivalTime']?.toString().split('T').length ?? 0) > 1
                                            ? ticket['bookingArrivalTime'].toString().split('T')[1].substring(0, 5)
                                            : '00:00',
                                        style: Theme.of(context).textTheme.bodySmall,
                                      ),
                                    ],
                                  ),
                                ],
                                ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                )),
    );
  }
}
