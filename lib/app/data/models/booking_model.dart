class BookingModel {
  final String bookingId;
  final String message;

  BookingModel({
    required this.bookingId,
    required this.message,
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      bookingId: json['bookingId']?.toString() ?? json['id']?.toString() ?? '',
      message: json['message'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'bookingId': bookingId,
      'message': message,
    };
  }
}
