import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod_boilerplate/src/constants/mock_data2.dart';
import 'package:flutter_riverpod_boilerplate/src/feature/tenant/scheduling/application/block_service.dart';
import 'package:flutter_riverpod_boilerplate/src/feature/tenant/scheduling/domain/availability.dart';
import 'package:flutter_riverpod_boilerplate/src/feature/tenant/scheduling/domain/block.dart'
    hide Provider;

import 'blocks_repository_base.dart';

class FirebaseBlocksRepository implements BlocksRepositoryBase {
  final FirebaseFirestore firestore;

  FirebaseBlocksRepository(this.firestore);

  @override
  Future<Future<DocumentReference<Map<String, dynamic>>>> createEvent(
    Block event,
  ) async {
    return firestore.collection('blocks').add(event.toJson());
  }

  @override
  Future<List<Block>> getInstructorEvents(String instructorId) async {
    QuerySnapshot snapshot = await firestore
        .collection('blocks')
        .where('provider.uid', isEqualTo: instructorId)
        .get();

    return snapshot.docs.map((doc) {
      var data = doc.data() as Map<String, dynamic>;
      var provider = data['provider'] as Map<String, dynamic>;
      return Block.fromJson({
        ...data,
        'id': doc.id,
        'provider': {
          'uid': provider['uid'],
          'name': provider['name'],
          'details': provider['details'],
        },
      });
    }).toList();
  }

  @override
  Future<Block?> fetchBlockById(String blockId) async {
    DocumentSnapshot snapshot = await firestore
        .collection('blocks')
        .doc(blockId)
        .get();
    if (snapshot.exists) {
      var data = snapshot.data() as Map<String, dynamic>;
      var provider = data['provider'] as Map<String, dynamic>;
      return Block.fromJson({
        ...data,
        'id': snapshot.id,
        'provider': {
          'uid': provider['uid'],
          'name': provider['name'],
          'details': provider['details'],
        },
      });
    }
    return null;
  }

  @override
  Future<void> deleteEvent(String id) async {
    return firestore.collection('blocks').doc(id).delete();
  }
}

final firestoreProvider = Provider((ref) => FirebaseFirestore.instance);

final eventRepoProvider = Provider(
  (ref) => FirebaseBlocksRepository(ref.watch(firestoreProvider)),
);

final eventServiceProvider = Provider(
  (ref) => EventService(ref.watch(eventRepoProvider)),
);

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
    weekdayHours[day.capitalize()] = TimeRange(
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
