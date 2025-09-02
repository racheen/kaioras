import 'package:flutter/material.dart';
import 'package:flutter_riverpod_boilerplate/src/routing/app_navigation_widget.dart';

class ClienteleNavigationBar extends StatelessWidget {
  const ClienteleNavigationBar({
    super.key,
    required this.body,
    required this.selectedIndex,
    required this.onDestinationSelected,
  });

  final Widget body;
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: body,
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        destinations: const [
          NavigationDestination(
            label: ClienteleNavigationLabel.bookings,
            icon: Icon(Icons.home, color: Colors.white70),
          ),
          NavigationDestination(
            label: ClienteleNavigationLabel.offers,
            icon: Icon(Icons.store, color: Colors.white70),
          ),
          NavigationDestination(
            label: ClienteleNavigationLabel.memberships,
            icon: Icon(Icons.card_membership, color: Colors.white70),
          ),
          NavigationDestination(
            label: ClienteleNavigationLabel.profile,
            icon: Icon(Icons.person, color: Colors.white70),
          ),
        ],
        onDestinationSelected: onDestinationSelected,
      ),
    );
  }
}
