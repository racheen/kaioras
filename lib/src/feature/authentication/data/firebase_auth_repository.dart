import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthRepository {
  AuthRepository(this._auth);
  final FirebaseAuth _auth;

  Stream<User?> authStateChanges() => _auth.authStateChanges();
  User? get currentUser => _auth.currentUser;

  Future<void> signInWithGoogleAuth(AuthProvider provider) {
    return _auth.signInWithProvider(provider);
  }

  Future<String?> getNewIdToken() async {
    String? newIdToken;
    if (currentUser != null) {
      newIdToken = await currentUser!.getIdToken(true);
    }
    return newIdToken;
  }

  Future<void> signOut() async {
    return _auth.signOut();
  }
}

final firebaseAuthProvider = Provider<FirebaseAuth>((ref) {
  return FirebaseAuth.instance;
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(ref.watch(firebaseAuthProvider));
});

final authStateChangesProvider = Provider<Stream<User?>>((ref) {
  return ref.watch(authRepositoryProvider).authStateChanges();
});
