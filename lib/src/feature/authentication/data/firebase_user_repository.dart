import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_boilerplate/src/constants/mock_data2.dart';
import 'package:flutter_riverpod_boilerplate/src/feature/authentication/data/user_repository_base.dart';
import 'package:flutter_riverpod_boilerplate/src/feature/authentication/domain/app_business.dart';
import 'package:flutter_riverpod_boilerplate/src/feature/authentication/domain/app_user.dart';

class UserRepository implements UserRepositoryBase {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  AppUser? _currentUser;

  @override
  Future<AppUser?> getCurrentUser() async {
    final User? firebaseUser = _auth.currentUser;
    if (firebaseUser == null) {
      _currentUser = null;
      return null;
    }

    // Return cached user if available and UID matches
    if (_currentUser != null && _currentUser!.uid == firebaseUser.uid) {
      return _currentUser;
    }

    try {
      final DocumentSnapshot userDoc = await _firestore
          .collection('users')
          .doc(firebaseUser.uid)
          .get();

      if (!userDoc.exists) {
        _currentUser = null;
        return null;
      }

      final userData = userDoc.data() as Map<String, dynamic>;
      _currentUser = AppUser.fromMap(userData);
      return _currentUser;
    } catch (e) {
      print('Error getting current user: $e');
      return null;
    }
  }

  @override
  Future<void> signOut() async {
    await _auth.signOut();
    _currentUser = null;
  }

  Future<AppUser?> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return await getCurrentUser();
    } catch (e) {
      print('Error signing in with email and password: $e');
      return null;
    }
  }

  Future<AppUser?> signUpWithEmailAndPassword(
    Map<String, dynamic> userData,
  ) async {
    try {
      final UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(
            email: userData['email'],
            password: userData['password'],
          );

      final newUser = AppUser(
        uid: userCredential.user!.uid,
        email: userData['email'],
        name: userData['name'],
        createdAt: DateTime.now(),
        image: '',
        lastBusinessId: null,
        platformRole: null,
        notifications: false,
        roles: {},
      );

      await _firestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .set(newUser.toMap());

      _currentUser = newUser;
      return newUser;
    } catch (e) {
      print('Error signing up with email and password: $e');
      return null;
    }
  }

  Future<AppUser?> signUpTenantWithEmailAndPassword(
    Map<String, dynamic> userData,
    Map<String, dynamic> businessData,
  ) async {
    try {
      print(userData['email']);
      print(userData['password']);
      print(userData['name']);
      print(businessData['businessName']);
      print(businessData.toString());

      if (userData['email'] == null ||
          userData['password'] == null ||
          userData['name'] == null ||
          businessData['businessName'] == null) {
        throw Exception('Missing required fields for signup');
      }

      final String newBusinessId = FirebaseFirestore.instance
          .collection('businesses')
          .doc()
          .id;

      final UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(
            email: userData['email'],
            password: userData['password'],
          );

      final newBusiness = AppBusiness(
        businessId: newBusinessId,
        name: businessData['businessName'],
        ownerUid: userCredential.user!.uid,
        createdAt: DateTime.now(),
        plan: 'basic',
        stripeAccountId: '',
        offers: [],
        roles: {
          userCredential.user!.uid: Role(
            uid: userCredential.user!.uid,
            role: RoleType.tenant.name,
            status: 'active',
            createdAt: DateTime.now(),
            displayName: userData['name'],
          ),
        },
        meta: Meta(
          industry: businessData['industry'] ?? 'Other',
          branding: null, // You can add branding information if available
          settings: BusinessSettings(
            availability: Availability(
              defaultHours: [
                DayHours(day: 'monday', start: '09:00', end: '17:00'),
                DayHours(day: 'tuesday', start: '09:00', end: '17:00'),
                DayHours(day: 'wednesday', start: '09:00', end: '17:00'),
                DayHours(day: 'thursday', start: '09:00', end: '17:00'),
                DayHours(day: 'friday', start: '09:00', end: '17:00'),
              ],
              timeZone: 'America/New_York',
            ),
            holidays: [],
            closedDays: ['saturday', 'sunday'],
          ),
        ),
      );

      await _firestore.collection('businesses').add(newBusiness.toMap());

      print('New business created with ID: ${newBusinessId}');

      final newUser = AppUser(
        uid: userCredential.user!.uid,
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

      await _firestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .set(newUser.toMap());

      _currentUser = newUser;
      return newUser;
    } catch (e) {
      print('Error signing up with email and password: $e');
      return null;
    }
  }

  // Add a method to update the cached user when user data changes
  Future<void> updateUserData(Map<String, dynamic> userData) async {
    final User? firebaseUser = _auth.currentUser;
    if (firebaseUser == null) return;

    await _firestore.collection('users').doc(firebaseUser.uid).update(userData);

    // Update the cached user
    _currentUser = await getCurrentUser();
  }
}

final userRepositoryProvider = Provider<UserRepository>(
  (ref) => UserRepository(),
);
