import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:swyft_rails/app/routes/app_routes.dart';
import '../../../core/services/api_service.dart';
import '../../../core/utils/api_endpoints.dart';
import '../../../data/models/schedule_model.dart';
import '../../../data/models/seat_model.dart';
import '../../../data/models/coach_model.dart';
import '../../../data/models/travel_class_model.dart';
import '../../../data/models/booking_model.dart';
import 'package:paystack_flutter_sdk/paystack_flutter_sdk.dart';

class BookingController extends GetxController {
  final ApiService _apiService = Get.find();

  final Paystack _paystack = Paystack();
  static const String _paystackPublicKey =
      'pk_test_d770b204243e0dfc1cd0e1007886b625c765d2e5';

  // --- STATE ---

  // Schedule selection (passed from search)
  final Rxn<ScheduleModel> selectedSchedule = Rxn<ScheduleModel>();

  // Step 2: Travel Class Selection
  final RxList<TravelClassModel> fareOptions = <TravelClassModel>[].obs;
  final Rxn<TravelClassModel> selectedTravelClass = Rxn<TravelClassModel>();

  // Step 3: Seat Selection
  final RxList<CoachModel> coachesWithSeats = <CoachModel>[].obs;
  final Rxn<CoachModel> selectedCoach = Rxn<CoachModel>();
  final Rxn<SeatModel> selectedSeat = Rxn<SeatModel>();

  // Step 4: Passenger Details
  final RxString passengerType = 'Adult'.obs;
  final RxString phone = ''.obs;
  final RxString email = ''.obs;
  final RxString nin = ''.obs;

  // Controllers for Passenger View
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController ninController = TextEditingController();

  // Final Step: Booking Result
  final RxString bookingId = ''.obs;
  final RxBool isLoading = false.obs;

  // --- METHODS ---

  /// Initializes the booking process for a specific schedule
  void initForSchedule(ScheduleModel schedule) {
    selectedSchedule.value = schedule;
    selectedTravelClass.value = null;
    selectedCoach.value = null;
    selectedSeat.value = null;
    passengerType.value = 'Adult';
    phone.value = '';
    email.value = '';
    nin.value = '';
    bookingId.value = '';

    phoneController.clear();
    emailController.clear();
    ninController.clear();

    fetchFareOptions();
  }

  /// GET /fares/pricing
  Future<void> fetchFareOptions() async {
    try {
      isLoading.value = true;
      final response = await _apiService.get(ApiEndpoints.faresPricing);
      final List data = response.data;
      fareOptions
          .assignAll(data.map((e) => TravelClassModel.fromJson(e)).toList());
    } catch (e) {
      Get.snackbar('Error', e.toString(), snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  /// Stores selected travel class and fetches available seats
  Future<void> selectTravelClass(TravelClassModel travelClass) async {
    selectedTravelClass.value = travelClass;
    await fetchSeatsForClass();
  }

  /// GET /schedules/:id/options?travelClassId=N
  Future<void> fetchSeatsForClass() async {
    if (selectedSchedule.value == null || selectedTravelClass.value == null)
      return;

    try {
      isLoading.value = true;
      final response = await _apiService.get(
        ApiEndpoints.scheduleOptions(selectedSchedule.value!.id),
        queryParameters: {
          'travelClassId': selectedTravelClass.value!.travelClassId
        },
      );

      // Backend returns {schedule, travelClass, coaches: [...]}
      final List coachesData = response.data['coaches'];
      coachesWithSeats
          .assignAll(coachesData.map((e) => CoachModel.fromJson(e)).toList());
    } catch (e) {
      Get.snackbar('Error', e.toString(), snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  /// Selects a seat if it is Available
  void selectSeat(SeatModel seat) {
    if (seat.status != 'Available') {
      Get.snackbar('Seat unavailable',
          'Sorry, ${seat.code} has just been booked. Please select another seat.',
          snackPosition: SnackPosition.BOTTOM);
      return;
    }
    selectedSeat.value = seat;
    // Automatically select the coach as well
    selectedCoach.value =
        coachesWithSeats.firstWhere((c) => c.id == seat.coachId);
  }

  /// POST /bookings
  Future<bool> createPendingBooking() async {
    if (selectedSeat.value == null) {
      Get.snackbar(
        'Error',
        'Please select a seat',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }

    try {
      isLoading.value = true;

      final payload = {
        'scheduleId': selectedSchedule.value!.id,
        'travelClassId': selectedTravelClass.value!.travelClassId,
        'passengers': [
          {
            'seatId': selectedSeat.value!.id,
            'passengerType': passengerType.value,
            'phone': phone.value,
            'email': email.value,
            'nin': nin.value,
          }
        ],
      };

      final response = await _apiService.post(
        ApiEndpoints.createBooking,
        data: payload,
      );

      final booking = BookingModel.fromJson(response.data);

      bookingId.value = booking.bookingId;

      return true;
    } catch (e) {
      debugPrint('Booking creation error: $e');

      Get.snackbar(
        'Booking failed',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );

      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> startPayment() async {
    try {
      isLoading.value = true;

      // Create the booking first.
      final bookingCreated = await createPendingBooking();

      if (!bookingCreated) {
        return;
      }

      // Ask our backend to initialize the Paystack transaction.
      final paymentResponse = await _apiService.post(
        ApiEndpoints.initializePayment,
        data: {
          'bookingId': int.parse(bookingId.value),
        },
      );

      final paymentData = paymentResponse.data;

      final accessCode = paymentData['accessCode'];
      final reference = paymentData['reference'];

      if (accessCode == null || reference == null) {
        throw Exception(
          'Invalid payment initialization response',
        );
      }

      debugPrint('Paystack reference: $reference');

      // Initialize Paystack SDK.
      _paystack.initialize(
        _paystackPublicKey,
        true,
      );

      // Open Paystack checkout.
      final transactionResponse = await _paystack.launch(
        accessCode,
      );

      debugPrint(
        'Paystack transaction status: '
        '${transactionResponse.status}',
      );

      if (transactionResponse.status == 'success') {
        // Ask our backend to verify the transaction.
        final verificationResponse = await _apiService.get(
          ApiEndpoints.verifyPayment(reference),
        );

        final verificationData = verificationResponse.data;

        debugPrint(
          'Payment verification: $verificationData',
        );

        if (verificationData['status'] == 'Paid') {
          Get.offAllNamed(
            AppRoutes.PAYMENT_SUCCESS,
          );
          return;
        }
      }

      Get.snackbar(
        'Payment not completed',
        'Your payment was not completed.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      debugPrint('Payment error: $e');

      Get.snackbar(
        'Payment failed',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  double get totalPrice {
    if (selectedTravelClass.value == null) return 0.0;
    return passengerType.value == 'Adult'
        ? selectedTravelClass.value!.adultAmount
        : selectedTravelClass.value!.childAmount;
  }
}
