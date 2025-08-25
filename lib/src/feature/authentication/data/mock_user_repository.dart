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
    _currentUser = mockUsers.values.firstWhere(
      (user) => user.email == email && password == 'password',
      orElse: () => throw Exception('User not found'),
    );
    return _currentUser;
  }

  Future<void> signOut() async {
    await Future.delayed(Duration(seconds: 1)); // Simulate network delay
    _currentUser = null;
  }

  Future<AppUser?> signUpUser(Map<String, dynamic> userData) async {
    await Future.delayed(Duration(seconds: 2)); // Simulate network delay
    final newUserId = 'user${mockUsers.length + 1}';
    final newUser = AppUser(
      uid: newUserId,
      email: userData['email'],
      name: userData['name'],
      createdAt: DateTime.now(),
      image: '',
      lastBusinessId: null,
      platformRole: null,
      notifications: false,
      roles: {},
    );
    mockUsers[newUserId] = newUser;
    _currentUser = newUser;
    return newUser;
  }

  Future<AppUser?> signUpTenant(
    Map<String, dynamic> userData,
    Map<String, dynamic> businessData,
  ) async {
    await Future.delayed(Duration(seconds: 2)); // Simulate network delay
    final newUserId = 'user${mockUsers.length + 1}';
    final newBusinessId = 'business${mockBusinesses.length + 1}';
    final newUser = AppUser(
      uid: newUserId,
      email: userData['email'],
      name: userData['name'],
      createdAt: DateTime.now(),
      image: '',
      lastBusinessId: newBusinessId,
      platformRole: null,
      notifications: false,
      roles: {
        newBusinessId: UserRole(
          role: RoleType.tenant.name,
          status: 'active',
          createdAt: DateTime.now(),
        ),
      },
    );
    mockUsers[newUserId] = newUser;
    _currentUser = newUser;

    // Add new business to mockBusinesses
    mockBusinesses[newBusinessId] = {
      'businessId': newBusinessId,
      'name': businessData['businessName'],
      'ownerUid': newUserId,
      'createdAt': DateTime.now().toIso8601String(),
      'industry': businessData['industry'] ?? 'Other',
      'branding': {
        'primaryColor': '#4A90E2',
        'logoUrl': 'https://example.com/logos/default.png',
      },
      'plan': 'basic',
      'stripeAccountId': 'acct_${DateTime.now().millisecondsSinceEpoch}',
      'offers': [],
      'roles': {
        newUserId: {
          'uid': newUserId,
          'role': RoleType.tenant.name,
          'status': 'active',
          'createdAt': DateTime.now().toIso8601String(),
          'displayName': userData['name'],
        },
      },
      'settings': {
        'availability': {
          'defaultHours': [
            {'day': 'monday', 'start': '09:00', 'end': '17:00'},
            {'day': 'tuesday', 'start': '09:00', 'end': '17:00'},
            {'day': 'wednesday', 'start': '09:00', 'end': '17:00'},
            {'day': 'thursday', 'start': '09:00', 'end': '17:00'},
            {'day': 'friday', 'start': '09:00', 'end': '17:00'},
          ],
          'timeZone': 'America/New_York',
        },
        'holidays': [],
        'closedDays': ['saturday', 'sunday'],
      },
    };

    return newUser;
  }
}

final userRepositoryProvider = Provider<UserRepository>(
  (ref) => UserRepository(),
);
