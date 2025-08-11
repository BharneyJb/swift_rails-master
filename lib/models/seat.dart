import 'dart:convert';

import 'package:swyft_rails/models/coach.dart';
import 'package:swyft_rails/models/customer.dart';
import 'package:swyft_rails/models/travelclass.dart';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class Seat {
  int? id;
  final String code;
  final int coachId;
  final Coach coach;
  final int customerId;
  final Customer customer;
  final int travelClassId;
  final TravelClass travelClass;
  final String status;
  DateTime createdAt;
  DateTime updatedAt;
  Seat({
    required this.coach, 
    required this.customer, 
    required this.travelClass,
    this.id,
    required this.code,
    required this.coachId,
    required this.customerId,
    required this.travelClassId,
    required this.status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'code': code,
      'coachId': coachId,
      'coach': coach.toMap(),
      'customerId': customerId,
      'customer': customer.toMap(),
      'travelClassId': travelClassId,
      'travelClass': travelClass.toMap(),
      'status': status,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory Seat.fromMap(Map<String, dynamic> map) {
    return Seat(
      id: map['id'] != null ? map['id'] as int : null,
      code: map['code'] as String,
      coachId: map['coachId'] as int,
      coach: Coach.fromMap(map['coach'] as Map<String, dynamic>),
      customer: Customer.fromMap(map['customer'] as Map<String, dynamic>),
      travelClass: TravelClass.fromMap(map['travelClass'] as Map<String, dynamic>),

      customerId: map['customerId'] as int,
      travelClassId: map['travelClassId'] as int,
      status: map['status'] as String,
      createdAt: DateTime.parse(map['createdAt'] as String),
      updatedAt: DateTime.parse(map['updatedAt'] as String), 
    );
  }

  String toJson() => json.encode(toMap());

  factory Seat.fromJson(String source) => Seat.fromMap(json.decode(source) as Map<String, dynamic>);
}
