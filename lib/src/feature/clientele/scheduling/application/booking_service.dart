import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_boilerplate/src/constants/mock_data.dart';
import 'package:flutter_riverpod_boilerplate/src/feature/clientele/scheduling/data/fake_app_user_repository.dart';
import 'package:flutter_riverpod_boilerplate/src/feature/clientele/scheduling/data/fake_blocks_repository.dart';
import 'package:flutter_riverpod_boilerplate/src/feature/clientele/scheduling/domain/app_user.dart';
import 'package:flutter_riverpod_boilerplate/src/feature/clientele/scheduling/domain/block.dart';
import 'package:flutter_riverpod_boilerplate/src/feature/clientele/scheduling/domain/booking.dart';
import 'package:flutter_riverpod_boilerplate/src/feature/clientele/scheduling/domain/mutable_bookings.dart';
import 'package:flutter_riverpod_boilerplate/src/feature/clientele/scheduling/presentation/bookings_controller.dart';

class BookingService {
  Ref ref;

  BookingService(this.ref);

  /// check if in bookings list
  /// IF user in bookings,
  ///   THEN check if hasAvailability
  ///     IF capacity is full,
  ///       then change status to waitlist
  ///     IF capacity is NOT full,
  ///       then change status to booked
  /// ELSE IF user not in bookings,
  ///   then check if hasAvailability
  ///     IF capacity is full
  ///       then change status to waitlist
  ///     IF capacity is NOT full
  ///       THEN change status to booked
  ///       AND add to list
  Future<void> book(Block currentBlock) async {
    // retrieve logged in user info
    final client = AppUser(
      uid: 'user001',
      email: 'user001@email.com',
      name: 'user001',
      image: '',
    );
    // fetch the block being booked
    // final block = _blocks.value.singleWhere((block) {
    //   return block.blockId == currentBlock.blockId;
    // });

    // verify if user has an existing booking
    final hasExistingBooking = _hasExistingBooking(currentBlock, client.uid!);
    final existingBooking = _findExistingBooking(currentBlock, client.uid!);

    if (hasExistingBooking && existingBooking != null) {
      handleBookingStatus(existingBooking);
      // update booking
    } else {
      final currentBooking = Booking(
        bookingId: 'booking001',
        bookedAt: DateTime(2025, 8, 14),
        user: client,
        membershipId: 'membership001',
        block: currentBlock,
      );
      handleBookingStatus(currentBooking);
      ref
          .read(blocksRepositoryProvider)
          .makeBooking(currentBlock, currentBooking);
      ref
          .read(bookingsControllerProvider.notifier)
          .addToUpcoming(currentBooking);
    }
  }

  Future<void> cancel(Block currentBlock) async {
    final client = AppUser(
      uid: 'user001',
      email: 'user001@email.com',
      name: 'user001',
      image: '',
    );

    final hasExistingBooking = _hasExistingBooking(currentBlock, client.uid!);
    final currentBooking = _findExistingBooking(currentBlock, client.uid!);

    if (hasExistingBooking && currentBooking != null) {
      currentBooking.status = BookingStatus.cancelled.name;
    }
  }

  static Booking? _findExistingBooking(Block block, String uid) {
    if (block.bookings != null) {
      if (block.bookings!.isNotEmpty) {
        for (Booking currentlyBooked in block.bookings!) {
          if (currentlyBooked.user.uid == uid) {
            return currentlyBooked;
          }
        }
      }
    }
    return null;
  }

  static void handleBookingStatus(Booking booking) {
    final block = booking.block!;
    final uid = booking.user.uid!;

    bool isFullyBooked = _isFullyBooked(block);
    bool isWaitlisted = _hasExistingWaitlist(block, uid);
    if (isFullyBooked) {
      if (!isWaitlisted) {
        booking.status = BookingStatus.waitlisted.name;
      }
    } else {
      booking.status = BookingStatus.booked.name;
    }
  }

  static bool _isFullyBooked(Block block) {
    final bookedCount =
        block.bookings
            ?.where((booking) => booking.status == BookingStatus.booked.name)
            .length ??
        0;
    final limit = block.capacity ?? 1;
    if (bookedCount == limit) {
      return true;
    }
    return false;
  }

  static bool _hasExistingBooking(Block block, String uid) {
    if (block.bookings != null) {
      final bookings = block.bookings ?? [];
      if (bookings.isNotEmpty) {
        for (Booking currentlyBooked in bookings) {
          if (currentlyBooked.user.uid == uid) {
            return true;
          }
        }
      }
    }
    return false;
  }

  static bool _hasExistingWaitlist(Block block, String uid) {
    if (block.bookings != null) {
      final bookings = block.bookings ?? [];
      final waitlistList = bookings.filter(BookingStatus.waitlisted.name);
      if (block.bookings!.isNotEmpty) {
        for (Booking waitlist in waitlistList) {
          if (waitlist.user.uid == uid) {
            return true;
          }
        }
      }
    }
    return false;
  }
}

final bookingsServiceProvider = Provider<BookingService>((ref) {
  return BookingService(ref);
});
