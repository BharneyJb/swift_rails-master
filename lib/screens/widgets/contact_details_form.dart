import 'package:flutter/material.dart';

class ContactDetailsForm extends StatelessWidget {
  final String title;
  final String seatNumber;

  const ContactDetailsForm({
    super.key,
    required this.title,
    required this.seatNumber,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            style: const TextStyle(
                fontSize: 16, color: Colors.black87, fontFamily: 'Inter'),
            children: [
              TextSpan(text: '$title / '),
              TextSpan(
                text: 'Seat No: $seatNumber',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF6200EE),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        _buildTextField('First name'),
        const SizedBox(height: 12),
        _buildTextField('Email'),
        const SizedBox(height: 12),
        _buildTextField('NIN'),
        const SizedBox(height: 12),
        _buildPhoneNumberField(),
      ],
    );
  }

  Widget _buildTextField(String hint) {
    return TextFormField(
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey[500]),
        filled: true,
        fillColor: Colors.grey[100],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      ),
    );
  }

  Widget _buildPhoneNumberField() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(12),
              bottomLeft: Radius.circular(12),
            ),
          ),
          child: Text(
            '+234',
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          ),
        ),
        Expanded(
          child: TextFormField(
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              hintText: 'Mobile Number',
              hintStyle: TextStyle(color: Colors.grey[500]),
              filled: true,
              fillColor: Colors.grey[100],
              border: const OutlineInputBorder(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
                borderSide: BorderSide.none,
              ),
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            ),
          ),
        ),
      ],
    );
  }
}
