import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_boilerplate/src/feature/clientele/scheduling/domain/block.dart';

class FirebaseBlocksRepository {
  const FirebaseBlocksRepository(this._firestore);
  final FirebaseFirestore _firestore;

  Query<Block> queryBlocks(String businessId, DateTime date) {
    final selectedDate = Timestamp.fromDate(date);
    final nextDate = Timestamp.fromDate(date.add(Duration(days: 1)));

    return _firestore
        .collection('businesses/$businessId/blocks')
        .withConverter(
          fromFirestore: (snapshot, _) =>
              Block.fromMap(snapshot.data()!, snapshot.id),
          toFirestore: (block, _) => block.toJson(),
        )
        .where('startTime', isGreaterThanOrEqualTo: selectedDate)
        .where('startTime', isLessThan: nextDate);
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

  Future<List<Block?>> fetchBlocks(String businessId, DateTime date) async {
    final blocks = await queryBlocks(businessId, date).get();
    return blocks.docs.map((doc) => doc.data()).toList();
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
