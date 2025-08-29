import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_boilerplate/src/common/global_loading_indicator.dart';
import 'package:flutter_riverpod_boilerplate/src/feature/authentication/application/firebase_auth_service.dart';
import 'package:flutter_riverpod_boilerplate/src/feature/clientele/scheduling/application/booking_service.dart';
import 'package:flutter_riverpod_boilerplate/src/feature/clientele/scheduling/data/fake_app_user_repository.dart';
import 'package:flutter_riverpod_boilerplate/src/feature/clientele/scheduling/data/firebase_bookings_repository.dart';
import 'package:flutter_riverpod_boilerplate/src/feature/clientele/scheduling/domain/block.dart';
import 'package:flutter_riverpod_boilerplate/src/feature/clientele/scheduling/domain/booking.dart';

class BookingsController extends AutoDisposeAsyncNotifier<List<Booking>> {
  Future<List<Booking>> fetchBookings() async {
    final currentUser = ref.read(currentAppUserProvider);
    final uid = currentUser.value?.uid;

    return await ref.read(bookingsRepositoryProvider).fetchUserBookings(uid);
  }

  @override
  Future<List<Booking>> build() async {
    return fetchBookings();
  }

  // add to users bookings collection
  Future<void> addToUpcoming(Booking newBooking) async {
    state = AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      ref.read(appUserRepositoryProvider).addBookingToUpcoming(newBooking);
      return fetchBookings();
    });
  }

  Future<void> book({
    required businessId,
    required block,
    required membershipId,
  }) async {
    state = await AsyncValue.guard(() async {
      ref.read(loadingProvider.notifier).state = true;
      await ref
          .read(bookingsServiceProvider)
          .book(businessId, block, membershipId);
      return fetchBookings();
    }).whenComplete(() => ref.read(loadingProvider.notifier).state = false);
  }

  Future<void> cancel(Block block, String businessId) async {
    state = await AsyncValue.guard(() async {
      ref.read(loadingProvider.notifier).state = true;
      await ref.read(bookingsServiceProvider).cancel(businessId, block);
      return fetchBookings();
    }).whenComplete(() => ref.read(loadingProvider.notifier).state = false);
  }

  Future<void> fetchUserBookings() async {
    state = AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      return fetchBookings();
    });
  }
}

final bookingsControllerProvider =
    AutoDisposeAsyncNotifierProvider<BookingsController, List<Booking>>(
      BookingsController.new,
    );
