import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_boilerplate/src/feature/authentication/presentation/privilege_controller.dart';
import 'package:flutter_riverpod_boilerplate/src/routing/app_navigation_widget.dart';

class ClienteleNavigationRail extends ConsumerStatefulWidget {
  const ClienteleNavigationRail({
    super.key,
    required this.body,
    required this.selectedIndex,
    required this.onDestinationSelected,
  });
  final Widget body;
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;

  @override
  ConsumerState<ClienteleNavigationRail> createState() =>
      _ScaffoldWithNavigationRailState();
}

class _ScaffoldWithNavigationRailState
    extends ConsumerState<ClienteleNavigationRail> {
  bool isExtended = false;

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
                label: Text(ClienteleNavigationLabel.bookings),
                icon: Icon(Icons.home, color: Colors.white70),
              ),
              NavigationRailDestination(
                label: Text(ClienteleNavigationLabel.memberships),
                icon: Icon(Icons.card_membership, color: Colors.white70),
              ),
              NavigationRailDestination(
                label: Text(ClienteleNavigationLabel.profile),
                icon: Icon(Icons.person, color: Colors.white70),
              ),
            ],
            trailing: Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: FloatingActionButton(
                    onPressed: () {
                      ref
                          .read(privilegeControllerProvider.notifier)
                          .togglePrivilage();
                    },
                    child: const Icon(Icons.work),
                  ),
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
