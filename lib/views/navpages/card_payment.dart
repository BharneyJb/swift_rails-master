import 'package:flutter/material.dart';
import 'package:swyft_rails/views/navpages/payment_status.dart';
import 'package:swyft_rails/views/utils/form_validators.dart';
import 'package:swyft_rails/views/utils/input_field.dart';

class CardPayment extends StatefulWidget {
  const CardPayment({Key? key}) : super(key: key);

  @override
  State<CardPayment> createState() => _CardPaymentState();
}

class _CardPaymentState extends State<CardPayment> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController cardController = TextEditingController();
  final TextEditingController cvvController = TextEditingController();
  final TextEditingController dateController = TextEditingController();

  @override
  void dispose() {
    cardController.dispose();
    cvvController.dispose();
    dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        title: const Text(
          "Ticket Details",
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18.0),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 15.0),
                InputField(
                  controller: cardController,
                  hintText: "1234 5678 9012 3456",
                  labelText: "Card Number",
                  keyboardType: TextInputType.number,
                  inputFormatters: [FormValidators.cardNumberFormatter],
                  validator: FormValidators.cardNumber,
                ),
                const SizedBox(height: 8.0),
                Row(
                  children: [
                    Expanded(
                      child: InputField(
                        controller: cvvController,
                        hintText: "CVV",
                        labelText: "CVV",
                        keyboardType: TextInputType.number,
                        inputFormatters: [FormValidators.cvvFormatter],
                        validator: FormValidators.cvv,
                      ),
                    ),
                    const SizedBox(width: 12.0),
                    Expanded(
                      child: InputField(
                        controller: dateController,
                        hintText: "MM/YY",
                        labelText: "Expiry",
                        keyboardType: TextInputType.number,
                        inputFormatters: [FormValidators.expiryFormatter],
                        validator: FormValidators.expiry,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30.0),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.maxFinite, 70),
                    backgroundColor: const Color(0xff4001a8),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50)),
                  ),
                  onPressed: () {
                    if (_formKey.currentState?.validate() ?? false) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const PaymentStatus()),
                      );
                    }
                  },
                  child: const Text(
                    'Pay #14,685',
                    style: TextStyle(color: Colors.white, fontSize: 15),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
