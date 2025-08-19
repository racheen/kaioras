import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_boilerplate/src/feature/authentication/application/firebase_auth_service.dart';
import 'package:flutter_riverpod_boilerplate/src/feature/authentication/application/privilege_controller.dart';
import 'package:flutter_riverpod_boilerplate/src/routing/app_navigation_widget.dart';
import 'package:go_router/go_router.dart';

class BusinessNavigationRail extends ConsumerStatefulWidget {
  const BusinessNavigationRail({
    super.key,
    required this.body,
    required this.selectedIndex,
    required this.onDestinationSelected,
  });
  final Widget body;
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;

  @override
  ConsumerState<BusinessNavigationRail> createState() =>
      _BusinessNavigationRailState();
}

class _BusinessNavigationRailState
    extends ConsumerState<BusinessNavigationRail> {
  bool isExtended = false;

  void _handleLogout() async {
    try {
      await ref.read(authServiceProvider).signOut();
      context.goNamed('sign-in');
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error signing out: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size.width;
    final isMobile = screenSize < 600;

    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            indicatorShape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            selectedIndex: widget.selectedIndex,
            onDestinationSelected: widget.onDestinationSelected,
            labelType: NavigationRailLabelType.none,
            extended: isExtended,
            leading: IconButton(
              onPressed: () {
                setState(() {
                  isExtended = !isExtended;
                });
              },
              icon: Icon(
                isExtended ? Icons.menu_open_rounded : Icons.menu,
                color: Colors.white70,
              ),
            ),
            destinations: const <NavigationRailDestination>[
              NavigationRailDestination(
                label: Text(NavigationLabel.home),
                icon: Icon(Icons.home, color: Colors.white70),
              ),
              NavigationRailDestination(
                label: Text(NavigationLabel.profile),
                icon: Icon(Icons.person, color: Colors.white70),
              ),
              NavigationRailDestination(
                label: Text(NavigationLabel.calendar),
                icon: Icon(Icons.calendar_month, color: Colors.white70),
              ),
              NavigationRailDestination(
                label: Text(NavigationLabel.dataTable),
                icon: Icon(Icons.storage, color: Colors.white70),
              ),
              NavigationRailDestination(
                label: Text(NavigationLabel.businessProfile),
                icon: Icon(Icons.business, color: Colors.white70),
              ),
            ],
            trailing: Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.logout, color: Colors.white70),
                      onPressed: _handleLogout,
                      tooltip: 'Logout',
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: FloatingActionButton(
                        onPressed: () {
                          ref
                              .read(privilegeControllerProvider.notifier)
                              .togglePrivilege();
                        },
                        child: const Icon(Icons.public),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const VerticalDivider(thickness: 1, width: 1),
          Expanded(child: widget.body),
        ],
      ),
    );
  }
}
