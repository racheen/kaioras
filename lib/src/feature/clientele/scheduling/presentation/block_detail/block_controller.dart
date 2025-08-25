import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_boilerplate/src/feature/clientele/scheduling/data/firebase_blocks_repository.dart';
// import 'package:flutter_riverpod_boilerplate/src/feature/clientele/scheduling/data/fake_blocks_repository.dart';
import 'package:flutter_riverpod_boilerplate/src/feature/clientele/scheduling/domain/block.dart';

class BlockArgs {
  String businessId;
  String blockId;
  BlockArgs({required this.businessId, required this.blockId});
}

class BlockController extends AutoDisposeFamilyAsyncNotifier<Block?, String> {
  Block? block;

  Future<Block?> fetchBlock(blockId) async {
    return await ref
        .read(blocksRepositoryProvider)
        .fetchBlock('business001', blockId);
  }

  @override
  Future<Block?> build(blockId) {
    return fetchBlock(blockId);
  }
}

final blockControllerProvider =
    AutoDisposeAsyncNotifierProviderFamily<BlockController, Block?, String>(
      BlockController.new,
    );
