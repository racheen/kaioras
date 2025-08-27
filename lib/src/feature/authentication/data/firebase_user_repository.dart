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
    if (userData['email'] == null ||
        userData['password'] == null ||
        userData['name'] == null ||
        businessData['businessName'] == null) {
      throw Exception('Missing required fields for signup');
    }

    try {
      final existingUser = await _firestore
          .collection('users')
          .where('email', isEqualTo: userData['email'])
          .get();

      if (existingUser.docs.isNotEmpty) {
        // User already exists, sign in with the email and add role to business
        final userCredential = await _auth.signInWithEmailAndPassword(
          email: userData['email'],
          password: userData['password'],
        );

        final existingUserDoc = existingUser.docs.first;
        final existingAppUser = AppUser.fromMap(existingUserDoc.data());

        final newBusiness = await createBusiness(
          businessData,
          userCredential,
          userData,
        );

        // Add the new tenant role to the existing user
        final newRole = UserRole(
          role: RoleType.tenant.name,
          status: 'active',
          createdAt: DateTime.now(),
        );

        final updatedRoles = {
          ...existingAppUser.roles,
          newBusiness!.businessId: newRole,
        };

        // Update the user document with the new role
        _currentUser =
            await _firestore
                    .collection('users')
                    .doc(userCredential.user!.uid)
                    .update({
                      'roles': updatedRoles.map(
                        (key, value) => MapEntry(key, value.toMap()),
                      ),
                      'lastBusinessId': newBusiness.businessId,
                    })
                as AppUser;

        return _currentUser;
      } else {
        final UserCredential userCredential = await _auth
            .createUserWithEmailAndPassword(
              email: userData['email'],
              password: userData['password'],
            );

        final newBusiness = await createBusiness(
          businessData,
          userCredential,
          userData,
        );

        final newUser = AppUser(
          uid: userCredential.user!.uid,
          email: userData['email'],
          name: userData['name'],
          createdAt: DateTime.now(),
          image: '',
          lastBusinessId: newBusiness!.businessId,
          platformRole: null,
          notifications: false,
          roles: {
            newBusiness.businessId: UserRole(
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
      }
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

  Future<AppBusiness?> createBusiness(
    Map<String, dynamic> businessData,
    UserCredential userCredential,
    Map<String, dynamic> userData,
  ) async {
    final String newBusinessId = FirebaseFirestore.instance
        .collection('businesses')
        .doc()
        .id;

    // Create a new business
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
    return newBusiness;
  }

  Future<AppUser?> signUpUserForBusiness(
    Map<String, dynamic> userData,
    String businessId,
  ) async {
    try {
      // Check if the business exists
      final businessDoc = await _firestore
          .collection('businesses')
          .doc(businessId)
          .get();
      if (!businessDoc.exists) {
        throw Exception('Business does not exist');
      }

      // Check if the user already exists
      final existingUserQuery = await _firestore
          .collection('users')
          .where('email', isEqualTo: userData['email'])
          .get();

      if (existingUserQuery.docs.isNotEmpty) {
        // User exists, add the new role
        final existingUserDoc = existingUserQuery.docs.first;
        final existingUser = AppUser.fromMap(existingUserDoc.data());

        final newRole = UserRole(
          role: RoleType.customer.name,
          status: 'active',
          createdAt: DateTime.now(),
        );

        final updatedRoles = {...existingUser.roles, businessId: newRole};

        await _firestore.collection('users').doc(existingUser.uid).update({
          'roles': updatedRoles.map(
            (key, value) => MapEntry(key, value.toMap()),
          ),
        });

        _currentUser = await getCurrentUser();
        return _currentUser;
      } else {
        // Create a new user
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
          lastBusinessId: businessId,
          platformRole: null,
          notifications: false,
          roles: {
            businessId: UserRole(
              role: RoleType.customer.name,
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
        return _currentUser;
      }
    } catch (e) {
      print('Error signing up user for business: $e');
      return null;
    }
  }
}

final userRepositoryProvider = Provider<UserRepository>(
  (ref) => UserRepository(),
);
