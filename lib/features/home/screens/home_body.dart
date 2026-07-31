import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../core/routing/route_paths.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_theme_extension.dart';
import '../../people/models/person.dart';
import '../../people/utils/birthday_util.dart';
import '../viewmodels/home_view_model.dart';

class HomeBody extends StatelessWidget {
  const HomeBody({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.extension<AppThemeExtension>()!;

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
          Selector<HomeViewModel, int?>(
            selector: (_, vm) => vm.firstTeamId,
            builder: (context, firstTeamId, _) =>
                _DailyCallout(teamId: firstTeamId),
          ),
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
                  label: 'Próxima',
                  value: 'Daily',
                  sub: '25 min',
                  icon: Icons.timer_outlined,
                ),
                _MetricCard(
                  label: 'Times',
                  value: '$teamsCount',
                  sub: 'ativos',
                  icon: Icons.groups_outlined,
                ),
                const _MetricCard(
                  label: 'Sinais abertos',
                  value: '4',
                  sub: '1 crítico',
                  icon: Icons.notifications_none,
                ),
                const _MetricCard(
                  label: 'Humor',
                  value: 'Bom',
                  sub: '2 atenção',
                  icon: Icons.favorite_border,
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          _SectionTitle('Alertas prioritários'),
          const SizedBox(height: AppSpacing.sm),
          _AlertCard(
            color: theme.colorScheme.error,
            tag: 'crítico',
            title: 'API Frota retornando 5xx',
            meta: 'Sinais · há 8 min',
          ),
          _AlertCard(
            color: theme.colorScheme.primary,
            tag: 'em risco',
            title: 'OKR "Reduzir p95" em risco',
            meta: 'OKRs · check-in atrasado',
          ),
          _AlertCard(
            color: theme.colorScheme.primary,
            tag: 'pendente',
            title: '1:1 com Diego há 6 semanas',
            meta: 'Pessoas · agendar',
          ),
          const SizedBox(height: AppSpacing.lg),
          _SectionTitle('Time hoje'),
          const SizedBox(height: AppSpacing.sm),
          Selector<HomeViewModel, List<Person>>(
            selector: (_, vm) => vm.teamToday,
            builder: (context, people, _) => _PeopleSnapshot(people: people),
          ),
          const SizedBox(height: AppSpacing.lg),
          _SectionTitle('Feed operacional'),
          const SizedBox(height: AppSpacing.sm),
          _FeedItem(
            color: theme.colorScheme.error,
            text: 'API Frota: erro 5xx acima de 4%',
            source: 'API Frota',
            when: 'há 8 min',
          ),
          _FeedItem(
            color: theme.colorScheme.primary,
            text: 'Deploy staging concluído (#482)',
            source: 'CI',
            when: 'há 22 min',
          ),
          _FeedItem(
            color: colors.success,
            text: 'Latência p95 normalizou (312ms)',
            source: 'Grafana',
            when: 'há 40 min',
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
  const _DailyCallout({required this.teamId});

  final int? teamId;

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
                  Text('Daily do time', style: theme.textTheme.titleMedium),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    teamId == null
                        ? 'Crie um time para começar.'
                        : 'Ritual rápido, foco em bloqueios e alinhamentos.',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            IconButton.filled(
              tooltip: 'Iniciar daily',
              onPressed: teamId == null
                  ? null
                  : () => context.go(RoutePaths.dailySessionPath('$teamId')),
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

class _AlertCard extends StatelessWidget {
  const _AlertCard({
    required this.color,
    required this.tag,
    required this.title,
    required this.meta,
  });

  final Color color;
  final String tag;
  final String title;
  final String meta;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Row(
          children: [
            Container(
              width: 8,
              height: 42,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _Pill(label: tag, color: color),
                  const SizedBox(height: AppSpacing.xs),
                  Text(title, style: theme.textTheme.titleSmall),
                  Text(
                    meta,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
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
              trailing: _Pill(
                label: _moodLabel(person.id),
                color: _moodColor(context, person.id),
              ),
            ),
        ],
      ),
    );
  }

  Color _moodColor(BuildContext context, int id) {
    final theme = Theme.of(context);
    final colors = theme.extension<AppThemeExtension>()!;

    return switch (id % 3) {
      0 => theme.colorScheme.error,
      1 => colors.success,
      _ => theme.colorScheme.primary,
    };
  }

  String _moodLabel(int id) => switch (id % 3) {
    0 => 'Baixo',
    1 => 'Bom',
    _ => 'Atenção',
  };
}

class _FeedItem extends StatelessWidget {
  const _FeedItem({
    required this.color,
    required this.text,
    required this.source,
    required this.when,
  });

  final Color color;
  final String text;
  final String source;
  final String when;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 10,
            height: 10,
            margin: const EdgeInsets.only(top: 5),
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(text, style: theme.textTheme.bodyMedium),
                Text(
                  '$source · $when',
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
              trailing: Text(
                _daysUntilLabel(daysUntilNextBirthday(person.birthDate)),
              ),
            ),
        ],
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withValues(alpha: 0.55)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: 2,
        ),
        child: Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(color: color),
        ),
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
