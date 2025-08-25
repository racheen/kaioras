import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_boilerplate/src/feature/authentication/data/mock_user_repository.dart';
import 'package:flutter_riverpod_boilerplate/src/feature/authentication/domain/app_user.dart';

class AuthService {
  final UserRepository _userRepository;
  final _authStateController = StreamController<AppUser?>.broadcast();

  AuthService(this._userRepository);

  Stream<AppUser?> authStateChanges() => _authStateController.stream;

  Future<AppUser?> signIn(String email, String password) async {
    final user = await _userRepository.signIn(email, password);
    _authStateController.add(user);
    return user;
  }

  Future<void> signOut() async {
    await _userRepository.signOut();
    _authStateController.add(null);
  }

  Future<AppUser?> signUpUser(Map<String, dynamic> userData) async {
    final user = await _userRepository.signUpUser(userData);
    _authStateController.add(user);
    return user;
  }

  Future<AppUser?> signUpTenant(
    Map<String, dynamic> userData,
    Map<String, dynamic> businessData,
  ) async {
    final user = await _userRepository.signUpTenant(userData, businessData);
    _authStateController.add(user);
    return user;
  }

  void dispose() {
    _authStateController.close();
  }
}

final authServiceProvider = Provider<AuthService>((ref) {
  final userRepository = ref.watch(userRepositoryProvider);
  return AuthService(userRepository);
});

final authStateProvider = StreamProvider<AppUser?>((ref) {
  final authService = ref.watch(authServiceProvider);
  return authService.authStateChanges();
});

final currentAppUserProvider = StreamProvider<AppUser?>((ref) async* {
  final authState = ref.watch(authStateProvider);

  if (authState.value == null) {
    print('AuthService: No authenticated user');
    yield null;
  } else {
    print('AuthService: Returning authenticated user');
    print(authState.value);
    yield authState.value;
  }
});
