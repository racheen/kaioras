import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_boilerplate/src/feature/clientele/scheduling/data/fake_blocks_repository.dart';
import 'package:flutter_riverpod_boilerplate/src/feature/clientele/scheduling/domain/app_user.dart';
import 'package:flutter_riverpod_boilerplate/src/feature/clientele/scheduling/domain/block.dart';
import 'package:flutter_riverpod_boilerplate/src/feature/clientele/scheduling/domain/booking.dart';

class BookingService {
  Ref ref;

  BookingService(this.ref);

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
    final hasExistingBooking = _verifyExistingBooking(
      currentBlock,
      client.uid!,
    );

    final isFullyBooked = currentBlock.booked!.length == currentBlock.capacity;

    if (hasExistingBooking) {
      print('already booked');
      return;
    }

    final currentBooking = Booking(
      bookingId: 'booking001',
      bookedAt: DateTime(2025, 8, 14),
      user: client,
      membershipId: 'membership001',
    );

    if (isFullyBooked) {
      print('already full');
      final hasExistingWaitlist = _verifyExistingWaitlisted(
        currentBlock,
        client.uid!,
      );

      if (hasExistingWaitlist) {
        print('already waitlisted');
        return;
      } else {
        print('adding as waitlisted');
        currentBlock.waitlisted!.add(currentBooking);
        print(currentBlock.waitlisted!.length);
        for (Booking booking in currentBlock.waitlisted!) {
          print('[waitlisted]: ${booking.toJson()}');
        }
        return;
      }
    }
    ref
        .read(blocksRepositoryProvider)
        .createBooking(currentBlock, currentBooking);
  }

  Future<void> cancel(Block currentBlock) async {
    print('cancel');
    final client = AppUser(
      uid: 'user001',
      email: 'user001@email.com',
      name: 'user001',
      image: '',
    );

    final hasExistingBooking = _verifyExistingBooking(
      currentBlock,
      client.uid!,
    );
    final currentBooking = _findExistingBooking(currentBlock, client.uid!);

    if (hasExistingBooking && currentBooking != null) {
      ref
          .read(blocksRepositoryProvider)
          .cancelBooking(currentBlock, currentBooking);
    }
  }

  static Booking? _findExistingBooking(Block block, String uid) {
    if (block.booked != null) {
      if (block.booked!.isNotEmpty) {
        for (Booking currentlyBooked in block.booked!) {
          if (currentlyBooked.user!.uid == uid) {
            return currentlyBooked;
          }
        }
      }
    }
    return null;
  }

  static bool _verifyExistingBooking(Block block, String uid) {
    if (block.booked != null) {
      if (block.booked!.isNotEmpty) {
        for (Booking currentlyBooked in block.booked!) {
          if (currentlyBooked.user!.uid == uid) {
            return true;
          }
        }
      }
    }
    return false;
  }

  static bool _verifyExistingWaitlisted(Block block, String uid) {
    if (block.booked != null) {
      if (block.waitlisted!.isNotEmpty) {
        for (Booking currentlyBooked in block.waitlisted!) {
          if (currentlyBooked.user!.uid == uid) {
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
