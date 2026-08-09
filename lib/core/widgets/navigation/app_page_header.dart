import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../routing/route_paths.dart';
import '../branding/app_logo.dart';

/// Standard page header used by every top-level (shell) screen instead of a
/// raw [AppBar]: description/subtitle on top, title below it — both left-
/// aligned — with the notifications bell right-aligned. Never build a
/// bespoke `AppBar` per screen; add [subtitle]/[title] here instead so the
/// layout stays identical everywhere.
class AppPageHeader extends StatelessWidget implements PreferredSizeWidget {
  const AppPageHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.showNotifications = true,
    this.showBrandMark = false,
  });

  final String title;
  final String? subtitle;
  final bool showNotifications;
  final bool showBrandMark;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppBar(
      centerTitle: false,
      titleSpacing: 16,
      toolbarHeight: preferredSize.height,
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showBrandMark) ...[
            const AppLogoMark(size: 36),
            const SizedBox(width: 12),
          ],
          Flexible(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (subtitle != null)
                  Text(
                    subtitle!,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                Text(title, style: theme.textTheme.titleLarge),
              ],
            ),
          ),
        ],
      ),
      actions: [
        if (showNotifications)
          IconButton(
            onPressed: () => context.go(RoutePaths.notifications),
            icon: const Icon(Icons.notifications_none),
            tooltip: 'Notificações',
          ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 16);
}
