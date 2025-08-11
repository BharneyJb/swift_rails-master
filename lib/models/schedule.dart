import 'dart:convert';

import 'package:swyft_rails/models/station.dart';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class Schedule {
  int? id;
  final String name;
  final double distance;
  final int stationId;
  final Station station;
  DateTime arrivalTime;
  DateTime departureTime;
  final String departureStation;
  DateTime createdAt;
  DateTime updatedAt;

  Schedule({
    this.id,
    required this.name,
    required this.distance,
    required this.stationId,
    required this.station,
    DateTime? arrivalTime,
    DateTime? departureTime,
    required this.departureStation,
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : arrivalTime = arrivalTime ?? DateTime.now(),
        departureTime = departureTime ?? DateTime.now(),
        createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'distance': distance,
      'stationId': stationId,
      'station': station.toMap(),
      'arrivalTime': arrivalTime.toIso8601String(),
      'departureTime': departureTime.toIso8601String(),
      'departureStation': departureStation,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory Schedule.fromMap(Map<String, dynamic> map) {
    return Schedule(
      id: map['id'] != null ? map['id'] as int : null,
      name: map['name'] as String,
      distance: map['distance'] as double,
      stationId: map['stationId'] as int,
      station: Station.fromMap(map['station'] as Map<String,dynamic>),
      arrivalTime: DateTime.parse(map['arrivalTime'] as String),
      departureTime: DateTime.parse(map['departureTime'] as String),
      departureStation: map['departureStation'] as String,
      createdAt: DateTime.parse(map['createdAt'] as String),
      updatedAt: DateTime.parse(map['updatedAt'] as String),
    );
  }

  String toJson() => json.encode(toMap());

  factory Schedule.fromJson(String source) => Schedule.fromMap(json.decode(source) as Map<String, dynamic>);
}
