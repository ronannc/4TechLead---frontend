import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../core/routing/route_paths.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/buttons/app_primary_button.dart';
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
        final dateFormat = DateFormat.yMMMd('pt_BR').add_jm();

        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(team.name, style: theme.textTheme.headlineMedium),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Criado em ${dateFormat.format(team.createdAt.toLocal())}',
              style: theme.textTheme.bodySmall,
            ),
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                Expanded(
                  child: AppPrimaryButton(
                    label: 'Iniciar daily',
                    onPressed: () => context.go(
                      RoutePaths.dailySessionPath(initialTeamId: '${team.id}'),
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: AppSecondaryButton(
                    label: 'Ver histórico',
                    onPressed: () =>
                        context.push(RoutePaths.dailyHistoryPath('${team.id}')),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
