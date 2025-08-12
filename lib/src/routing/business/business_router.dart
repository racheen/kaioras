import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_boilerplate/src/constants/fake_user_role.dart';
import 'package:flutter_riverpod_boilerplate/src/constants/user_roles.dart';
import 'package:flutter_riverpod_boilerplate/src/feature/authentication/auth_gate.dart';
import 'package:flutter_riverpod_boilerplate/src/feature/home/data_table.dart';
import 'package:flutter_riverpod_boilerplate/src/feature/home/grid.dart';
import 'package:flutter_riverpod_boilerplate/src/feature/tenant/scheduling/presentation/schedule_list_page.dart';
import 'package:flutter_riverpod_boilerplate/src/routing/app_navigation_widget.dart';
import 'package:flutter_riverpod_boilerplate/src/feature/home/home.dart';
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

enum AppRoute { signIn, home, profile, schedule, dataTable, calendarDetail }

final goRouterBusinessProvider = Provider((ref) {
  return GoRouter(
    initialLocation: '/',
    navigatorKey: _rootNavigatorKey,
    debugLogDiagnostics: false,
    redirect: (context, state) {
      final path = state.uri.path;
      final userRole = FakeUserRole.tenant;
      if (path.startsWith('/clientele') && userRole == UserRoles.tenant) {
        return '/';
      }
      // check loggedIn state here then redirect to proper path
      return null;
    },
    routes: [
      GoRoute(
        path: '/signIn',
        name: AppRoute.signIn.name,
        pageBuilder: (context, state) =>
            const NoTransitionPage(child: AuthGate()),
      ),
      StatefulShellRoute.indexedStack(
        pageBuilder: (context, state, navigationShell) => NoTransitionPage(
          child: AppNavigationWidget(navigationShell: navigationShell),
        ),
        branches: [
          StatefulShellBranch(
            navigatorKey: _shellNavigatorHomeKey,
            routes: [
              GoRoute(
                path: '/',
                name: AppRoute.home.name,
                pageBuilder: (context, state) =>
                    const NoTransitionPage(child: Home()),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _shellNavigatorProfileKey,
            routes: [
              GoRoute(
                path: '/profile',
                name: AppRoute.profile.name,
                pageBuilder: (context, state) =>
                    const NoTransitionPage(child: GridWidget()),
              ),
            ],
          ),
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
    ],
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
