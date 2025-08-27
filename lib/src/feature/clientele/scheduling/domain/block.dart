import 'package:cloud_firestore/cloud_firestore.dart';

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
  Origin origin;

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
    required this.origin,
  });

  factory Block.fromMap(Map<String, dynamic> data, String blockId) {
    final title = data['title'] as String;
    final type = data['type'] as String;
    final startTime = data['startTime'] as Timestamp;
    final duration = data['duration'] as int;
    final location = data['location'] as String;
    final capacity = data['capacity'] as int;
    final visibility = data['visibility'] as String;
    final status = data['status'] as String;
    final createdAt = data['createdAt'] as Timestamp;
    final tags = data['tags'] as List<dynamic>;
    final description = data['description'] as String;
    final host = data['host'] as Map<String, dynamic>;
    final origin = data['origin'] as Map<String, dynamic>;

    return Block(
      blockId: blockId,
      title: title,
      type: type,
      startTime: startTime.toDate(),
      duration: duration,
      location: location,
      capacity: capacity,
      visibility: visibility,
      status: status,
      createdAt: createdAt.toString(),
      tags: tags.map((tag) => tag.toString()).toList(),
      description: description,
      host: Host.fromMap(host),
      origin: Origin.fromMap(origin),
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
      'origin': origin,
    };
  }

  Map<String, dynamic> toFirestore() {
    return {
      'blockId': blockId,
      'title': title,
      'type': type,
      'startTime': Timestamp.fromDate(startTime!),
      'duration': duration,
      'location': location,
      'capacity': capacity,
      'visibility': visibility,
      'status': status,
      'createdAt': Timestamp.fromDate(DateTime.parse(createdAt!)),
      'tags': tags,
      'description': description,
      'host': host,
      'origin': origin,
    };
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

class Host {
  String? uid;
  String? name;
  String? title;
  String? about;
  String? image;

  Host({this.uid, this.name, this.title, this.about, this.image});

  factory Host.fromMap(Map<String, dynamic> map) {
    return Host(
      uid: map['uid'],
      name: map['name'],
      title: map['title'],
      about: map['about'],
      image: map['image'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'name': name,
      'title': title,
      'about': about,
      'image': image,
    };
  }

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

class BlockSnapshot {
  String blockId;
  String title;
  DateTime startTime;
  String location;
  Host host;
  Origin origin;

  BlockSnapshot({
    required this.blockId,
    required this.title,
    required this.startTime,
    required this.location,
    required this.host,
    required this.origin,
  });

  factory BlockSnapshot.fromMap(Map<String, dynamic> data) {
    final blockId = data['blockId'] as String;
    final title = data['title'] as String;
    final startTime = data['startTime'] as Timestamp;
    final location = data['location'] as String;
    final host = data['host'] as Map<String, dynamic>;
    final origin = data['origin'] as Map<String, dynamic>;

    return BlockSnapshot(
      blockId: blockId,
      title: title,
      startTime: startTime.toDate(),
      location: location,
      host: Host.fromMap(host),
      origin: Origin.fromMap(origin),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'blockId': blockId,
      'title': title,
      'startTime': startTime,
      'location': location,
      'host': host.toJson(),
      'origin': origin.toJson(),
    };
  }
}
