import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../config/theme/app_colors.dart';
import '../../../routes/app_routes.dart';
import '../controllers/admin_controller.dart';
import 'package:iconsax/iconsax.dart';

class AdminDashboardView extends GetView<AdminController> {
  const AdminDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'System Overview',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 24),

              // Summary Grid
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.2,
                children: [
                  _buildSummaryCard(
                    context,
                    'Total Trains',
                    controller.totalTrains.value.toString(),
                    Icons.train,
                    AppColors.primary,
                  ),
                  _buildSummaryCard(
                    context,
                    'Total Stations',
                    controller.totalStations.value.toString(),
                    Iconsax.location,
                    Colors.orange,
                  ),
                  _buildSummaryCard(
                    context,
                    'Total Bookings',
                    controller.totalBookings.value.toString(),
                    Iconsax.ticket,
                    Colors.green,
                  ),
                  _buildSummaryCard(
                    context,
                    'Active Routes',
                    '--', // Placeholder for route count
                    Icons.route,
                    Colors.purple,
                  ),
                ],
              ),
              const SizedBox(height: 40),

              Text(
                'Management',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 16),

              // Management Navigation
              _buildNavCard(
                context,
                'Manage Trains',
                'Add, edit, or remove trains from the system',
                Icons.train,
                () => Get.toNamed(AppRoutes.MANAGE_TRAINS),
              ),
              _buildNavCard(
                context,
                'Manage Stations',
                'Configure station locations and details',
                Iconsax.location,
                () => Get.toNamed(AppRoutes.MANAGE_STATIONS),
              ),
              _buildNavCard(
                context,
                'Manage Bookings',
                'View and manage all customer bookings',
                Iconsax.ticket,
                () => Get.toNamed(AppRoutes.MANAGE_BOOKINGS),
              ),
              _buildNavCard(
                context,
                'Fare Management',
                'Set and update pricing for travel classes',
                Iconsax.money_send,
                () => Get.toNamed(
                    '/admin/fares'), // Route to be added to AppRoutes
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildSummaryCard(
    BuildContext context,
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: AppColors.border),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 32, color: color),
            const SizedBox(height: 12),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            Text(
              title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavCard(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    VoidCallback onTap,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        onTap: onTap,
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: AppColors.primary),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(subtitle),
        trailing: const Icon(Iconsax.arrow_right_3),
      ),
    );
  }
}
