import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'screens/dashboard.dart';
// Remove the login screen import since we're not using it

final appRouter = GoRouter(
  // Set the initial location to the dashboard
  initialLocation: '/dashboard',
  routes: [
    // Remove the login route entirely
    GoRoute(
      path: '/dashboard',
      builder: (context, state) => const DashboardScreen(),
    ),
    // Add your other routes as needed
    // For example:
    // GoRoute(
    //   path: '/policy-holders',
    //   builder: (context, state) => const PolicyHolderScreen(),
    // ),
    // GoRoute(
    //   path: '/claims',
    //   builder: (context, state) => const ClaimsScreen(),
    // ),
  ],
  errorBuilder:
      (context, state) => Scaffold(
        body: Center(child: Text('Page not found: ${state.uri.toString()}')),
      ),
);
