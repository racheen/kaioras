import '../data/schedule_repository.dart';
import '../domain/schedule.dart';

class EventService {
  final EventFirebaseRepository _repository;

  EventService(this._repository);

  Future<void> create(EventModel event) {
    return _repository.createEvent(event);
  }

  Stream<List<EventModel>> getInstructorEvents(String instructorId) {
    return _repository.getInstructorEvents(instructorId);
  }

  Future<void> delete(String id) {
    return _repository.deleteEvent(id);
  }
}
