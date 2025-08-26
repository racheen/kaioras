import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_boilerplate/src/feature/authentication/data/user_repository_provider.dart';

class PrivilegeController extends AutoDisposeNotifier<bool> {
  @override
  bool build() {
    final appUser = ref.watch(currentAppUserProvider).value;
    return appUser?.isTenant ?? false;
  }

  void _checkUserRole() {
    final appUser = ref.read(currentAppUserProvider).value;
    if (appUser != null) {
      state = appUser.isTenant;
    } else {
      state = false;
    }
  }

  void hasAdminPrivilege() {
    _checkUserRole();
  }

  void togglePrivilege() {
    state = !state;
  }
}

final privilegeControllerProvider =
    AutoDisposeNotifierProvider<PrivilegeController, bool>(
      PrivilegeController.new,
    );
