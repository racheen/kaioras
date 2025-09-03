import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../constants/mock_data2.dart';
import '../domain/app_business.dart';

class FakeBusinessRepository {
  final Map<String, AppBusiness> _businesses = Map.from(mockBusinesses);

  Future<AppBusiness> fetchBusiness(String businessId) async {
    // Simulate network delay
    await Future.delayed(Duration(seconds: 1));
    if (_businesses.containsKey(businessId)) {
      return _businesses[businessId]!;
    } else {
      throw Exception('Business not found');
    }
  }

  Future<void> updateBusiness(AppBusiness updatedBusiness) async {
    // Simulate network delay
    await Future.delayed(Duration(seconds: 1));
    if (_businesses.containsKey(updatedBusiness.businessId)) {
      _businesses[updatedBusiness.businessId] = updatedBusiness;
    } else {
      throw Exception('Business not found');
    }
  }
}

final businessRepositoryProvider = Provider<FakeBusinessRepository>((ref) {
  return FakeBusinessRepository();
});

final businessProvider = FutureProvider.family<AppBusiness, String>((
  ref,
  businessId,
) async {
  final repository = ref.watch(businessRepositoryProvider);
  return repository.fetchBusiness(businessId);
});
