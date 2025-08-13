import 'package:flutter_riverpod_boilerplate/src/feature/tenant/scheduling/domain/block.dart';

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
  List<Block>? booked;
  List<Block>? waitlisted;
  List<Block>? cancelled;

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
  });

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
