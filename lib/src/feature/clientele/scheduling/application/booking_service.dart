import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_boilerplate/src/constants/mock_data.dart';
import 'package:flutter_riverpod_boilerplate/src/feature/authentication/application/firebase_auth_service.dart';
import 'package:flutter_riverpod_boilerplate/src/feature/clientele/scheduling/data/firebase_bookings_repository.dart';
import 'package:flutter_riverpod_boilerplate/src/feature/clientele/membership/data/firebase_membership_repository.dart';
import 'package:flutter_riverpod_boilerplate/src/feature/clientele/scheduling/domain/block.dart';
import 'package:flutter_riverpod_boilerplate/src/feature/clientele/scheduling/domain/booking.dart';
import 'package:flutter_riverpod_boilerplate/src/feature/clientele/scheduling/presentation/bookings_notifier.dart';

// todo: update booking function
///   check capacity, if full ask user to register as waitlist; else back home (verifyBookingAvailability)
///   if has available capacity,
///     verify if user has valid membership to book block
///       then display list of user's membership to select
///         when user confirmed purchase,
///           then update membership startDate and reduce credit by 1
///           and add Booking to user.bookings
///           and add Booking to business.block.bookings
///     else ask user to browse related offers
class BookingService {
  Ref ref;
  BookingService(this.ref);

  Future<bool> checkAvailability(
    String businessId,
    Block currentBlock,
    String membershipId,
  ) async {
    return await ref
        .read(bookingsRepositoryProvider)
        .verifyBookingAvailability(
          businessId,
          currentBlock.blockId!,
          currentBlock.capacity!,
        );
  }

  Future<bool> waitlist(
    String businessId,
    Block currentBlock,
    String membershipId,
  ) async {
    final currentUser = ref.read(currentAppUserProvider);
    bool isComplete = false;
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

      if (existingBooking != null) {
        final hasExistingWaitlist = await ref
            .read(bookingsRepositoryProvider)
            .verifyExistingWaitlisting(
              businessId: businessId,
              blockId: currentBlock.blockId,
              uid: uid,
            );

        if (!hasExistingWaitlist) {
          existingBooking.status = BookingStatus.waitlisted.name;
        }
        await ref
            .read(bookingsRepositoryProvider)
            .updateBooking(
              currentBlock.origin.businessId,
              currentBlock.blockId!,
              existingBooking,
            );
        await ref
            .read(bookingsNotifierProvider.notifier)
            .updateUserBookings(uid, existingBooking)
            .whenComplete(() {
              isComplete = true;
            });
      } else {
        Booking newBooking = Booking(
          bookedAt: DateTime.now(),
          uid: uid,
          membershipId: membershipId,
          status: BookingStatus.waitlisted.name,
          blockSnapshot: BlockSnapshot(
            blockId: currentBlock.blockId!,
            title: currentBlock.title!,
            startTime: currentBlock.startTime!,
            location: currentBlock.location!,
            host: currentBlock.host!,
            origin: currentBlock.origin,
          ),
        );

        if (!hasExistingWaitlist) {
          newBooking.status = BookingStatus.waitlisted.name;
        }
        await ref
            .read(bookingsRepositoryProvider)
            .addBooking(currentBlock.origin.businessId, newBooking);
        await ref
            .read(bookingsNotifierProvider.notifier)
            .updateUserBookings(uid, newBooking)
            .whenComplete(() {
              isComplete = true;
            });
      }

      return Future.value(isComplete);
    }
    return Future.value(isComplete);
  }

  Future<void> book(
    String businessId,
    Block currentBlock,
    String membershipId,
  ) async {
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
            .checkout(existingBooking.uid!, membershipId);
        if (isCheckoutComplete) {
          handleBookingStatus(
            hasAvailability: hasAvailability,
            hasExistingWaitlist: hasExistingWaitlist,
            booking: existingBooking,
            membershipId: membershipId,
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
          membershipId: membershipId,
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
            .checkout(newBooking.uid!, newBooking.membershipId!);

        if (isCheckoutComplete) {
          handleBookingStatus(
            hasAvailability: hasAvailability,
            hasExistingWaitlist: hasExistingWaitlist,
            booking: newBooking,
            membershipId: membershipId,
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
              .refundCredits(uid, existingBooking.membershipId!);

          if (isRefundComplete) {
            existingBooking.membershipId = null;
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
    required String membershipId,
  }) {
    booking.membershipId = membershipId;
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
