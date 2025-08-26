import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_boilerplate/src/feature/authentication/application/firebase_auth_service.dart';
import 'package:flutter_riverpod_boilerplate/src/feature/clientele/scheduling/data/firebase_bookings_repository.dart';
import 'package:flutter_riverpod_boilerplate/src/feature/clientele/scheduling/domain/booking.dart';

class BookingsNotifier
    extends AutoDisposeNotifier<List<Map<String?, String?>>> {
  @override
  List<Map<String?, String?>> build() {
    _fetchUserBookings();
    return [];
  }

  Future<void> _fetchUserBookings() async {
    final currentUser = ref.read(currentAppUserProvider);
    final uid = currentUser.value!.uid;
    state = await ref.read(bookingsFutureProvider(uid).future);
  }

  Future<void> updateUserBookings(String uid, Booking booking) async {
    try {
      await ref.read(bookingsRepositoryProvider).setUserBooking(uid, booking);
      _fetchUserBookings();
    } catch (e) {
      log(e.toString());
    }
  }
}

final bookingsNotifierProvider =
    NotifierProvider.autoDispose<BookingsNotifier, List<Map<String?, String?>>>(
      () {
        return BookingsNotifier();
      },
    );
