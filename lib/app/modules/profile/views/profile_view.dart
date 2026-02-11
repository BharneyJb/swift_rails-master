import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../../../config/theme/app_colors.dart';
import '../../../routes/app_routes.dart';
import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Profile Header
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: AppColors.primary,
                      child: Obx(() => Text(
                        controller.currentUser.value?.name.substring(0, 1).toUpperCase() ?? 'G',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      )),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Obx(() => Text(
                            controller.currentUser.value?.name ?? 'Guest',
                            style: Theme.of(context).textTheme.titleLarge,
                          )),
                          const SizedBox(height: 4),
                          Obx(() => Text(
                            controller.currentUser.value?.email ?? '',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          )),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            
            // Menu Items
            _buildMenuItem(
              context,
              'Edit Profile',
              Iconsax.user_edit,
              () => Get.toNamed(AppRoutes.EDIT_PROFILE),
            ),
            _buildMenuItem(
              context,
              'Trip History',
              Iconsax.clock,
              () => Get.toNamed(AppRoutes.TRIP_HISTORY),
            ),
            _buildMenuItem(
              context,
              'Notifications',
              Iconsax.notification,
              () => Get.toNamed(AppRoutes.NOTIFICATIONS),
            ),
            _buildMenuItem(
              context,
              'Settings',
              Iconsax.setting_2,
              () {},
            ),
            _buildMenuItem(
              context,
              'Help & Support',
              Iconsax.message_question,
              () {},
            ),
            const SizedBox(height: 24),
            
            // Logout Button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: controller.logout,
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.error,
                  side: const BorderSide(color: AppColors.error),
                ),
                child: const Text('Logout'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context,
    String title,
    IconData icon,
    VoidCallback onTap,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(icon, color: AppColors.primary),
        title: Text(title),
        trailing: const Icon(Iconsax.arrow_right_3, color: AppColors.textSecondary),
        onTap: onTap,
      ),
    );
  }
}
