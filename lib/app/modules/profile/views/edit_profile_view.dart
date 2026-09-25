import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../../../config/theme/app_colors.dart';
import '../controllers/profile_controller.dart';
import '../../../../views/utils/form_validators.dart';

class EditProfileView extends GetView<ProfileController> {
  const EditProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: controller.editProfileFormKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // ── Avatar ──────────────────────────────────────────────────────
              Center(
                child: Stack(
                  children: [
                    Obx(() {
                      final user = controller.currentUser.value;
                      final hasAvatar =
                          user?.avatar != null && user!.avatar!.isNotEmpty;
                      return CircleAvatar(
                        radius: 60,
                        backgroundColor:
                            AppColors.primary.withValues(alpha: 0.1),
                        backgroundImage:
                            hasAvatar ? NetworkImage(user!.avatar!) : null,
                        child: hasAvatar
                            ? null
                            : Text(
                                user?.initial ?? 'U',
                                style: const TextStyle(
                                  color: AppColors.primary,
                                  fontSize: 48,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      );
                    }),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 3),
                        ),
                        child: IconButton(
                          icon: const Icon(Iconsax.camera,
                              color: Colors.white, size: 20),
                          onPressed: controller.pickImage,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // ── First Name ──────────────────────────────────────────────────
              TextFormField(
                controller: controller.firstNameController,
                decoration: InputDecoration(
                  labelText: 'First Name',
                  prefixIcon: const Icon(Iconsax.user),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) {
                    return 'First name is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // ── Surname ─────────────────────────────────────────────────────
              TextFormField(
                controller: controller.surnameController,
                decoration: InputDecoration(
                  labelText: 'Surname',
                  prefixIcon: const Icon(Iconsax.user),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) {
                    return 'Surname is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // ── Email ───────────────────────────────────────────────────────
              TextFormField(
                controller: controller.emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  prefixIcon: const Icon(Iconsax.sms),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: FormValidators.email,
              ),
              const SizedBox(height: 16),

              // ── Phone ───────────────────────────────────────────────────────
              TextFormField(
                controller: controller.phoneController,
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                  prefixIcon: const Icon(Iconsax.call),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                keyboardType: TextInputType.phone,
                validator: FormValidators.phone,
              ),
              const SizedBox(height: 16),

              // ── Gender ──────────────────────────────────────────────────────
              Obx(() => DropdownButtonFormField<String>(
                    initialValue: controller.selectedGender.value.isEmpty
                        ? null
                        : controller.selectedGender.value,
                    decoration: InputDecoration(
                      labelText: 'Gender',
                      prefixIcon: const Icon(Iconsax.profile_circle),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'Male', child: Text('Male')),
                      DropdownMenuItem(value: 'Female', child: Text('Female')),
                    ],
                    onChanged: (v) => controller.selectedGender.value = v ?? '',
                  )),
              const SizedBox(height: 16),

              // ── Date of Birth ───────────────────────────────────────────────
              Obx(() {
                final dob = controller.selectedDob.value;
                return TextFormField(
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: 'Date of Birth',
                    prefixIcon: const Icon(Iconsax.calendar),
                    hintText: dob == null
                        ? 'Select date'
                        : '${dob.year}-${dob.month.toString().padLeft(2, '0')}-${dob.day.toString().padLeft(2, '0')}',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  controller: TextEditingController(
                    text: dob == null
                        ? ''
                        : '${dob.year}-${dob.month.toString().padLeft(2, '0')}-${dob.day.toString().padLeft(2, '0')}',
                  ),
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: dob ?? DateTime(1990),
                      firstDate: DateTime(1900),
                      lastDate: DateTime.now(),
                    );
                    if (picked != null) {
                      controller.selectedDob.value = picked;
                    }
                  },
                );
              }),
              const SizedBox(height: 16),

              // ── NIN ─────────────────────────────────────────────────────────
              TextFormField(
                controller: controller.ninController,
                decoration: InputDecoration(
                  labelText: 'NIN (National ID)',
                  prefixIcon: const Icon(Iconsax.card),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                keyboardType: TextInputType.number,
                maxLength: 11,
              ),
              const SizedBox(height: 32),

              // ── Save ────────────────────────────────────────────────────────
              Obx(() => SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: controller.isUpdating.value
                          ? null
                          : controller.updateProfile,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: controller.isUpdating.value
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : const Text(
                              'Save Changes',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
