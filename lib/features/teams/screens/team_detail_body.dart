import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_spacing.dart';
import '../models/team.dart';
import '../viewmodels/team_detail_view_model.dart';

/// The loaded-state body of [TeamDetailScreen], split into its own
/// file/class so only this subtree rebuilds when the team data changes.
class TeamDetailBody extends StatelessWidget {
  const TeamDetailBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Selector<TeamDetailViewModel, Team?>(
      selector: (_, vm) => vm.team,
      builder: (context, team, _) {
        if (team == null) {
          return const SizedBox.shrink();
        }

        final theme = Theme.of(context);
        final dateFormat = DateFormat.yMMMd().add_jm();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(team.name, style: theme.textTheme.headlineMedium),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Created at ${dateFormat.format(team.createdAt.toLocal())}',
              style: theme.textTheme.bodySmall,
            ),
          ],
        );
      },
    );
  }
}
