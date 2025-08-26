import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod_boilerplate/src/feature/tenant/scheduling/domain/app_user.dart';

enum UserRoleType { tenant, customer }

class AppUser {
  final String uid;
  final String email;
  final String name;
  final DateTime createdAt;
  final String? image;
  final String? lastBusinessId;
  final String? platformRole;
  final bool notifications;
  final Map<String, UserRole> roles;
  final Map<String, Membership>? memberships;
  final Map<String, Booking>? bookings;

  AppUser({
    required this.uid,
    required this.email,
    required this.name,
    required this.createdAt,
    this.image,
    this.lastBusinessId,
    this.platformRole,
    required this.notifications,
    required this.roles,
    this.memberships,
    this.bookings,
  });

  bool hasRole(UserRoleType roleType) => roles.values.any(
    (role) => role.role == roleType.toString().split('.').last,
  );

  bool get isTenant => hasRole(UserRoleType.tenant);
  bool get isCustomer => hasRole(UserRoleType.customer);

  UserRoleType getPrimaryRole() {
    if (isTenant) {
      return UserRoleType.tenant;
    } else if (isCustomer) {
      return UserRoleType.customer;
    } else {
      throw Exception('User has no valid role');
    }
  }

  String? getBusinessIdForRole(UserRoleType roleType) {
    return roles.entries
        .firstWhere(
          (entry) => entry.value.role == roleType.toString().split('.').last,
          orElse: () => MapEntry(
            '',
            UserRole(role: '', status: '', createdAt: DateTime.now()),
          ),
        )
        .key;
  }

  static fromFirebaseUser(User user) {}

  factory AppUser.fromMap(Map<String, dynamic> map) {
    return AppUser(
      uid: map['uid'] as String,
      email: map['email'] as String,
      name: map['name'] as String,
      createdAt: map['createdAt'] is Timestamp
          ? (map['createdAt'] as Timestamp).toDate()
          : DateTime.parse(map['createdAt'] as String),
      image: map['image'] as String?,
      lastBusinessId: map['lastBusinessId'] as String?,
      platformRole: map['platformRole'] as String?,
      notifications: map['notifications'] as bool,
      roles: (map['roles'] as Map<String, dynamic>).map(
        (key, value) =>
            MapEntry(key, UserRole.fromMap(value as Map<String, dynamic>)),
      ),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'name': name,
      'createdAt': Timestamp.fromDate(createdAt),
      'image': image,
      'lastBusinessId': lastBusinessId,
      'platformRole': platformRole,
      'notifications': notifications,
      'roles': roles.map((key, value) => MapEntry(key, value.toMap())),
      'memberships': memberships,
      'bookings': bookings,
    };
  }
}

class UserRole {
  final String role;
  final String status;
  final DateTime createdAt;

  UserRole({required this.role, required this.status, required this.createdAt});
  factory UserRole.fromMap(Map<String, dynamic> map) {
    return UserRole(
      role: map['role'] as String,
      status: map['status'] as String,
      createdAt: map['createdAt'] is Timestamp
          ? (map['createdAt'] as Timestamp).toDate()
          : DateTime.parse(map['createdAt'] as String),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'role': role,
      'status': status,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}
