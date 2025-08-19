import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_boilerplate/src/constants/fake_user_role.dart';
import 'package:flutter_riverpod_boilerplate/src/constants/user_roles.dart';
import 'package:flutter_riverpod_boilerplate/src/feature/authentication/application/firebase_auth_service.dart';
import 'package:flutter_riverpod_boilerplate/src/feature/authentication/presentation/auth_gate.dart';
import 'package:flutter_riverpod_boilerplate/src/feature/authentication/presentation/tenant_sign_up.dart';
import 'package:flutter_riverpod_boilerplate/src/feature/home/data_table.dart';
import 'package:flutter_riverpod_boilerplate/src/feature/home/grid.dart';
import 'package:flutter_riverpod_boilerplate/src/feature/tenant/business_profile/presentation/business_profile_page.dart';
import 'package:flutter_riverpod_boilerplate/src/feature/tenant/business_profile/presentation/edit_business_profile_page.dart';
import 'package:flutter_riverpod_boilerplate/src/feature/tenant/scheduling/presentation/schedule_list_page.dart';
import 'package:flutter_riverpod_boilerplate/src/routing/app_navigation_widget.dart';
import 'package:go_router/go_router.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorHomeKey = GlobalKey<NavigatorState>(
  debugLabel: 'shellHome',
);
final _shellNavigatorProfileKey = GlobalKey<NavigatorState>(
  debugLabel: 'shellProfile',
);
final _shellNavigatorDataTableKey = GlobalKey<NavigatorState>(
  debugLabel: 'shellDataTable',
);
final _shellNavigatorScheduleKey = GlobalKey<NavigatorState>(
  debugLabel: 'shellSchedule',
);
final _shellNavigatorBusinessProfileKey = GlobalKey<NavigatorState>(
  debugLabel: 'shellBusinessProfile',
);

enum AppRoute {
  signIn,
  tenantSignUp,
  home,
  profile,
  businessProfile,
  schedule,
  dataTable,
  calendarDetail,
}

final businessRoutes = [
  GoRoute(
    path: '/sign-in',
    name: AppRoute.signIn.name,
    pageBuilder: (context, state) => const NoTransitionPage(child: AuthGate()),
  ),
  GoRoute(
    path: '/tenant-sign-up',
    name: AppRoute.tenantSignUp.name,
    pageBuilder: (context, state) =>
        const NoTransitionPage(child: TenantSignUp()),
  ),
  StatefulShellRoute.indexedStack(
    branches: [
      // StatefulShellBranch(
      //   navigatorKey: _shellNavigatorHomeKey,
      //   routes: [
      //     GoRoute(
      //       path: '/',
      //       name: AppRoute.home.name,
      //       pageBuilder: (context, state) =>
      //           const NoTransitionPage(child: AuthGate()),
      //     ),
      //   ],
      // ),
      // StatefulShellBranch(
      //   navigatorKey: _shellNavigatorBusinessProfileKey,
      //   routes: [
      //     GoRoute(
      //       path: '/business-profile',
      //       name: AppRoute.businessProfile.name,
      //       pageBuilder: (context, state) =>
      //           const NoTransitionPage(child: BusinessProfilePage()),
      //       routes: [
      //         GoRoute(
      //           path: 'edit',
      //           pageBuilder: (context, state) =>
      //               const NoTransitionPage(child: EditBusinessProfilePage()),
      //         ),
      //       ],
      //     ),
      //   ],
      // ),
      // StatefulShellBranch(
      //   navigatorKey: _shellNavigatorProfileKey,
      //   routes: [
      //     GoRoute(
      //       path: '/profile',
      //       name: AppRoute.profile.name,
      //       pageBuilder: (context, state) =>
      //           const NoTransitionPage(child: GridWidget()),
      //     ),
      //   ],
      // ),
      StatefulShellBranch(
        navigatorKey: _shellNavigatorScheduleKey,
        routes: [
          GoRoute(
            path: '/schedule',
            name: AppRoute.schedule.name,
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: ScheduleListPage()),
          ),
        ],
      ),
      StatefulShellBranch(
        navigatorKey: _shellNavigatorDataTableKey,
        routes: [
          GoRoute(
            path: '/dataTable',
            name: AppRoute.dataTable.name,
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: MyDataTable()),
          ),
        ],
      ),
    ],
  ),
];

final goRouterBusinessProvider = Provider((ref) {
  final authState = ref.watch(authStateProvider);

  return GoRouter(
    initialLocation: '/',
    navigatorKey: _rootNavigatorKey,
    debugLogDiagnostics: false,
    redirect: (context, state) {
      final path = state.uri.path;
      final userRole = FakeUserRole.tenant;
      final isLoggedIn = authState.value != null;
      final isLoggingIn = state.uri.toString() == '/sign-in';
      final isSigningUp = state.uri.toString() == '/tenant-sign-up';

      if (!isLoggedIn && !isLoggingIn && !isSigningUp) {
        return '/sign-in';
      }

      if (isLoggedIn && isLoggingIn) {
        return '/schedule';
      }

      if (path.startsWith('/clientele') && userRole == UserRoles.tenant) {
        return '/';
      }
      // check loggedIn state here then redirect to proper path
      return null;
    },
    routes: businessRoutes,
    errorPageBuilder: (context, state) => NoTransitionPage(
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Page Not Found',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              TextButton(
                onPressed: () {
                  context.goNamed(AppRoute.home.name);
                },
                child: const Text('Back to home'),
              ),
            ],
          ),
        ),
      ),
    ),
  );
});
