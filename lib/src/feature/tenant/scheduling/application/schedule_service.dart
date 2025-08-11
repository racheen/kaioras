import '../data/schedule_repository.dart';
import '../domain/schedule.dart';

class EventService {
  final EventFirebaseRepository _repository;

  EventService(this._repository);

  Future<void> create(BlockModel event) {
    return _repository.createEvent(event);
  }

  Future<List<BlockModel>> getInstructorEvents(String instructorId) {
    return _repository.getInstructorEvents(instructorId);
  }

  Future<void> delete(String id) {
    return _repository.deleteEvent(id);
  }
}
