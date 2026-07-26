import 'package:flutter/material.dart';

import '../../../core/widgets/states/empty_view.dart';

/// Placeholder screen for the Notifications nav destination — no
/// notifications backend/feature exists yet, so this is an intentional
/// empty state rather than a stub with fake data. Replace `body` with a
/// proper NotificationsViewModel/Repository once that API exists, mirroring
/// `features/teams/`.
class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notifications')),
      body: const EmptyView(
        icon: Icons.notifications_none,
        message: 'No notifications yet.',
      ),
    );
  }
}
