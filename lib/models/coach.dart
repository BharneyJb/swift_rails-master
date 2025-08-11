import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class Coach {
  int? id; 
  final String code;
  final int trainId;
  final int travelClassId;
  DateTime createdAt;
  DateTime updatedAt;
  Coach({
    this.id,
    required this.code,
    required this.trainId,
    required this.travelClassId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'code': code,
      'trainId': trainId,
      'travelClassId': travelClassId,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory Coach.fromMap(Map<String, dynamic> map) {
    return Coach(
      id: map['id'] != null ? map['id'] as int : null,
      code: map['code'] as String,
      trainId: map['trainId'] as int,
      travelClassId: map['travelClassId'] as int,
      createdAt: DateTime.parse(map['createdAt'] as String),
      updatedAt: DateTime.parse(map['updatedAt'] as String),
    );
  }

  String toJson() => json.encode(toMap());

  factory Coach.fromJson(String source) => Coach.fromMap(json.decode(source) as Map<String, dynamic>);
}
