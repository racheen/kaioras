import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_boilerplate/src/feature/authentication/shared_preferences_repository.dart';

class BusinessNotifier extends AutoDisposeNotifier<String?> {
  @override
  String? build() {
    _loadBusinessData();
    return null;
  }

  Future<void> _loadBusinessData() async {
    final prefs = await ref.read(sharedPreferencesProvider.future);
    state = prefs.getString('businessName');
  }

  Future<void> setActiveBusiness(name) async {
    final prefs = await ref.read(sharedPreferencesProvider.future);
    final businessName = prefs.getString('businessName');
    await prefs.setString('businessName', name);
    state = businessName;
  }
}

final activeBusinessProvider =
    AutoDisposeNotifierProvider<BusinessNotifier, String?>(
      BusinessNotifier.new,
    );
