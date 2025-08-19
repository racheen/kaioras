import 'package:flutter_riverpod_boilerplate/src/constants/mock_data2.dart';
import 'package:flutter_riverpod_boilerplate/src/feature/authentication/data/user_repository_base.dart';
import 'package:flutter_riverpod_boilerplate/src/feature/authentication/domain/app_user.dart';

class UserRepository implements UserRepositoryBase {
  @override
  Future<AppUser?> getCurrentUser() async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));
    // Return a mock user
    return mockUsers['user002'] as AppUser;
  }
}
