import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthService {
  Future<void> signUpTenant(
    Map<String, dynamic> userData,
    Map<String, dynamic> businessData,
  ) async {
    // TODO: Implement actual Firebase authentication and Firestore document creation

    final String userId = 'user0004';
    final String businessId = 'business0002';

    // Simulate creating a user document
    final userDoc = {
      'uid': userId,
      'email': userData['email'],
      'name': userData['name'],
      'createdAt': DateTime.now().toIso8601String(),
      'profilePic': '', // You might want to add this field to your form
      'lastBusinessId': businessId,
      'platformRole': null,
      'notifications': false,
      'roles': {
        businessId: {
          'role': 'tenant',
          'status': 'active',
          'createdAt': DateTime.now().toIso8601String(),
        },
      },
    };

    // Simulate creating a business document
    final businessDoc = {
      'businessId': businessId,
      'name': businessData['businessName'],
      'ownerUid': userId,
      'createdAt': DateTime.now().toIso8601String(),
      'industry': businessData['industry'],
      'branding': {
        'primaryColor': businessData['primaryColor'],
        'logoUrl': businessData['logoUrl'],
      },
      'plan': 'pro', // You might want to add a plan selection to your form
      'stripeAccountId': '', // This would typically be set up separately
      'roles': {
        userId: {
          'uid': userId,
          'role': 'tenant',
          'status': 'active',
          'createdAt': DateTime.now().toIso8601String(),
          'displayName': userData['name'],
        },
      },
      'settings': {
        'availability': {
          'defaultHours': [
            {'day': 'monday', 'start': '08:00', 'end': '18:00'},
            {'day': 'tuesday', 'start': '08:00', 'end': '18:00'},
            {'day': 'wednesday', 'start': '08:00', 'end': '18:00'},
            {'day': 'thursday', 'start': '08:00', 'end': '18:00'},
            {'day': 'friday', 'start': '08:00', 'end': '18:00'},
          ],
          'timeZone': 'America/New_York',
        },
        'holidays': [],
        'closedDays': ['sunday', 'saturday'],
      },
    };

    // Here you would typically use Firebase to create these documents
    print('Creating user document: $userDoc');
    print('Creating business document: $businessDoc');

    // Simulate a delay
    await Future.delayed(Duration(seconds: 2));

    // TODO: Implement error handling
  }
}

final authServiceProvider = Provider<AuthService>((ref) => AuthService());
