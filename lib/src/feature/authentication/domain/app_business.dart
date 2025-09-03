import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod_boilerplate/src/feature/tenant/scheduling/domain/availability.dart';

class AppBusiness {
  final String businessId;
  final String name;
  final String ownerUid;
  final DateTime createdAt;
  final String plan;
  final String stripeAccountId;
  final List<Offer> offers;
  final Map<String, Role> roles;
  final Meta meta;

  AppBusiness({
    required this.businessId,
    required this.name,
    required this.ownerUid,
    required this.createdAt,
    required this.plan,
    required this.stripeAccountId,
    required this.offers,
    required this.roles,
    required this.meta,
  });

  factory AppBusiness.fromMap(Map<String, dynamic> map) {
    return AppBusiness(
      businessId: map['businessId'],
      name: map['name'],
      ownerUid: map['ownerUid'],
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      plan: map['plan'],
      stripeAccountId: map['stripeAccountId'],
      offers: (map['offers'] as Map<String, dynamic>).entries
          .map((e) => Offer.fromMap(e.value as Map<String, dynamic>))
          .toList(),
      roles: (map['roles'] as Map<String, dynamic>).map(
        (key, value) =>
            MapEntry(key, Role.fromMap(value as Map<String, dynamic>)),
      ),
      meta: Meta.fromMap(map['meta']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'businessId': businessId,
      'name': name,
      'ownerUid': ownerUid,
      'createdAt': Timestamp.fromDate(createdAt),
      'plan': plan,
      'stripeAccountId': stripeAccountId,
      'offers': offers.asMap().map(
        (key, value) => MapEntry(key.toString(), value.toMap()),
      ),
      'roles': roles.map((key, value) => MapEntry(key, value.toMap())),
      'meta': meta.toMap(),
    };
  }
}

class Branding {
  final String primaryColor;
  final String logoUrl;

  Branding({required this.primaryColor, required this.logoUrl});

  factory Branding.fromMap(Map<String, dynamic> map) {
    return Branding(primaryColor: map['primaryColor'], logoUrl: map['logoUrl']);
  }

  Map<String, dynamic> toMap() {
    return {'primaryColor': primaryColor, 'logoUrl': logoUrl};
  }
}

class Offer {
  final String name;
  final String type;
  final int credits;
  final int price;
  final String currency;
  final int? durationInDays;
  final String description;
  final bool active;
  final DateTime createdAt;

  Offer({
    required this.name,
    required this.type,
    required this.credits,
    required this.price,
    required this.currency,
    this.durationInDays,
    required this.description,
    required this.active,
    required this.createdAt,
  });

  factory Offer.fromMap(Map<String, dynamic> map) {
    return Offer(
      name: map['name'],
      type: map['type'],
      credits: map['credits'],
      price: map['price'],
      currency: map['currency'],
      durationInDays: map['durationInDays'],
      description: map['description'],
      active: map['active'],
      createdAt: (map['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'type': type,
      'credits': credits,
      'price': price,
      'currency': currency,
      'durationInDays': durationInDays,
      'description': description,
      'active': active,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}

class Role {
  final String uid;
  final String role;
  final String status;
  final DateTime createdAt;
  final String? displayName;

  Role({
    required this.uid,
    required this.role,
    required this.status,
    required this.createdAt,
    this.displayName,
  });

  factory Role.fromMap(Map<String, dynamic> map) {
    return Role(
      uid: map['uid'],
      role: map['role'],
      status: map['status'],
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      displayName: map['displayName'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'role': role,
      'status': status,
      'createdAt': Timestamp.fromDate(createdAt),
      'displayName': displayName,
    };
  }
}

class BusinessSettings {
  final Availability availability;
  final List<Holiday> holidays;

  BusinessSettings({required this.availability, required this.holidays});

  factory BusinessSettings.fromMap(Map<String, dynamic> map) {
    return BusinessSettings(
      availability: Availability.fromMap(map['availability']),
      holidays: (map['holidays'] as List)
          .map((item) => Holiday.fromMap(item as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'availability': availability.toMap(),
      'holidays': holidays.map((holiday) => holiday.toMap()).toList(),
    };
  }
}

class DayHours {
  final String day;
  final String start;
  final String end;

  DayHours({required this.day, required this.start, required this.end});

  factory DayHours.fromMap(Map<String, dynamic> map) {
    return DayHours(day: map['day'], start: map['start'], end: map['end']);
  }

  Map<String, dynamic> toMap() {
    return {'day': day, 'start': start, 'end': end};
  }
}

class Holiday {
  final DateTime date;
  final String reason;

  Holiday({required this.date, required this.reason});

  factory Holiday.fromMap(Map<String, dynamic> map) {
    return Holiday(
      date: (map['date'] as Timestamp).toDate(),
      reason: map['reason'],
    );
  }

  Map<String, dynamic> toMap() {
    return {'date': Timestamp.fromDate(date), 'reason': reason};
  }
}

class Meta {
  final BusinessSettings? settings;
  final Branding? branding;
  final String industry;

  Meta({this.settings, this.branding, required this.industry});

  factory Meta.fromMap(Map<String, dynamic> map) {
    return Meta(
      settings: map['settings'] != null
          ? BusinessSettings.fromMap(map['settings'] as Map<String, dynamic>)
          : null,
      branding: map['branding'] != null
          ? Branding.fromMap(map['branding'] as Map<String, dynamic>)
          : null,
      industry: map['industry'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'settings': settings?.toMap(),
      'branding': branding?.toMap(),
      'industry': industry,
    };
  }
}
