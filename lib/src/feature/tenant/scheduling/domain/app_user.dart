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
  String? membershipId;
  OfferSnapshot? offerSnapshot;
  BusinessDetails? businessDetails;
  String? name;
  int? credits;
  int? creditsUsed;
  String? expiration;
  String? status;
  String? createdAt;
  Map<String, BookingSnapshot>? bookings;

  Membership({
    this.membershipId,
    this.businessDetails,
    this.offerSnapshot,
    this.name,
    this.credits,
    this.creditsUsed,
    this.expiration,
    this.status,
    this.createdAt,
    this.bookings,
  });

  Membership copyWith({
    String? membershipId,
    BusinessDetails? businessDetails,
    OfferSnapshot? offerSnapshot,
    String? name,
    int? credits,
    int? creditsUsed,
    String? expiration,
    String? status,
    String? createdAt,
    Map<String, BookingSnapshot>? bookings,
  }) => Membership(
    membershipId: membershipId ?? this.membershipId,
    businessDetails: businessDetails ?? this.businessDetails,
    offerSnapshot: offerSnapshot ?? this.offerSnapshot,
    name: name ?? this.name,
    credits: credits ?? this.credits,
    creditsUsed: creditsUsed ?? this.creditsUsed,
    expiration: expiration ?? this.expiration,
    status: status ?? this.status,
    createdAt: createdAt ?? this.createdAt,
    bookings: bookings ?? this.bookings,
  );
}

class OfferSnapshot {
  final String name;
  final String type;
  final String description;

  OfferSnapshot({
    required this.name,
    required this.type,
    required this.description,
  });

  factory OfferSnapshot.fromMap(Map<String, dynamic> map) {
    return OfferSnapshot(
      name: map['name'],
      type: map['type'],
      description: map['description'],
    );
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
}

class Branding {
  final String primaryColor;
  final String logoUrl;

  Branding({required this.primaryColor, required this.logoUrl});

  factory Branding.fromMap(Map<String, dynamic> map) {
    return Branding(primaryColor: map['primaryColor'], logoUrl: map['logoUrl']);
  }
}
