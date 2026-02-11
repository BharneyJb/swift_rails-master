import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../config/theme/app_colors.dart';
import '../../../routes/app_routes.dart';

class PaymentView extends StatelessWidget {
  const PaymentView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select Payment Method',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 24),
            
            _buildPaymentOption(
              context,
              'Card Payment',
              'Pay with Debit/Credit Card',
              Icons.credit_card,
              () => _processPayment(context),
            ),
            const SizedBox(height: 12),
            
            _buildPaymentOption(
              context,
              'Bank Transfer',
              'Pay via bank transfer',
              Icons.account_balance,
              () {},
            ),
            const SizedBox(height: 12),
            
            _buildPaymentOption(
              context,
              'USSD',
              'Pay with USSD code',
              Icons.dialpad,
              () {},
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentOption(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    VoidCallback onTap,
  ) {
    return Card(
      child: ListTile(
        leading: Icon(icon, color: AppColors.primary, size: 32),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }

  void _processPayment(BuildContext context) {
    // Simulate payment processing
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );
    
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pop(context);
      Get.offAllNamed(AppRoutes.PAYMENT_SUCCESS);
    });
  }
}
