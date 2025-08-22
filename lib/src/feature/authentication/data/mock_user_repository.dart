import 'package:flutter_riverpod_boilerplate/src/constants/mock_data2.dart';
import 'package:flutter_riverpod_boilerplate/src/feature/authentication/data/user_repository_base.dart';
import 'package:flutter_riverpod_boilerplate/src/feature/authentication/domain/app_user.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserRepository implements UserRepositoryBase {
  AppUser? _currentUser;

  @override
  Future<AppUser?> getCurrentUser() async {
    await Future.delayed(Duration(seconds: 1)); // Simulate network delay
    return _currentUser;
  }

  Future<AppUser?> signIn(String email, String password) async {
    await Future.delayed(Duration(seconds: 1)); // Simulate network delay
    if (password == 'password') {
      _currentUser = mockUsers['user003'];
      return _currentUser;
    }
    return null;
  }

  Future<void> signOut() async {
    await Future.delayed(Duration(seconds: 1)); // Simulate network delay
    _currentUser = null;
  }

  Future<AppUser?> signUpTenant(
    Map<String, dynamic> userData,
    Map<String, dynamic> businessData,
  ) async {
    await Future.delayed(Duration(seconds: 2)); // Simulate network delay
    // Create a new user and business (you can add more logic here if needed)
    final newUser = AppUser(
      uid: 'user006',
      email: userData['email'],
      name: userData['name'],
      createdAt: DateTime.now(),
      image: '',
      lastBusinessId: 'business003',
      platformRole: null,
      notifications: false,
      roles: {
        'business003': UserRole(
          role: RoleType.tenant.name,
          status: 'active',
          createdAt: DateTime.now(),
        ),
      },
    );
    _currentUser = newUser;
    return newUser;
  }
}

final userRepositoryProvider = Provider<UserRepository>(
  (ref) => UserRepository(),
);
