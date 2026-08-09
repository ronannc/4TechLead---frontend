import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_theme_extension.dart';
import '../../../core/widgets/buttons/app_primary_button.dart';
import '../../../core/widgets/inputs/app_search_field.dart';
import '../../people/models/person.dart';
import '../../teams/models/team.dart';
import '../utils/daily_time_limit.dart';
import '../viewmodels/daily_session_view_model.dart';

const _dailyConfigOuterGap = AppSpacing.md;
const _dailyConfigInnerGap = AppSpacing.sm;

class DailyConfigBody extends StatefulWidget {
  const DailyConfigBody({super.key});

  @override
  State<DailyConfigBody> createState() => _DailyConfigBodyState();
}

class _DailyConfigBodyState extends State<DailyConfigBody> {
  final _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Selector<DailySessionViewModel, List<Person>>(
      selector: (_, vm) => vm.members,
      builder: (context, members, _) {
        final viewModel = context.read<DailySessionViewModel>();
        final people = _filteredPeople(viewModel.people);

        return SingleChildScrollView(
          padding: const EdgeInsets.all(_dailyConfigOuterGap),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _ConfigHeader(selectedCount: members.length),
              const SizedBox(height: _dailyConfigInnerGap),
              _TimeLimitControl(),
              const SizedBox(height: _dailyConfigInnerGap),
              Text(
                'Selecionar participantes',
                style: theme.textTheme.titleMedium,
              ),
              const SizedBox(height: _dailyConfigInnerGap),
              _TeamSelector(teams: viewModel.teams),
              const SizedBox(height: _dailyConfigInnerGap),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: viewModel.selectAllPeople,
                      icon: const Icon(Icons.done_all),
                      label: const Text('Todos'),
                    ),
                  ),
                  const SizedBox(width: _dailyConfigInnerGap),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: viewModel.clearSelection,
                      icon: const Icon(Icons.clear_all),
                      label: const Text('Limpar'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: _dailyConfigInnerGap),
              AppSearchField(
                controller: _searchController,
                hintText: 'Buscar pessoa cadastrada...',
                onChanged: (value) => setState(() => _query = value),
              ),
              const SizedBox(height: _dailyConfigInnerGap),
              if (viewModel.people.isEmpty)
                const _EmptySelection(
                  message: 'Nenhuma pessoa cadastrada ainda.',
                )
              else
                _PeoplePicker(people: people),
              const SizedBox(height: _dailyConfigInnerGap),
              Text('Ordem de fala', style: theme.textTheme.titleMedium),
              const SizedBox(height: _dailyConfigInnerGap),
              _SpeakingQueue(members: members),
              const SizedBox(height: _dailyConfigInnerGap),
              AppPrimaryButton(
                label: 'Iniciar daily',
                onPressed: members.isEmpty ? null : viewModel.start,
              ),
            ],
          ),
        );
      },
    );
  }

  List<Person> _filteredPeople(List<Person> people) {
    final query = _query.trim().toLowerCase();
    if (query.isEmpty) {
      return people;
    }

    return people
        .where(
          (person) =>
              person.name.toLowerCase().contains(query) ||
              person.position.toLowerCase().contains(query),
        )
        .toList();
  }
}

class _ConfigHeader extends StatelessWidget {
  const _ConfigHeader({required this.selectedCount});

  final int selectedCount;

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
              width: 54,
              height: 54,
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
                  Text('Daily', style: theme.textTheme.titleLarge),
                  Text(
                    '$selectedCount participantes selecionados',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            Selector<DailySessionViewModel, int>(
              selector: (_, vm) => vm.timeLimitSeconds,
              builder: (context, seconds, _) => Text(
                formatDailyDuration(seconds),
                style: theme.textTheme.titleLarge?.copyWith(
                  color: theme.colorScheme.primary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TimeLimitControl extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final viewModel = context.read<DailySessionViewModel>();

    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Selector<DailySessionViewModel, int>(
          selector: (_, vm) => vm.timeLimitSeconds,
          builder: (context, timeLimitSeconds, _) => Row(
            children: [
              IconButton.filledTonal(
                onPressed: viewModel.decreaseTimeLimit,
                icon: const Icon(Icons.remove),
                tooltip: 'Diminuir 30s',
              ),
              Expanded(
                child: Column(
                  children: [
                    Text(
                      formatDailyDuration(timeLimitSeconds),
                      style: theme.textTheme.displaySmall,
                    ),
                    Text(
                      'tempo por pessoa',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton.filled(
                onPressed: viewModel.increaseTimeLimit,
                icon: const Icon(Icons.add),
                tooltip: 'Aumentar 30s',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TeamSelector extends StatelessWidget {
  const _TeamSelector({required this.teams});

  final List<Team> teams;

  @override
  Widget build(BuildContext context) {
    if (teams.isEmpty) {
      return const _EmptySelection(message: 'Nenhum time cadastrado.');
    }

    final viewModel = context.read<DailySessionViewModel>();

    return Wrap(
      spacing: _dailyConfigInnerGap,
      runSpacing: _dailyConfigInnerGap,
      children: [
        for (final team in teams)
          FilterChip(
            selected: viewModel.isTeamSelected(team),
            label: Text(
              '${team.name} (${viewModel.selectedCountForTeam(team)}/${viewModel.totalCountForTeam(team)})',
            ),
            avatar: const Icon(Icons.groups_outlined, size: 18),
            onSelected: (_) => viewModel.toggleTeam(team),
          ),
      ],
    );
  }
}

class _PeoplePicker extends StatelessWidget {
  const _PeoplePicker({required this.people});

  final List<Person> people;

  @override
  Widget build(BuildContext context) {
    if (people.isEmpty) {
      return const _EmptySelection(message: 'Nenhuma pessoa encontrada.');
    }

    final viewModel = context.read<DailySessionViewModel>();

    return Column(
      children: [
        for (final (index, person) in people.indexed) ...[
          _PersonOption(
            person: person,
            teamName: viewModel.teamNameFor(person.teamId),
            selected: viewModel.isPersonSelected(person),
            onTap: () => viewModel.togglePerson(person),
          ),
          if (index < people.length - 1)
            const SizedBox(height: _dailyConfigInnerGap),
        ],
      ],
    );
  }
}

class _PersonOption extends StatelessWidget {
  const _PersonOption({
    required this.person,
    required this.teamName,
    required this.selected,
    required this.onTap,
  });

  final Person person;
  final String teamName;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final border = Theme.of(context).extension<AppThemeExtension>()!.border;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: selected
              ? theme.colorScheme.primary.withValues(alpha: 0.12)
              : theme.cardTheme.color,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: selected ? theme.colorScheme.primary : border,
          ),
        ),
        child: Row(
          children: [
            CircleAvatar(child: Text(_initials(person.name))),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(person.name, style: theme.textTheme.titleSmall),
                  Text(
                    '$teamName · ${person.position}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              selected ? Icons.check_circle : Icons.add_circle_outline,
              color: selected
                  ? theme.colorScheme.primary
                  : theme.colorScheme.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }
}

class _SpeakingQueue extends StatelessWidget {
  const _SpeakingQueue({required this.members});

  final List<Person> members;

  @override
  Widget build(BuildContext context) {
    if (members.isEmpty) {
      return const _EmptySelection(
        message: 'Escolha participantes para montar a ordem de fala.',
      );
    }

    final viewModel = context.read<DailySessionViewModel>();

    return SizedBox(
      height: 92,
      child: ReorderableListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: members.length,
        onReorderItem: viewModel.reorderMembers,
        buildDefaultDragHandles: false,
        itemBuilder: (context, index) {
          final member = members[index];

          return Padding(
            key: ValueKey(member.id),
            padding: const EdgeInsets.only(right: _dailyConfigInnerGap),
            child: ReorderableDragStartListener(
              index: index,
              child: Column(
                children: [
                  CircleAvatar(radius: 24, child: Text('${index + 1}')),
                  const SizedBox(height: AppSpacing.xs),
                  SizedBox(
                    width: 72,
                    child: Text(
                      member.name.split(' ').first,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _EmptySelection extends StatelessWidget {
  const _EmptySelection({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        border: Border.all(color: theme.colorScheme.outline),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        message,
        style: theme.textTheme.bodySmall?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}

String _initials(String name) {
  final parts = name.trim().split(RegExp(r'\s+'));
  if (parts.length == 1) {
    return parts.first.characters.take(2).toString().toUpperCase();
  }

  return '${parts.first.characters.first}${parts.last.characters.first}'
      .toUpperCase();
}
