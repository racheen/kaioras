import 'package:cloud_firestore/cloud_firestore.dart';

class EventModel {
  final String id;
  final String businessId;
  final String providerId;
  final String title;
  final String type;
  final Timestamp startTime;
  final int duration;
  final String location;
  final int capacity;
  final String visibility;
  final String status;
  final Timestamp createdAt;
  EventModel({
    required this.id,
    required this.businessId,
    required this.providerId,
    required this.title,
    required this.type,
    required this.startTime,
    required this.duration,
    required this.location,
    required this.capacity,
    required this.visibility,
    required this.status,
    required this.createdAt,
  });

  factory EventModel.fromJson(Map<String, dynamic> json, String id) {
    return EventModel(
      id: id,
      businessId: json['businessId'] ?? '',
      providerId: json['providerId'] ?? '',
      title: json['title'] ?? '',
      type: json['type'] ?? '',
      startTime: json['startTime'] ?? Timestamp.now(),
      duration: json['duration'] ?? 0,
      location: json['location'] ?? '',
      capacity: json['capacity'] ?? 0,
      visibility: json['visibility'] ?? '',
      status: json['status'] ?? '',
      createdAt: json['createdAt'] ?? Timestamp.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'businessId': businessId,
      'providerId': providerId,
      'title': title,
      'type': type,
      'startTime': startTime,
      'duration': duration,
      'location': location,
      'capacity': capacity,
      'visibility': visibility,
      'status': status,
      'createdAt': createdAt,
    };
  }
}
