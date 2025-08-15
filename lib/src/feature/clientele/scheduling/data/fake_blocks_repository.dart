import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_boilerplate/src/constants/mock_data.dart';
import 'package:flutter_riverpod_boilerplate/src/feature/clientele/scheduling/domain/block.dart';
import 'package:flutter_riverpod_boilerplate/src/feature/clientele/scheduling/domain/booking.dart';
import 'package:flutter_riverpod_boilerplate/src/utils/in_memory_store.dart';

class FakeBlocksRepository {
  FakeBlocksRepository();

  final _blocks = InMemoryStore<List<Block>>(mockBlocks);

  Future<List<Block>> fetchBookings() async {
    return Future.value(_blocks.value);
  }

  Future<List<Block>> fetchBlocks() {
    final upcomingBookings = _blocks.value
        .where((booking) => booking.status == BookingStatus.booked.name)
        .toList();
    return Future.value(upcomingBookings);
  }

  Future<Block> fetchBlockById(String blockId) {
    final block = _blocks.value.singleWhere(
      (block) => block.blockId == blockId,
    );
    return Future.value(block);
  }

  Future<List<Block>> fetchBlockByBusinessId(String businessId) {
    final blocks = _blocks.value
        .where((block) => block.origin.businessId == businessId)
        .toList();
    return Future.value(blocks);
  }

  Future<List<Block>> fetchBlocksByStartDate(
    String businessId,
    DateTime selectedDate,
  ) {
    final blocks = _blocks.value.where((block) {
      return block.origin.businessId == businessId &&
          block.startTime == selectedDate;
    }).toList();
    return Future.value(blocks);
  }

  Future<void> createBooking(Block block, Booking currentBooking) async {
    block.booked ??= [];
    block.waitlisted ??= [];
    final capacityLimit = block.capacity ?? 1;

    final hasAvailableSlot = block.booked!.length < capacityLimit;
    // final isFullyBooked = block.booked!.length == capacityLimit;
    block.cancelled!.removeWhere(
      (booking) => booking.user!.uid == currentBooking.user!.uid,
    );
    // check if there is available slot
    if (hasAvailableSlot) {
      currentBooking.status = 'booked';
      block.booked!.add(currentBooking);
      print('booked');
    } else {
      print('full');
    }
    print(block.booked!.length);
    for (Booking booking in block.booked!) {
      print('[booked]: ${booking.toJson()}');
    }
  }

  Future<void> cancelBooking(Block block, Booking currentBooking) async {
    block.cancelled ??= [];

    block.booked!.removeWhere(
      (booking) => booking.user!.uid == currentBooking.user!.uid,
    );
    currentBooking.status = 'cancelled';
    block.cancelled!.add(currentBooking);
    print('cancelled');

    print(block.cancelled!.length);
    for (Booking booking in block.booked!) {
      print('[booked]: ${booking.toJson()}');
    }
    for (Booking booking in block.cancelled!) {
      print('[cancelled]: ${booking.toJson()}');
    }
  }
}

final blocksRepositoryProvider = Provider<FakeBlocksRepository>((ref) {
  return FakeBlocksRepository();
});

final blocksListFutureProvider = FutureProvider.autoDispose<List<Block>>((ref) {
  final bookingsRepository = ref.watch(blocksRepositoryProvider);
  return bookingsRepository.fetchBlocks();
});

final blockFutureProvider = FutureProvider.autoDispose.family<Block, String>((
  ref,
  blockId,
) {
  final blockRepository = ref.watch(blocksRepositoryProvider);
  return blockRepository.fetchBlockById(blockId);
});
