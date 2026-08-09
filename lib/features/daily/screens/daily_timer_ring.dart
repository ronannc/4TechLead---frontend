import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_theme_extension.dart';
import '../utils/daily_time_limit.dart';

const _dailyTimerMaxDiameter = 220.0;
const _dailyTimerOuterPadding = AppSpacing.md;
const _dailyTimerStrokeWidth = 12.0;

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
        final fallbackWidth =
            _dailyTimerMaxDiameter + (_dailyTimerOuterPadding * 2);

        return LayoutBuilder(
          builder: (context, constraints) {
            final availableWidth = constraints.hasBoundedWidth
                ? constraints.maxWidth
                : fallbackWidth;
            final diameter = (availableWidth - (_dailyTimerOuterPadding * 2))
                .clamp(0.0, _dailyTimerMaxDiameter)
                .toDouble();
            final labelWidth = diameter > (AppSpacing.lg * 2)
                ? diameter - (AppSpacing.lg * 2)
                : diameter;

            return Padding(
              padding: const EdgeInsets.all(_dailyTimerOuterPadding),
              child: SizedBox.square(
                dimension: diameter,
                child: DecoratedBox(
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
                      Positioned.fill(
                        child: CircularProgressIndicator(
                          value: isBurned ? 1 : progress,
                          strokeWidth: _dailyTimerStrokeWidth,
                          color: color,
                          backgroundColor: colors.border,
                        ),
                      ),
                      SizedBox(
                        width: labelWidth,
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                formatDailyDuration(remaining),
                                style: theme.textTheme.displaySmall?.copyWith(
                                  color: color,
                                ),
                              ),
                              const SizedBox(height: AppSpacing.xs),
                              Text(
                                isBurned ? 'tempo estourado' : 'restante',
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
