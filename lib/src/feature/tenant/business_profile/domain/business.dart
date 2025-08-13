import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod_boilerplate/src/feature/tenant/scheduling/domain/availability.dart';

class Business {
  final String businessId;
  final String name;
  final String ownerUid;
  final Timestamp createdAt;
  final String description;
  final String industry;
  final Branding branding;
  final String plan;
  final String stripeAccountId;
  final List<Offer> offers;
  final Roles roles;
  final BusinessSettings settings;

  Business({
    required this.businessId,
    required this.name,
    required this.ownerUid,
    required this.createdAt,
    required this.description,
    required this.industry,
    required this.branding,
    required this.plan,
    required this.stripeAccountId,
    required this.offers,
    required this.roles,
    required this.settings,
  });

  Business copyWith({
    String? businessId,
    String? name,
    String? ownerUid,
    Timestamp? createdAt,
    String? description,
    String? industry,
    Branding? branding,
    String? plan,
    String? stripeAccountId,
    List<Offer>? offers,
    Roles? roles,
    BusinessSettings? settings,
  }) {
    return Business(
      businessId: businessId ?? this.businessId,
      name: name ?? this.name,
      ownerUid: ownerUid ?? this.ownerUid,
      createdAt: createdAt ?? this.createdAt,
      description: description ?? this.description,
      industry: industry ?? this.industry,
      branding: branding ?? this.branding,
      plan: plan ?? this.plan,
      stripeAccountId: stripeAccountId ?? this.stripeAccountId,
      offers: offers ?? this.offers,
      roles: roles ?? this.roles,
      settings: settings ?? this.settings,
    );
  }
}

class Branding {
  final String primaryColor;
  final String logoUrl;

  Branding({required this.primaryColor, required this.logoUrl});
}

class BusinessSettings {
  final Availability availability;
  final Holiday holidays;
  final List<String> closedDays;

  BusinessSettings({
    required this.availability,
    required this.holidays,
    required this.closedDays,
  });
}

class Holiday {
  final DateTime date;
  final String reason;

  Holiday({required this.date, required this.reason});
}

class Roles {
  final String uid;
  final String role;
  final String status;
  final Timestamp createdAt;
  final String displayName;

  Roles({
    required this.uid,
    required this.role,
    required this.status,
    required this.createdAt,
    required this.displayName,
  });
}

class Offer {
  final String name;
  final String type;
  final String credits;
  final int price;
  final String currency;
  final int durationInDays;
  final String description;
  final bool active;
  final Timestamp createdAt;

  Offer({
    required this.name,
    required this.type,
    required this.credits,
    required this.price,
    required this.currency,
    required this.durationInDays,
    required this.description,
    required this.active,
    required this.createdAt,
  });

  Offer values({
    String? name,
    String? type,
    String? credits,
    int? price,
    String? currency,
    int? durationInDays,
    String? description,
    bool? active,
    Timestamp? createdAt,
  }) {
    return Offer(
      name: name ?? this.name,
      type: type ?? this.type,
      credits: credits ?? this.credits,
      price: price ?? this.price,
      currency: currency ?? this.currency,
      durationInDays: durationInDays ?? this.durationInDays,
      description: description ?? this.description,
      active: active ?? this.active,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
