import 'package:cloud_firestore/cloud_firestore.dart';

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
  final Map<String, BookingSnapshot>? bookings;

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

  factory AppUser.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return AppUser(
      uid: doc.id,
      email: data['email'],
      name: data['name'],
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      image: data['image'],
      lastBusinessId: data['lastBusinessId'],
      platformRole: data['platformRole'],
      notifications: data['notifications'],
      roles: (data['roles'] as Map<String, dynamic>).map(
        (key, value) => MapEntry(key, UserRole.fromMap(value)),
      ),
      memberships: {},
      bookings: {},
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'email': email,
      'name': name,
      'createdAt': Timestamp.fromDate(createdAt),
      'image': image,
      'lastBusinessId': lastBusinessId,
      'platformRole': platformRole,
      'notifications': notifications,
      'roles': roles.map((key, value) => MapEntry(key, value.toMap())),
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
      role: map['role'],
      status: map['status'],
      createdAt: (map['createdAt'] as Timestamp).toDate(),
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

class Membership {
  final String membershipId;
  final BusinessDetails businessDetails;
  final OfferSnapshot offerSnapshot;
  final String name;
  final int credits;
  final int creditsUsed;
  final DateTime expiration;
  final String status;
  final DateTime createdAt;
  // final Map<String, BookingSnapshot> bookings;

  Membership({
    required this.membershipId,
    required this.businessDetails,
    required this.offerSnapshot,
    required this.name,
    required this.credits,
    required this.creditsUsed,
    required this.expiration,
    required this.status,
    required this.createdAt,
    // required this.bookings,
  });

  factory Membership.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Membership(
      membershipId: doc.id,
      businessDetails: BusinessDetails.fromMap(data['businessDetails']),
      offerSnapshot: OfferSnapshot.fromMap(data['offerSnapshot']),
      name: data['name'],
      credits: data['credits'],
      creditsUsed: data['creditsUsed'],
      expiration: (data['expiration'] as Timestamp).toDate(),
      status: data['status'],
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      // bookings: (data['bookings'] as Map<String, dynamic>).map(
      //   (key, value) => MapEntry(key, BookingSnapshot.fromMap(value)),
      // ),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'membershipId': membershipId,
      'businessDetails': businessDetails.toJson(),
      'offerSnapshot': offerSnapshot.toJson(),
      'name': name,
      'credits': credits,
      'creditsUsed': creditsUsed,
      'expiration': Timestamp.fromDate(expiration),
      'status': status,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}

class OfferSnapshot {
  final String name;
  final String type;
  final String description;
  final String blockType;
  final String blockSubtype;

  OfferSnapshot({
    required this.name,
    required this.type,
    required this.description,
    required this.blockType,
    required this.blockSubtype,
  });

  factory OfferSnapshot.fromMap(Map<String, dynamic> map) {
    return OfferSnapshot(
      name: map['name'],
      type: map['type'],
      description: map['description'],
      blockType: map['blockType'],
      blockSubtype: map['blockSubtype'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'type': type,
      'description': description,
      'blockType': blockType,
      'blockSubtype': blockSubtype,
    };
  }
}

class BookingSnapshot {
  final String blockId;
  final String title;
  final DateTime startTime;
  final String status;

  BookingSnapshot({
    required this.blockId,
    required this.title,
    required this.startTime,
    required this.status,
  });

  factory BookingSnapshot.fromMap(Map<String, dynamic> map) {
    return BookingSnapshot(
      blockId: map['blockId'],
      title: map['title'],
      startTime: (map['startTime'] as Timestamp).toDate(),
      status: map['status'],
    );
  }
}

class Booking {
  final String bookingId;
  final String membershipId;
  final BusinessDetails businessDetails;
  final String status;
  final DateTime bookedAt;
  final String notes;
  final BlockDetails blockDetails;

  Booking({
    required this.bookingId,
    required this.membershipId,
    required this.businessDetails,
    required this.status,
    required this.bookedAt,
    required this.notes,
    required this.blockDetails,
  });

  factory Booking.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Booking(
      bookingId: doc.id,
      membershipId: data['membershipId'],
      businessDetails: BusinessDetails.fromMap(data['businessDetails']),
      status: data['status'],
      bookedAt: (data['bookedAt'] as Timestamp).toDate(),
      notes: data['notes'],
      blockDetails: BlockDetails.fromMap(data['blockDetails']),
    );
  }
}

class BlockDetails {
  final String title;
  final DateTime startTime;
  final String location;
  final String hostName;
  final String hostDetails;

  BlockDetails({
    required this.title,
    required this.startTime,
    required this.location,
    required this.hostName,
    required this.hostDetails,
  });

  factory BlockDetails.fromMap(Map<String, dynamic> map) {
    return BlockDetails(
      title: map['title'],
      startTime: (map['startTime'] as Timestamp).toDate(),
      location: map['location'],
      hostName: map['hostName'],
      hostDetails: map['hostDetails'],
    );
  }
}

class BusinessDetails {
  final String name;
  final String image;
  final String businessId;

  BusinessDetails({
    required this.name,
    required this.image,
    required this.businessId,
  });

  factory BusinessDetails.fromMap(Map<String, dynamic> map) {
    return BusinessDetails(
      businessId: map['businessId'],
      name: map['name'],
      image: map['image'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'businessId': businessId, 'name': name, 'image': image};
  }
}

class Branding {
  final String primaryColor;
  final String logoUrl;

  Branding({required this.primaryColor, required this.logoUrl});

  factory Branding.fromMap(Map<String, dynamic> map) {
    return Branding(primaryColor: map['primaryColor'], logoUrl: map['logoUrl']);
  }
}
