import '../data/blocks_repository_base.dart';
import '../domain/block.dart';

class EventService {
  final BlocksRepositoryBase _repository;

  EventService(this._repository);

  Future<void> create(Block event, String businessId) async {
    return _repository.createNewBlock(event, businessId);
  }

  Future<List<Block>> getInstructorEvents(String instructorId) {
    return _repository.getInstructorEvents(instructorId);
  }

  Future<void> delete(String id) {
    return _repository.deleteEvent(id);
  }
}
