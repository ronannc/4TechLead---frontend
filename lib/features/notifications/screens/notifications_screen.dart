import 'package:flutter/material.dart';

import '../../../core/widgets/navigation/app_page_header.dart';
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
      appBar: const AppPageHeader(
        subtitle: 'Fique por dentro',
        title: 'Notificações',
        showNotifications: false,
      ),
      body: const EmptyView(
        icon: Icons.notifications_none,
        message: 'Nenhuma notificação por enquanto.',
      ),
    );
  }
}
