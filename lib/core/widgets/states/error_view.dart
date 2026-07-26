import 'package:flutter/material.dart';

import '../../theme/app_spacing.dart';
import '../buttons/app_primary_button.dart';

/// Standard full-space error state for a screen's body, with an optional
/// retry action.
class ErrorView extends StatelessWidget {
  const ErrorView({super.key, required this.message, this.onRetry});

  final String message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, color: theme.colorScheme.error, size: 48),
            const SizedBox(height: AppSpacing.md),
            Text(message, style: theme.textTheme.bodyLarge, textAlign: TextAlign.center),
            if (onRetry != null) ...[
              const SizedBox(height: AppSpacing.md),
              AppPrimaryButton(label: 'Tentar novamente', onPressed: onRetry),
            ],
          ],
        ),
      ),
    );
  }
}
