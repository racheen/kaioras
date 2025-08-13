import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_boilerplate/src/common/async_value_widget.dart';
import 'package:flutter_riverpod_boilerplate/src/constants/fake_user_role.dart';
import 'package:flutter_riverpod_boilerplate/src/constants/user_roles.dart';
import 'package:flutter_riverpod_boilerplate/src/feature/authentication/application/privilege_controller.dart';
import 'package:flutter_riverpod_boilerplate/src/routing/business/business_navigation_bar.dart';
import 'package:flutter_riverpod_boilerplate/src/routing/business/business_navigation_rail.dart';
import 'package:flutter_riverpod_boilerplate/src/routing/clientele/clientele_navigation_bar.dart';
import 'package:flutter_riverpod_boilerplate/src/routing/clientele/clientele_navigation_rail.dart';
import 'package:flutter_riverpod_boilerplate/src/routing/scaffold_with_navigation_bar.dart';
import 'package:flutter_riverpod_boilerplate/src/routing/scaffold_with_navigation_rail.dart';
import 'package:go_router/go_router.dart';

class NavigationLabel {
  static const home = 'Home';
  static const profile = 'Profile';
  static const dataTable = 'Data Table';
  static const calendar = 'Calendar';
  static const businessProfile = 'Business Profile';
}

class ClienteleNavigationLabel {
  static const bookings = 'Bookings';
  static const memberships = 'Memberships';
  static const profile = 'Profile';
}

class AppNavigationWidget extends ConsumerWidget {
  const AppNavigationWidget({Key? key, required this.navigationShell})
    : super(key: key ?? const ValueKey('AppNavigationBar'));
  final StatefulNavigationShell navigationShell;

  void _goBranch(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  Widget _clienteleNavigationWidget(
    BuildContext context,
    BoxConstraints constraints,
  ) {
    if (constraints.maxWidth < 450) {
      return ClienteleNavigationBar(
        body: navigationShell,
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: _goBranch,
      );
    } else {
      return ClienteleNavigationRail(
        body: navigationShell,
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: _goBranch,
      );
    }
  }

  Widget _tenantNavigationWidget(
    BuildContext context,
    BoxConstraints constraints,
  ) {
    if (constraints.maxWidth < 450) {
      return BusinessNavigationBar(
        body: navigationShell,
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: _goBranch,
      );
    } else {
      return BusinessNavigationRail(
        body: navigationShell,
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: _goBranch,
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final hasAdminPrivilege = ref.watch(privilegeControllerProvider);

        if (hasAdminPrivilege) {
          return _tenantNavigationWidget(context, constraints);
        } else {
          return _clienteleNavigationWidget(context, constraints);
        }
      },
    );
  }
}
