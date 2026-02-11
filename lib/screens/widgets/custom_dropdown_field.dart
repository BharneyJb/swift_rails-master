import 'package:flutter/material.dart';

class CustomDropdownField extends StatelessWidget {
  final IconData icon;
  final String text;
  final bool hasDropdown;

  const CustomDropdownField({
    super.key,
    required this.icon,
    required this.text,
    this.hasDropdown = true,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.grey[600]),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                text,
                style: const TextStyle(fontSize: 16, color: Colors.black87),
              ),
            ),
            if (hasDropdown)
              const Icon(Icons.arrow_drop_down, color: Color(0xFF6200EE)),
          ],
        ),
      ),
    );
  }
}
