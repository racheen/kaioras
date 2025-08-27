import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod_boilerplate/src/feature/clientele/scheduling/domain/app_user.dart';
import 'package:flutter_riverpod_boilerplate/src/feature/clientele/scheduling/domain/block.dart';

class Booking {
  String? bookingId;
  String? membershipId;
  String? status;
  DateTime bookedAt;
  BlockSnapshot? blockSnapshot;
  Block? block;
  AppUser? user;
  String? image;
  String? name;
  String? uid;
  String? blockId;
  String? businessId;

  Booking({
    this.bookingId,
    this.membershipId,
    this.status = 'waitlisted',
    required this.bookedAt,
    this.block,
    this.blockSnapshot,
    this.user,
    this.image,
    this.name,
    this.uid,
    this.blockId,
    this.businessId,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    final bookedAt = json['bookedAt'] as Timestamp;
    return Booking(
      bookingId: json['bookingId'],
      membershipId: json['membershipId'],
      status: json['status'],
      bookedAt: bookedAt.toDate(),
      image: json['image'],
      name: json['name'],
      uid: json['uid'],
      blockId: json['blockId'],
      businessId: json['businessId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'bookingId': bookingId,
      'membershipId': membershipId,
      'status': status,
      'bookedAt': Timestamp.fromDate(bookedAt),
      'uid': uid,
      'block': blockSnapshot?.toJson(),
    };
  }

  factory Booking.fromMap(Map<String, dynamic> json, String bookingId) {
    final bookedAt = json['bookedAt'] as Timestamp;
    final block = json['block'] as Map<String, dynamic>;

    return Booking(
      bookingId: bookingId,
      membershipId: json['membershipId'],
      status: json['status'],
      bookedAt: bookedAt.toDate(),
      uid: json['uid'],
      blockSnapshot: BlockSnapshot.fromMap(block),
    );
  }
}
