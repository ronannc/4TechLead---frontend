import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../core/routing/route_paths.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/viewmodels/base_view_model.dart';
import '../../../core/widgets/data/app_key_value_row.dart';
import '../viewmodels/person_daily_stats_view_model.dart';

/// "Dailies" section appended to the end of `PersonDetailBody` — this
/// person's own aggregated stats, with a link into the team's daily
/// history. Uses its own [ViewState] (via [PersonDailyStatsViewModel]) so a
/// stats-fetch failure never takes down the rest of the person's page.
class PersonDailySection extends StatelessWidget {
  const PersonDailySection({super.key, required this.teamId});

  final int teamId;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Selector<PersonDailyStatsViewModel, ViewState>(
      selector: (_, vm) => vm.state,
      builder: (context, state, _) {
        final viewModel = context.read<PersonDailyStatsViewModel>();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Dailies', style: theme.textTheme.titleMedium),
            const SizedBox(height: AppSpacing.sm),
            switch (state) {
              ViewState.idle || ViewState.loading => const Padding(
                padding: EdgeInsets.symmetric(vertical: AppSpacing.md),
                child: Center(child: CircularProgressIndicator()),
              ),
              ViewState.error => Text(
                viewModel.errorMessage ??
                    'Não foi possível carregar as estatísticas.',
                style: TextStyle(color: theme.colorScheme.error),
              ),
              ViewState.loaded => _DailyStatsContent(teamId: teamId),
            },
          ],
        );
      },
    );
  }
}

class _DailyStatsContent extends StatelessWidget {
  const _DailyStatsContent({required this.teamId});

  final int teamId;

  @override
  Widget build(BuildContext context) {
    final stats = context.read<PersonDailyStatsViewModel>().stats;

    if (stats.entryCount == 0) {
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
          value: '${stats.averageActualSeconds.round()}s',
        ),
        AppKeyValueRow(
          label: 'No tempo',
          value: '${stats.onTimePercentage.round()}%',
        ),
        AppKeyValueRow(
          label: 'Queimou o tempo',
          value: '${stats.burnedPercentage.round()}%',
        ),
        AppKeyValueRow(
          label: 'Falou pouco',
          value: '${stats.spokeTooLittlePercentage.round()}%',
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
