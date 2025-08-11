import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class Train {
  int? id;
  final String code;
  DateTime createdAt;
  DateTime updatedAt;
  Train({
    this.id,
    required this.code,
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'code': code,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory Train.fromMap(Map<String, dynamic> map) {
    return Train(
      id: map['id'] != null ? map['id'] as int : null,
      code: map['code'] as String,
      createdAt: DateTime.parse(map['createdAt'] as String),
      updatedAt: DateTime.parse(map['updatedAt'] as String),
    );
  }

  String toJson() => json.encode(toMap());

  factory Train.fromJson(String source) => Train.fromMap(json.decode(source) as Map<String, dynamic>);
}
