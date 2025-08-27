import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_boilerplate/src/feature/authentication/data/firebase_user_repository.dart';
import 'package:flutter_riverpod_boilerplate/src/feature/authentication/domain/app_user.dart';

class AuthService {
  final UserRepository _userRepository;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final _authStateController = StreamController<AppUser?>.broadcast();

  AuthService(this._userRepository) {
    // Listen to Firebase Auth state changes and update the controller
    _firebaseAuth.authStateChanges().listen((firebaseUser) async {
      if (firebaseUser == null) {
        _authStateController.add(null);
      } else {
        final appUser = await _userRepository.getCurrentUser();
        _authStateController.add(appUser);
      }
    });
  }

  Stream<AppUser?> authStateChanges() {
    return _firebaseAuth.authStateChanges().asyncMap((firebaseUser) async {
      if (firebaseUser == null) {
        print('AuthService: No authenticated user');
        return null;
      }
      print('AuthService: User authenticated - ${firebaseUser.uid}');
      return await _userRepository.getCurrentUser();
    });
  }

  Future<AppUser?> signIn(String email, String password) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return await _userRepository.getCurrentUser();
    } catch (e) {
      print('Error signing in: $e');
      return null;
    }
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
    // The authStateChanges listener will handle updating the controller
  }

  Future<AppUser?> signUpUser(
    Map<String, dynamic> userData,
    String? businessId,
  ) async {
    try {
      if (businessId == null) {
        final user = await _userRepository.signUpWithEmailAndPassword(userData);
        _authStateController.add(user);
        return user;
      } else {
        final user = await _userRepository.signUpUserForBusiness(
          userData,
          businessId,
        );
        _authStateController.add(user);
        return user;
      }
    } catch (e) {
      print('Error signing up user: $e');
      return null;
    }
  }

  Future<AppUser?> signUpTenant(
    Map<String, dynamic> userData,
    Map<String, dynamic> businessData,
  ) async {
    try {
      final user = await _userRepository.signUpTenantWithEmailAndPassword(
        userData,
        businessData,
      );
      _authStateController.add(user);
      return user;
    } catch (e) {
      print('Error signing up tenant: $e');
      return null;
    }
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

final currentAppUserProvider = StreamProvider<AppUser?>((ref) {
  final authService = ref.watch(authServiceProvider);
  return authService.authStateChanges();
});
