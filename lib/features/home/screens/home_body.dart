import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../core/routing/route_paths.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/cards/app_summary_card.dart';
import '../../people/models/person.dart';
import '../../people/utils/birthday_util.dart';
import '../viewmodels/home_view_model.dart';

const _homeOuterGap = AppSpacing.md;
const _homeInnerGap = AppSpacing.sm;

class HomeBody extends StatelessWidget {
  const HomeBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(
        _homeOuterGap,
        _homeOuterGap,
        _homeOuterGap,
        _homeOuterGap,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _DailyCallout(),
          const SizedBox(height: _homeInnerGap),
          Selector<HomeViewModel, ({int peopleCount, int teamsCount})>(
            selector: (_, vm) =>
                (peopleCount: vm.peopleCount, teamsCount: vm.teamsCount),
            builder: (context, metrics, _) => LayoutBuilder(
              builder: (context, constraints) {
                const cardHeight = 180.0;

                return GridView(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisExtent: cardHeight,
                    crossAxisSpacing: _homeInnerGap,
                    mainAxisSpacing: _homeInnerGap,
                  ),
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    AppSummaryCard(
                      icon: Icons.person_outline,
                      value: '${metrics.peopleCount}',
                      label: 'Pessoas cadastradas',
                    ),
                    AppSummaryCard(
                      icon: Icons.groups_outlined,
                      value: '${metrics.teamsCount}',
                      label: 'Times ativos',
                    ),
                  ],
                );
              },
            ),
          ),
          const SizedBox(height: _homeInnerGap),
          _SectionTitle('Time hoje'),
          const SizedBox(height: _homeInnerGap),
          Selector<HomeViewModel, List<Person>>(
            selector: (_, vm) => vm.teamToday,
            builder: (context, people, _) => _PeopleSnapshot(people: people),
          ),
          const SizedBox(height: _homeInnerGap),
          _SectionTitle('Próximos aniversários'),
          const SizedBox(height: _homeInnerGap),
          Selector<HomeViewModel, List<Person>>(
            selector: (_, vm) => vm.upcomingBirthdays,
            builder: (context, people, _) => _BirthdayCard(people: people),
          ),
        ],
      ),
    );
  }
}

class _DailyCallout extends StatelessWidget {
  const _DailyCallout();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withValues(alpha: 0.18),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.timer_outlined,
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Daily', style: theme.textTheme.titleMedium),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    'Escolha times ou pessoas para o ritual de alinhamento.',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            IconButton.filled(
              tooltip: 'Iniciar daily',
              onPressed: () => context.go(RoutePaths.dailySessionPath()),
              icon: const Icon(Icons.play_arrow),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text.toUpperCase(),
      style: Theme.of(context).textTheme.labelSmall?.copyWith(
        color: Theme.of(context).colorScheme.onSurfaceVariant,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}

class _PeopleSnapshot extends StatelessWidget {
  const _PeopleSnapshot({required this.people});

  final List<Person> people;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (people.isEmpty) {
      return Card(
        margin: EdgeInsets.zero,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Text(
            'Nenhuma pessoa cadastrada ainda.',
            style: theme.textTheme.bodyMedium,
          ),
        ),
      );
    }

    return Card(
      margin: EdgeInsets.zero,
      child: Column(
        children: [
          for (final (index, person) in people.indexed) ...[
            _PersonSnapshotRow(person: person),
            if (index < people.length - 1)
              Divider(
                height: 1,
                color: theme.colorScheme.outline.withValues(alpha: 0.6),
              ),
          ],
        ],
      ),
    );
  }
}

class _PersonSnapshotRow extends StatelessWidget {
  const _PersonSnapshotRow({required this.person});

  final Person person;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Row(
        children: [
          CircleAvatar(child: Text(_initials(person.name))),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(person.name, style: theme.textTheme.titleSmall),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  person.position,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BirthdayCard extends StatelessWidget {
  const _BirthdayCard({required this.people});

  final List<Person> people;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (people.isEmpty) {
      return Card(
        margin: EdgeInsets.zero,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
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
      margin: EdgeInsets.zero,
      child: Column(
        children: [
          for (final person in people)
            ListTile(
              leading: const Icon(Icons.cake_outlined),
              title: Text(person.name),
              subtitle: Text(dateFormat.format(person.birthDate!)),
              trailing: Text(
                _daysUntilLabel(daysUntilNextBirthday(person.birthDate!)),
              ),
            ),
        ],
      ),
    );
  }
}

String _initials(String name) {
  final parts = name
      .trim()
      .split(RegExp(r'\s+'))
      .where((part) => part.isNotEmpty)
      .toList();
  if (parts.isEmpty) {
    return '?';
  }

  return parts.take(2).map((part) => part[0].toUpperCase()).join();
}

String _daysUntilLabel(int days) {
  return switch (days) {
    0 => 'Hoje',
    1 => 'Amanhã',
    _ => 'Em $days dias',
  };
}
