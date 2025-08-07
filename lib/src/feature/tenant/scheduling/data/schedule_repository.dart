import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_boilerplate/src/feature/tenant/scheduling/application/schedule_service.dart';
import '../domain/schedule.dart';

class EventFirebaseRepository {
  final FirebaseFirestore firestore;

  EventFirebaseRepository(this.firestore);

  Future<void> createEvent(EventModel event) {
    return firestore.collection('events').add(event.toJson());
  }

  Stream<List<EventModel>> getInstructorEvents(String instructorId) {
    return firestore
        .collection('events')
        .where('providerId', isEqualTo: instructorId)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            return EventModel.fromJson(doc.data(), doc.id);
          }).toList();
        });
  }

  Future<void> deleteEvent(String id) {
    return firestore.collection('events').doc(id).delete();
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
    StreamProvider.family<List<EventModel>, String>(
      (ref, instructorId) =>
          ref.watch(eventServiceProvider).getInstructorEvents(instructorId),
    );
