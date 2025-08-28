import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_boilerplate/src/feature/authentication/domain/app_user.dart';
import 'package:flutter_riverpod_boilerplate/src/feature/tenant/scheduling/domain/block.dart';

class FirebaseBlocksRepository {
  const FirebaseBlocksRepository(this._firestore);
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
}

final blocksRepositoryProvider = Provider((Ref ref) {
  return FirebaseBlocksRepository(FirebaseFirestore.instance);
});

final blocksHostedProvider =
    FutureProvider.family<List<Block>, (String, String)>((ref, params) async {
      final (businessId, hostUid) = params;
      final repository = ref.watch(blocksRepositoryProvider);
      return repository.fetchBlocksHosted(businessId, hostUid);
    });
