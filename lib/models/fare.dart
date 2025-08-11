// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:swyft_rails/models/travelclass.dart';

class Fare {
  int? id;
  final String passengerType;
  final int travelClassId;
  final TravelClass travelClass;
  DateTime createdAt;
  DateTime updatedAt;
  Fare({
    this.id,
    required this.passengerType,
    required this.travelClassId,
    required this.travelClass,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'passengerType': passengerType,
      'travelClassId': travelClassId,
      'travelClass': travelClass.toMap(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory Fare.fromMap(Map<String, dynamic> map) {
    return Fare(
      id: map['id'] != null ? map['id'] as int : null,
      passengerType: map['passengerType'] as String,
      travelClassId: map['travelClassId'] as int,
      travelClass: TravelClass.fromMap(map['travelClass'] as Map<String,dynamic>),
      createdAt: DateTime.parse(map['createdAt'] as String),
      updatedAt: DateTime.parse(map['updatedAt'] as String),
    );
  }

  String toJson() => json.encode(toMap());

  factory Fare.fromJson(String source) => Fare.fromMap(json.decode(source) as Map<String, dynamic>);
}
