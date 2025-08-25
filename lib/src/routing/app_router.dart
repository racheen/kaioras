import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_boilerplate/src/feature/authentication/application/firebase_auth_service.dart';
import 'package:flutter_riverpod_boilerplate/src/feature/authentication/domain/app_user.dart';
import 'package:flutter_riverpod_boilerplate/src/feature/authentication/presentation/auth_gate.dart';
import 'package:flutter_riverpod_boilerplate/src/feature/authentication/presentation/user_sign_up.dart';
import 'package:flutter_riverpod_boilerplate/src/routing/business/business_router.dart';
import 'package:flutter_riverpod_boilerplate/src/routing/clientele/clientele_router.dart';
import 'package:go_router/go_router.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

final goRouterProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(currentAppUserProvider);

  return GoRouter(
    initialLocation: '/sign-in',
    navigatorKey: _rootNavigatorKey,
    debugLogDiagnostics: false,
    redirect: (context, state) {
      final userAsync = ref.watch(currentAppUserProvider);

      return userAsync.when(
        data: (user) {
          print(
            'Redirect: User state - ${user != null ? 'Authenticated' : 'Not authenticated'}',
          );

          final isLoggedIn = user != null;
          final isLoggingIn = state.uri.toString() == '/sign-in';
          final isSigningUp = state.uri.toString() == '/tenant-sign-up';

          if (!isLoggedIn && !isLoggingIn && !isSigningUp) {
            return '/sign-in';
          }

          if (isLoggedIn && (isLoggingIn || isSigningUp)) {
            if (user.hasRole(UserRoleType.tenant) &&
                user.hasRole(UserRoleType.customer)) {
              return '/role-selection';
            } else if (user.hasRole(UserRoleType.tenant)) {
              return '/tenant/schedule';
            } else if (user.hasRole(UserRoleType.customer)) {
              return '/clientele/bookings';
            }
          }

          return null;
        },
        loading: () => '/loading', // You might want to create a loading screen
        error: (_, __) => '/error', // You might want to create an error screen
      );
    },
    routes: [
      GoRoute(
        path: '/sign-in',
        name: AppRoute.signIn.name,
        pageBuilder: (context, state) =>
            const NoTransitionPage(child: AuthGate()),
      ),
      GoRoute(
        path: '/tenant-sign-up',
        name: AppRoute.tenantSignUp.name,
        pageBuilder: (context, state) =>
            const NoTransitionPage(child: UserSignUp()),
      ),
      GoRoute(
        path: '/role-selection',
        pageBuilder: (context, state) =>
            const NoTransitionPage(child: RoleSelectionScreen()),
      ),
      ShellRoute(
        builder: (context, state, child) {
          return MaterialApp(home: child);
        },
        routes: [
          GoRoute(
            path: '/clientele',
            builder: (context, state) => const SizedBox(),
            routes: clienteleRoutes,
          ),
          GoRoute(
            path: '/tenant',
            builder: (context, state) => const SizedBox(),
            routes: businessRoutes,
          ),
        ],
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      appBar: AppBar(title: const Text('Error')),
      body: Center(child: Text('Main Error: Page not found - ${state.uri}')),
    ),
  );
});

class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Select Role')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => context.go('/tenant/schedule'),
              child: Text('Continue as Tenant'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => context.go('/clientele/bookings'),
              child: Text('Continue as Client'),
            ),
          ],
        ),
      ),
    );
  }
}
