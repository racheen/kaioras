import '../domain/block.dart';

abstract class BlocksRepositoryBase {
  Future<void> createEvent(Block event);
  Future<List<Block>> getInstructorEvents(String instructorId);
  Future<Block?> fetchBlockById(String blockId);
  Future<void> deleteEvent(String id);
}