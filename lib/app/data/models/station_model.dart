class StationModel {
  final int id;
  final String name;
  final String city;
  final String code;
  final String? address;

  StationModel({
    required this.id,
    required this.name,
    required this.city,
    required this.code,
    this.address,
  });

  factory StationModel.fromJson(Map<String, dynamic> json) {
    return StationModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      city: json['city'] ?? '',
      code: json['code'] ?? json['station_code'] ?? '',
      address: json['address'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'city': city,
      'code': code,
      'address': address,
    };
  }

  @override
  String toString() => name;
}
