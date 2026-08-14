import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/routing/route_paths.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/data/app_key_value_row.dart';
import '../../people/models/person.dart';

/// "Dailies" section appended to the end of `PersonDetailBody` — this
/// person's own aggregated stats, with a link into the team's daily
/// history. The summary comes pre-aggregated from `/people/{id}` so this
/// section does not trigger an extra request on screen load.
class PersonDailySection extends StatelessWidget {
  const PersonDailySection({
    super.key,
    required this.teamId,
    required this.stats,
  });

  final int teamId;
  final PersonDailyStatsSummary? stats;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Dailies', style: theme.textTheme.titleMedium),
        const SizedBox(height: AppSpacing.sm),
        _DailyStatsContent(teamId: teamId, stats: stats),
      ],
    );
  }
}

class _DailyStatsContent extends StatelessWidget {
  const _DailyStatsContent({required this.teamId, required this.stats});

  final int teamId;
  final PersonDailyStatsSummary? stats;

  @override
  Widget build(BuildContext context) {
    if (stats == null || stats!.entryCount == 0) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Ainda não participou de nenhuma daily.'),
          const SizedBox(height: AppSpacing.sm),
          _historyLink(context),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppKeyValueRow(
          label: 'Tempo médio de fala',
          value: '${stats!.averageActualSeconds.round()}s',
        ),
        AppKeyValueRow(
          label: 'No tempo',
          value: '${stats!.onTimePercentage.round()}%',
        ),
        AppKeyValueRow(
          label: 'Queimou o tempo',
          value: '${stats!.burnedPercentage.round()}%',
        ),
        AppKeyValueRow(
          label: 'Falou pouco',
          value: '${stats!.spokeTooLittlePercentage.round()}%',
        ),
        const SizedBox(height: AppSpacing.sm),
        _historyLink(context),
      ],
    );
  }

  Widget _historyLink(BuildContext context) {
    return TextButton(
      onPressed: () => context.push(RoutePaths.dailyHistoryPath('$teamId')),
      child: const Text('Ver histórico do time'),
    );
  }
}
