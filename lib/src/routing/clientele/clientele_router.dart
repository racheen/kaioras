import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_boilerplate/src/constants/fake_user_role.dart';
import 'package:flutter_riverpod_boilerplate/src/constants/user_roles.dart';
import 'package:flutter_riverpod_boilerplate/src/feature/authentication/presentation/auth_gate.dart';
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
  GoRoute(
    path: '/sign-in',
    name: ClienteleRoute.signIn.name,
    pageBuilder: (context, state) => const NoTransitionPage(child: AuthGate()),
  ),
  StatefulShellRoute.indexedStack(
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
                    child: BusinessBlocksList(businessId: businessId),
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
              GoRoute(
                path: 'block/:blockId',
                name: ClienteleRoute.bookingDetail.name,
                pageBuilder: (context, state) {
                  final blockId = state.pathParameters['blockId'];
                  return NoTransitionPage(
                    child: BlockDetail(blockId: blockId!),
                  );
                },
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

final clienteleRedirect = (BuildContext context, GoRouterState state) {
  final path = state.uri.path;
  if (path == '/') {
    return '/bookings';
  }
  return null;
};

final goRouterClienteleProvider = Provider((ref) {
  return GoRouter(
    initialLocation: '/bookings',
    navigatorKey: _rootClienteleNavigatorKey,
    debugLogDiagnostics: false,
    redirect: (context, state) {
      final path = state.uri.path;
      final userRole = FakeUserRole.tenant;
      if (path.startsWith('/profile') ||
          path.startsWith('/schedule') && userRole == UserRoles.clientele) {
        return '/bookings';
      }
      // check loggedIn state here then redirect to proper path
      return clienteleRedirect(context, state);
    },
    routes: clienteleRoutes,
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
                  context.goNamed(ClienteleRoute.clienteleBookings.name);
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
