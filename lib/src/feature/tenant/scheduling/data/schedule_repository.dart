import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod_boilerplate/src/feature/tenant/scheduling/application/schedule_service.dart';
import 'package:flutter_riverpod_boilerplate/src/feature/tenant/scheduling/domain/availability.dart';
import 'package:flutter_riverpod_boilerplate/src/feature/tenant/scheduling/domain/schedule.dart'
    hide Provider;

class EventFirebaseRepository {
  final FirebaseFirestore firestore;

  EventFirebaseRepository(this.firestore);

  Future<void> createEvent(BlockModel event) {
    return firestore.collection('blocks').add(event.toJson());
  }

  Future<List<BlockModel>> getInstructorEvents(String instructorId) async {
    QuerySnapshot snapshot = await firestore
        .collection('blocks')
        .where('provider.uid', isEqualTo: instructorId)
        .get();

    return snapshot.docs.map((doc) {
      var data = doc.data() as Map<String, dynamic>;
      var provider = data['provider'] as Map<String, dynamic>;
      return BlockModel.fromJson({
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

  Future<void> deleteEvent(String id) {
    return firestore.collection('blocks').doc(id).delete();
  }
}

final firestoreProvider = Provider((ref) => FirebaseFirestore.instance);

final eventRepoProvider = Provider(
  (ref) => EventFirebaseRepository(ref.watch(firestoreProvider)),
);

final eventServiceProvider = Provider(
  (ref) => EventService(ref.watch(eventRepoProvider)),
);

final instructorEventsProvider =
    FutureProvider.family<List<BlockModel>, String>(
  (ref, instructorId) =>
      ref.watch(eventServiceProvider).getInstructorEvents(instructorId),
);

final studioAvailabilityProvider = Provider<Availability>((ref) {
  // This is a mock. In a real app, you'd fetch this from your backend.
  return Availability(
    weekdayHours: {
      'Monday': TimeRange(
        start: TimeOfDay(hour: 9, minute: 0),
        end: TimeOfDay(hour: 17, minute: 0),
      ),
      'Tuesday': TimeRange(
        start: TimeOfDay(hour: 9, minute: 0),
        end: TimeOfDay(hour: 17, minute: 0),
      ),
      'Wednesday': TimeRange(
        start: TimeOfDay(hour: 9, minute: 0),
        end: TimeOfDay(hour: 17, minute: 0),
      ),
      'Thursday': TimeRange(
        start: TimeOfDay(hour: 9, minute: 0),
        end: TimeOfDay(hour: 17, minute: 0),
      ),
      'Friday': TimeRange(
        start: TimeOfDay(hour: 9, minute: 0),
        end: TimeOfDay(hour: 17, minute: 0),
      ),
      // Weekend closed
    },
    blackoutDates: [
      DateTime(2024, 12, 25), // Christmas
      DateTime(2025, 1, 1), // New Year's Day
    ],
  );
});