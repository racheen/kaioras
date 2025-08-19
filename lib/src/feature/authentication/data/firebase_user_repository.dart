import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod_boilerplate/src/feature/authentication/data/user_repository_base.dart';
import 'package:flutter_riverpod_boilerplate/src/feature/authentication/domain/app_user.dart';

class UserRepository implements UserRepositoryBase {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<AppUser?> getCurrentUser() async {
    try {
      final User? firebaseUser = _auth.currentUser;
      if (firebaseUser == null) return null;

      final DocumentSnapshot userDoc = await _firestore
          .collection('users')
          .doc(firebaseUser.uid)
          .get();

      if (!userDoc.exists) return null;

      final userData = userDoc.data() as Map<String, dynamic>;
      return AppUser.fromMap(userData);
    } catch (e) {
      print('Error getting current user: $e');
      return null;
    }
  }

  // @override
  // Future<void> signOut() async {
  //   await _auth.signOut();
  // }

  // @override
  // Future<AppUser?> signInWithEmailAndPassword(String email, String password) async {
  //   try {
  //     final UserCredential userCredential = await _auth.signInWithEmailAndPassword(
  //       email: email,
  //       password: password,
  //     );
  //     return await getCurrentUser();
  //   } catch (e) {
  //     print('Error signing in with email and password: $e');
  //     return null;
  //   }
  // }

  // @override
  // Future<AppUser?> signUpWithEmailAndPassword(String email, String password, String name) async {
  //   try {
  //     final UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
  //       email: email,
  //       password: password,
  //     );

  //     final newUser = AppUser(
  //       uid: userCredential.user!.uid,
  //       email: email,
  //       name: name,
  //       createdAt: DateTime.now(),
  //       // Add other fields as needed
  //     );

  //     await _firestore
  //         .collection('users')
  //         .doc(userCredential.user!.uid)
  //         .set(newUser.toMap());

  //     return newUser;
  //   } catch (e) {
  //     print('Error signing up with email and password: $e');
  //     return null;
  //   }
  // }
}
