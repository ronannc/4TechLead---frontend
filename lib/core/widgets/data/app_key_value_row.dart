import 'package:flutter/material.dart';

import '../../theme/app_spacing.dart';

/// A label/value pair rendered as a small stacked block — the same shape
/// `PersonDetailBody` already used privately for each field, now shared so
/// stats sections (Daily history/person stats) can reuse it instead of
/// reaching for a `Card` per row.
class AppKeyValueRow extends StatelessWidget {
  const AppKeyValueRow({super.key, required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          Text(value, style: theme.textTheme.bodyLarge),
        ],
      ),
    );
  }
}
