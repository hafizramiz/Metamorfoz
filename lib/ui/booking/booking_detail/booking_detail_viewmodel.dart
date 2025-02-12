import 'package:flutter/foundation.dart';
import '../../../data/repositories/booking/booking_repository.dart';
import '../../../domain/models/booking/booking.dart';
import '../../../utils/result.dart';

class BookingDetailViewModel extends ChangeNotifier {
  BookingDetailViewModel({required this.bookingRepository});

  final BookingRepository bookingRepository;
  Booking? _booking;

  Booking? get booking => _booking;

  /// Loads booking details by ID
  Future<Result<void>> loadBooking(int id) async {
    final result = await bookingRepository.getBooking(id);
    switch (result) {
      case Ok<Booking>():
        _booking = result.value;
        notifyListeners();
        return Result.ok(null);
      case Error<Booking>():
        return Result.error(result.error);
    }
  }
}


// return const Result.ok(null);
// case Error<Booking>():
// _log.warning('Booking error: ${result.error}');
// notifyListeners();
// return Result.error(result.error);