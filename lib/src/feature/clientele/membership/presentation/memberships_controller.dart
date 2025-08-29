import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_boilerplate/src/feature/authentication/application/firebase_auth_service.dart';
import 'package:flutter_riverpod_boilerplate/src/feature/clientele/membership/data/firebase_membership_repository.dart';
import 'package:flutter_riverpod_boilerplate/src/feature/tenant/scheduling/domain/app_user.dart';

class MembershipsController extends AutoDisposeAsyncNotifier<List<Membership>> {
  Future<List<Membership>> fetchUserMemberships() async {
    final currentUser = ref.read(currentAppUserProvider);
    final uid = currentUser.value?.uid;

    return await ref
        .read(membershipsRepositoryProvider)
        .fetchUserMemberships(uid!);
  }

  @override
  Future<List<Membership>> build() async {
    return fetchUserMemberships();
  }

  Future<void> refreshUserMemberships() async {
    state = AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      return fetchUserMemberships();
    });
  }
}

final membershipsControllerProvider =
    AutoDisposeAsyncNotifierProvider<MembershipsController, List<Membership>>(
      MembershipsController.new,
    );
