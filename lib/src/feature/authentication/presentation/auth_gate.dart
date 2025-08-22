import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_boilerplate/src/feature/authentication/data/user_repository_provider.dart';
import 'package:flutter_riverpod_boilerplate/src/feature/authentication/domain/app_user.dart';
import 'package:flutter_riverpod_boilerplate/src/feature/authentication/presentation/sign_in_form.dart';
import 'package:flutter_riverpod_boilerplate/src/routing/app_router.dart';
import 'package:flutter_riverpod_boilerplate/src/routing/business/business_router.dart';
import 'package:flutter_riverpod_boilerplate/src/routing/clientele/clientele_router.dart';
import 'package:go_router/go_router.dart';

class AuthGate extends ConsumerWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appUserAsync = ref.watch(currentAppUserProvider);

    return appUserAsync.when(
      data: (user) {
        if (user != null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            switch (user.getPrimaryRole()) {
              case UserRoleType.tenant:
                context.go('/tenant/schedule');
                break;
              case UserRoleType.customer:
                context.go('/clientele/bookings');
                break;
            }
          });
          return const Scaffold(
            body: Center(child: Text('user was found but error')),
          );
        } else {
          // User is not signed in, show the login form
          return Scaffold(body: SignInForm());
        }
      },
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (error, stackTrace) {
        // Return a Scaffold that displays the error message
        return Scaffold(body: Center(child: Text('An error occurred: $error')));
      },
    );
  }
}
