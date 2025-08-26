import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_boilerplate/src/feature/home/data_table.dart';
import 'package:flutter_riverpod_boilerplate/src/feature/tenant/business_profile/presentation/business_profile_page.dart';
import 'package:flutter_riverpod_boilerplate/src/feature/tenant/business_profile/presentation/edit_business_profile_page.dart';
import 'package:flutter_riverpod_boilerplate/src/feature/tenant/scheduling/presentation/schedule_list_page.dart';
import 'package:flutter_riverpod_boilerplate/src/routing/app_navigation_widget.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod_boilerplate/src/feature/authentication/application/firebase_auth_service.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorBusinessProfileKey = GlobalKey<NavigatorState>(
  debugLabel: 'shellBusinessProfile',
);
final _shellNavigatorScheduleKey = GlobalKey<NavigatorState>(
  debugLabel: 'shellSchedule',
);
final _shellNavigatorDataTableKey = GlobalKey<NavigatorState>(
  debugLabel: 'shellDataTable',
);

enum AppRoute {
  signIn,
  tenantSignUp,
  home,
  businessProfile,
  schedule,
  dataTable,
  calendarDetail,
}

final businessRoutes = [
  StatefulShellRoute.indexedStack(
    builder: (context, state, navigationShell) {
      return AppNavigationWidget(navigationShell: navigationShell);
    },
    branches: [
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
        navigatorKey: _shellNavigatorBusinessProfileKey,
        routes: [
          GoRoute(
            path: '/business-profile',
            name: AppRoute.businessProfile.name,
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: BusinessProfilePage()),
            routes: [
              GoRoute(
                path: 'edit',
                pageBuilder: (context, state) =>
                    const NoTransitionPage(child: EditBusinessProfilePage()),
              ),
            ],
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
  final authState = ref.watch(currentAppUserProvider);

  return GoRouter(
    initialLocation: '/',
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

      if (isLoggedIn && isLoggingIn) {
        return '/schedule';
      }

      return null;
    },
    routes: businessRoutes,
    errorBuilder: (context, state) => Scaffold(
      appBar: AppBar(title: const Text('Error')),
      body: Center(
        child: Text('Business Error: Page not found - ${state.uri}'),
      ),
    ),
  );
});
