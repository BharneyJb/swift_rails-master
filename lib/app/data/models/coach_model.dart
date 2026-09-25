import 'seat_model.dart';

class CoachModel {
  final int id;
  final String code;
  final int trainId;
  final int travelClassId;
  final List<SeatModel> seats;

  CoachModel({
    required this.id,
    required this.code,
    required this.trainId,
    required this.travelClassId,
    required this.seats,
  });

  factory CoachModel.fromJson(Map<String, dynamic> json) {
    return CoachModel(
      id: json['id'] ?? 0,
      code: json['code'] ?? '',
      trainId: json['trainId'] ?? 0,
      travelClassId: json['travelClassId'] ?? 0,
      seats: (json['seats'] as List? ?? [])
          .map((e) => SeatModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
      'trainId': trainId,
      'travelClassId': travelClassId,
      'seats': seats.map((e) => e.toJson()).toList(),
    };
  }
}
