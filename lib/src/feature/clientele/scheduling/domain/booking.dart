import 'package:flutter_riverpod_boilerplate/src/feature/clientele/scheduling/domain/app_user.dart';
import 'package:flutter_riverpod_boilerplate/src/feature/clientele/scheduling/domain/block.dart';

class Booking {
  String bookingId;
  String? membershipId;
  String? status;
  DateTime bookedAt;
  Block? block;
  AppUser? user;

  Booking({
    required this.bookingId,
    this.membershipId,
    this.status = 'waitlisted',
    required this.bookedAt,
    this.block,
    this.user,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      bookingId: json['bookingId'],
      membershipId: json['membershipId'],
      status: json['status'],
      bookedAt: json['bookedAt'],
      block: json['block'],
      user: json['user'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'bookingId': bookingId,
      'membershipId': membershipId,
      'status': status,
      'bookedAt': bookedAt,
      'block': block?.toJson() ?? {},
      'user': user?.toJson() ?? {},
    };
  }

  // bool contains(String uid) {
  //   return
  // }
}
