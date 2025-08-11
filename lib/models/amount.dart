import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class Amount {
  int? id;
  final double amount;
  DateTime createdAt;
  DateTime updatedAt;
  Amount({
    this.id,
    required this.amount,
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'amount': amount,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory Amount.fromMap(Map<String, dynamic> map) {
    return Amount(
      id: map['id'] != null ? map['id'] as int : null,
      amount: map['amount'] as double,
      createdAt: DateTime.parse(map['createdAt'] as String),
      updatedAt: DateTime.parse(map['updatedAt'] as String),
    );
  }

  String toJson() => json.encode(toMap());

  factory Amount.fromJson(String source) => Amount.fromMap(json.decode(source) as Map<String, dynamic>);
}
