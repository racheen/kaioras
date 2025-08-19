import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_boilerplate/src/constants/fake_user_role.dart';
import 'package:flutter_riverpod_boilerplate/src/constants/mock_data2.dart';
import 'package:flutter_riverpod_boilerplate/src/constants/user_roles.dart';
import 'package:flutter_riverpod_boilerplate/src/feature/authentication/application/mock_auth_service.dart';
import 'package:flutter_riverpod_boilerplate/src/feature/authentication/domain/app_user.dart';
import 'package:flutter_riverpod_boilerplate/src/feature/authentication/presentation/auth_gate.dart';
import 'package:flutter_riverpod_boilerplate/src/feature/authentication/presentation/tenant_sign_up.dart';
import 'package:flutter_riverpod_boilerplate/src/feature/clientele/membership/presentation/memberships_screen.dart';
import 'package:flutter_riverpod_boilerplate/src/feature/clientele/scheduling/presentation/bookings_screen.dart';
import 'package:flutter_riverpod_boilerplate/src/feature/clientele/scheduling/presentation/block_detail/block_detail_screen.dart';
import 'package:flutter_riverpod_boilerplate/src/feature/clientele/scheduling/presentation/block_list/business_blocks_list_screen.dart';
import 'package:flutter_riverpod_boilerplate/src/feature/home/grid.dart';
import 'package:flutter_riverpod_boilerplate/src/routing/app_navigation_widget.dart';
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
      final user = authState.value;
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
          return '/';
        } else if (user.hasRole(UserRoleType.customer)) {
          return '/';
        }
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/sign-in',
        pageBuilder: (context, state) =>
            const NoTransitionPage(child: AuthGate()),
      ),
      GoRoute(
        path: '/tenant-sign-up',
        pageBuilder: (context, state) =>
            const NoTransitionPage(child: TenantSignUp()),
      ),
      GoRoute(
        path: '/',
        pageBuilder: (context, state) =>
            const NoTransitionPage(child: GridWidget()),
      ),
      ...clienteleRoutes,
      // ...businessRoutes,
    ],
    errorBuilder: (context, state) =>
        Scaffold(body: Center(child: Text('Page not found: ${state.uri}'))),
  );
});
