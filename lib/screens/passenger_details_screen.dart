import 'package:flutter/material.dart';
import 'widgets/contact_details_form.dart';
import 'widgets/seat_widget.dart';
import 'payment_screen.dart';

class PassengerDetailsScreen extends StatefulWidget {
  const PassengerDetailsScreen({super.key});

  @override
  State<PassengerDetailsScreen> createState() => _PassengerDetailsScreenState();
}

class _PassengerDetailsScreenState extends State<PassengerDetailsScreen> {
  // State Variables
  int _selectedNumberOfPassengers = 1;
  String _selectedClass = 'First Class'; // The initial value
  String _selectedCoach = 'Coach A';
  double _totalPrice = 0.0;

  final Set<String> _selectedSeats = {};
  final Set<String> _occupiedSeats = {'13', '14'};

  // Pricing constants
  static const double _basePrice = 2500.0;
  static const Map<String, double> _classMultipliers = {
    'First Class': 1.5,
    'Business Class': 1.2,
    'Economy Class': 1.0,
  };


  final List<String> _classOptions = [
    'Economy Class',
    'Business Class',
    'First Class'
  ];

  final List<String> _coachOptions = ['Coach A', 'Coach B', 'Coach C'];
  final List<int> _passengerOptions = [1, 2, 3, 4, 5];

  @override
  void initState() {
    super.initState();
    _calculatePrice();
  }

  // Custom Currency Formatter (no changes here)
  String _formatCurrency(double value) {
    String formatted = value.toStringAsFixed(2);
    final parts = formatted.split('.');
    String integerPart = parts[0].replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
    String decimalPart = parts[1];
    return '₦$integerPart.$decimalPart';
  }

  // All other business logic and build methods remain exactly the same.
  // ... (the rest of the code is unchanged)

  void _calculatePrice() {
    final multiplier = _classMultipliers[_selectedClass] ?? 1.0;
    setState(() {
      _totalPrice = _basePrice * _selectedNumberOfPassengers * multiplier;
    });
  }

  void _onPassengerChanged(int? newValue) {
    if (newValue == null) return;
    setState(() {
      _selectedNumberOfPassengers = newValue;
      _selectedSeats.clear();
      _calculatePrice();
    });
  }

  void _onClassChanged(String? newValue) {
    if (newValue == null) return;
    setState(() {
      _selectedClass = newValue;
      _calculatePrice();
    });
  }

  void _onCoachChanged(String? newValue) {
    if (newValue == null) return;
    setState(() {
      _selectedCoach = newValue;
    });
  }

  void _onSeatTapped(String seatNumber) {
    setState(() {
      if (_selectedSeats.contains(seatNumber)) {
        _selectedSeats.remove(seatNumber);
      } else {
        if (_selectedSeats.length < _selectedNumberOfPassengers) {
          _selectedSeats.add(seatNumber);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.redAccent,
              content: Text(
                'You can only select $_selectedNumberOfPassengers seat(s).',
                style: const TextStyle(color: Colors.white),
              ),
            ),
          );
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isSelectionComplete =
        _selectedSeats.length == _selectedNumberOfPassengers;

    return Scaffold(
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTripDetailsCard(),
              const SizedBox(height: 24),
              _buildSelectionFields(),
              const SizedBox(height: 24),
              _buildSeatSelectionGrid(),
              const SizedBox(height: 24),
              const Text(
                'Contact Details',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              _buildContactForms(),
              const SizedBox(height: 32),
              _buildPurchaseButton(isSelectionComplete),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSelectionFields() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              flex: 1,
              child: _buildDropdown(
                icon: Icons.person_outline,
                value: _selectedNumberOfPassengers,
                items: _passengerOptions
                    .map(
                        (p) => DropdownMenuItem<int>(value: p, child: Text('$p')))
                    .toList(),
                onChanged: _onPassengerChanged,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 2,
              child: _buildDropdown(
                icon: Icons.notes_outlined,
                value: _selectedClass,
                items: _classOptions
                    .map(
                        (c) => DropdownMenuItem<String>(value: c, child: Text(c)))
                    .toList(),
                onChanged: _onClassChanged,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        _buildDropdown(
          icon: Icons.event_seat_outlined,
          value: _selectedCoach,
          items: _coachOptions
              .map((c) => DropdownMenuItem<String>(value: c, child: Text(c)))
              .toList(),
          onChanged: _onCoachChanged,
        ),
      ],
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      elevation: 0,
      leading: const Icon(Icons.arrow_back, color: Colors.white),
      title: const Text(
        'Passenger Details',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      centerTitle: true,
    );
  }

  Widget _buildTripDetailsCard() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('12:00 AM', style: TextStyle(color: Colors.grey)),
            SizedBox(height: 4),
            Text('LOS',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
          ],
        ),
        Column(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: Color(0xFFFDECDD),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.train_outlined, color: Color(0xFFF2994A)),
            ),
            const SizedBox(height: 4),
            const Text('Train No : L1', style: TextStyle(color: Colors.grey)),
          ],
        ),
        const Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text('15:00 PM', style: TextStyle(color: Colors.grey)),
            SizedBox(height: 4),
            Text('ABK',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
          ],
        ),
      ],
    );
  }

  Widget _buildDropdown<T>({
    required IconData icon,
    required T value,
    required List<DropdownMenuItem<T>> items,
    required ValueChanged<T?> onChanged,
  }) {
    return DropdownButtonFormField<T>(
      initialValue: value,
      items: items,
      onChanged: onChanged,
      icon: Icon(Icons.arrow_drop_down, color: Theme.of(context).primaryColor),
      isExpanded: true,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.grey[600]),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
        isDense: true,
      ),
    );
  }

  Widget _buildSeatSelectionGrid() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSeatColumn(1, 6),
        Row(
          children: [
            _buildSeatColumn(7, 12),
            const SizedBox(width: 10),
            _buildSeatColumn(13, 18),
          ],
        ),
      ],
    );
  }

  Widget _buildSeatColumn(int start, int end) {
    return Column(
      children: List.generate(end - start + 1, (index) {
        String seatNumber = (start + index).toString();
        SeatStatus status;
        if (_occupiedSeats.contains(seatNumber)) {
          status = SeatStatus.occupied;
        } else if (_selectedSeats.contains(seatNumber)) {
          status = SeatStatus.selected;
        } else {
          status = SeatStatus.available;
        }
        return SeatWidget(
          seatNumber: seatNumber,
          status: status,
          onTap: () => _onSeatTapped(seatNumber),
        );
      }),
    );
  }

  Widget _buildContactForms() {
    if (_selectedSeats.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(24),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Text(
          'Please select your seat(s) above.',
          style: TextStyle(color: Colors.grey, fontSize: 16),
        ),
      );
    }

    final seatsList = _selectedSeats.toList()
      ..sort((a, b) => int.parse(a).compareTo(int.parse(b)));

    return Column(
      children: List.generate(seatsList.length, (index) {
        final seat = seatsList[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 24.0),
          child: ContactDetailsForm(
            title: 'Passenger ${index + 1}',
            seatNumber: '$_selectedCoach / $seat',
          ),
        );
      }),
    );
  }

  Widget _buildPurchaseButton(bool isEnabled) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isEnabled
            ? () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PaymentScreen(
                      totalPrice: _totalPrice,
                      selectedClass: _selectedClass,
                      selectedCoach: _selectedCoach,
                      selectedSeats: _selectedSeats,
                      numberOfPassengers: _selectedNumberOfPassengers,
                    ),
                  ),
                );
              }
            : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).primaryColor,
          disabledBackgroundColor: Colors.grey.shade400,
          padding: const EdgeInsets.symmetric(vertical: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: const Text(
          'Purchase Ticket',
          style: TextStyle(fontSize: 18, color: Colors.white),
        ),
      ),
    );
  }
}
