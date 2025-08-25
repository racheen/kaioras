import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_boilerplate/src/constants/mock_data.dart';
import 'package:flutter_riverpod_boilerplate/src/feature/clientele/scheduling/data/fake_app_user_repository.dart';
import 'package:flutter_riverpod_boilerplate/src/feature/clientele/scheduling/data/firebase_bookings_repository.dart';
import 'package:flutter_riverpod_boilerplate/src/feature/clientele/scheduling/domain/block.dart';
import 'package:flutter_riverpod_boilerplate/src/feature/clientele/scheduling/domain/booking.dart';
import 'package:flutter_riverpod_boilerplate/src/feature/clientele/scheduling/presentation/bookings_notifier.dart';

class BookingService {
  Ref ref;
  BookingService(this.ref);

  Future<void> book(String businessId, Block currentBlock) async {
    final currentUser = await ref.read(appUserRepositoryProvider).currentUser();

    final existingBooking = await ref
        .read(bookingsRepositoryProvider)
        .verifyExistingBooking(
          businessId: businessId,
          blockId: currentBlock.blockId,
          uid: currentUser,
        );

    final hasExistingWaitlist = await ref
        .read(bookingsRepositoryProvider)
        .verifyExistingWaitlisting(
          businessId: businessId,
          blockId: currentBlock.blockId,
          uid: currentUser,
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
          .updateUserBookings(currentUser, existingBooking);
    } else {
      Booking newBooking = Booking(
        bookedAt: DateTime.now(),
        uid: currentUser,
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
          .updateUserBookings(currentUser, newBooking);
    }
  }

  Future<void> cancel(String businessId, Block currentBlock) async {
    try {
      final currentUser = await ref
          .read(appUserRepositoryProvider)
          .currentUser();

      final existingBooking = await ref
          .read(bookingsRepositoryProvider)
          .verifyExistingBooking(
            businessId: businessId,
            blockId: currentBlock.blockId,
            uid: currentUser,
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
            .updateUserBookings(currentUser, existingBooking);
      } else {
        print('unable to find existing booking to cancel');
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
