import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'blocks_repository_base.dart';
import 'fake_blocks_repository.dart' as FakeBlocksRepository;
import 'firebase_blocks_repository.dart' as FirebaseBlocksRepository;

final useFirebaseProvider = StateProvider<bool>((ref) => false);

final blocksRepositoryProvider = Provider<BlocksRepositoryBase>((ref) {
  return true
      ? FirebaseBlocksRepository.BlocksRepository(FirebaseFirestore.instance)
      : FakeBlocksRepository.BlocksRepository();
});
