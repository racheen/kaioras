import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_boilerplate/src/feature/tenant/scheduling/data/blocks_repository_base.dart';
import 'package:flutter_riverpod_boilerplate/src/feature/tenant/scheduling/data/blocks_repository_provider.dart';
import 'package:flutter_riverpod_boilerplate/src/feature/tenant/scheduling/domain/block.dart';

class BlocksRepository implements BlocksRepositoryBase {
  const BlocksRepository(this._firestore);
  final FirebaseFirestore _firestore;

  Query<Block> queryBlocksHosted(String businessId, String currentAppUserUid) {
    return _firestore
        .collection('businesses/$businessId/blocks')
        .withConverter(
          fromFirestore: (snapshot, _) =>
              Block.fromMap(snapshot.data()!, snapshot.id),
          toFirestore: (block, _) => block.toJson(),
        )
        .where('host.uid', isEqualTo: currentAppUserUid);
  }

  DocumentReference<Block> queryBlockById(String businessId, String blockId) {
    return _firestore
        .doc('businesses/$businessId/blocks/$blockId')
        .withConverter(
          fromFirestore: (snapshot, _) =>
              Block.fromMap(snapshot.data()!, snapshot.id),
          toFirestore: (block, _) => block.toJson(),
        );
  }

  Future<List<Block>> fetchBlocksHosted(
    String businessId,
    String currentAppUserUid,
  ) async {
    final blocks = await queryBlocksHosted(businessId, currentAppUserUid).get();
    return blocks.docs.map((doc) => doc.data()).whereType<Block>().toList();
  }

  Future<Block?> fetchBlock(String businessId, String blockId) async {
    final block = await queryBlockById(businessId, blockId).get();

    if (block.exists) {
      return block.data();
    }
    return null;
  }

  @override
  Future<void> createNewBlock(Block block, String businessId) async {
    try {
      // Create a new document reference
      final docRef = _firestore
          .collection('businesses/$businessId/blocks')
          .doc();

      // Set the block ID to the generated document ID
      final blockWithId = block.copyWith(blockId: docRef.id);

      // Add the new block to Firestore
      await docRef.set(blockWithId.toFirestore());

      print('New block created with ID: ${docRef.id}');
    } catch (e) {
      print('Error creating new block: $e');
      rethrow;
    }
  }

  @override
  Future<void> deleteEvent(String id) {
    // TODO: implement deleteEvent
    throw UnimplementedError();
  }

  @override
  Future<Block?> fetchBlockById(String blockId) {
    // TODO: implement fetchBlockById
    throw UnimplementedError();
  }

  @override
  Future<List<Block>> getInstructorEvents(String instructorId) {
    // TODO: implement getInstructorEvents
    throw UnimplementedError();
  }
}

final blocksHostedProvider =
    FutureProvider.family<List<Block>, (String, String)>((ref, params) async {
      final (businessId, hostUid) = params;
      final repository = ref.watch(blocksRepositoryProvider);
      return repository.fetchBlocksHosted(businessId, hostUid);
    });
