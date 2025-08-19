import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_boilerplate/src/feature/authentication/data/user_repository_provider.dart';
import 'package:flutter_riverpod_boilerplate/src/feature/authentication/domain/app_user.dart';

class PrivilegeController extends AutoDisposeNotifier<bool> {
  @override
  bool build() {
    _checkUserRole();
    return false;
  }

  void _checkUserRole() {
    final appUser = ref.read(currentAppUserProvider).value;
    if (appUser != null) {
      state = appUser.hasRole(UserRoleType.tenant);
    } else {
      state = false;
    }
  }

  void togglePrivilege() {
    _checkUserRole();
  }
}

final privilegeControllerProvider =
    AutoDisposeNotifierProvider<PrivilegeController, bool>(
      PrivilegeController.new,
    );
