import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/cards/app_summary_card.dart';
import '../viewmodels/home_view_model.dart';

/// The loaded-state body of [HomeScreen], split into its own file/class so
/// only this subtree rebuilds when the summary data changes — see
/// `frontend/CLAUDE.md`'s "One class per file" convention.
class HomeBody extends StatelessWidget {
  const HomeBody({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Overview', style: theme.textTheme.titleMedium),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              Expanded(
                child: Selector<HomeViewModel, int>(
                  selector: (_, vm) => vm.teamsCount,
                  builder: (context, teamsCount, _) => AppSummaryCard(
                    icon: Icons.groups_outlined,
                    value: '$teamsCount',
                    label: 'Teams',
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          Text('Trends', style: theme.textTheme.titleMedium),
          const SizedBox(height: AppSpacing.sm),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Center(
                child: Text(
                  'Historical trend data isn\'t tracked yet — this card will chart '
                  'metrics like team growth once that data exists.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
