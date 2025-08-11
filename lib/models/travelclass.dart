import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class TravelClass {
  int? id;
  final String name;
  final String description;
  DateTime createdAt;
  DateTime updatedAt;
  TravelClass({
    this.id,
    required this.name,
    required this.description,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'description': description,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory TravelClass.fromMap(Map<String, dynamic> map) {
    return TravelClass(
      id: map['id'] != null ? map['id'] as int : null,
      name: map['name'] as String,
      description: map['description'] as String,
      createdAt: DateTime.parse(map['createdAt'] as String),
      updatedAt: DateTime.parse(map['updatedAt'] as String),
    );
  }

  String toJson() => json.encode(toMap());

  factory TravelClass.fromJson(String source) => TravelClass.fromMap(json.decode(source) as Map<String, dynamic>);
}
