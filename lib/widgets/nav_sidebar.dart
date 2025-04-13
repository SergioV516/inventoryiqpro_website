import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NavigationSidebar extends StatelessWidget {
  final int selectedIndex;

  const NavigationSidebar({Key? key, required this.selectedIndex})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return NavigationRail(
      backgroundColor: const Color(0xFF1E2A3A),
      selectedIndex: selectedIndex,
      extended: true,
      minExtendedWidth: 210,
      labelType: NavigationRailLabelType.none,
      destinations: [
        NavigationRailDestination(
          icon: const Icon(Icons.dashboard, color: Colors.white54),
          selectedIcon: const Icon(Icons.dashboard, color: Colors.white),
          label: const Text('Dashboard', style: TextStyle(color: Colors.white)),
        ),
        NavigationRailDestination(
          icon: const Icon(Icons.people, color: Colors.white54),
          selectedIcon: const Icon(Icons.people, color: Colors.white),
          label: const Text(
            'Policy Holders',
            style: TextStyle(color: Colors.white),
          ),
        ),
        NavigationRailDestination(
          icon: const Icon(Icons.receipt_long, color: Colors.white54),
          selectedIcon: const Icon(Icons.receipt_long, color: Colors.white),
          label: const Text('Claims', style: TextStyle(color: Colors.white)),
        ),
        NavigationRailDestination(
          icon: const Icon(Icons.payments, color: Colors.white54),
          selectedIcon: const Icon(Icons.payments, color: Colors.white),
          label: const Text('Payments', style: TextStyle(color: Colors.white)),
        ),
        NavigationRailDestination(
          icon: const Icon(Icons.settings, color: Colors.white54),
          selectedIcon: const Icon(Icons.settings, color: Colors.white),
          label: const Text('Settings', style: TextStyle(color: Colors.white)),
        ),
      ],
      onDestinationSelected: (index) {
        switch (index) {
          case 0:
            context.go('/dashboard');
            break;
          case 1:
            context.go('/policy-holders');
            break;
          case 2:
            context.go('/claims');
            break;
          case 3:
            context.go('/payments');
            break;
          case 4:
            context.go('/settings');
            break;
        }
      },
    );
  }
}
