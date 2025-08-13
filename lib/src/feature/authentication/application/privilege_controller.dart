import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_boilerplate/src/feature/authentication/data/shared_preferences_repository.dart';

class PrivilegeController extends AutoDisposeNotifier<bool> {
  @override
  bool build() {
    _loadUserData();
    return false;
  }

  Future<void> _loadUserData() async {
    final prefs = await ref.read(sharedPreferencesProvider.future);
    state = prefs.getBool('hasAdminPrivilege') ?? false;
  }

  Future<void> togglePrivilage() async {
    final prefs = await ref.read(sharedPreferencesProvider.future);
    final isAdmin = prefs.getBool('hasAdminPrivilege') ?? false;
    await prefs.setBool('hasAdminPrivilege', !isAdmin);
    state = !isAdmin;
  }
}

final privilegeControllerProvider =
    AutoDisposeNotifierProvider<PrivilegeController, bool>(
      PrivilegeController.new,
    );
