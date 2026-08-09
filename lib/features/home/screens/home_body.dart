import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../core/routing/route_paths.dart';
import '../../../core/theme/app_spacing.dart';
import '../../people/models/person.dart';
import '../../people/utils/birthday_util.dart';
import '../viewmodels/home_view_model.dart';

class HomeBody extends StatelessWidget {
  const HomeBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.sm,
        AppSpacing.md,
        AppSpacing.lg,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _DailyCallout(),
          const SizedBox(height: AppSpacing.md),
          Selector<HomeViewModel, int>(
            selector: (_, vm) => vm.teamsCount,
            builder: (context, teamsCount, _) => GridView.count(
              crossAxisCount: 2,
              childAspectRatio: 1.58,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: AppSpacing.sm,
              mainAxisSpacing: AppSpacing.sm,
              children: [
                _MetricCard(
                  label: 'Ritual',
                  value: 'Daily',
                  sub: 'disponível',
                  icon: Icons.timer_outlined,
                ),
                _MetricCard(
                  label: 'Times',
                  value: '$teamsCount',
                  sub: 'ativos',
                  icon: Icons.groups_outlined,
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          _SectionTitle('Time hoje'),
          const SizedBox(height: AppSpacing.sm),
          Selector<HomeViewModel, List<Person>>(
            selector: (_, vm) => vm.teamToday,
            builder: (context, people, _) => _PeopleSnapshot(people: people),
          ),
          const SizedBox(height: AppSpacing.lg),
          _SectionTitle('Próximos aniversários'),
          const SizedBox(height: AppSpacing.sm),
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

class _MetricCard extends StatelessWidget {
  const _MetricCard({
    required this.label,
    required this.value,
    required this.sub,
    required this.icon,
  });

  final String label;
  final String value;
  final String sub;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: theme.colorScheme.primary, size: 20),
            const Spacer(),
            Text(
              label,
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            Text(value, style: theme.textTheme.titleLarge),
            Text(
              sub,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
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
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Text(
            'Nenhuma pessoa cadastrada ainda.',
            style: theme.textTheme.bodyMedium,
          ),
        ),
      );
    }

    return Card(
      child: Column(
        children: [
          for (final person in people)
            ListTile(
              leading: CircleAvatar(child: Text(_initials(person.name))),
              title: Text(person.name),
              subtitle: Text(person.position),
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
