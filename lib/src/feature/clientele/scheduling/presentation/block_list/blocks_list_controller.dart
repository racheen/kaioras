import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_boilerplate/src/feature/clientele/scheduling/application/booking_service.dart';
import 'package:flutter_riverpod_boilerplate/src/feature/clientele/scheduling/data/fake_blocks_repository.dart';
import 'package:flutter_riverpod_boilerplate/src/feature/clientele/scheduling/domain/block.dart';

DateTime now = DateTime.now();

class BlocksListController extends FamilyAsyncNotifier<List<Block?>, String?> {
  DateTime selectedDate = DateTime(now.year, now.month, now.day);

  Future<List<Block?>> fetchBlocks(businessId) async {
    return await ref
        .watch(blocksRepositoryProvider)
        .fetchBlocksByStartDate(businessId, selectedDate);
  }

  @override
  Future<List<Block?>> build([businessId]) async {
    return fetchBlocks(businessId);
  }

  Future<void> fetchBlocksByDate(String businessId, DateTime date) async {
    state = AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      selectedDate = date;
      return fetchBlocks(businessId);
    });
  }

  Future<void> book(Block block, String businessId) async {
    print('book');
    state = AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      ref.read(bookingsServiceProvider).book(block);
      return fetchBlocks(businessId);
    });
  }

  Future<void> cancel(Block block, String businessId) async {
    print('cancel');
    state = AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      ref.read(bookingsServiceProvider).cancel(block);
      return fetchBlocks(businessId);
    });
  }
}

final blocksListControllerProvider =
    AsyncNotifierProviderFamily<BlocksListController, List<Block?>, String?>(
      BlocksListController.new,
    );
