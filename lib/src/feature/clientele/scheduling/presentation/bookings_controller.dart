import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_boilerplate/src/feature/clientele/scheduling/data/fake_app_user_repository.dart';
import 'package:flutter_riverpod_boilerplate/src/feature/clientele/scheduling/domain/booking.dart';

class BookingsController extends AutoDisposeAsyncNotifier<List<Booking>> {
  Future<List<Booking>> fetchBookings() async {
    return ref.read(upcomingBookingsListFutureProvider.future);
  }

  @override
  Future<List<Booking>> build() async {
    return fetchBookings();
  }

  Future<void> addToUpcoming(Booking newBooking) async {
    state = AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      ref.read(appUserRepositoryProvider).addBookingToUpcoming(newBooking);
      return fetchBookings();
    });
  }
}

final bookingsControllerProvider =
    AutoDisposeAsyncNotifierProvider<BookingsController, List<Booking>>(
      BookingsController.new,
    );
