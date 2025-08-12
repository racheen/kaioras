import 'dart:core';
import 'package:cloud_firestore/cloud_firestore.dart';

class Block {
  final String blockId;
  final BusinessDetails businessDetails;
  final String title;
  final String type;
  final DateTime startTime;
  final int duration;
  final String location;
  final int capacity;
  final String visibility;
  final String status;
  final DateTime createdAt;
  final List<String> tags;
  final String description;
  final Map<String, Attendee> attendees;
  final Host host;

  Block({
    required this.blockId,
    required this.businessDetails,
    required this.title,
    required this.type,
    required this.startTime,
    required this.duration,
    required this.location,
    required this.capacity,
    required this.visibility,
    required this.status,
    required this.createdAt,
    required this.tags,
    required this.description,
    required this.attendees,
    required this.host,
  });

  factory Block.fromJson(Map<String, dynamic> json) {
    return Block(
      blockId: json['id'],
      businessDetails: json['businessDetails'],
      title: json['title'],
      type: json['type'],
      startTime: (json['startTime'] as Timestamp).toDate(),
      duration: json['duration'],
      location: json['location'],
      capacity: json['capacity'],
      visibility: json['visibility'],
      status: json['status'],
      createdAt: (json['createdAt'] as Timestamp).toDate(),
      tags: List<String>.from(json['tags'] ?? []),
      description: json['description'],
      attendees:
          (json['attendees'] as Map<String, dynamic>?)?.map(
            (key, value) => MapEntry(key, Attendee.fromJson(value)),
          ) ??
          {},
      host: Host.fromJson(json['provider']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'businessDetails': businessDetails.toJson(),
      'title': title,
      'type': type,
      'startTime': Timestamp.fromDate(startTime),
      'duration': duration,
      'location': location,
      'capacity': capacity,
      'visibility': visibility,
      'status': status,
      'createdAt': Timestamp.fromDate(createdAt),
      'tags': tags,
      'description': description,
      'attendees': attendees.map((key, value) => MapEntry(key, value.toJson())),
      'provider': host.toJson(),
    };
  }
}

class Attendee {
  final String uid;
  final String membershipId;
  final String name;
  final String status;
  final DateTime bookedAt;

  Attendee({
    required this.uid,
    required this.membershipId,
    required this.name,
    required this.status,
    required this.bookedAt,
  });

  factory Attendee.fromJson(Map<String, dynamic> json) {
    return Attendee(
      uid: json['uid'],
      membershipId: json['membershipId'],
      name: json['name'],
      status: json['status'],
      bookedAt: (json['bookedAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'membershipId': membershipId,
      'name': name,
      'status': status,
      'bookedAt': Timestamp.fromDate(bookedAt),
    };
  }
}

class Host {
  final String uid;
  final String name;
  final String details;

  Host({required this.uid, required this.name, required this.details});

  factory Host.fromJson(Map<String, dynamic> json) {
    return Host(uid: json['uid'], name: json['name'], details: json['details']);
  }

  Map<String, dynamic> toJson() {
    return {'uid': uid, 'name': name, 'details': details};
  }
}

class BusinessDetails {
  final String businessId;
  final String name;
  final String picture;

  BusinessDetails({
    required this.businessId,
    required this.name,
    required this.picture,
  });
  factory BusinessDetails.fromMap(Map<String, dynamic> map) {
    return BusinessDetails(
      businessId: map['businessId'],
      name: map['name'],
      picture: map['picture'],
    );
  }
  Map<String, dynamic> toJson() {
    return {'businessId': businessId, 'name': name, 'picture': picture};
  }
}
