import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_boilerplate/src/constants/mock_data.dart';
import 'package:flutter_riverpod_boilerplate/src/feature/clientele/scheduling/domain/block.dart';
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
        .where((block) => block.businessDetails.businessId == businessId)
        .toList();
    return Future.value(blocks);
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
