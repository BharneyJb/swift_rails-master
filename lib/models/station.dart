import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class Station {
  int? id;
  final String stationCode;
  final String name;
  final String city;
  DateTime createdAt;
  DateTime updatedAt;
  Station({
    this.id,
    required this.stationCode,
    required this.name,
    required this.city,
   DateTime? createdAt,
    DateTime? updatedAt,
  }) : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'stationCode': stationCode,
      'name': name,
      'city': city,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory Station.fromMap(Map<String, dynamic> map) {
    return Station(
      id: map['id'] != null ? map['id'] as int : null,
      stationCode: map['stationCode'] as String,
      name: map['name'] as String,
      city: map['city'] as String,
      createdAt: DateTime.parse(map['createdAt'] as String),
      updatedAt: DateTime.parse(map['updatedAt'] as String),
    );
  }

  String toJson() => json.encode(toMap());

  factory Station.fromJson(String source) => Station.fromMap(json.decode(source) as Map<String, dynamic>);
}
