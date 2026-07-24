// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:swyft_rails/screens/passenger_details_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  static const Color _purple = Color(0xff4001a8);
  static const Color _purpleLight = Color(0xff5a1ec8);

  final TextEditingController _fromController = TextEditingController();
  final TextEditingController _toController = TextEditingController();

  DateTime _departDate = DateTime.now();
  DateTime _returnDate = DateTime.now().add(const Duration(days: 1));
  bool _isRoundTrip = false;

  int _passengers = 1;
  String _classValue = 'First Class';

  static const List<String> _classOptions = [
    'Economy Class',
    'Business Class',
    'First Class',
  ];

  static const List<int> _passengerOptions = [1, 2, 3, 4, 5];

  @override
  void dispose() {
    _fromController.dispose();
    _toController.dispose();
    super.dispose();
  }

  String _formatDate(DateTime d) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${months[d.month - 1]} ${d.day}, ${d.year}';
  }

  void _swapFromTo() {
    final tmp = _fromController.text;
    setState(() {
      _fromController.text = _toController.text;
      _toController.text = tmp;
    });
  }

  Future<void> _pickDepartDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _departDate,
      firstDate: DateTime.now().subtract(const Duration(days: 1)),
      lastDate: DateTime(2100),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(
            primary: _purple,
            onPrimary: Colors.white,
            onSurface: Colors.black87,
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      setState(() {
        _departDate = picked;
        if (_returnDate.isBefore(_departDate)) {
          _returnDate = _departDate.add(const Duration(days: 1));
        }
      });
    }
  }

  Future<void> _pickReturnDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _returnDate.isAfter(_departDate)
          ? _returnDate
          : _departDate.add(const Duration(days: 1)),
      firstDate: _departDate,
      lastDate: DateTime(2100),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(
            primary: _purple,
            onPrimary: Colors.white,
            onSurface: Colors.black87,
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      setState(() => _returnDate = picked);
    }
  }

  void _openSearch() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const PassengerDetailsScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: CustomScrollView(
        slivers: [
          // ── Purple header ──────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [_purple, _purpleLight],
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(32),
                  bottomRight: Radius.circular(32),
                ),
              ),
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Find your ride',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: -0.4,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Search trains between cities',
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.75),
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: _pickDepartDate,
                            child: Container(
                              width: 42,
                              height: 42,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white.withOpacity(0.15),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.3),
                                  width: 1.5,
                                ),
                              ),
                              child: const Icon(
                                Icons.calendar_today_outlined,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 22),

                      _buildTripTypeToggle(),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // ── Body content ──────────────────────────────────────────────
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Search card
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.06),
                        blurRadius: 18,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      _buildStationField(
                        controller: _fromController,
                        hint: 'Departure city',
                        accent: _purple,
                        showSwap: true,
                      ),
                      const Divider(
                        height: 1,
                        thickness: 1,
                        color: Color(0xFFEDEDED),
                        indent: 76,
                      ),
                      _buildStationField(
                        controller: _toController,
                        hint: 'Arrival city',
                        accent: _purple,
                        showSwap: false,
                      ),
                      const Divider(
                        height: 1,
                        thickness: 1,
                        color: Color(0xFFEDEDED),
                        indent: 76,
                      ),
                      _buildDateField(
                        icon: Icons.calendar_today_rounded,
                        label: _isRoundTrip ? 'Departure' : 'Date',
                        value: _formatDate(_departDate),
                        onTap: _pickDepartDate,
                      ),
                      if (_isRoundTrip) ...[
                        const Divider(
                          height: 1,
                          thickness: 1,
                          color: Color(0xFFEDEDED),
                          indent: 76,
                        ),
                        _buildDateField(
                          icon: Icons.event_repeat_rounded,
                          label: 'Return',
                          value: _formatDate(_returnDate),
                          onTap: _pickReturnDate,
                        ),
                      ],
                    ],
                  ),
                ),

                const SizedBox(height: 18),

                Row(
                  children: [
                    Expanded(
                      child: _buildDropdown<int>(
                        icon: Icons.person_outline_rounded,
                        value: _passengers,
                        items: _passengerOptions
                            .map((p) => DropdownMenuItem<int>(
                                  value: p,
                                  child: Text(
                                    '$p ${p == 1 ? "passenger" : "passengers"}',
                                    style: textTheme.titleMedium?.copyWith(
                                      color: Colors.black87,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ))
                            .toList(),
                        onChanged: (v) {
                          if (v != null) setState(() => _passengers = v);
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 2,
                      child: _buildDropdown<String>(
                        icon: Icons.workspace_premium_outlined,
                        value: _classValue,
                        items: _classOptions
                            .map((c) => DropdownMenuItem<String>(
                                  value: c,
                                  child: Text(
                                    c,
                                    style: textTheme.titleMedium?.copyWith(
                                      color: _classColor(c),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ))
                            .toList(),
                        onChanged: (v) {
                          if (v != null) setState(() => _classValue = v);
                        },
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                Text(
                  'RECENT SEARCHES',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade500,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _chip('Lagos → Abuja'),
                    _chip('Ibadan → Kano'),
                    _chip('Enugu → Port Harcourt'),
                  ],
                ),

                const SizedBox(height: 32),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _openSearch,
                    icon: const Icon(Icons.search_rounded, size: 22),
                    label: const Text(
                      'Search trains',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ),
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTripTypeToggle() {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withOpacity(0.25), width: 1),
      ),
      child: Row(
        children: [
          _toggleSegment(
            label: 'One way',
            isActive: !_isRoundTrip,
            onTap: () => setState(() => _isRoundTrip = false),
          ),
          _toggleSegment(
            label: 'Round trip',
            isActive: _isRoundTrip,
            onTap: () => setState(() => _isRoundTrip = true),
          ),
        ],
      ),
    );
  }

  Widget _toggleSegment({
    required String label,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOut,
          margin: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: isActive ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(11),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              color: isActive ? _purple : Colors.white,
              fontSize: 14,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStationField({
    required TextEditingController controller,
    required String hint,
    required Color accent,
    required bool showSwap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: accent.withOpacity(0.1),
            ),
            child: Icon(
              Icons.train_outlined,
              color: accent,
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: TextFormField(
              controller: controller,
              textCapitalization: TextCapitalization.words,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black87,
                fontWeight: FontWeight.w500,
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                isCollapsed: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 14),
                hintText: hint,
                hintStyle: TextStyle(
                  color: Colors.grey.shade400,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          if (showSwap)
            IconButton(
              onPressed: _swapFromTo,
              icon: Icon(
                Icons.swap_vert_rounded,
                color: Colors.grey.shade400,
              ),
              tooltip: 'Swap',
            ),
        ],
      ),
    );
  }

  Widget _buildDateField({
    required IconData icon,
    required String label,
    required String value,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _purple.withOpacity(0.1),
              ),
              child: Icon(icon, color: _purple, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      color: Colors.grey.shade500,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    value,
                    style: const TextStyle(
                      color: Colors.black87,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: Colors.grey.shade400,
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
      icon: Icon(Icons.arrow_drop_down_rounded, color: _purple),
      isExpanded: true,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: _purple),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.grey.shade200, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: _purple, width: 1.5),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        isDense: true,
      ),
    );
  }

  Widget _chip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.history_rounded, size: 14, color: Colors.grey.shade500),
          const SizedBox(width: 6),
          Text(
            text,
            style: TextStyle(
              color: Colors.grey.shade700,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Color _classColor(String name) {
    switch (name) {
      case 'First Class':
        return _purple;
      case 'Business Class':
        return Colors.indigo.shade400;
      case 'Economy Class':
      default:
        return Colors.black87;
    }
  }
}
