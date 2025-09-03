import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod_boilerplate/src/feature/authentication/domain/app_business.dart';

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

  copyWith({required String name, required String industry}) {}
}
