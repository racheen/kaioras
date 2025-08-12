import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod_boilerplate/src/constants/mock_data2.dart';
import 'package:flutter_riverpod_boilerplate/src/feature/tenant/scheduling/application/block_service.dart';
import 'package:flutter_riverpod_boilerplate/src/feature/tenant/scheduling/domain/availability.dart';
import 'package:flutter_riverpod_boilerplate/src/feature/tenant/scheduling/domain/block.dart';
import 'blocks_repository_base.dart';

class FakeBlocksRepository implements BlocksRepositoryBase {
  FakeBlocksRepository();

  final Map<String, Block> _blocks = Map.from(mockBlocks);

  @override
  Future<void> createEvent(Block event) async {
    // Simulate network delay
    await Future.delayed(Duration(milliseconds: 300));

    // Add the new event to the _blocks map
    _blocks[event.blockId] = event;

    debugPrint(_blocks.toString());
  }

  @override
  Future<List<Block>> getInstructorEvents(String instructorId) async {
    // Simulate network delay
    await Future.delayed(Duration(milliseconds: 300));

    return _blocks.values
        .where((block) => block.host.uid == instructorId)
        .toList();
  }

  @override
  Future<Block?> fetchBlockById(String blockId) async {
    // Simulate network delay
    await Future.delayed(Duration(milliseconds: 300));

    return _blocks[blockId];
  }

  @override
  Future<void> deleteEvent(String id) async {
    // Simulate network delay
    await Future.delayed(Duration(milliseconds: 300));

    _blocks.remove(id);
  }
}

final blocksRepoProvider = Provider((ref) => FakeBlocksRepository());

final eventServiceProvider = Provider((ref) {
  final repository = ref.watch(blocksRepoProvider);
  return EventService(repository);
});

final instructorEventsProvider = FutureProvider.family<List<Block>, String>(
  (ref, instructorId) =>
      ref.watch(eventServiceProvider).getInstructorEvents(instructorId),
);

final studioAvailabilityProvider = Provider<Availability>((ref) {
  // Get the first business from mockBusinesses (assuming there's at least one)
  final business = mockBusinesses.values.first;
  final settings = business['settings'] as Map<String, dynamic>;
  final availability = settings['availability'] as Map<String, dynamic>;
  final defaultHours = availability['defaultHours'] as List<dynamic>;
  final timeZone = availability['timeZone'] as String;
  final holidays = settings['holidays'] as List<dynamic>;
  final closedDays = settings['closedDays'] as List<dynamic>;

  Map<String, TimeRange> weekdayHours = {};
  for (var hours in defaultHours) {
    String day = hours['day'];
    List<String> startParts = hours['start'].split(':');
    List<String> endParts = hours['end'].split(':');
    weekdayHours[StringExtension(day).capitalize()] = TimeRange(
      start: TimeOfDay(
        hour: int.parse(startParts[0]),
        minute: int.parse(startParts[1]),
      ),
      end: TimeOfDay(
        hour: int.parse(endParts[0]),
        minute: int.parse(endParts[1]),
      ),
    );
  }

  List<DateTime> blackoutDates = holidays
      .map<DateTime>((holiday) => DateTime.parse(holiday['date'] as String))
      .toList();

  return Availability(
    weekdayHours: weekdayHours,
    blackoutDates: blackoutDates,
    timeZone: timeZone,
    closedDays: closedDays.cast<String>(),
  );
});

// Extension to capitalize the first letter of a string
extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}
