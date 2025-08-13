import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_boilerplate/src/feature/authentication/application/firebase_auth_service.dart';
import 'package:flutter_riverpod_boilerplate/src/feature/authentication/presentation/sign_in_form.dart';
import 'package:flutter_riverpod_boilerplate/src/routing/business/business_router.dart';
import 'package:go_router/go_router.dart';

class AuthGate extends ConsumerWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);

    return authState.when(
      data: (user) {
        if (user != null) {
          // User is signed in, navigate to the schedules page
          WidgetsBinding.instance.addPostFrameCallback((_) {
            context.goNamed(AppRoute.schedule.name);
          });
          return const SizedBox.shrink(); // or a loading indicator
        } else {
          // User is not signed in, show the login form
          return Scaffold(body: SignInForm());
        }
      },
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (_, __) =>
          const Scaffold(body: Center(child: Text('An error occurred'))),
    );
  }
}
