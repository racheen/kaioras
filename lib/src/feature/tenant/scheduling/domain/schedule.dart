import 'dart:core';
import 'package:cloud_firestore/cloud_firestore.dart';

class BlockModel {
  final String id;
  final String businessId;
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
  final Provider provider;

  BlockModel({
    required this.id,
    required this.businessId,
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
    required this.provider,
  });

  factory BlockModel.fromJson(Map<String, dynamic> json) {
    return BlockModel(
      id: json['id'],
      businessId: json['businessId'],
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
      provider: Provider.fromJson(json['provider']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'businessId': businessId,
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
      'provider': provider.toJson(),
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

class Provider {
  final String uid;
  final String name;
  final String details;

  Provider({required this.uid, required this.name, required this.details});

  factory Provider.fromJson(Map<String, dynamic> json) {
    return Provider(
      uid: json['uid'],
      name: json['name'],
      details: json['details'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'uid': uid, 'name': name, 'details': details};
  }
}
