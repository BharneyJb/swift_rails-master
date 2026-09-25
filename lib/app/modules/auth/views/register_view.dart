import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../../../config/theme/app_colors.dart';
import '../controllers/auth_controller.dart';
import '../../../../views/utils/form_validators.dart';

class RegisterView extends GetView<AuthController> {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Account')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: controller.registerFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                Text(
                  'Join Swift Rails',
                  style: Theme.of(context).textTheme.displaySmall,
                ),
                const SizedBox(height: 8),
                Text(
                  'Create an account to start booking',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                ),
                const SizedBox(height: 28),

                // ── First Name ────────────────────────────────────────────────
                TextFormField(
                  controller: controller.registerFirstNameController,
                  decoration: const InputDecoration(
                    labelText: 'First Name',
                    hintText: 'e.g. John',
                    prefixIcon: Icon(Iconsax.user),
                  ),
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? 'First name is required' : null,
                ),
                const SizedBox(height: 16),

                // ── Surname ───────────────────────────────────────────────────
                TextFormField(
                  controller: controller.registerSurnameController,
                  decoration: const InputDecoration(
                    labelText: 'Surname',
                    hintText: 'e.g. Doe',
                    prefixIcon: Icon(Iconsax.user),
                  ),
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? 'Surname is required' : null,
                ),
                const SizedBox(height: 16),

                // ── Email ─────────────────────────────────────────────────────
                TextFormField(
                  controller: controller.registerEmailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    hintText: 'Enter your email',
                    prefixIcon: Icon(Iconsax.sms),
                  ),
                  validator: FormValidators.email,
                ),
                const SizedBox(height: 16),

                // ── Phone ─────────────────────────────────────────────────────
                TextFormField(
                  controller: controller.registerPhoneController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    labelText: 'Phone Number',
                    hintText: 'e.g. 08012345678',
                    prefixIcon: Icon(Iconsax.call),
                  ),
                  validator: FormValidators.phone,
                ),
                const SizedBox(height: 16),

                // ── Gender ────────────────────────────────────────────────────
                Obx(() => DropdownButtonFormField<String>(
                      initialValue: controller.registerGender.value.isEmpty
                          ? null
                          : controller.registerGender.value,
                      decoration: const InputDecoration(
                        labelText: 'Gender',
                        prefixIcon: Icon(Iconsax.profile_circle),
                      ),
                      items: const [
                        DropdownMenuItem(value: 'Male', child: Text('Male')),
                        DropdownMenuItem(
                            value: 'Female', child: Text('Female')),
                      ],
                      onChanged: (v) =>
                          controller.registerGender.value = v ?? '',
                      validator: (v) =>
                          (v == null || v.isEmpty) ? 'Please select gender' : null,
                    )),
                const SizedBox(height: 16),

                // ── Date of Birth ─────────────────────────────────────────────
                Obx(() {
                  final dob = controller.registerDob.value;
                  final dobText = dob == null
                      ? ''
                      : '${dob.year}-${dob.month.toString().padLeft(2, '0')}-${dob.day.toString().padLeft(2, '0')}';
                  return TextFormField(
                    readOnly: true,
                    decoration: const InputDecoration(
                      labelText: 'Date of Birth',
                      hintText: 'Select date',
                      prefixIcon: Icon(Iconsax.calendar),
                    ),
                    controller: TextEditingController(text: dobText),
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: dob ?? DateTime(1995),
                        firstDate: DateTime(1900),
                        lastDate: DateTime.now().subtract(
                          const Duration(days: 365 * 10),
                        ),
                      );
                      if (picked != null) {
                        controller.registerDob.value = picked;
                      }
                    },
                  );
                }),
                const SizedBox(height: 16),

                // ── NIN ───────────────────────────────────────────────────────
                TextFormField(
                  controller: controller.registerNinController,
                  keyboardType: TextInputType.number,
                  maxLength: 11,
                  decoration: const InputDecoration(
                    labelText: 'NIN (National Identification Number)',
                    hintText: '11-digit NIN',
                    prefixIcon: Icon(Iconsax.card),
                  ),
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) {
                      return 'NIN is required';
                    }
                    if (v.trim().length != 11) {
                      return 'NIN must be exactly 11 digits';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // ── Password ──────────────────────────────────────────────────
                Obx(() => TextFormField(
                      controller: controller.registerPasswordController,
                      obscureText: !controller.isRegisterPasswordVisible.value,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        hintText: 'Min 8 chars, upper, lower, number, symbol',
                        prefixIcon: const Icon(Iconsax.lock),
                        suffixIcon: IconButton(
                          icon: Icon(
                            controller.isRegisterPasswordVisible.value
                                ? Iconsax.eye
                                : Iconsax.eye_slash,
                          ),
                          onPressed:
                              controller.toggleRegisterPasswordVisibility,
                        ),
                      ),
                      validator: (v) {
                        if (v == null || v.isEmpty) {
                          return 'Password is required';
                        }
                        if (v.length < 8) {
                          return 'Must be at least 8 characters';
                        }
                        return null;
                      },
                    )),
                const SizedBox(height: 16),

                // ── Confirm Password ──────────────────────────────────────────
                Obx(() => TextFormField(
                      controller:
                          controller.registerConfirmPasswordController,
                      obscureText:
                          !controller.isRegisterConfirmPasswordVisible.value,
                      decoration: InputDecoration(
                        labelText: 'Confirm Password',
                        prefixIcon: const Icon(Iconsax.lock),
                        suffixIcon: IconButton(
                          icon: Icon(
                            controller.isRegisterConfirmPasswordVisible.value
                                ? Iconsax.eye
                                : Iconsax.eye_slash,
                          ),
                          onPressed: controller
                              .toggleRegisterConfirmPasswordVisibility,
                        ),
                      ),
                      validator: (v) {
                        if (v == null || v.isEmpty) {
                          return 'Please confirm your password';
                        }
                        if (v != controller.registerPasswordController.text) {
                          return 'Passwords do not match';
                        }
                        return null;
                      },
                    )),
                const SizedBox(height: 32),

                // ── Register Button ───────────────────────────────────────────
                Obx(() => SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: controller.isRegisterLoading.value
                            ? null
                            : controller.register,
                        child: controller.isRegisterLoading.value
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                ),
                              )
                            : const Text('Create Account'),
                      ),
                    )),
                const SizedBox(height: 24),

                // ── Login Link ────────────────────────────────────────────────
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already have an account? ',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    TextButton(
                      onPressed: () => Get.back(),
                      child: const Text('Login'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
