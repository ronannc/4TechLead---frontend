import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/cards/app_summary_card.dart';
import '../../people/models/person.dart';
import '../../people/utils/birthday_util.dart';
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
          Text('Visão geral', style: theme.textTheme.titleMedium),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              Expanded(
                child: Selector<HomeViewModel, int>(
                  selector: (_, vm) => vm.teamsCount,
                  builder: (context, teamsCount, _) => AppSummaryCard(
                    icon: Icons.groups_outlined,
                    value: '$teamsCount',
                    label: 'Times',
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          Text('Próximos aniversários', style: theme.textTheme.titleMedium),
          const SizedBox(height: AppSpacing.sm),
          Selector<HomeViewModel, List<Person>>(
            selector: (_, vm) => vm.upcomingBirthdays,
            builder: (context, people, _) {
              if (people.isEmpty) {
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    child: Center(
                      child: Text(
                        'Nenhum aniversário cadastrado ainda.',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ),
                );
              }

              final dateFormat = DateFormat("d 'de' MMMM", 'pt_BR');

              return Card(
                child: Column(
                  children: [
                    for (final person in people)
                      ListTile(
                        leading: const Icon(Icons.cake_outlined),
                        title: Text(person.name),
                        subtitle: Text(dateFormat.format(person.birthDate)),
                        trailing: Text(_daysUntilLabel(daysUntilNextBirthday(person.birthDate))),
                      ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: AppSpacing.lg),
          Text('Tendências', style: theme.textTheme.titleMedium),
          const SizedBox(height: AppSpacing.sm),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Center(
                child: Text(
                  'Ainda não há dados históricos registrados — este card vai exibir '
                  'métricas como o crescimento dos times assim que esses dados existirem.',
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

String _daysUntilLabel(int days) {
  return switch (days) {
    0 => 'Hoje',
    1 => 'Amanhã',
    _ => 'Em $days dias',
  };
}
