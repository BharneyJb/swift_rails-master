class SeatModel {
  final int id;
  final String code;
  final int coachId;
  final int travelClassId;
  final String status; // "Available" or "Unavailable"

  SeatModel({
    required this.id,
    required this.code,
    required this.coachId,
    required this.travelClassId,
    required this.status,
  });

  factory SeatModel.fromJson(Map<String, dynamic> json) {
    return SeatModel(
      id: json['id'] ?? 0,
      code: json['code'] ?? '',
      coachId: json['coachId'] ?? 0,
      travelClassId: json['travelClassId'] ?? 0,
      status: json['status'] ?? 'Unavailable',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
      'coachId': coachId,
      'travelClassId': travelClassId,
      'status': status,
    };
  }
}
