import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_boilerplate/src/feature/tenant/scheduling/domain/app_user.dart';

class FirebaseMembershipsRepository {
  FirebaseMembershipsRepository(this._firestore);
  final FirebaseFirestore _firestore;

  Query<Membership> queryMemberships(String uid) {
    return _firestore
        .collection('users/$uid/membership')
        .withConverter(
          fromFirestore: (snapshot, _) => Membership.fromFirestore(snapshot),
          toFirestore: (membership, _) {
            return membership.toFirestore();
          },
        );
  }

  DocumentReference<Map<String, dynamic>> queryMembershipById(
    String uid,
    String membershipId,
  ) {
    return _firestore.collection('users/$uid/membership').doc(membershipId);
  }

  Future<Membership?> fetchUserMembership(
    String uid,
    String membershipId,
  ) async {
    final membership = await queryMembershipById(uid, membershipId).get();
    return Membership.fromFirestore(membership);
  }

  Future<List<Membership>> fetchUserMemberships(String uid) async {
    final memberships = await queryMemberships(uid).get();
    return memberships.docs.map((doc) => doc.data()).toList();
  }

  bool _verifyMembershipCredits(Membership userMembership, int toPayAmount) {
    final isValidMembership = DateTime.now().isBefore(
      userMembership.expiration,
    );
    final hasAvailableCredits = userMembership.credits >= toPayAmount;
    if (isValidMembership && hasAvailableCredits) {
      return true;
    }
    return false;
  }

  Future<bool> checkout(String uid, String membershipId) async {
    final toPayAmount = 1;
    try {
      final userMembership = await fetchUserMembership(uid, membershipId);
      if (userMembership != null) {
        final hasValidMembershipCredits = _verifyMembershipCredits(
          userMembership,
          toPayAmount,
        );

        if (hasValidMembershipCredits) {
          final newCredits = userMembership.credits - toPayAmount;
          final newTotalCreditsUsed = userMembership.creditsUsed + toPayAmount;

          final updatedMembership = Membership(
            membershipId: userMembership.membershipId,
            businessDetails: userMembership.businessDetails,
            offerSnapshot: userMembership.offerSnapshot,
            name: userMembership.name,
            credits: newCredits,
            creditsUsed: newTotalCreditsUsed,
            expiration: userMembership.expiration,
            status: userMembership.status,
            createdAt: userMembership.createdAt,
          );

          await queryMembershipById(
            uid,
            membershipId,
          ).set(updatedMembership.toFirestore());

          return true;
        } else {
          print('insufficient credits');
          return false;
        }
      }
    } catch (e, st) {
      print(e);
      print(st);
    }
    return false;
  }

  bool _verifyMembershipRefundCredits(
    Membership userMembership,
    int refundAmount,
  ) {
    final isValidMembership = DateTime.now().isBefore(
      userMembership.expiration,
    );
    final hasAvailableCredits = userMembership.creditsUsed >= refundAmount;
    if (isValidMembership && hasAvailableCredits) {
      return true;
    }
    return false;
  }

  Future<bool> refundCredits(String uid, String membershipId) async {
    final userMembership = await fetchUserMembership(uid, membershipId);
    final refundAmount = 1;
    if (userMembership != null) {
      final hasValidMembershipCredits = _verifyMembershipRefundCredits(
        userMembership,
        refundAmount,
      );

      if (hasValidMembershipCredits) {
        final newTotalCreditsUsed = userMembership.creditsUsed - refundAmount;
        final newCredits = userMembership.credits + refundAmount;

        final updatedMembership = Membership(
          membershipId: userMembership.membershipId,
          businessDetails: userMembership.businessDetails,
          offerSnapshot: userMembership.offerSnapshot,
          name: userMembership.name,
          credits: newCredits,
          creditsUsed: newTotalCreditsUsed,
          expiration: userMembership.expiration,
          status: userMembership.status,
          createdAt: userMembership.createdAt,
        );

        await queryMembershipById(
          uid,
          membershipId,
        ).set(updatedMembership.toFirestore());

        return true;
      } else {
        print('no credits to refund');
        return false;
      }
    }
    return false;
  }
}

final membershipsRepositoryProvider = Provider((Ref ref) {
  return FirebaseMembershipsRepository(FirebaseFirestore.instance);
});
