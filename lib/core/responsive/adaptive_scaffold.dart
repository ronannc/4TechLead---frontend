import 'package:flutter/material.dart';

import 'breakpoints.dart';

/// A navigation destination shared between the mobile bottom nav and the
/// desktop side rail, so [AdaptiveScaffold] only needs one list of items.
class AppNavDestination {
  const AppNavDestination({
    required this.label,
    required this.icon,
    required this.path,
    this.showInMobileBar = true,
  });

  final String label;
  final IconData icon;
  final String path;
  final bool showInMobileBar;
}

/// Adaptive navigation chrome: a compact bottom [NavigationBar] on mobile
/// widths, a [NavigationRail] on desktop widths (macOS/Windows). Wrapped around
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

  List<AppNavDestination> get _mobilePrimaryDestinations => destinations
      .where((destination) => destination.showInMobileBar)
      .toList(growable: false);

  List<AppNavDestination> get _mobileSecondaryDestinations => destinations
      .where((destination) => !destination.showInMobileBar)
      .toList(growable: false);

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

    final primaryDestinations = _mobilePrimaryDestinations;
    final secondaryDestinations = _mobileSecondaryDestinations;
    final hasSecondaryDestinations = secondaryDestinations.isNotEmpty;
    final selectedPrimaryIndex = primaryDestinations.indexWhere(
      (destination) => destinations[selectedIndex].path == destination.path,
    );
    final mobileSelectedIndex = selectedPrimaryIndex >= 0
        ? selectedPrimaryIndex
        : primaryDestinations.length;

    return Scaffold(
      body: child,
      bottomNavigationBar: !_hasNav
          ? null
          : NavigationBar(
              selectedIndex: mobileSelectedIndex,
              onDestinationSelected: (index) {
                if (index < primaryDestinations.length) {
                  onDestinationSelected(
                    destinations.indexOf(primaryDestinations[index]),
                  );

                  return;
                }

                _showMoreDestinations(context, secondaryDestinations);
              },
              destinations: [
                for (final destination in primaryDestinations)
                  NavigationDestination(
                    icon: Icon(destination.icon),
                    label: destination.label,
                  ),
                if (hasSecondaryDestinations)
                  const NavigationDestination(
                    icon: Icon(Icons.more_horiz),
                    label: 'Mais',
                  ),
              ],
            ),
    );
  }

  void _showMoreDestinations(
    BuildContext context,
    List<AppNavDestination> secondaryDestinations,
  ) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) => SafeArea(
        child: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.only(bottom: 8),
          children: [
            for (final destination in secondaryDestinations)
              ListTile(
                leading: Icon(destination.icon),
                title: Text(destination.label),
                selected: destinations[selectedIndex].path == destination.path,
                onTap: () {
                  Navigator.of(context).pop();
                  onDestinationSelected(destinations.indexOf(destination));
                },
              ),
          ],
        ),
      ),
    );
  }
}
