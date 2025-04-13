import 'package:flutter/material.dart';
import 'package:inventory_iq_pro/screens/analytics_page.dart';
import 'package:inventory_iq_pro/screens/policy_holders.dart';
import 'package:inventory_iq_pro/screens/settings_page.dart';
import 'package:inventory_iq_pro/screens/claims_management_page.dart'; // New import
import 'screens/dashboard.dart';
import 'screens/claim_detail.dart';

void main() {
  runApp(const InventoryIQApp());
}

class InventoryIQApp extends StatelessWidget {
  const InventoryIQApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'InventoryIQ Pro',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF1E2A3A),
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1E2A3A),
          foregroundColor: Colors.white,
        ),
      ),
      home: const MainNavigationWrapper(),
    );
  }
}

class MainNavigationWrapper extends StatefulWidget {
  const MainNavigationWrapper({Key? key}) : super(key: key);

  @override
  _MainNavigationWrapperState createState() => _MainNavigationWrapperState();
}

class _MainNavigationWrapperState extends State<MainNavigationWrapper> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const DashboardScreen(),
    const PolicyHolderPage(),
    const ClaimsManagementPage(), // Replace Placeholder with actual ClaimsManagementPage
    const AnalyticsPage(),
    const SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Navigation sidebar
          Container(
            width: 240,
            color: const Color(0xFF1E2A3A),
            child: Column(
              children: [
                const SizedBox(height: 24),
                _buildNavItem(0, Icons.dashboard, 'Dashboard'),
                _buildNavItem(1, Icons.people, 'Policy Holders'),
                _buildNavItem(2, Icons.receipt_long, 'Claims'),
                _buildNavItem(3, Icons.analytics, 'Analytics'),
                _buildNavItem(4, Icons.settings, 'Settings'),
              ],
            ),
          ),

          // Main content
          Expanded(child: _screens[_selectedIndex]),
        ],
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String title) {
    final isSelected = index == _selectedIndex;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        leading: Icon(
          icon,
          color: isSelected ? Colors.white : Colors.white.withOpacity(0.6),
        ),
        title: Text(
          title,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.white.withOpacity(0.6),
          ),
        ),
        selected: isSelected,
        onTap: () {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}
