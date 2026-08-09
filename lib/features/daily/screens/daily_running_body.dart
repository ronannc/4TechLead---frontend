import 'package:flutter/foundation.dart';
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
import 'daily_timer_ring.dart';

enum _DailyAnnotationKind { topic, blocker }

extension on _DailyAnnotationKind {
  String get fieldLabel => switch (this) {
    _DailyAnnotationKind.topic => 'Tópico levantado',
    _DailyAnnotationKind.blocker => 'Bloqueio',
  };

  String get hintText => switch (this) {
    _DailyAnnotationKind.topic => 'Ex.: Finalizou integração do webhook',
    _DailyAnnotationKind.blocker => 'Ex.: Aguardando credencial de staging',
  };

  String get helperText => switch (this) {
    _DailyAnnotationKind.topic =>
      'Registre um assunto que precisa de alinhamento depois da rodada.',
    _DailyAnnotationKind.blocker =>
      'Registre um impedimento que precisa sair da daily com responsável.',
  };

  String get addTooltip => switch (this) {
    _DailyAnnotationKind.topic => 'Adicionar tópico',
    _DailyAnnotationKind.blocker => 'Adicionar bloqueio',
  };
}

class DailyRunningBody extends StatefulWidget {
  const DailyRunningBody({super.key});

  @override
  State<DailyRunningBody> createState() => _DailyRunningBodyState();
}

class _DailyRunningBodyState extends State<DailyRunningBody> {
  final _annotationController = TextEditingController();
  _DailyAnnotationKind _annotationKind = _DailyAnnotationKind.topic;

  @override
  void dispose() {
    _annotationController.dispose();
    super.dispose();
  }

  void _submitAnnotation(DailySessionViewModel viewModel, String rawText) {
    final text = rawText.trim();
    if (text.isEmpty) {
      return;
    }

    if (_annotationKind == _DailyAnnotationKind.topic) {
      viewModel.addTopic(text);
    } else {
      viewModel.addBlocker(text);
    }

    _annotationController.clear();
    FocusScope.of(context).unfocus();
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
              const SizedBox(height: AppSpacing.sm),
              _TimerPanel(
                allowedSeconds: turn.allowedSeconds,
                elapsedSeconds: viewModel.elapsedSeconds,
              ),
              const SizedBox(height: AppSpacing.sm),
              const _PauseBanner(),
              const SizedBox(height: AppSpacing.sm),
              _ParticipantsStrip(turns: viewModel.turns, currentIndex: index),
              const SizedBox(height: AppSpacing.sm),
              Row(
                children: [
                  Expanded(
                    child: Selector<DailySessionViewModel, bool>(
                      selector: (_, vm) => vm.isPaused,
                      builder: (context, isPaused, _) => OutlinedButton.icon(
                        onPressed: viewModel.togglePause,
                        icon: Icon(
                          isPaused
                              ? Icons.play_arrow_outlined
                              : Icons.pause_outlined,
                        ),
                        label: Text(
                          isPaused ? 'Retomar timer' : 'Pausar timer',
                        ),
                      ),
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
              const SizedBox(height: AppSpacing.sm),
              _AnnotationComposer(
                kind: _annotationKind,
                controller: _annotationController,
                onKindChanged: (kind) => setState(() => _annotationKind = kind),
                onAdd: (text) => _submitAnnotation(viewModel, text),
              ),
              const SizedBox(height: AppSpacing.sm),
              Selector<
                DailySessionViewModel,
                ({List<String> topics, List<DailyBlockerDraft> blockers})
              >(
                selector: (_, vm) => (topics: vm.topics, blockers: vm.blockers),
                builder: (context, notes, _) => _AnnotationList(
                  topics: notes.topics,
                  blockers: notes.blockers,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Use tópico levantado para registrar assuntos que exigem alinhamento. Use bloqueio quando algo precisar sair da daily com dono.',
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

class _TimerPanel extends StatelessWidget {
  const _TimerPanel({
    required this.allowedSeconds,
    required this.elapsedSeconds,
  });

  final int allowedSeconds;
  final ValueListenable<int> elapsedSeconds;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.lg,
        ),
        child: Center(
          child: DailyTimerRing(
            allowedSeconds: allowedSeconds,
            elapsedSeconds: elapsedSeconds,
          ),
        ),
      ),
    );
  }
}

class _PauseBanner extends StatelessWidget {
  const _PauseBanner();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Selector<DailySessionViewModel, bool>(
      selector: (_, vm) => vm.isPaused,
      builder: (context, isPaused, _) {
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 180),
          child: isPaused
              ? Container(
                  key: const ValueKey('daily-paused-banner'),
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: AppSpacing.sm,
                  ),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.secondaryContainer,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.pause_circle_filled,
                        color: theme.colorScheme.onSecondaryContainer,
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: Text(
                          'Timer pausado. Retome quando quiser continuar este turno.',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSecondaryContainer,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : Text(
                  'Pause o timer se a conversa sair da daily ou precisar interromper o turno atual.',
                  key: const ValueKey('daily-running-hint'),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
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
    final status = ValueListenableBuilder<int>(
      valueListenable: context.read<DailySessionViewModel>().elapsedSeconds,
      builder: (context, elapsed, _) {
        final status = computeDraftStatus(
          allottedSeconds: turn.allowedSeconds,
          actualSeconds: elapsed,
        );

        return _StatusPill(status: status);
      },
    );
    final identity = Row(
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
              Text(
                turn.person.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.titleLarge,
              ),
              Text(
                turn.person.position,
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
    );

    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth < 360) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  identity,
                  const SizedBox(height: AppSpacing.sm),
                  Align(alignment: Alignment.centerLeft, child: status),
                ],
              );
            }

            return Row(
              children: [
                Expanded(child: identity),
                const SizedBox(width: AppSpacing.md),
                status,
              ],
            );
          },
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

class _AnnotationComposer extends StatelessWidget {
  const _AnnotationComposer({
    required this.kind,
    required this.controller,
    required this.onKindChanged,
    required this.onAdd,
  });

  final _DailyAnnotationKind kind;
  final TextEditingController controller;
  final ValueChanged<_DailyAnnotationKind> onKindChanged;
  final ValueChanged<String> onAdd;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Anotações da daily', style: theme.textTheme.titleMedium),
            const SizedBox(height: AppSpacing.sm),
            SegmentedButton<_DailyAnnotationKind>(
              segments: const [
                ButtonSegment(
                  value: _DailyAnnotationKind.topic,
                  icon: Icon(Icons.chat_bubble_outline),
                  label: Text('Tópico'),
                ),
                ButtonSegment(
                  value: _DailyAnnotationKind.blocker,
                  icon: Icon(Icons.report_problem_outlined),
                  label: Text('Bloqueio'),
                ),
              ],
              selected: {kind},
              onSelectionChanged: (selection) =>
                  onKindChanged(selection.single),
            ),
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    decoration: InputDecoration(
                      labelText: kind.fieldLabel,
                      hintText: kind.hintText,
                      helperText: kind.helperText,
                    ),
                    onSubmitted: onAdd,
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                IconButton.filled(
                  tooltip: kind.addTooltip,
                  onPressed: () => onAdd(controller.text),
                  icon: Icon(
                    kind == _DailyAnnotationKind.blocker
                        ? Icons.report_problem_outlined
                        : Icons.add_comment_outlined,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _AnnotationList extends StatelessWidget {
  const _AnnotationList({required this.topics, required this.blockers});

  final List<String> topics;
  final List<DailyBlockerDraft> blockers;

  @override
  Widget build(BuildContext context) {
    if (topics.isEmpty && blockers.isEmpty) {
      return const SizedBox.shrink();
    }

    final viewModel = context.read<DailySessionViewModel>();

    return Card(
      margin: EdgeInsets.zero,
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
              subtitle: const Text('Bloqueio'),
              secondary: const Icon(Icons.report_problem_outlined),
              controlAffinity: ListTileControlAffinity.leading,
            ),
          for (final topic in topics)
            ListTile(
              dense: true,
              leading: const Icon(Icons.chat_bubble_outline),
              title: Text(topic),
              subtitle: const Text('Tópico levantado'),
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
