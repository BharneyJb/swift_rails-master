import 'package:flutter/material.dart';
import 'package:swyft_rails/models/schedule.dart';
import 'widgets/contact_details_form.dart';
import 'widgets/seat_widget.dart';
import 'payment_screen.dart';

class PassengerDetailsScreen extends StatefulWidget {
  final Schedule? schedule;

  const PassengerDetailsScreen({super.key, this.schedule});

  @override
  State<PassengerDetailsScreen> createState() =>
      _PassengerDetailsScreenState();
}

class _PassengerDetailsScreenState extends State<PassengerDetailsScreen> {
  static const Color _purple = Color(0xff4001a8);
  static const Color _purpleLight = Color(0xff7c3aed);

  // ── State ─────────────────────────────────────────────────────────────────
  int _selectedNumberOfPassengers = 1;
  String _selectedClass = 'First Class';
  String _selectedCoach = 'Coach A';
  double _totalPrice = 0.0;
  int _activeStep = 0; // 0=Seats 1=Passengers 2=Payment

  final Set<String> _selectedSeats = {};
  final Set<String> _occupiedSeats = {'A3', 'B2', 'C5', 'D1'};

  // Form keys for each passenger form
  final List<GlobalKey<ContactDetailsFormState>> _formKeys = [];

  static const double _basePrice = 2500.0;
  static const Map<String, double> _classMultipliers = {
    'First Class': 1.5,
    'Business Class': 1.2,
    'Economy Class': 1.0,
  };

  final List<String> _classOptions = [
    'Economy Class',
    'Business Class',
    'First Class',
  ];
  final List<String> _coachOptions = ['Coach A', 'Coach B', 'Coach C'];
  final List<int> _passengerOptions = [1, 2, 3, 4, 5];

  // ── Seat grid config ──────────────────────────────────────────────────────
  // 4 rows × 6 cols with center aisle (cols 0-2 | aisle | cols 3-5)
  static const int _rows = 6;
  static const List<String> _colLetters = ['A', 'B', 'C', 'D', 'E', 'F'];

  @override
  void initState() {
    super.initState();
    _calculatePrice();
  }

  String _seatId(int row, int col) =>
      '${_colLetters[col]}${row + 1}'; // e.g. A1, B3

  void _calculatePrice() {
    final multiplier = _classMultipliers[_selectedClass] ?? 1.0;
    setState(() {
      _totalPrice =
          _basePrice * _selectedNumberOfPassengers * multiplier;
    });
  }

  void _onSeatTapped(String seatId) {
    setState(() {
      if (_selectedSeats.contains(seatId)) {
        _selectedSeats.remove(seatId);
      } else {
        if (_selectedSeats.length < _selectedNumberOfPassengers) {
          _selectedSeats.add(seatId);
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

  String _formatTime(DateTime dt) {
    final h = dt.hour;
    final m = dt.minute.toString().padLeft(2, '0');
    final period = h >= 12 ? 'PM' : 'AM';
    final hour12 = h == 0 ? 12 : (h > 12 ? h - 12 : h);
    return '$hour12:$m $period';
  }

  Duration get _tripDuration {
    final s = widget.schedule;
    if (s == null) return const Duration(hours: 3);
    return s.arrivalTime.difference(s.departureTime);
  }

  String get _durationLabel {
    final h = _tripDuration.inHours;
    final m = _tripDuration.inMinutes.remainder(60);
    if (h == 0) return '${m}m';
    return m == 0 ? '${h}h' : '${h}h ${m}m';
  }

  String _formatCurrency(double value) {
    final formatted = value.toStringAsFixed(0);
    return '₦${formatted.replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')}';
  }

  // ── Purchase ──────────────────────────────────────────────────────────────
  void _onPurchase() {
    final seatsList = _selectedSeats.toList()..sort();
    // Rebuild form keys list fresh if sizes differ
    if (_formKeys.length != seatsList.length) return;

    final passengerDataList = <PassengerData>[];
    bool allValid = true;

    for (final key in _formKeys) {
      final data = key.currentState?.getData();
      if (data == null) {
        allValid = false;
      } else {
        passengerDataList.add(data);
      }
    }

    if (!allValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.redAccent,
          content: Text('Please fill in all passenger details correctly.'),
        ),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PaymentScreen(
          totalPrice: _totalPrice,
          selectedClass: _selectedClass,
          selectedCoach: _selectedCoach,
          selectedSeats: _selectedSeats,
          numberOfPassengers: _selectedNumberOfPassengers,
          passengerDataList: passengerDataList,
          schedule: widget.schedule,
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final seatsList = _selectedSeats.toList()..sort();
    final bool isSelectionComplete =
        _selectedSeats.length == _selectedNumberOfPassengers;

    // Keep form keys aligned with seats
    while (_formKeys.length < seatsList.length) {
      _formKeys.add(GlobalKey<ContactDetailsFormState>());
    }
    while (_formKeys.length > seatsList.length) {
      _formKeys.removeLast();
    }

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: CustomScrollView(
        slivers: [
          // ── SliverAppBar with trip header ──────────────────────────
          SliverAppBar(
            expandedHeight: 190,
            pinned: true,
            backgroundColor: _purple,
            leading: IconButton(
              icon:
                  const Icon(Icons.arrow_back_ios_new, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
            title: const Text(
              'Passenger Details',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 17,
              ),
            ),
            centerTitle: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [_purple, _purpleLight],
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 56, 20, 16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // Departure
                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.schedule?.departureStation ??
                                        'Lagos',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    widget.schedule != null
                                        ? _formatTime(
                                            widget.schedule!.departureTime)
                                        : '12:00 AM',
                                    style: TextStyle(
                                      color:
                                          Colors.white.withOpacity(0.75),
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Center
                            Column(
                              children: [
                                const Icon(Icons.train,
                                    color: Colors.white, size: 22),
                                const SizedBox(height: 2),
                                Text(
                                  _durationLabel,
                                  style: TextStyle(
                                    color:
                                        Colors.white.withOpacity(0.8),
                                    fontSize: 11,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  widget.schedule?.name ?? 'L1',
                                  style: TextStyle(
                                    color:
                                        Colors.white.withOpacity(0.65),
                                    fontSize: 10,
                                  ),
                                ),
                              ],
                            ),

                            // Arrival
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    widget.schedule?.station.name ??
                                        'Abuja',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.end,
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    widget.schedule != null
                                        ? _formatTime(
                                            widget.schedule!.arrivalTime)
                                        : '03:00 PM',
                                    style: TextStyle(
                                      color:
                                          Colors.white.withOpacity(0.75),
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // ── Body ─────────────────────────────────────────────────────
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Progress stepper
                _buildStepper(),
                const SizedBox(height: 20),

                // Selection dropdowns
                _buildSelectionFields(),
                const SizedBox(height: 20),

                // Seat map
                _buildSeatMapCard(),
                const SizedBox(height: 20),

                // Contact forms
                const Text(
                  'Passenger Details',
                  style: TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                _buildContactForms(seatsList),
                const SizedBox(height: 12),
              ]),
            ),
          ),
        ],
      ),

      // ── Sticky bottom bar ──────────────────────────────────────────────
      bottomNavigationBar: _buildBottomBar(isSelectionComplete),
    );
  }

  // ─── Sub-builders ─────────────────────────────────────────────────────────

  Widget _buildStepper() {
    final steps = ['Seats', 'Passengers', 'Payment'];
    return Row(
      children: List.generate(steps.length * 2 - 1, (i) {
        if (i.isOdd) {
          // Connector line
          final stepIdx = i ~/ 2;
          final isCompleted = _activeStep > stepIdx;
          return Expanded(
            child: Container(
              height: 2,
              color: isCompleted ? _purple : Colors.grey.shade300,
            ),
          );
        }
        final stepIdx = i ~/ 2;
        final isActive = _activeStep == stepIdx;
        final isCompleted = _activeStep > stepIdx;
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isActive || isCompleted
                    ? _purple
                    : Colors.grey.shade300,
              ),
              child: Center(
                child: isCompleted
                    ? const Icon(Icons.check,
                        size: 14, color: Colors.white)
                    : Text(
                        '${stepIdx + 1}',
                        style: TextStyle(
                          color: isActive
                              ? Colors.white
                              : Colors.grey.shade600,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              steps[stepIdx],
              style: TextStyle(
                fontSize: 10,
                color: isActive ? _purple : Colors.grey.shade500,
                fontWeight:
                    isActive ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildSelectionFields() {
    return Card(
      elevation: 2,
      color: Colors.white,
      shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: _buildDropdown<int>(
                    icon: Icons.person_outline,
                    value: _selectedNumberOfPassengers,
                    items: _passengerOptions
                        .map((p) => DropdownMenuItem<int>(
                            value: p, child: Text('$p pax')))
                        .toList(),
                    onChanged: (v) {
                      if (v == null) return;
                      setState(() {
                        _selectedNumberOfPassengers = v;
                        _selectedSeats.clear();
                        _calculatePrice();
                      });
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: _buildDropdown<String>(
                    icon: Icons.airline_seat_recline_extra_outlined,
                    value: _selectedClass,
                    items: _classOptions
                        .map((c) => DropdownMenuItem<String>(
                            value: c, child: Text(c)))
                        .toList(),
                    onChanged: (v) {
                      if (v == null) return;
                      setState(() {
                        _selectedClass = v;
                        _calculatePrice();
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildDropdown<String>(
              icon: Icons.train_outlined,
              value: _selectedCoach,
              items: _coachOptions
                  .map((c) =>
                      DropdownMenuItem<String>(value: c, child: Text(c)))
                  .toList(),
              onChanged: (v) {
                if (v == null) return;
                setState(() => _selectedCoach = v);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdown<T>({
    required IconData icon,
    required T value,
    required List<DropdownMenuItem<T>> items,
    required ValueChanged<T?> onChanged,
  }) {
    return DropdownButtonFormField<T>(
      value: value,
      items: items,
      onChanged: onChanged,
      icon: const Icon(Icons.arrow_drop_down, color: _purple),
      isExpanded: true,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.grey[600], size: 20),
        filled: true,
        fillColor: Colors.grey.shade50,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: _purple),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
        isDense: true,
      ),
    );
  }

  Widget _buildSeatMapCard() {
    return Card(
      elevation: 2,
      color: Colors.white,
      shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select Your Seat(s)',
              style:
                  TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            // Legend
            Row(
              children: [
                _legendItem(
                    color: Colors.white,
                    border: _purple,
                    label: 'Available'),
                const SizedBox(width: 16),
                _legendItem(color: _purple, border: _purple, label: 'Selected'),
                const SizedBox(width: 16),
                _legendItem(
                    color: Colors.grey.shade300,
                    border: Colors.grey.shade400,
                    label: 'Occupied'),
              ],
            ),
            const SizedBox(height: 16),

            // Column headers
            Row(
              children: [
                const SizedBox(width: 20), // row number column
                ..._colLetters.asMap().entries.map((e) {
                  final bool isAisle = e.key == 3;
                  return Row(
                    children: [
                      if (isAisle) const SizedBox(width: 24),
                      SizedBox(
                        width: 60,
                        child: Center(
                          child: Text(
                            e.value,
                            style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey.shade500),
                          ),
                        ),
                      ),
                    ],
                  );
                }),
              ],
            ),
            const SizedBox(height: 4),

            // Seat grid
            ...List.generate(_rows, (row) {
              return Row(
                children: [
                  // Row number
                  SizedBox(
                    width: 20,
                    child: Text(
                      '${row + 1}',
                      style: TextStyle(
                          fontSize: 10, color: Colors.grey.shade400),
                      textAlign: TextAlign.right,
                    ),
                  ),
                  ...List.generate(_colLetters.length, (col) {
                    final id = _seatId(row, col);
                    SeatStatus status;
                    if (_occupiedSeats.contains(id)) {
                      status = SeatStatus.occupied;
                    } else if (_selectedSeats.contains(id)) {
                      status = SeatStatus.selected;
                    } else {
                      status = SeatStatus.available;
                    }
                    return Row(
                      children: [
                        if (col == 3) const SizedBox(width: 24), // aisle
                        SizedBox(
                          width: 60,
                          child: Center(
                            child: SeatWidget(
                              seatNumber: id,
                              status: status,
                              onTap: () => _onSeatTapped(id),
                              size: 48,
                            ),
                          ),
                        ),
                      ],
                    );
                  }),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _legendItem(
      {required Color color,
      required Color border,
      required String label}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            border: Border.all(color: border, width: 1.5),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 4),
        Text(label,
            style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
      ],
    );
  }

  Widget _buildContactForms(List<String> seatsList) {
    if (seatsList.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(32),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Icon(Icons.event_seat_outlined,
                size: 48, color: Colors.grey.shade300),
            const SizedBox(height: 12),
            Text(
              'Select your seat(s) above to fill in passenger details.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey.shade500),
            ),
          ],
        ),
      );
    }

    return Column(
      children: List.generate(seatsList.length, (index) {
        final seat = seatsList[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: ContactDetailsForm(
            key: _formKeys[index],
            title: 'Passenger ${index + 1}',
            seatNumber: '$_selectedCoach / $seat',
          ),
        );
      }),
    );
  }

  Widget _buildBottomBar(bool isSelectionComplete) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Total',
                style:
                    TextStyle(fontSize: 12, color: Colors.grey.shade500),
              ),
              Text(
                _formatCurrency(_totalPrice),
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: _purple,
                ),
              ),
            ],
          ),
          const SizedBox(width: 20),
          Expanded(
            child: ElevatedButton(
              onPressed: isSelectionComplete ? _onPurchase : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: _purple,
                disabledBackgroundColor: Colors.grey.shade400,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
              ),
              child: Text(
                isSelectionComplete
                    ? 'Purchase Ticket'
                    : 'Select ${_selectedNumberOfPassengers - _selectedSeats.length} more seat(s)',
                style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
