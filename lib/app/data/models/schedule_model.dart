class ScheduleModel {
  final int id;
  final String trainName;
  final String from;
  final String to;
  final DateTime departureTime;
  final DateTime arrivalTime;
  final double price;
  final int availableSeats;
  final String? trainNumber;
  final String? trainClass;

  ScheduleModel({
    required this.id,
    required this.trainName,
    required this.from,
    required this.to,
    required this.departureTime,
    required this.arrivalTime,
    required this.price,
    required this.availableSeats,
    this.trainNumber,
    this.trainClass,
  });

  factory ScheduleModel.fromJson(Map<String, dynamic> json) {
    return ScheduleModel(
      id: json['id'] ?? 0,
      trainName: json['train_name'] ?? json['name'] ?? '',
      from: json['from'] ?? json['departure_station'] ?? '',
      to: json['to'] ?? json['arrival_station'] ?? '',
      departureTime: json['departure_time'] != null
          ? DateTime.parse(json['departure_time'])
          : DateTime.now(),
      arrivalTime: json['arrival_time'] != null
          ? DateTime.parse(json['arrival_time'])
          : DateTime.now(),
      price: (json['price'] ?? 0).toDouble(),
      availableSeats: json['available_seats'] ?? 0,
      trainNumber: json['train_number'],
      trainClass: json['train_class'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'train_name': trainName,
      'from': from,
      'to': to,
      'departure_time': departureTime.toIso8601String(),
      'arrival_time': arrivalTime.toIso8601String(),
      'price': price,
      'available_seats': availableSeats,
      'train_number': trainNumber,
      'train_class': trainClass,
    };
  }

  String get duration {
    final diff = arrivalTime.difference(departureTime);
    final hours = diff.inHours;
    final minutes = diff.inMinutes.remainder(60);
    return '${hours}h ${minutes}m';
  }
}
