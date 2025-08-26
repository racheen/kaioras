import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_boilerplate/src/constants/mock_data.dart';
import 'package:flutter_riverpod_boilerplate/src/feature/authentication/application/firebase_auth_service.dart';
import 'package:flutter_riverpod_boilerplate/src/feature/clientele/scheduling/data/firebase_bookings_repository.dart';
import 'package:flutter_riverpod_boilerplate/src/feature/clientele/scheduling/domain/block.dart';
import 'package:flutter_riverpod_boilerplate/src/feature/clientele/scheduling/domain/booking.dart';
import 'package:flutter_riverpod_boilerplate/src/feature/clientele/scheduling/presentation/bookings_notifier.dart';

class BookingService {
  Ref ref;
  BookingService(this.ref);

  Future<void> book(String businessId, Block currentBlock) async {
    final currentUser = ref.read(currentAppUserProvider);

    if (currentUser.value != null) {
      final uid = currentUser.value!.uid;

      final existingBooking = await ref
          .read(bookingsRepositoryProvider)
          .verifyExistingBooking(
            businessId: businessId,
            blockId: currentBlock.blockId,
            uid: uid,
          );

      final hasExistingWaitlist = await ref
          .read(bookingsRepositoryProvider)
          .verifyExistingWaitlisting(
            businessId: businessId,
            blockId: currentBlock.blockId,
            uid: uid,
          );

      final hasAvailability = await ref
          .read(bookingsRepositoryProvider)
          .verifyBookingAvailability(
            businessId,
            currentBlock.blockId!,
            currentBlock.capacity!,
          );

      if (existingBooking != null) {
        handleBookingStatus(
          hasAvailability: hasAvailability,
          hasExistingWaitlist: hasExistingWaitlist,
          booking: existingBooking,
        );
        await ref
            .read(bookingsRepositoryProvider)
            .updateBooking(
              currentBlock.origin.businessId,
              currentBlock.blockId!,
              existingBooking,
            );
        await ref
            .read(bookingsNotifierProvider.notifier)
            .updateUserBookings(uid, existingBooking);
      } else {
        Booking newBooking = Booking(
          bookedAt: DateTime.now(),
          uid: uid,
          name: currentBlock.title,
          image: 'currentUserImage',
          membershipId: 'testMembershipId',
          blockId: currentBlock.blockId,
          status: BookingStatus.booked.name,
          businessId: currentBlock.origin.businessId,
        );
        handleBookingStatus(
          hasAvailability: hasAvailability,
          hasExistingWaitlist: hasExistingWaitlist,
          booking: newBooking,
        );
        await ref
            .read(bookingsRepositoryProvider)
            .addBooking(currentBlock.origin.businessId, newBooking);
        await ref
            .read(bookingsNotifierProvider.notifier)
            .updateUserBookings(uid, newBooking);
      }
    }
  }

  Future<void> cancel(String businessId, Block currentBlock) async {
    try {
      // final currentUser = await ref
      //     .read(appUserRepositoryProvider)
      //     .currentUser();
      final currentUser = ref.read(currentAppUserProvider);
      final uid = currentUser.value!.uid;

      if (currentUser.value != null) {
        final existingBooking = await ref
            .read(bookingsRepositoryProvider)
            .verifyExistingBooking(
              businessId: businessId,
              blockId: currentBlock.blockId,
              uid: uid,
            );
        if (existingBooking != null) {
          existingBooking.status = BookingStatus.cancelled.name;
          await ref
              .read(bookingsRepositoryProvider)
              .updateBooking(
                currentBlock.origin.businessId,
                currentBlock.blockId!,
                existingBooking,
              );
          await ref
              .read(bookingsNotifierProvider.notifier)
              .updateUserBookings(uid, existingBooking);
        } else {
          print('unable to find existing booking to cancel');
        }
      }
    } catch (e) {
      print(e);
    }
  }

  void handleBookingStatus({
    required bool hasAvailability,
    required bool hasExistingWaitlist,
    required Booking booking,
  }) {
    if (hasAvailability) {
      booking.status = BookingStatus.booked.name;
    } else {
      if (!hasExistingWaitlist) {
        booking.status = BookingStatus.waitlisted.name;
      }
    }
  }
}

final bookingsServiceProvider = Provider<BookingService>((ref) {
  return BookingService(ref);
});
