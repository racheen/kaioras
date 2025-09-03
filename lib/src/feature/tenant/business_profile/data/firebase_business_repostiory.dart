import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_boilerplate/src/feature/authentication/domain/app_business.dart'
    hide AppBusiness;
import 'package:flutter_riverpod_boilerplate/src/feature/tenant/business_profile/data/business_repository_base.dart';
import 'package:flutter_riverpod_boilerplate/src/feature/tenant/business_profile/domain/app_business.dart';
import 'package:flutter_riverpod_boilerplate/src/feature/tenant/scheduling/domain/availability.dart';

class BusinessRepository implements BusinessRepositoryBase {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  AppBusiness? _appBusiness;

  String? getCurrentBusinessId() {
    return _appBusiness?.businessId;
  }

  @override
  Future<Availability> getBusinessAvailability(String businessId) async {
    try {
      if (_appBusiness == null || _appBusiness!.businessId != businessId) {
        await getBusinessById(businessId);
      }
      return _appBusiness!.meta.settings!.availability;
    } catch (e) {
      print('Failed to retrieve business availability: $e');
      return _getDefaultAvailability();
    }
  }

  Availability _getDefaultAvailability() {
    // Define a default availability
    return Availability(
      weekdayHours: {
        'Monday': TimeRange(
          start: TimeOfDay(hour: 9, minute: 0),
          end: TimeOfDay(hour: 17, minute: 0),
        ),
        'Tuesday': TimeRange(
          start: TimeOfDay(hour: 9, minute: 0),
          end: TimeOfDay(hour: 17, minute: 0),
        ),
        'Wednesday': TimeRange(
          start: TimeOfDay(hour: 9, minute: 0),
          end: TimeOfDay(hour: 17, minute: 0),
        ),
        'Thursday': TimeRange(
          start: TimeOfDay(hour: 9, minute: 0),
          end: TimeOfDay(hour: 17, minute: 0),
        ),
        'Friday': TimeRange(
          start: TimeOfDay(hour: 9, minute: 0),
          end: TimeOfDay(hour: 17, minute: 0),
        ),
      },
      blackoutDates: [],
      timeZone: 'America/New_York',
      closedDays: ['Saturday', 'Sunday'],
    );
  }

  @override
  Future<AppBusiness> getBusinessById(String id) async {
    try {
      final DocumentSnapshot businessDoc = await _firestore
          .collection('businesses')
          .doc(id)
          .get();

      if (businessDoc.exists) {
        _appBusiness = AppBusiness.fromMap(
          businessDoc.data() as Map<String, dynamic>,
        );
        return _appBusiness!;
      } else {
        throw Exception('Business document does not exist');
      }
    } catch (e) {
      print('Failed to retrieve business: $e');
      throw e;
    }
  }

  @override
  Future<AppBusiness> updateBusiness(AppBusiness business) async {
    try {
      await _firestore
          .collection('businesses')
          .doc(business.businessId)
          .update(business.toMap());
      _appBusiness = business;
      return business;
    } catch (e) {
      print('Failed to update business: $e');
      throw e;
    }
  }
}

final businessRepositoryProvider = Provider<BusinessRepository>((ref) {
  return BusinessRepository();
});

final businessAvailabilityProvider =
    FutureProvider.family<Availability?, String>((ref, businessId) async {
      final businessRepository = ref.watch(businessRepositoryProvider);
      print("Fetching availability for business: $businessId");

      print("Current Business ID: $businessId"); // Add this line
      if (businessId == null) {
        print('No current business ID available');
        return null;
      }
      try {
        final availability = await businessRepository.getBusinessAvailability(
          businessId,
        );
        print("Fetched Availability: $availability"); // Add this line
        return availability;
      } catch (e) {
        print('Error fetching business availability: $e');
        return null;
      }
    });
