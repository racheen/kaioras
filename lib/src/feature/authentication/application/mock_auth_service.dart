import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_boilerplate/src/constants/mock_data2.dart';
import 'package:flutter_riverpod_boilerplate/src/feature/authentication/domain/app_user.dart';

// Mock User class to simulate Firebase User
class MockUser {
  final String uid;
  MockUser(this.uid);
}

class AuthService {
  MockUser? _currentUser;
  final _authStateController = StreamController<MockUser?>.broadcast();

  Stream<MockUser?> authStateChanges() => _authStateController.stream;

  Future<void> signIn(String email, String password) async {
    // Simulate sign in delay
    await Future.delayed(Duration(seconds: 1));
    _currentUser = MockUser('user002');
    _authStateController.add(_currentUser);
  }

  Future<void> signOut() async {
    // Simulate sign out delay
    await Future.delayed(Duration(seconds: 1));
    _currentUser = null;
    _authStateController.add(null);
  }

  Future<void> signUpTenant(
    Map<String, dynamic> userData,
    Map<String, dynamic> businessData,
  ) async {
    // Simulate sign up delay
    await Future.delayed(Duration(seconds: 2));

    final String userId = 'user006';
    final String businessId = 'business003';

    // Simulate creating a user document
    final userDoc = {
      'uid': userId,
      'email': userData['email'],
      'name': userData['name'],
      'createdAt': DateTime.now().toIso8601String(),
      'profilePic': '',
      'lastBusinessId': businessId,
      'platformRole': null,
      'notifications': false,
      'roles': {
        businessId: {
          'role': 'tenant',
          'status': 'active',
          'createdAt': DateTime.now().toIso8601String(),
        },
      },
    };

    // Simulate creating a business document
    final businessDoc = {
      'businessId': businessId,
      'name': businessData['businessName'],
      'ownerUid': userId,
      'createdAt': DateTime.now().toIso8601String(),
      'industry': businessData['industry'],
      'branding': {
        'primaryColor': businessData['primaryColor'],
        'logoUrl': businessData['logoUrl'],
      },
      'plan': 'pro',
      'stripeAccountId': '',
      'roles': {
        userId: {
          'uid': userId,
          'role': 'tenant',
          'status': 'active',
          'createdAt': DateTime.now().toIso8601String(),
          'displayName': userData['name'],
        },
      },
      'settings': {
        'availability': {
          'defaultHours': [
            {'day': 'monday', 'start': '08:00', 'end': '18:00'},
            {'day': 'tuesday', 'start': '08:00', 'end': '18:00'},
            {'day': 'wednesday', 'start': '08:00', 'end': '18:00'},
            {'day': 'thursday', 'start': '08:00', 'end': '18:00'},
            {'day': 'friday', 'start': '08:00', 'end': '18:00'},
          ],
          'timeZone': 'America/New_York',
        },
        'holidays': [],
        'closedDays': ['sunday', 'saturday'],
      },
    };

    print('Creating user document: $userDoc');
    print('Creating business document: $businessDoc');

    // Simulate successful sign up
    _currentUser = MockUser(userId);
    _authStateController.add(_currentUser);
  }

  void dispose() {
    _authStateController.close();
  }
}

final authServiceProvider = Provider<AuthService>((ref) => AuthService());

final authStateProvider = StreamProvider<MockUser?>((ref) {
  final authService = ref.watch(authServiceProvider);
  return authService.authStateChanges();
});

final currentAppUserProvider = StreamProvider<AppUser?>((ref) async* {
  final authState = ref.watch(authStateProvider);

  if (authState.value == null) {
    yield null;
  } else {
    // Simulate fetching user document from Firestore
    await Future.delayed(Duration(seconds: 1));

    // Use mock data from mockdata2
    final mockUserId = authState.value!.uid;
    if (mockUsers.containsKey(mockUserId)) {
      final mockUser = mockUsers[mockUserId];
      if (mockUser != null) {
        yield AppUser(
          uid: mockUser.uid,
          email: mockUser.email,
          name: mockUser.name,
          createdAt: mockUser.createdAt,
          image: mockUser.image,
          lastBusinessId: mockUser.lastBusinessId,
          platformRole: mockUser.platformRole,
          notifications: mockUser.notifications,
          roles: Map<String, UserRole>.from(mockUser.roles),
        );
      }
    } else {
      // If the specific user is not found in mock data, use the first user as a fallback
      final fallbackUser = mockUsers.values.first;
      yield AppUser(
        uid: fallbackUser.uid,
        email: fallbackUser.email,
        name: fallbackUser.name,
        createdAt: fallbackUser.createdAt,
        image: fallbackUser.image,
        lastBusinessId: fallbackUser.lastBusinessId,
        platformRole: fallbackUser.platformRole,
        notifications: fallbackUser.notifications,
        roles: Map<String, UserRole>.from(fallbackUser.roles),
      );
    }
  }
});
