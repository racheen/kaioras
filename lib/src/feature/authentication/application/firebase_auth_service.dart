import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Stream<User?> authStateChanges() => _auth.authStateChanges();

  Future<UserCredential> signIn(String email, String password) async {
    return await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> signUpTenant(
    Map<String, dynamic> userData,
    Map<String, dynamic> businessData,
  ) async {
    try {
      // Create the user with Firebase Authentication
      UserCredential
      userCredential = await _auth.createUserWithEmailAndPassword(
        email: userData['email'],
        password:
            userData['password'], // Make sure to pass the password from the form
      );

      final String userId = userCredential.user!.uid;
      final String businessId = _firestore
          .collection('businesses')
          .doc()
          .id; // Generate a new business ID

      // Create user document
      await _firestore.collection('users').doc(userId).set({
        'uid': userId,
        'email': userData['email'],
        'name': userData['name'],
        'createdAt': FieldValue.serverTimestamp(),
        'profilePic': '', // You might want to add this field to your form
        'lastBusinessId': businessId,
        'platformRole': null,
        'notifications': false,
        'roles': {
          businessId: {
            'role': 'tenant',
            'status': 'active',
            'createdAt': FieldValue.serverTimestamp(),
          },
        },
      });

      // Create business document
      await _firestore.collection('businesses').doc(businessId).set({
        'businessId': businessId,
        'name': businessData['businessName'],
        'ownerUid': userId,
        'createdAt': FieldValue.serverTimestamp(),
        'industry': businessData['industry'],
        'branding': {
          'primaryColor': businessData['primaryColor'],
          'logoUrl': businessData['logoUrl'],
        },
        'plan': 'pro', // You might want to add a plan selection to your form
        'stripeAccountId': '', // This would typically be set up separately
        'roles': {
          userId: {
            'uid': userId,
            'role': 'tenant',
            'status': 'active',
            'createdAt': FieldValue.serverTimestamp(),
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
      });
    } catch (e) {
      print('Error during signup: $e');
      throw e;
    }
  }
}

final authServiceProvider = Provider<AuthService>((ref) => AuthService());

final authStateProvider = StreamProvider<User?>((ref) {
  final authService = ref.watch(authServiceProvider);
  return authService.authStateChanges();
});
