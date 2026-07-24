import 'package:flutter/material.dart';

// Enum to manage the state of the seat
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
    this.size = 48.0,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: status == SeatStatus.occupied ? null : onTap,
      child: Container(
        width: size,
        height: size,
        margin: const EdgeInsets.all(6.0),
        decoration: BoxDecoration(
          color: _getBackgroundColor(),
          border: Border.all(color: _getBorderColor(), width: 1.5),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(8),
            topRight: Radius.circular(8),
            bottomLeft: Radius.circular(4),
            bottomRight: Radius.circular(4),
          ),
        ),
        child: Center(
          child: Text(
            seatNumber,
            style: TextStyle(
              color: _getTextColor(),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Color _getBorderColor() {
    switch (status) {
      case SeatStatus.selected:
        return Colors.deepOrange;
      case SeatStatus.occupied:
        return Colors.grey.shade400;
      case SeatStatus.available:
        return Colors.black54;
    }
  }

  Color? _getBackgroundColor() {
    switch (status) {
      case SeatStatus.occupied:
        return Colors.grey.shade200;
      default:
        return Colors.transparent;
    }
  }

  Color _getTextColor() {
    switch (status) {
      case SeatStatus.occupied:
        return Colors.grey.shade500;
      default:
        return Colors.black87;
    }
  }
}
