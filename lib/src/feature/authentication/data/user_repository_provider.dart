import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_boilerplate/src/feature/authentication/data/mock_user_repository.dart';
import 'package:flutter_riverpod_boilerplate/src/feature/authentication/data/user_repository_base.dart';
import 'package:flutter_riverpod_boilerplate/src/feature/authentication/domain/app_user.dart';

final userRepositoryProvider = Provider<UserRepositoryBase>((ref) {
  return UserRepository();
});

final currentAppUserProvider = FutureProvider<AppUser?>((ref) async {
  final userRepository = ref.watch(userRepositoryProvider);
  return userRepository.getCurrentUser();
});
