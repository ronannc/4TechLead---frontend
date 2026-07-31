import 'package:flutter/material.dart';

import 'breakpoints.dart';

/// A navigation destination shared between the mobile bottom nav and the
/// desktop side rail, so [AdaptiveScaffold] only needs one list of items.
class AppNavDestination {
  const AppNavDestination({
    required this.label,
    required this.icon,
    required this.path,
  });

  final String label;
  final IconData icon;
  final String path;
}

/// Adaptive navigation chrome: a bottom [NavigationBar] on mobile widths,
/// a [NavigationRail] on desktop widths (macOS/Windows). Wrapped around
/// `child` by a go_router `ShellRoute`, so it persists across route changes.
class AdaptiveScaffold extends StatelessWidget {
  const AdaptiveScaffold({
    super.key,
    required this.child,
    required this.destinations,
    required this.selectedIndex,
    required this.onDestinationSelected,
  });

  final Widget child;
  final List<AppNavDestination> destinations;
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;

  /// [NavigationBar] (and, practically, [NavigationRail]) only make sense
  /// with at least 2 destinations — `NavigationBar` actually asserts on it.
  /// With 0 or 1 destinations, render the nav chrome-less body instead of
  /// crashing.
  bool get _hasNav => destinations.length >= 2;

  @override
  Widget build(BuildContext context) {
    if (Breakpoints.isDesktop(context)) {
      if (!_hasNav) {
        return Scaffold(body: child);
      }

      return Scaffold(
        body: Row(
          children: [
            NavigationRail(
              selectedIndex: selectedIndex,
              onDestinationSelected: onDestinationSelected,
              labelType: NavigationRailLabelType.all,
              destinations: [
                for (final destination in destinations)
                  NavigationRailDestination(
                    icon: Icon(destination.icon),
                    label: Text(destination.label),
                  ),
              ],
            ),
            const VerticalDivider(width: 1),
            Expanded(child: child),
          ],
        ),
      );
    }

    return Scaffold(
      body: child,
      bottomNavigationBar: !_hasNav
          ? null
          : NavigationBar(
              selectedIndex: selectedIndex,
              onDestinationSelected: onDestinationSelected,
              destinations: [
                for (final destination in destinations)
                  NavigationDestination(
                    icon: Icon(destination.icon),
                    label: destination.label,
                  ),
              ],
            ),
    );
  }
}
