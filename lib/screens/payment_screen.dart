import 'package:flutter/material.dart';
import 'package:swyft_rails/models/schedule.dart';
import 'package:swyft_rails/views/utils/form_validators.dart';
import 'widgets/contact_details_form.dart';

class PaymentScreen extends StatefulWidget {
  final double totalPrice;
  final String selectedClass;
  final String selectedCoach;
  final Set<String> selectedSeats;
  final int numberOfPassengers;
  final List<PassengerData>? passengerDataList;
  final Schedule? schedule;

  const PaymentScreen({
    super.key,
    required this.totalPrice,
    required this.selectedClass,
    required this.selectedCoach,
    required this.selectedSeats,
    required this.numberOfPassengers,
    this.passengerDataList,
    this.schedule,
  });

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  static const Color _purple = Color(0xff4001a8);

  String _selectedPaymentMethod = 'Card';
  bool _passengersExpanded = false;

  final _cardFormKey = GlobalKey<FormState>();
  final TextEditingController _cardNumberController =
      TextEditingController();
  final TextEditingController _expiryController = TextEditingController();
  final TextEditingController _cvvController = TextEditingController();
  final TextEditingController _cardholderNameController =
      TextEditingController();

  // Display-formatted card number (with spaces)
  String _displayCardNumber = '';

  final List<String> _paymentMethods = [
    'Card',
    'PayPal',
    'Apple Pay',
    'Google Pay',
  ];

  @override
  void dispose() {
    _cardNumberController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    _cardholderNameController.dispose();
    super.dispose();
  }

  String _formatCurrency(double value) {
    final formatted = value.toStringAsFixed(2);
    final parts = formatted.split('.');
    final integerPart = parts[0].replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (m) => '${m[1]},',
    );
    return '₦$integerPart.${parts[1]}';
  }

  String _formatTime(DateTime dt) {
    final h = dt.hour;
    final m = dt.minute.toString().padLeft(2, '0');
    final period = h >= 12 ? 'PM' : 'AM';
    final hour12 = h == 0 ? 12 : (h > 12 ? h - 12 : h);
    return '$hour12:$m $period';
  }

  Future<void> _processPayment() async {
    if (_selectedPaymentMethod == 'Card') {
      if (!(_cardFormKey.currentState?.validate() ?? false)) return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;
    Navigator.pop(context); // close loading

    if (!mounted) return;
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.check_circle, color: Colors.green, size: 28),
            SizedBox(width: 8),
            Text('Payment Successful!'),
          ],
        ),
        content: const Text('Your ticket has been booked successfully.'),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: _purple),
            child: const Text('OK', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  // ── Build ─────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildPriceCard(),
              const SizedBox(height: 24),
              _buildTripSummary(),
              const SizedBox(height: 24),
              _buildPaymentMethodSelection(),
              const SizedBox(height: 24),
              _buildPaymentForm(),
              const SizedBox(height: 32),
              _buildPayButton(),
            ],
          ),
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: _purple,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Navigator.pop(context),
      ),
      title: const Text(
        'Payment',
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      centerTitle: true,
    );
  }

  Widget _buildPriceCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [_purple, Color(0xff7c3aed)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: _purple.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          const Text('Total Amount',
              style: TextStyle(color: Colors.white70, fontSize: 16)),
          const SizedBox(height: 8),
          Text(
            _formatCurrency(widget.totalPrice),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 36,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTripSummary() {
    final s = widget.schedule;
    final seats = widget.selectedSeats.toList()..sort();
    final passengers = widget.passengerDataList;

    return Card(
      elevation: 2,
      color: Colors.white,
      shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Trip Summary',
                style:
                    TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            _summaryRow('From',
                s?.departureStation ?? 'Lagos'),
            _summaryRow('To', s?.station.name ?? 'Abuja'),
            _summaryRow('Date',
                s != null
                    ? '${s.departureTime.day}/${s.departureTime.month}/${s.departureTime.year}'
                    : 'Today'),
            _summaryRow('Time',
                s != null
                    ? '${_formatTime(s.departureTime)} – ${_formatTime(s.arrivalTime)}'
                    : '12:00 AM – 3:00 PM'),
            _summaryRow('Class', widget.selectedClass),
            _summaryRow('Coach', widget.selectedCoach),
            _summaryRow('Passengers', '${widget.numberOfPassengers}'),
            _summaryRow('Seats', seats.join(', ')),

            // ── Passenger list (expandable) ──
            if (passengers != null && passengers.isNotEmpty) ...[
              const Divider(height: 24),
              InkWell(
                onTap: () => setState(
                    () => _passengersExpanded = !_passengersExpanded),
                child: Row(
                  children: [
                    const Text('Passengers',
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 14)),
                    const Spacer(),
                    Icon(
                      _passengersExpanded
                          ? Icons.expand_less
                          : Icons.expand_more,
                      color: Colors.grey.shade500,
                    ),
                  ],
                ),
              ),
              if (_passengersExpanded)
                ...passengers.asMap().entries.map((e) {
                  final idx = e.key;
                  final p = e.value;
                  final seat =
                      idx < seats.length ? seats[idx] : '—';
                  return Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 28,
                            height: 28,
                            decoration: const BoxDecoration(
                                shape: BoxShape.circle, color: _purple),
                            child: Center(
                              child: Text(
                                '${idx + 1}',
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                Text(
                                  p.firstName.isEmpty
                                      ? 'Passenger ${idx + 1}'
                                      : p.firstName,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 13),
                                ),
                                Text(
                                  p.email,
                                  style: TextStyle(
                                      fontSize: 11,
                                      color: Colors.grey.shade500),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: _purple.withOpacity(0.08),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              'Seat $seat',
                              style: const TextStyle(
                                  fontSize: 11,
                                  color: _purple,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
            ],
          ],
        ),
      ),
    );
  }

  Widget _summaryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style:
                  const TextStyle(color: Colors.grey, fontSize: 14)),
          Flexible(
            child: Text(
              value,
              style: const TextStyle(
                  fontWeight: FontWeight.w600, fontSize: 14),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethodSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Payment Method',
            style:
                TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        Card(
          elevation: 2,
          color: Colors.white,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: _paymentMethods.map((method) {
                return RadioListTile<String>(
                  value: method,
                  groupValue: _selectedPaymentMethod,
                  onChanged: (v) =>
                      setState(() => _selectedPaymentMethod = v!),
                  title: Text(method),
                  activeColor: _purple,
                  contentPadding: EdgeInsets.zero,
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentForm() {
    if (_selectedPaymentMethod != 'Card') {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Text(
          'You will be redirected to complete your payment.',
          style: TextStyle(fontSize: 16),
        ),
      );
    }

    return Form(
      key: _cardFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Card Details',
              style:
                  TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Card(
            elevation: 2,
            color: Colors.white,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // Card number
                  TextFormField(
                    controller: _cardNumberController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FormValidators.cardNumberFormatter,
                    ],
                    onChanged: (raw) {
                      final formatted =
                          FormValidators.formatCardNumber(raw);
                      if (_displayCardNumber != formatted) {
                        setState(() => _displayCardNumber = formatted);
                        final sel = TextSelection.collapsed(
                            offset: formatted.length);
                        _cardNumberController.value =
                            _cardNumberController.value.copyWith(
                          text: formatted,
                          selection: sel,
                        );
                      }
                    },
                    validator: FormValidators.cardNumber,
                    decoration: _fieldDecor(
                      label: 'Card Number',
                      hint: '1234 5678 9012 3456',
                      icon: Icons.credit_card,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _expiryController,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FormValidators.expiryFormatter,
                          ],
                          onChanged: (raw) {
                            final formatted =
                                FormValidators.formatExpiry(raw);
                            if (_expiryController.text != formatted) {
                              _expiryController.value =
                                  _expiryController.value.copyWith(
                                text: formatted,
                                selection: TextSelection.collapsed(
                                    offset: formatted.length),
                              );
                            }
                          },
                          validator: FormValidators.expiry,
                          decoration: _fieldDecor(
                            label: 'Expiry',
                            hint: 'MM/YY',
                            icon: Icons.calendar_today,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextFormField(
                          controller: _cvvController,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FormValidators.cvvFormatter,
                          ],
                          obscureText: true,
                          validator: FormValidators.cvv,
                          decoration: _fieldDecor(
                            label: 'CVV',
                            hint: '•••',
                            icon: Icons.security,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _cardholderNameController,
                    inputFormatters: [FormValidators.nameFormatter],
                    validator: FormValidators.cardholderName,
                    decoration: _fieldDecor(
                      label: 'Cardholder Name',
                      hint: 'John Doe',
                      icon: Icons.person,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration _fieldDecor({
    required String label,
    required String hint,
    required IconData icon,
  }) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      prefixIcon: Icon(icon, color: Colors.grey[600]),
      filled: true,
      fillColor: Colors.grey.shade50,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: _purple),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.red.shade400),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.red.shade600, width: 2),
      ),
    );
  }

  Widget _buildPayButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _processPayment,
        style: ElevatedButton.styleFrom(
          backgroundColor: _purple,
          padding: const EdgeInsets.symmetric(vertical: 18),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30)),
        ),
        child: Text(
          'Pay ${_formatCurrency(widget.totalPrice)}',
          style: const TextStyle(
            fontSize: 18,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
