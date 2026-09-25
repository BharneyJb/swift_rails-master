class TravelClassModel {
  final int travelClassId;
  final String travelClass;
  final double adultAmount;
  final double childAmount;

  TravelClassModel({
    required this.travelClassId,
    required this.travelClass,
    required this.adultAmount,
    required this.childAmount,
  });

  factory TravelClassModel.fromJson(Map<String, dynamic> json) {
    return TravelClassModel(
      travelClassId: json['travelClassId'] ?? 0,
      travelClass: json['travelClass'] ?? '',
      adultAmount: ((json['adultAmount'] ?? 0) as num).toDouble(),
      childAmount: ((json['childAmount'] ?? 0) as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'travelClassId': travelClassId,
      'travelClass': travelClass,
      'adultAmount': adultAmount,
      'childAmount': childAmount,
    };
  }
}
