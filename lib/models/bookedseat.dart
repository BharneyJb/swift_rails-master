// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'booking.dart';
import 'seat.dart';

class BookedSeat {
  int? id;
  final int bookingId;
  final Booking booking;
  final int seatId;
  final Seat seat;
  final String passengerType;
  final int phone;
  final String nin;
  final String email;
  final double amount;
  DateTime createdAt;
  DateTime updatedAt;
  BookedSeat({
    this.id,
    required this.bookingId,
    required this.booking,
    required this.seatId,
    required this.seat,
    required this.passengerType,
    required this.phone,
    required this.nin,
    required this.email,
    required this.amount,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'bookingId': bookingId,
      'booking': booking.toMap(),
      'seatId': seatId,
      'seat': seat.toMap(),
      'passengerType': passengerType,
      'phone': phone,
      'nin': nin,
      'email': email,
      'amount': amount,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory BookedSeat.fromMap(Map<String, dynamic> map) {
    return BookedSeat(
      id: map['id'] != null ? map['id'] as int : null,
      bookingId: map['bookingId'] as int,
      booking: Booking.fromMap(map['booking'] as Map<String,dynamic>),
      seatId: map['seatId'] as int,
      seat: Seat.fromMap(map['seat'] as Map<String,dynamic>),
      passengerType: map['passengerType'] as String,
      phone: map['phone'] as int,
      nin: map['nin'] as String,
      email: map['email'] as String,
      amount: map['amount'] as double,
      createdAt: DateTime.parse(map['createdAt'] as String),
      updatedAt: DateTime.parse(map['updatedAt'] as String),
    );
  }

  String toJson() => json.encode(toMap());

  factory BookedSeat.fromJson(String source) => BookedSeat.fromMap(json.decode(source) as Map<String, dynamic>);
}
