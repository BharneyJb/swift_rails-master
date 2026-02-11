class ApiEndpoints {
  // Base URL - Update with your backend server IP and port
  static const String baseUrl = 'http://localhost:3000';
  
  // Auth Endpoints
  static const String login = '/login';
  static const String register = '/register'; // Not implemented in backend yet
  static const String forgotPassword = '/forgot-password';
  static const String verifyOtp = '/verify-otp';
  static const String resetPassword = '/reset-password';
  
  // Customer/User Endpoints
  static const String profile = '/customers';
  static const String updateProfile = '/customers';
  
  // Train & Station Endpoints
  static const String trains = '/trains';
  static const String stations = '/stations';
  static const String schedules = '/schedules';
  static const String coaches = '/coaches';
  static String trainDetails(int id) => '/trains/$id';
  static String stationDetails(int id) => '/stations/$id';
  static String scheduleDetails(int id) => '/schedules/$id';
  static String schedulesByRoute(int fromStationId, int toStationId) => 
      '/schedules/route/$fromStationId/$toStationId';
  static String coachDetails(int id) => '/coaches/$id';
  
  // Booking Endpoints
  static const String bookings = '/bookings';
  static const String createBooking = '/bookings';
  static String bookingDetails(int id) => '/bookings/$id';
  
  // Seat Endpoints
  static const String seats = '/seats';
  static String seatDetails(int id) => '/seats/$id';
  static const String bookedSeats = '/booked-seats';
  
  // Fare Endpoints
  static const String fares = '/fares';
  static String fareDetails(int id) => '/fares/$id';
  
  // Amount Endpoints
  static String amountDetails(int id) => '/amounts/$id';
}
