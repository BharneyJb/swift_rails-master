import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class Customer {
  int? id;
  final String surname;
  final String firstName;
  final String email;
  final String phone;
  final String gender;
  final DateTime dob;
  final String password;
  final String nin;
  DateTime createdAt;
  DateTime updatedAt;
  Customer({
    this.id,
    required this.surname,
    required this.firstName,
    required this.email,
    required this.phone,
    required this.gender,
    required this.dob,
    required this.password,
    required this.nin,
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'surname': surname,
      'firstName': firstName,
      'email': email,
      'phone': phone,
      'gender': gender,
      'dob': dob.toIso8601String(),
      'password': password,
      'nin': nin,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory Customer.fromMap(Map<String, dynamic> map) {
    return Customer(
      id: map['id'] != null ? map['id'] as int : null,
      surname: map['surname'] as String,
      firstName: map['firstName'] as String,
      email: map['email'] as String,
      phone: map['phone'] as String,
      gender: map['gender'] as String,
      dob: DateTime.parse(map['dob'] as String),
      password: map['password'] as String,
      nin: map['nin'] as String,
      createdAt: DateTime.parse(map['createdAt'] as String),
      updatedAt: DateTime.parse(map['updatedAt'] as String),
    );
  }

  String toJson() => json.encode(toMap());

  factory Customer.fromJson(String source) => Customer.fromMap(json.decode(source) as Map<String, dynamic>);
}
