import 'package:flutter_riverpod_boilerplate/src/feature/tenant/business_profile/domain/app_business.dart';
import 'package:flutter_riverpod_boilerplate/src/feature/tenant/scheduling/domain/availability.dart';

abstract class BusinessRepositoryBase {
  Future<AppBusiness> updateBusiness(AppBusiness business);
  Future<AppBusiness> getBusinessById(String id);
  Future<Availability> getBusinessAvailability(String businessId);
}
