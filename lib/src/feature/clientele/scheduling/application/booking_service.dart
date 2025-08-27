import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_boilerplate/src/constants/mock_data.dart';
import 'package:flutter_riverpod_boilerplate/src/feature/authentication/application/firebase_auth_service.dart';
import 'package:flutter_riverpod_boilerplate/src/feature/clientele/scheduling/data/firebase_bookings_repository.dart';
import 'package:flutter_riverpod_boilerplate/src/feature/clientele/scheduling/data/firebase_membership_repository.dart';
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
        final isCheckoutComplete = await ref
            .read(membershipsRepositoryProvider)
            .checkout(
              existingBooking.uid!,
              existingBooking.membershipId!,
              60,
            ); // todo: replace with actual price
        if (isCheckoutComplete) {
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
          print('unable to process checkout');
        }
      } else {
        Booking newBooking = Booking(
          bookedAt: DateTime.now(),
          uid: uid,
          membershipId:
              'JlWE0vDmzgAU58zHSa8h', // todo: replace with actual membershipId
          blockId: currentBlock.blockId,
          status: BookingStatus.booked.name,
          blockSnapshot: BlockSnapshot(
            blockId: currentBlock.blockId!,
            title: currentBlock.title!,
            startTime: currentBlock.startTime!,
            location: currentBlock.location!,
            host: currentBlock.host!,
            origin: currentBlock.origin,
          ),
        );

        final isCheckoutComplete = await ref
            .read(membershipsRepositoryProvider)
            .checkout(newBooking.uid!, newBooking.membershipId!, 60);

        if (isCheckoutComplete) {
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
        } else {
          print('unable to process checkout');
        }
      }
    }
  }

  Future<void> cancel(String businessId, Block currentBlock) async {
    try {
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
          final isRefundComplete = await ref
              .read(membershipsRepositoryProvider)
              .refundCredits(
                uid,
                existingBooking.membershipId!,
                60,
              ); // todo: replace with actual price

          if (isRefundComplete) {
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
          }
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
