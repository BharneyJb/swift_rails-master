class TrainModel {
  final int id;
  final String trainName;
  final String trainNumber;
  final String trainType;

  TrainModel({
    required this.id,
    required this.trainName,
    required this.trainNumber,
    required this.trainType,
  });

  factory TrainModel.fromJson(Map<String, dynamic> json) {
    return TrainModel(
      id: json['id'] ?? 0,
      trainName: json['name'] ?? json['train_name'] ?? '',
      trainNumber: json['train_number'] ?? json['trainId']?.toString() ?? '',
      trainType: json['type'] ?? json['train_type'] ?? 'Express',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': trainName,
      'train_number': trainNumber,
      'type': trainType,
    };
  }
}
