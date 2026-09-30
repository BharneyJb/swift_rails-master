import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../../../config/theme/app_colors.dart';
import '../../../widgets/app_empty_state.dart';
import '../../tickets/controllers/tickets_controller.dart';
import '../../../routes/app_routes.dart';
import 'ticket_details_view.dart';

class MyTicketsView extends GetView<TicketsController> {
  const MyTicketsView({super.key});

  String formatTime(dynamic value) {
    if (value == null) return '--:--';

    try {
      final dateTime = DateTime.parse(value.toString()).toLocal();

      final hour = dateTime.hour == 0
          ? 12
          : dateTime.hour > 12
              ? dateTime.hour - 12
              : dateTime.hour;

      final minute = dateTime.minute.toString().padLeft(2, '0');
      final period = dateTime.hour >= 12 ? 'PM' : 'AM';

      return '$hour:$minute $period';
    } catch (_) {
      return '--:--';
    }
  }

  String formatDate(dynamic value) {
    if (value == null) return '--';

    try {
      final dateTime = DateTime.parse(value.toString()).toLocal();

      return '${dateTime.day.toString().padLeft(2, '0')}/'
          '${dateTime.month.toString().padLeft(2, '0')}/'
          '${dateTime.year}';
    } catch (_) {
      return '--';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Tickets'),
        automaticallyImplyLeading: false,
      ),
      body: Obx(
        () {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          // Network / server error
          if (controller.hasError.value) {
            return AppEmptyState(
              icon: Icons.wifi_off_rounded,
              iconColor: AppColors.error,
              title: "Couldn't connect to SwyftRails",
              subtitle:
                  'Network failure. Please check your connection and try again.',
              buttonLabel: 'Try Again',
              onButtonTap: controller.fetchTickets,
            );
          }

          // No tickets yet
          if (controller.tickets.isEmpty) {
            return AppEmptyState(
              icon: Iconsax.ticket,
              title: "No tickets",
              subtitle: "You don't have any tickets yet.",
              buttonLabel: 'Book a Train',
              buttonIcon: const Icon(Icons.train_rounded),
              onButtonTap: () => Get.toNamed(AppRoutes.SEARCH_TRAINS),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: controller.tickets.length,
            itemBuilder: (context, index) {
              final ticket =
                  Map<String, dynamic>.from(controller.tickets[index]);

              return InkWell(
                borderRadius: BorderRadius.circular(16),
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
                    side: const BorderSide(
                      color: AppColors.border,
                    ),
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
                              'Ticket #${ticket['id'] ?? '--'}',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall
                                  ?.copyWith(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            Text(
                              ticket['trainNumber']?.toString() ?? 'Train',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    ticket['fromStation']?.toString() ??
                                        'Departure',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    formatTime(ticket['departureTime']),
                                    style:
                                        Theme.of(context).textTheme.bodySmall,
                                  ),
                                ],
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8),
                              child: Icon(
                                Iconsax.arrow_right_1,
                                color: AppColors.textSecondary,
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    ticket['toStation']?.toString() ??
                                        'Arrival',
                                    textAlign: TextAlign.right,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    formatTime(ticket['arrivalTime']),
                                    style:
                                        Theme.of(context).textTheme.bodySmall,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              formatDate(ticket['departureTime']),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    color: AppColors.textSecondary,
                                  ),
                            ),
                            Text(
                              'Seat: ${ticket['seats'] ?? 'Unassigned'}',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
