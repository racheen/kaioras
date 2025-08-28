import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_boilerplate/src/core/services/firebase_service.dart';
import 'blocks_repository_base.dart';
import 'fake_blocks_repository.dart';
import 'firebase_blocks_repository.dart';

final useFirebaseProvider = StateProvider<bool>((ref) => false);

final blocksRepositoryProvider = Provider<BlocksRepositoryBase>((ref) {
  final useFirebase = ref.watch(useFirebaseProvider);
  final firestoreInstance = ref.watch(firestoreProvider);
  // return useFirebase
  //     ? FirebaseBlocksRepository(firestoreInstance)
  //     : FakeBlocksRepository();
  return FakeBlocksRepository();
});
