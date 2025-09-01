import '../domain/block.dart';

abstract class BlocksRepositoryBase {
  Future<void> createNewBlock(Block event, String businessId);
  Future<List<Block>> getInstructorEvents(String instructorId);
  Future<Block?> fetchBlockById(String blockId);
  Future<void> deleteEvent(String id);
  Future<List<Block>> fetchBlocksHosted(
    String businessId,
    String currentAppUserUid,
  );
}
