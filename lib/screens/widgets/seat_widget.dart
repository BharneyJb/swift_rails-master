import 'package:flutter/material.dart';

enum SeatStatus { available, selected, occupied }

class SeatWidget extends StatelessWidget {
  final String seatNumber;
  final SeatStatus status;
  final VoidCallback onTap;
  final double size;

  const SeatWidget({
    super.key,
    required this.seatNumber,
    required this.status,
    required this.onTap,
    this.size = 52.0,
  });

  static const Color _purple = Color(0xff4001a8);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: status == SeatStatus.occupied ? null : onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        width: size,
        height: size + 4,
        margin: const EdgeInsets.all(4.0),
        decoration: BoxDecoration(
          color: _backgroundColor,
          border: Border.all(color: _borderColor, width: 1.8),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(14),
            topRight: Radius.circular(14),
            bottomLeft: Radius.circular(6),
            bottomRight: Radius.circular(6),
          ),
          boxShadow: _boxShadow,
        ),
        child: Column(
          children: [
            // Headrest strip
            Container(
              height: 7,
              decoration: BoxDecoration(
                color: _headrestColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(13),
                  topRight: Radius.circular(13),
                ),
              ),
            ),
            // Seat body with number
            Expanded(
              child: Center(
                child: Text(
                  seatNumber,
                  style: TextStyle(
                    color: _textColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 11,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color get _backgroundColor {
    switch (status) {
      case SeatStatus.selected:
        return _purple;
      case SeatStatus.occupied:
        return Colors.grey.shade300;
      case SeatStatus.available:
        return Colors.white;
    }
  }

  Color get _borderColor {
    switch (status) {
      case SeatStatus.selected:
        return _purple;
      case SeatStatus.occupied:
        return Colors.grey.shade400;
      case SeatStatus.available:
        return _purple;
    }
  }

  Color get _headrestColor {
    switch (status) {
      case SeatStatus.selected:
        return const Color(0xff5a1ec8);
      case SeatStatus.occupied:
        return Colors.grey.shade400;
      case SeatStatus.available:
        return const Color(0xffe8d5ff);
    }
  }

  Color get _textColor {
    switch (status) {
      case SeatStatus.selected:
        return Colors.white;
      case SeatStatus.occupied:
        return Colors.grey.shade500;
      case SeatStatus.available:
        return _purple;
    }
  }

  List<BoxShadow> get _boxShadow {
    switch (status) {
      case SeatStatus.selected:
        return [
          BoxShadow(
            color: _purple.withOpacity(0.45),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
          BoxShadow(
            color: Colors.orange.withOpacity(0.25),
            blurRadius: 12,
            spreadRadius: 1,
          ),
        ];
      case SeatStatus.available:
        return [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ];
      case SeatStatus.occupied:
        return [];
    }
  }
}
