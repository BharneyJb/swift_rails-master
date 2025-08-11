import 'dart:convert';

import 'customer.dart';
import 'schedule.dart';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class Booking {
  int? id;
  final int scheduleId;
  final Schedule schedule;
  final int customerId;
  final Customer customer;
  DateTime date;
  DateTime arrivalTime;
  DateTime departureTime;
   DateTime createdAt;
  DateTime updatedAt;
  Booking({
    this.id,
    required this.scheduleId,
    required this.schedule,
    required this.customerId,
    required this.customer,
    DateTime? date,
    DateTime? arrivalTime,
    DateTime? departureTime,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : date = date ?? DateTime.now(),
      arrivalTime = arrivalTime ?? DateTime.now(),
      departureTime = departureTime ?? DateTime.now(),
      createdAt = createdAt ?? DateTime.now(),
      updatedAt = updatedAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'scheduleId': scheduleId,
      'schedule': schedule.toMap(),
      'customerId': customerId,
      'customer': customer.toMap(),
      'date': date.toIso8601String(),
      'arrivalTime': arrivalTime.toIso8601String(),
      'departureTime': departureTime.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory Booking.fromMap(Map<String, dynamic> map) {
    return Booking(
      id: map['id'] != null ? map['id'] as int : null,
      scheduleId: map['scheduleId'] as int,
      schedule: Schedule.fromMap(map['schedule'] as Map<String,dynamic>),
      customerId: map['customerId'] as int,
      customer: Customer.fromMap(map['customer'] as Map<String,dynamic>),
      date: DateTime.parse(map['date'] as String),
      arrivalTime: DateTime.parse(map['arrivalTime'] as String),
      departureTime: DateTime.parse(map['departureTime'] as String),
      createdAt: DateTime.parse(map['createdAt'] as String),
      updatedAt: DateTime.parse(map['updatedAt'] as String),
    );
  }

  String toJson() => json.encode(toMap());

  factory Booking.fromJson(String source) => Booking.fromMap(json.decode(source) as Map<String, dynamic>);
}
