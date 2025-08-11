import '../data/blocks_repository_base.dart';
import '../domain/block.dart';

class EventService {
  final BlocksRepositoryBase _repository;

  EventService(this._repository);

  Future<void> create(Block event) {
    return _repository.createEvent(event);
  }

  Future<List<Block>> getInstructorEvents(String instructorId) {
    return _repository.getInstructorEvents(instructorId);
  }

  Future<void> delete(String id) {
    return _repository.deleteEvent(id);
  }
}