import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_theme_extension.dart';
import '../../../core/widgets/buttons/app_primary_button.dart';
import '../models/daily_blocker_draft.dart';
import '../models/daily_entry_status.dart';
import '../models/daily_turn_draft.dart';
import '../utils/daily_stats.dart';
import '../utils/daily_time_limit.dart';
import '../viewmodels/daily_session_view_model.dart';
import 'daily_note_sheet.dart';
import 'daily_timer_ring.dart';

class DailyRunningBody extends StatefulWidget {
  const DailyRunningBody({super.key});

  @override
  State<DailyRunningBody> createState() => _DailyRunningBodyState();
}

class _DailyRunningBodyState extends State<DailyRunningBody> {
  final _topicController = TextEditingController();
  final _blockerController = TextEditingController();

  @override
  void dispose() {
    _topicController.dispose();
    _blockerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Selector<DailySessionViewModel, int>(
      selector: (_, vm) => vm.currentTurnIndex,
      builder: (context, index, _) {
        final viewModel = context.read<DailySessionViewModel>();
        final turn = viewModel.currentTurn;

        if (turn == null) {
          return const SizedBox.shrink();
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _LiveHeader(
                index: index,
                total: viewModel.turns.length,
                turn: turn,
              ),
              const SizedBox(height: AppSpacing.md),
              Center(
                child: DailyTimerRing(
                  allowedSeconds: turn.allowedSeconds,
                  elapsedSeconds: viewModel.elapsedSeconds,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              _ParticipantsStrip(turns: viewModel.turns, currentIndex: index),
              const SizedBox(height: AppSpacing.md),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => showDailyNoteSheet(context, viewModel),
                      icon: const Icon(Icons.edit_note),
                      label: const Text('Nota'),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: viewModel.finishNow,
                      icon: const Icon(Icons.flag_outlined),
                      label: const Text('Finalizar'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              AppPrimaryButton(label: 'Próximo', onPressed: viewModel.nextTurn),
              const SizedBox(height: AppSpacing.lg),
              _QuickCapture(
                title: 'Tópicos levantados',
                hint: 'Ex.: Finalizou integração do webhook',
                controller: _topicController,
                icon: Icons.add_comment_outlined,
                onAdd: (text) {
                  viewModel.addTopic(text);
                  _topicController.clear();
                },
              ),
              const SizedBox(height: AppSpacing.sm),
              Selector<DailySessionViewModel, List<String>>(
                selector: (_, vm) => vm.topics,
                builder: (context, topics, _) => _TopicList(topics: topics),
              ),
              const SizedBox(height: AppSpacing.lg),
              _QuickCapture(
                title: 'Bloqueios',
                hint: 'Ex.: Aguardando credencial de staging',
                controller: _blockerController,
                icon: Icons.report_problem_outlined,
                onAdd: (text) {
                  viewModel.addBlocker(text);
                  _blockerController.clear();
                },
              ),
              const SizedBox(height: AppSpacing.sm),
              Selector<DailySessionViewModel, List<DailyBlockerDraft>>(
                selector: (_, vm) => vm.blockers,
                builder: (context, blockers, _) =>
                    _BlockerList(blockers: blockers),
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                'Use tópicos para alinhar avanços e bloqueios para marcar riscos que precisam sair da daily com dono.',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _LiveHeader extends StatelessWidget {
  const _LiveHeader({
    required this.index,
    required this.total,
    required this.turn,
  });

  final int index;
  final int total;
  final DailyTurnDraft turn;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Row(
          children: [
            CircleAvatar(radius: 26, child: Text(_initials(turn.person.name))),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${index + 1} de $total',
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  Text(turn.person.name, style: theme.textTheme.titleLarge),
                  Text(
                    turn.person.position,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            ValueListenableBuilder<int>(
              valueListenable: context
                  .read<DailySessionViewModel>()
                  .elapsedSeconds,
              builder: (context, elapsed, _) {
                final status = computeDraftStatus(
                  allottedSeconds: turn.allowedSeconds,
                  actualSeconds: elapsed,
                );

                return _StatusPill(status: status);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _ParticipantsStrip extends StatelessWidget {
  const _ParticipantsStrip({required this.turns, required this.currentIndex});

  final List<DailyTurnDraft> turns;
  final int currentIndex;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 72,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: turns.length,
        separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.sm),
        itemBuilder: (context, index) {
          final turn = turns[index];
          final active = index == currentIndex;
          final done = index < currentIndex;
          final color = active
              ? Theme.of(context).colorScheme.primary
              : done
              ? Theme.of(context).extension<AppThemeExtension>()!.success
              : Theme.of(context).colorScheme.outline;

          return DecoratedBox(
            decoration: BoxDecoration(
              border: Border.all(color: color),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.sm,
                vertical: AppSpacing.xs,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 16,
                    child: Text(_initials(turn.person.name)),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    formatDailyDuration(turn.actualSeconds ?? 0),
                    style: Theme.of(context).textTheme.labelSmall,
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

class _QuickCapture extends StatelessWidget {
  const _QuickCapture({
    required this.title,
    required this.hint,
    required this.controller,
    required this.icon,
    required this.onAdd,
  });

  final String title;
  final String hint;
  final TextEditingController controller;
  final IconData icon;
  final ValueChanged<String> onAdd;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: theme.textTheme.titleMedium),
        const SizedBox(height: AppSpacing.sm),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                decoration: InputDecoration(hintText: hint),
                onSubmitted: onAdd,
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            IconButton.filled(
              tooltip: 'Adicionar',
              onPressed: () => onAdd(controller.text),
              icon: Icon(icon),
            ),
          ],
        ),
      ],
    );
  }
}

class _TopicList extends StatelessWidget {
  const _TopicList({required this.topics});

  final List<String> topics;

  @override
  Widget build(BuildContext context) {
    if (topics.isEmpty) {
      return const SizedBox.shrink();
    }

    return Card(
      child: Column(
        children: [
          for (final topic in topics)
            ListTile(
              dense: true,
              leading: const Icon(Icons.chat_bubble_outline),
              title: Text(topic),
            ),
        ],
      ),
    );
  }
}

class _BlockerList extends StatelessWidget {
  const _BlockerList({required this.blockers});

  final List<DailyBlockerDraft> blockers;

  @override
  Widget build(BuildContext context) {
    if (blockers.isEmpty) {
      return const SizedBox.shrink();
    }

    final viewModel = context.read<DailySessionViewModel>();

    return Card(
      child: Column(
        children: [
          for (var i = 0; i < blockers.length; i++)
            CheckboxListTile(
              value: blockers[i].resolved,
              onChanged: (_) => viewModel.toggleBlocker(i),
              title: Text(
                blockers[i].text,
                style: TextStyle(
                  decoration: blockers[i].resolved
                      ? TextDecoration.lineThrough
                      : null,
                ),
              ),
              controlAffinity: ListTileControlAffinity.leading,
            ),
        ],
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.status});

  final DailyEntryStatus status;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = switch (status) {
      DailyEntryStatus.onTime => theme.extension<AppThemeExtension>()!.success,
      DailyEntryStatus.spokeTooLittle => theme.colorScheme.primary,
      DailyEntryStatus.burned => theme.colorScheme.error,
    };

    return DecoratedBox(
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withValues(alpha: 0.55)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: 4,
        ),
        child: Text(
          status.label,
          style: theme.textTheme.labelSmall?.copyWith(color: color),
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
