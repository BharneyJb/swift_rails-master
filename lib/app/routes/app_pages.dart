import 'package:get/get.dart';
import '../modules/splash/bindings/splash_binding.dart';
import '../modules/splash/views/splash_view.dart';
import '../modules/onboarding/bindings/onboarding_binding.dart';
import '../modules/onboarding/views/onboarding_view.dart';
import '../modules/auth/bindings/auth_binding.dart';
import '../modules/auth/views/login_view.dart';
import '../modules/auth/views/register_view.dart';
import '../modules/auth/views/forgot_password_view.dart';
import '../modules/auth/views/verify_otp_view.dart';
import '../modules/auth/views/reset_password_view.dart';
import '../modules/main/bindings/main_binding.dart';
import '../modules/main/views/main_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/search/bindings/search_binding.dart';
import '../modules/booking/bindings/booking_binding.dart';
import '../modules/booking/views/seat_selection_view.dart';
import '../modules/booking/views/passenger_details_view.dart';
import '../modules/booking/views/payment_view.dart';
import '../modules/booking/views/payment_success_view.dart';
import '../modules/tickets/bindings/tickets_binding.dart';
import '../modules/tickets/views/my_tickets_view.dart';
import '../modules/tickets/views/ticket_details_view.dart';
import '../modules/profile/bindings/profile_binding.dart';
import '../modules/profile/views/profile_view.dart';
import '../modules/profile/views/edit_profile_view.dart';
import '../modules/profile/views/trip_history_view.dart';
import '../modules/notifications/bindings/notifications_binding.dart';
import '../modules/notifications/views/notifications_view.dart';
import 'app_routes.dart';

class AppPages {
  static final pages = [
    // Splash & Onboarding
    GetPage(
      name: AppRoutes.SPLASH,
      page: () => const SplashView(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: AppRoutes.ONBOARDING,
      page: () => const OnboardingView(),
      binding: OnboardingBinding(),
    ),
    
    // Auth
    GetPage(
      name: AppRoutes.LOGIN,
      page: () => const LoginView(),
      binding: AuthBinding(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutes.REGISTER,
      page: () => const RegisterView(),
      binding: AuthBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.FORGOT_PASSWORD,
      page: () => const ForgotPasswordView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.VERIFY_OTP,
      page: () => const VerifyOtpView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.RESET_PASSWORD,
      page: () => const ResetPasswordView(),
      binding: AuthBinding(),
    ),
    
    // Main
    GetPage(
      name: AppRoutes.MAIN,
      page: () => const MainView(),
      binding: MainBinding(),
      bindings: [
        HomeBinding(),
        SearchBinding(),
        TicketsBinding(),
        ProfileBinding(),
      ],
    ),
    GetPage(
      name: AppRoutes.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    
    // Booking Flow
    GetPage(
      name: AppRoutes.SEAT_SELECTION,
      page: () => const SeatSelectionView(),
      binding: BookingBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.PASSENGER_DETAILS,
      page: () => const PassengerDetailsView(),
      binding: BookingBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.PAYMENT,
      page: () => const PaymentView(),
      binding: BookingBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.PAYMENT_SUCCESS,
      page: () => const PaymentSuccessView(),
      binding: BookingBinding(),
      transition: Transition.zoom,
    ),
    
    // Tickets
    GetPage(
      name: AppRoutes.MY_TICKETS,
      page: () => const MyTicketsView(),
      binding: TicketsBinding(),
    ),
    GetPage(
      name: AppRoutes.TICKET_DETAILS,
      page: () => const TicketDetailsView(),
      binding: TicketsBinding(),
      transition: Transition.rightToLeft,
    ),
    
    // Profile
    GetPage(
      name: AppRoutes.PROFILE,
      page: () => const ProfileView(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: AppRoutes.EDIT_PROFILE,
      page: () => const EditProfileView(),
      binding: ProfileBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.TRIP_HISTORY,
      page: () => const TripHistoryView(),
      binding: ProfileBinding(),
      transition: Transition.rightToLeft,
    ),
    
    // Notifications
    GetPage(
      name: AppRoutes.NOTIFICATIONS,
      page: () => const NotificationsView(),
      binding: NotificationsBinding(),
      transition: Transition.downToUp,
    ),
  ];
}
