import 'package:flutter_riverpod_boilerplate/src/feature/authentication/domain/app_user.dart';

abstract class UserRepositoryBase {
  Future<AppUser?> getCurrentUser();
}
