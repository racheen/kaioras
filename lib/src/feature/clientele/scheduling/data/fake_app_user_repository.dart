import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_boilerplate/src/constants/mock_data.dart';
import 'package:flutter_riverpod_boilerplate/src/feature/clientele/scheduling/domain/app_user.dart';
import 'package:flutter_riverpod_boilerplate/src/feature/clientele/scheduling/domain/booking.dart';
import 'package:flutter_riverpod_boilerplate/src/utils/in_memory_store.dart';

class FakeAppUserRepository {
  FakeAppUserRepository();

  final _appUser = InMemoryStore<AppUser>(mockAppUser);
  final _bookings = InMemoryStore<List<Booking>>(mockAppUser.bookings!);

  Future<String> currentUser() async {
    return Future.value(_appUser.value.uid);
  }

  Future<AppUser> fetchAppUser() async {
    return Future.value(_appUser.value);
  }

  Future<List<Booking>> fetchBookings() async {
    return Future.value(_bookings.value);
  }

  Future<List<Booking>> fetchUpcomingBookings() {
    final upcomingBookings = _bookings.value
        .where((booking) => booking.status == BookingStatus.booked.name)
        .toList();
    return Future.value(upcomingBookings);
  }

  Future<List<Booking>> fetchPastBookings() {
    final pastBookings = _bookings.value.where((booking) {
      return booking.status == BookingStatus.attended.name;
    }).toList();
    return Future.value(pastBookings);
  }

  Future<void> addBookingToUpcoming(Booking newBooking) async {
    print(newBooking.toJson());
    _bookings.value.add(newBooking);
    print(_bookings.value);
  }
}

final appUserRepositoryProvider = Provider<FakeAppUserRepository>((ref) {
  return FakeAppUserRepository();
});

final appUserFutureProvider = FutureProvider.autoDispose<AppUser>((ref) {
  final blocksRepository = ref.watch(appUserRepositoryProvider);
  return blocksRepository.fetchAppUser();
});

final upcomingBookingsListFutureProvider =
    FutureProvider.autoDispose<List<Booking>>((ref) {
      final bookingsRepository = ref.watch(appUserRepositoryProvider);
      return bookingsRepository.fetchUpcomingBookings();
    });

final pastBookingsListFutureProvider =
    FutureProvider.autoDispose<List<Booking>>((ref) {
      final bookingsRepository = ref.watch(appUserRepositoryProvider);
      return bookingsRepository.fetchPastBookings();
    });
