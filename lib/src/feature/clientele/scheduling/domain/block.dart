import 'package:flutter_riverpod_boilerplate/src/feature/tenant/scheduling/domain/block.dart';

class Block {
  String? blockId;
  String? businessId;
  String? title;
  String? type;
  String? startTime;
  int? duration;
  String? location;
  int? capacity;
  String? visibility;
  String? status;
  String? createdAt;
  List<String>? tags;
  String? description;
  List<Attendee>? attendees;
  Host? host;
  String? tenant;

  Block({
    this.blockId,
    this.businessId,
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
    this.attendees,
    this.host,
    this.tenant,
    required BusinessDetails businessDetails,
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
  String? details;

  Host({this.uid, this.name, this.details});

  Host copyWith({String? uid, String? name, String? details}) => Host(
    uid: uid ?? this.uid,
    name: name ?? this.name,
    details: details ?? this.details,
  );
}
