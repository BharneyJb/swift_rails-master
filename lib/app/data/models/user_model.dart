class UserModel {
  final int id;
  final String firstName;
  final String surname;
  final String email;
  final String? phone;
  final String? gender;
  final String? dob;
  final String? nin;
  final String? avatar;
  final String role;
  final DateTime? createdAt;

  UserModel({
    required this.id,
    required this.firstName,
    required this.surname,
    required this.email,
    this.phone,
    this.gender,
    this.dob,
    this.nin,
    this.avatar,
    required this.role,
    this.createdAt,
  });

  /// Display name composed from firstName + surname.
  /// Falls back to the email prefix if both are empty (e.g. right after login
  /// before GET /customers has been called).
  String get fullName {
    final f = firstName.trim();
    final s = surname.trim();
    if (f.isNotEmpty || s.isNotEmpty) return '$f $s'.trim();
    if (email.isNotEmpty) return email.split('@').first;
    return 'User';
  }

  /// Single initial for avatars — always safe.
  String get initial => fullName.isNotEmpty ? fullName[0].toUpperCase() : 'U';

  factory UserModel.fromJson(Map<String, dynamic> json) {
    // The API returns firstName / surname.
    // Legacy responses (pre-fix) may return a bare 'name' field — handle both.
    String firstName = (json['firstName'] as String? ?? '').trim();
    String surname = (json['surname'] as String? ?? '').trim();

    if (firstName.isEmpty && surname.isEmpty) {
      // Fallback: split a legacy 'name' field if present
      final legacy = (json['name'] as String? ?? '').trim();
      final parts = legacy.split(' ');
      firstName = parts.isNotEmpty ? parts.first : '';
      surname = parts.length > 1 ? parts.sublist(1).join(' ') : '';
    }

    return UserModel(
      id: json['id'] ?? 0,
      firstName: firstName,
      surname: surname,
      email: (json['email'] as String? ?? '').trim(),
      phone: json['phone'] as String?,
      gender: json['gender'] as String?,
      dob: json['dob'] as String?,
      nin: json['nin'] as String?,
      avatar: json['avatar'] as String?,
      role: json['role'] ?? 'customer',
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString())
          : json['created_at'] != null
              ? DateTime.tryParse(json['created_at'].toString())
              : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'surname': surname,
      'email': email,
      'phone': phone,
      'gender': gender,
      'dob': dob,
      'nin': nin,
      'avatar': avatar,
      'role': role,
      'createdAt': createdAt?.toIso8601String(),
    };
  }
}
