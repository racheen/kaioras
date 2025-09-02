import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_boilerplate/src/common/global_loading_indicator.dart';
import 'package:flutter_riverpod_boilerplate/src/feature/authentication/application/firebase_auth_service.dart';
import 'package:flutter_riverpod_boilerplate/src/feature/authentication/data/firebase_auth_repository.dart';
import 'package:flutter_riverpod_boilerplate/src/feature/authentication/domain/app_user.dart';
import 'package:flutter_riverpod_boilerplate/src/feature/authentication/presentation/auth_gate.dart';
import 'package:flutter_riverpod_boilerplate/src/feature/authentication/presentation/role_selection_screen.dart';
import 'package:flutter_riverpod_boilerplate/src/feature/authentication/presentation/user_sign_up.dart';
import 'package:flutter_riverpod_boilerplate/src/feature/clientele/membership/presentation/checkout_screen.dart';
import 'package:flutter_riverpod_boilerplate/src/feature/clientele/membership/presentation/memberships_screen.dart';
import 'package:flutter_riverpod_boilerplate/src/feature/clientele/membership/presentation/offers_list_screen.dart';
import 'package:flutter_riverpod_boilerplate/src/feature/clientele/scheduling/presentation/block_detail/block_detail_screen.dart';
import 'package:flutter_riverpod_boilerplate/src/feature/clientele/scheduling/presentation/block_list/business_blocks_list_screen.dart';
import 'package:flutter_riverpod_boilerplate/src/feature/clientele/scheduling/presentation/booking_detail/booking_detail_screen.dart';
import 'package:flutter_riverpod_boilerplate/src/feature/clientele/scheduling/presentation/bookings_screen.dart';
import 'package:flutter_riverpod_boilerplate/src/feature/home/data_table.dart';
import 'package:flutter_riverpod_boilerplate/src/feature/tenant/business_profile/presentation/business_profile_page.dart';
import 'package:flutter_riverpod_boilerplate/src/feature/tenant/business_profile/presentation/edit_business_profile_page.dart';
import 'package:flutter_riverpod_boilerplate/src/feature/tenant/scheduling/presentation/schedule_list_page.dart';
import 'package:flutter_riverpod_boilerplate/src/routing/app_navigation_widget.dart';
import 'package:flutter_riverpod_boilerplate/src/routing/business/business_router.dart';
import 'package:flutter_riverpod_boilerplate/src/routing/clientele/clientele_router.dart';
import 'package:flutter_riverpod_boilerplate/src/routing/go_router_refresh_stream.dart';
import 'package:go_router/go_router.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

final _rootClienteleNavigatorKey = GlobalKey<NavigatorState>();
final shellClienteleBookingsKey = GlobalKey<NavigatorState>(
  debugLabel: 'shellClienteleBookings',
);
final _shellClienteleMembershipKey = GlobalKey<NavigatorState>(
  debugLabel: 'shellClienteleMembership',
);
final _shellClienteleOffersKey = GlobalKey<NavigatorState>(
  debugLabel: 'shellClienteleOffers',
);
final _shellClienteleProfileKey = GlobalKey<NavigatorState>(
  debugLabel: 'shellClienteleProfile',
);

final _shellNavigatorBusinessProfileKey = GlobalKey<NavigatorState>(
  debugLabel: 'shellBusinessProfile',
);
final _shellNavigatorScheduleKey = GlobalKey<NavigatorState>(
  debugLabel: 'shellSchedule',
);
final _shellNavigatorDataTableKey = GlobalKey<NavigatorState>(
  debugLabel: 'shellDataTable',
);

final goRouterProvider = Provider.family<GoRouter, AppUser?>((ref, user) {
  final authRepository = ref.watch(authRepositoryProvider);
  final authService = ref.watch(authServiceProvider);

  return GoRouter(
    initialLocation: '/sign-in',
    navigatorKey: _rootNavigatorKey,
    debugLogDiagnostics: true,
    redirect: (context, state) {
      final path = state.uri.path;
      final isLoggedIn = user != null;

      // final isLoggingIn = state.uri.toString() == '/sign-in';
      // final isSigningUp = state.uri.toString() == '/tenant-sign-up';

      // if (!isLoggedIn && !isLoggingIn && !isSigningUp) {
      //   return '/sign-in';
      // }

      // if (isLoggedIn && (isLoggingIn || isSigningUp)) {
      //   if (user.hasRole(UserRoleType.tenant) &&
      //       user.hasRole(UserRoleType.customer)) {
      //     return '/role-selection';
      //   } else if (user.hasRole(UserRoleType.tenant)) {
      //     return '/tenant/schedule';
      //   } else {
      //     return '/clientele/bookings';
      //   }
      // }

      if (isLoggedIn) {
        final isAdmin = user.hasRole(UserRoleType.tenant);

        if (path.startsWith('/sign-in') && isAdmin) {
          return '/tenant/schedule';
        } else if (path.startsWith('/sign-in') && !isAdmin) {
          return '/clientele/bookings';
        }

        if (path.startsWith('/tenant') && !isAdmin) {
          return '/clientele/bookings';
        }
      } else {
        if (path.startsWith('/clientele') || path.startsWith('/tenant')) {
          return '/sign-in';
        }
      }
      return null;
    },
    refreshListenable: GoRouterRefreshStream(authRepository.authStateChanges()),
    routes: [
      /// Root Routes
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

      /// Clientele Routes
      GoRoute(
        path: '/clientele',
        redirect: (context, state) {
          final path = state.uri.path;
          if (path == '/clientele') {
            return '/clientele/bookings';
          }
          return null;
        },
        pageBuilder: (context, state) =>
            const NoTransitionPage(child: SizedBox()),
        routes: [
          StatefulShellRoute.indexedStack(
            pageBuilder: (context, state, navigationShell) {
              return NoTransitionPage(
                child: GlobalLoadingIndicator(
                  child: AppNavigationWidget(navigationShell: navigationShell),
                ),
              );
            },
            branches: [
              /// Clientele Routes
              StatefulShellBranch(
                navigatorKey: shellClienteleBookingsKey,
                routes: [
                  GoRoute(
                    path: '/bookings',
                    name: ClienteleRoute.clienteleBookings.name,
                    pageBuilder: (context, state) =>
                        const NoTransitionPage(child: BookingsScreen()),
                    routes: [
                      GoRoute(
                        path: '/business/:businessId',
                        name: ClienteleRoute.tenantCalendar.name,
                        pageBuilder: (context, state) {
                          final businessId = state.pathParameters['businessId'];
                          return NoTransitionPage(
                            child: BusinessBlocksList(businessId: businessId!),
                          );
                        },
                        routes: [
                          GoRoute(
                            path: '/block/:blockId',
                            name: ClienteleRoute.block.name,
                            pageBuilder: (context, state) {
                              final blockId = state.pathParameters['blockId'];
                              final businessId =
                                  state.pathParameters['businessId'];
                              return NoTransitionPage(
                                child: BlockDetail(
                                  blockId: blockId!,
                                  businessId: businessId,
                                ),
                              );
                            },
                            routes: [
                              GoRoute(
                                path: '/book',
                                name: ClienteleRoute.bookingDetail.name,
                                pageBuilder: (context, state) {
                                  final blockId =
                                      state.pathParameters['blockId'];
                                  final businessId =
                                      state.pathParameters['businessId'];
                                  return NoTransitionPage(
                                    child: BookingDetailScreen(
                                      blockId: blockId!,
                                      businessId: businessId!,
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                      GoRoute(
                        path: '/block/:blockId',
                        name: ClienteleRoute.blockDetail.name,
                        pageBuilder: (context, state) {
                          final blockId = state.pathParameters['blockId'];
                          if (blockId != null) {
                            return NoTransitionPage(
                              child: BlockDetail(blockId: blockId),
                            );
                          }
                          return NoTransitionPage(child: Text('data'));
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
                navigatorKey: _shellClienteleOffersKey,
                routes: [
                  GoRoute(
                    path: '/offers',
                    name: ClienteleRoute.clienteleOffers.name,
                    pageBuilder: (context, state) =>
                        const NoTransitionPage(child: OffersListScreen()),
                    routes: [
                      GoRoute(
                        path: '/:businessId/checkout',
                        name: ClienteleRoute.checkout.name,
                        pageBuilder: (context, state) {
                          final businessId = state.pathParameters['businessId'];
                          return NoTransitionPage(
                            child: CheckoutScreen(businessId: businessId!),
                          );
                        },
                      ),
                    ],
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
        ],
      ),

      /// Business Routes
      GoRoute(
        path: '/tenant',
        redirect: (context, state) {
          final path = state.uri.path;
          if (path == '/tenant') {
            return '/tenant/schedule';
          }
          return null;
        },
        pageBuilder: (context, state) =>
            const NoTransitionPage(child: SizedBox()),
        routes: [
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
                        pageBuilder: (context, state) => const NoTransitionPage(
                          child: EditBusinessProfilePage(),
                        ),
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
        ],
      ),
    ],
    errorBuilder: (context, state) =>
        Scaffold(body: Center(child: Text('Page not found - ${state.uri}'))),
  );
});
