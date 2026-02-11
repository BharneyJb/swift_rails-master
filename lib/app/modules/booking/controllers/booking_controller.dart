import 'package:get/get.dart';

class BookingController extends GetxController {
  final RxList<String> selectedSeats = <String>[].obs;
  final RxDouble totalPrice = 0.0.obs;

  void toggleSeat(String seatNumber, double price) {
    if (selectedSeats.contains(seatNumber)) {
      selectedSeats.remove(seatNumber);
      totalPrice.value -= price;
    } else {
      selectedSeats.add(seatNumber);
      totalPrice.value += price;
    }
  }

  bool isSeatSelected(String seatNumber) {
    return selectedSeats.contains(seatNumber);
  }
}
