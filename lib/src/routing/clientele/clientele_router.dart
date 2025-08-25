import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_boilerplate/src/common/global_loading_indicator.dart';
import 'package:flutter_riverpod_boilerplate/src/feature/authentication/application/firebase_auth_service.dart';
import 'package:flutter_riverpod_boilerplate/src/feature/authentication/domain/app_user.dart';
import 'package:flutter_riverpod_boilerplate/src/feature/clientele/membership/presentation/memberships_screen.dart';
import 'package:flutter_riverpod_boilerplate/src/feature/clientele/scheduling/presentation/bookings_screen.dart';
import 'package:flutter_riverpod_boilerplate/src/feature/clientele/scheduling/presentation/block_detail/block_detail_screen.dart';
import 'package:flutter_riverpod_boilerplate/src/feature/clientele/scheduling/presentation/block_list/business_blocks_list_screen.dart';
import 'package:flutter_riverpod_boilerplate/src/routing/app_navigation_widget.dart';

import 'package:go_router/go_router.dart';

final _rootClienteleNavigatorKey = GlobalKey<NavigatorState>();
final _shellClienteleBookingsKey = GlobalKey<NavigatorState>(
  debugLabel: 'shellClienteleBookings',
);
final _shellClienteleMembershipKey = GlobalKey<NavigatorState>(
  debugLabel: 'shellClienteleMembership',
);
final _shellClienteleProfileKey = GlobalKey<NavigatorState>(
  debugLabel: 'shellClienteleProfile',
);

enum ClienteleRoute {
  signIn,
  clienteleBookings,
  tenantCalendar,
  clienteleMemberships,
  clienteleProfile,
  bookingDetail,
  block,
}

final clienteleRoutes = [
  StatefulShellRoute.indexedStack(
    pageBuilder: (context, state, navigationShell) {
      return NoTransitionPage(
        child: GlobalLoadingIndicator(
          child: AppNavigationWidget(navigationShell: navigationShell),
        ),
      );
    },
    branches: [
      StatefulShellBranch(
        navigatorKey: _shellClienteleBookingsKey,
        routes: [
          GoRoute(
            path: '/bookings',
            name: ClienteleRoute.clienteleBookings.name,
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: BookingsScreen()),
            routes: [
              GoRoute(
                path: 'business/:businessId',
                name: ClienteleRoute.tenantCalendar.name,
                pageBuilder: (context, state) {
                  final businessId = state.pathParameters['businessId'];
                  return NoTransitionPage(
                    child: BusinessBlocksList(businessId: businessId!),
                  );
                },
                routes: [
                  GoRoute(
                    path: 'block/:blockId',
                    name: ClienteleRoute.block.name,
                    pageBuilder: (context, state) {
                      final blockId = state.pathParameters['blockId'];
                      final businessId = state.pathParameters['businessId'];
                      return NoTransitionPage(
                        child: BlockDetail(
                          blockId: blockId!,
                          businessId: businessId,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
      StatefulShellBranch(
        navigatorKey: _shellClienteleMembershipKey,
        routes: [
          GoRoute(
            path: '/memberships',
            name: ClienteleRoute.clienteleMemberships.name,
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: MembershipsScreen()),
          ),
        ],
      ),
      StatefulShellBranch(
        navigatorKey: _shellClienteleProfileKey,
        routes: [
          GoRoute(
            path: '/profile',
            name: ClienteleRoute.clienteleProfile.name,
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: Placeholder()),
          ),
        ],
      ),
    ],
  ),
];

final goRouterClienteleProvider = Provider((ref) {
  final authState = ref.watch(currentAppUserProvider);

  return GoRouter(
    initialLocation: '/bookings',
    navigatorKey: _rootClienteleNavigatorKey,
    debugLogDiagnostics: true,
    redirect: (context, state) {
      final user = authState.value;
      if (user == null || !user.hasRole(UserRoleType.customer)) {
        return '/sign-in';
      }
      return null;
    },
    routes: clienteleRoutes,
    errorBuilder: (context, state) => Scaffold(
      appBar: AppBar(title: const Text('Error')),
      body: Center(
        child: Text('Clientele Error: Page not found - ${state.uri}'),
      ),
    ),
  );
});
