import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../core/theme/app_theme_extension.dart';
import '../utils/daily_time_limit.dart';

/// The live countdown/overtime display for the current turn. Rebuilds by
/// itself once a second via [ValueListenableBuilder] on the ViewModel's raw
/// `elapsedSeconds` notifier — nothing else in the tree re-renders per tick.
class DailyTimerRing extends StatelessWidget {
  const DailyTimerRing({
    super.key,
    required this.allowedSeconds,
    required this.elapsedSeconds,
  });

  final int allowedSeconds;
  final ValueListenable<int> elapsedSeconds;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ValueListenableBuilder<int>(
      valueListenable: elapsedSeconds,
      builder: (context, elapsed, _) {
        final remaining = allowedSeconds - elapsed;
        final isBurned = remaining <= 0;
        final isAboutToBurn = !isBurned && remaining <= 10;
        final colors = theme.extension<AppThemeExtension>()!;
        final color = isBurned
            ? theme.colorScheme.error
            : isAboutToBurn
            ? theme.colorScheme.primary
            : theme.colorScheme.primary;
        final progress = (elapsed / allowedSeconds).clamp(0.0, 1.0);

        return DecoratedBox(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: 0.22),
                blurRadius: 32,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 220,
                height: 220,
                child: CircularProgressIndicator(
                  value: isBurned ? 1 : progress,
                  strokeWidth: 12,
                  color: color,
                  backgroundColor: colors.border,
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    formatDailyDuration(remaining),
                    style: theme.textTheme.displaySmall?.copyWith(color: color),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    isBurned ? 'tempo estourado' : 'restante',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
