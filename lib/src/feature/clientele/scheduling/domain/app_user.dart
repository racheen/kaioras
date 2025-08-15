import 'package:flutter_riverpod_boilerplate/src/feature/clientele/scheduling/domain/booking.dart';
import 'package:flutter_riverpod_boilerplate/src/feature/clientele/scheduling/domain/membership.dart';

class AppUser {
  String? uid;
  String? email;
  String? name;
  String? createdAt;
  String? image;
  String? lastBusinessId;
  String? platformRole;
  bool? notifications;
  List<Membership>? memberships;
  List<Booking>? bookings;

  AppUser({
    this.uid,
    this.email,
    this.name,
    this.createdAt,
    this.image,
    this.lastBusinessId,
    this.platformRole,
    this.notifications,
    this.memberships,
    this.bookings,
  });

  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      uid: json['uid'],
      email: json['email'],
      name: json['name'],
      createdAt: json['createdAt'],
      image: json['image'],
      lastBusinessId: json['lastBusinessId'],
      platformRole: json['platformRole'],
      notifications: json['notifications'],
      memberships: json['memberships'],
      bookings: json['bookings'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'email': email,
      'name': name,
      'createdAt': createdAt,
      'image': image,
      'lastBusinessId': lastBusinessId,
      'platformRole': platformRole,
      'notifications': notifications,
      'memberships': memberships,
      'bookings': bookings,
    };
  }

  AppUser copyWith({
    String? uid,
    String? email,
    String? name,
    String? createdAt,
    String? profilePic,
    String? lastBusinessId,
    String? platformRole,
    bool? notifications,
    List<Booking>? bookings,
    List<Membership>? memberships,
  }) => AppUser(
    uid: uid ?? this.uid,
    email: email ?? this.email,
    name: name ?? this.name,
    createdAt: createdAt ?? this.createdAt,
    image: profilePic ?? image,
    lastBusinessId: lastBusinessId ?? this.lastBusinessId,
    platformRole: platformRole ?? this.platformRole,
    notifications: notifications ?? this.notifications,
    memberships: memberships ?? this.memberships,
    bookings: bookings ?? this.bookings,
  );
}
