import 'package:flutter_riverpod_boilerplate/src/feature/clientele/scheduling/domain/booking.dart';

class Block {
  String? blockId;
  String? title;
  String? type;
  DateTime? startTime;
  int? duration;
  String? location;
  int? capacity;
  String? visibility;
  String? status;
  String? createdAt;
  List<String>? tags;
  String? description;
  Host? host;
  String? tenant;
  Origin origin;
  List<Booking>? booked;
  List<Booking>? waitlisted;
  List<Booking>? cancelled;
  List<Booking>? bookings;

  Block({
    this.blockId,
    this.title,
    this.type,
    this.startTime,
    this.duration,
    this.location,
    this.capacity,
    this.visibility,
    this.status,
    this.createdAt,
    this.tags,
    this.description,
    this.host,
    this.tenant,
    required this.origin,
    this.booked,
    this.waitlisted,
    this.cancelled,
    this.bookings = const [],
  });

  factory Block.fromJson(Map<String, dynamic> json) {
    return Block(
      blockId: json['blockId'],
      title: json['title'],
      type: json['type'],
      startTime: json['startTime'],
      duration: json['duration'],
      location: json['location'],
      capacity: json['capacity'],
      visibility: json['visibility'],
      status: json['status'],
      createdAt: json['createdAt'],
      tags: json['tags'],
      description: json['description'],
      host: json['host'],
      tenant: json['tenant'],
      origin: json['origin'],
      booked: json['booked'],
      waitlisted: json['waitlisted'],
      cancelled: json['cancelled'],
      bookings: json['bookings'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'blockId': blockId,
      'title': title,
      'type': type,
      'startTime': startTime,
      'duration': duration,
      'location': location,
      'capacity': capacity,
      'visibility': visibility,
      'status': status,
      'createdAt': createdAt,
      'tags': tags,
      'description': description,
      'host': host,
      'tenant': tenant,
      'origin': origin,
      'booked': booked,
      'waitlisted': waitlisted,
      'cancelled': cancelled,
      'bookings': bookings,
    };
  }

  bool isUserBooked(String uid) {
    final list = booked ?? [];
    for (Booking booking in list) {
      if (booking.user!.uid == uid) {
        return true;
      }
    }
    return false;
  }

  bool isUserWaitlisted(String uid) {
    final list = waitlisted ?? [];
    for (Booking booking in list) {
      if (booking.user!.uid == uid) {
        return true;
      }
    }
    return false;
  }

  bool isUserAttended(String uid) {
    final list = waitlisted ?? [];
    for (Booking booking in list) {
      if (booking.status == 'attended' && booking.user!.uid == uid) {
        return true;
      }
    }
    return false;
  }

  // Block copyWith({
  //   String? blockId,
  //   String? businessId,
  //   String? title,
  //   String? type,
  //   String? startTime,
  //   int? duration,
  //   String? location,
  //   int? capacity,
  //   String? visibility,
  //   String? status,
  //   String? createdAt,
  //   List<String>? tags,
  //   String? description,
  //   List<Attendee>? attendees,
  //   Host? host,
  //   String? tenant,
  // }) => Block(
  //   blockId: blockId ?? this.blockId,
  //   businessId: businessId ?? this.businessId,
  //   title: title ?? this.title,
  //   type: type ?? this.type,
  //   startTime: startTime ?? this.startTime,
  //   duration: duration ?? this.duration,
  //   location: location ?? this.location,
  //   capacity: capacity ?? this.capacity,
  //   visibility: visibility ?? this.visibility,
  //   status: status ?? this.status,
  //   createdAt: createdAt ?? this.createdAt,
  //   tags: tags ?? this.tags,
  //   description: description ?? this.description,
  //   attendees: attendees ?? this.attendees,
  //   host: host ?? this.host,
  //   tenant: tenant ?? this.tenant,
  // );
}

class Attendee {
  String? uid;
  String? membershipId;
  String? name;
  String? status;
  String? bookedAt;

  Attendee({
    this.uid,
    this.membershipId,
    this.name,
    this.status,
    this.bookedAt,
  });

  Attendee copyWith({
    String? uid,
    String? membershipId,
    String? name,
    String? status,
    String? bookedAt,
  }) => Attendee(
    uid: uid ?? this.uid,
    membershipId: membershipId ?? this.membershipId,
    name: name ?? this.name,
    status: status ?? this.status,
    bookedAt: bookedAt ?? this.bookedAt,
  );
}

class Host {
  String? uid;
  String? name;
  String? title;
  String? about;
  String? image;

  Host({this.uid, this.name, this.title, this.about, this.image});

  Host copyWith({
    String? uid,
    String? name,
    String? title,
    String? about,
    String? image,
  }) => Host(
    uid: uid ?? this.uid,
    name: name ?? this.name,
    title: title ?? title,
    about: about ?? about,
    image: image ?? image,
  );
}

class Origin {
  final String businessId;
  final String name;
  final String image;

  Origin({required this.businessId, required this.name, required this.image});
  factory Origin.fromMap(Map<String, dynamic> map) {
    return Origin(
      businessId: map['businessId'],
      name: map['name'],
      image: map['image'],
    );
  }
  Map<String, dynamic> toJson() {
    return {'businessId': businessId, 'name': name, 'image': image};
  }
}
