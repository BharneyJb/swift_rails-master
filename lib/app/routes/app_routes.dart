// ignore_for_file: constant_identifier_names

abstract class AppRoutes {
  // Auth Routes
  static const SPLASH = '/splash';
  static const ONBOARDING = '/onboarding';
  static const LOGIN = '/login';
  static const REGISTER = '/register';
  static const FORGOT_PASSWORD = '/forgot-password';
  static const VERIFY_OTP = '/verify-otp';
  static const RESET_PASSWORD = '/reset-password';
  
  // Main Routes
  static const HOME = '/home';
  static const MAIN = '/main';
  
  // Booking Routes
  static const SEARCH_TRAINS = '/search-trains';
  static const TRAIN_DETAILS = '/train-details';
  static const SEAT_SELECTION = '/seat-selection';
  static const PASSENGER_DETAILS = '/passenger-details';
  static const PAYMENT = '/payment';
  static const PAYMENT_SUCCESS = '/payment-success';
  
  // Ticket Routes
  static const MY_TICKETS = '/my-tickets';
  static const TICKET_DETAILS = '/ticket-details';
  static const QR_SCANNER = '/qr-scanner';
  
  // Profile Routes
  static const PROFILE = '/profile';
  static const EDIT_PROFILE = '/edit-profile';
  static const TRIP_HISTORY = '/trip-history';
  static const NOTIFICATIONS = '/notifications';
  static const SETTINGS = '/settings';
  
  // Admin Routes (Optional)
  static const ADMIN_DASHBOARD = '/admin/dashboard';
  static const MANAGE_TRAINS = '/admin/trains';
  static const MANAGE_STATIONS = '/admin/stations';
  static const MANAGE_BOOKINGS = '/admin/bookings';
}
