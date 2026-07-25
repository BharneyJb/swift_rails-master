import 'package:flutter/material.dart';
import 'package:swyft_rails/views/utils/form_validators.dart';
import 'package:swyft_rails/views/utils/input_field.dart';

// ─── Shared data model ────────────────────────────────────────────────────────
class PassengerData {
  String firstName;
  String email;
  String nin;
  String phone;

  PassengerData({
    this.firstName = '',
    this.email = '',
    this.nin = '',
    this.phone = '',
  });
}

// ─── Widget ───────────────────────────────────────────────────────────────────
class ContactDetailsForm extends StatefulWidget {
  final String title;
  final String seatNumber;
  final PassengerData? initialData;

  const ContactDetailsForm({
    super.key,
    required this.title,
    required this.seatNumber,
    this.initialData,
  });

  @override
  State<ContactDetailsForm> createState() => ContactDetailsFormState();
}

class ContactDetailsFormState extends State<ContactDetailsForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _firstNameController;
  late final TextEditingController _emailController;
  late final TextEditingController _ninController;
  late final TextEditingController _phoneController;

  static const Color _purple = Color(0xff4001a8);

  @override
  void initState() {
    super.initState();
    _firstNameController =
        TextEditingController(text: widget.initialData?.firstName ?? '');
    _emailController =
        TextEditingController(text: widget.initialData?.email ?? '');
    _ninController =
        TextEditingController(text: widget.initialData?.nin ?? '');
    _phoneController =
        TextEditingController(text: widget.initialData?.phone ?? '');
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _emailController.dispose();
    _ninController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  /// Call this from the parent to validate and extract data.
  /// Returns null if validation fails.
  PassengerData? getData() {
    if (_formKey.currentState?.validate() ?? false) {
      return PassengerData(
        firstName: _firstNameController.text.trim(),
        email: _emailController.text.trim(),
        nin: _ninController.text.trim(),
        phone: _phoneController.text.trim(),
      );
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Purple left accent bar
              Container(width: 4, color: _purple),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Form(
                    key: _formKey,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header row
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                widget.title,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: _purple,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                'Seat ${widget.seatNumber}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // First name
                        InputField(
                          controller: _firstNameController,
                          hintText: 'e.g. Amara',
                          labelText: 'First Name',
                          prefixIcon: const Icon(Icons.person_outline),
                          validator: FormValidators.name,
                        ),
                        const SizedBox(height: 12),

                        // Email
                        InputField(
                          controller: _emailController,
                          hintText: 'name@example.com',
                          labelText: 'Email',
                          prefixIcon: const Icon(Icons.email_outlined),
                          keyboardType: TextInputType.emailAddress,
                          validator: FormValidators.email,
                        ),
                        const SizedBox(height: 12),

                        // NIN
                        InputField(
                          controller: _ninController,
                          hintText: '12345678901',
                          labelText: 'NIN',
                          prefixIcon: const Icon(Icons.badge_outlined),
                          keyboardType: TextInputType.number,
                          inputFormatters: [FormValidators.ninFormatter],
                          validator: FormValidators.nin,
                        ),
                        const SizedBox(height: 12),

                        // Phone number with +234 prefix
                        _buildPhoneField(),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPhoneField() {
    return TextFormField(
      controller: _phoneController,
      keyboardType: TextInputType.phone,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: FormValidators.phone,
      style: const TextStyle(fontSize: 16.0, color: Colors.black87),
      decoration: InputDecoration(
        labelText: 'Mobile Number',
        hintText: '08012345678',
        hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
        labelStyle: TextStyle(color: Colors.grey.shade600, fontSize: 14),
        filled: true,
        fillColor: Colors.grey.shade50,
        prefixIcon: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          margin: const EdgeInsets.only(right: 8),
          decoration: BoxDecoration(
            border: Border(
              right: BorderSide(color: Colors.grey.shade300),
            ),
          ),
          child: Align(
            alignment: Alignment.center,
            widthFactor: 1,
            child: Text(
              '+234',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300, width: 1.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300, width: 1.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xff4001a8), width: 2.0),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.red.shade400, width: 1.0),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.red.shade600, width: 2.0),
        ),
      ),
    );
  }
}
