import 'package:flutter/material.dart';

import '../../theme/app_spacing.dart';

/// Reusable dashboard summary card: an icon, a large value, and a label —
/// used by [HomeScreen] and any future screen needing quick-glance KPIs.
class AppSummaryCard extends StatelessWidget {
  const AppSummaryCard({super.key, required this.icon, required this.value, required this.label});

  final IconData icon;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: theme.colorScheme.primary),
            const SizedBox(height: AppSpacing.sm),
            Text(value, style: theme.textTheme.displaySmall),
            const SizedBox(height: AppSpacing.xs),
            Text(label, style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
          ],
        ),
      ),
    );
  }
}
