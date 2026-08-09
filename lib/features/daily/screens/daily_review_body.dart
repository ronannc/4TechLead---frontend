import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_theme_extension.dart';
import '../../../core/widgets/buttons/app_primary_button.dart';
import '../models/daily_blocker_draft.dart';
import '../utils/daily_stats.dart';
import '../utils/daily_time_limit.dart';
import '../viewmodels/daily_session_view_model.dart';

/// Final review before saving: every completed turn with the time used and
/// its (locally previewed) status, plus the save action. A save failure
/// keeps this exact screen up with an inline error + retry — see
/// [DailySessionViewModel.save]'s doc comment for why.
class DailyReviewBody extends StatelessWidget {
  const DailyReviewBody({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final viewModel = context.read<DailySessionViewModel>();
    final spokenTurns = viewModel.turns
        .where((turn) => turn.hasSpoken)
        .toList();

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Revisão da daily', style: theme.textTheme.titleLarge),
          const SizedBox(height: AppSpacing.sm),
          Expanded(
            child: ListView(
              children: [
                Text('Participantes', style: theme.textTheme.titleMedium),
                const SizedBox(height: AppSpacing.sm),
                if (spokenTurns.isEmpty)
                  const Card(
                    margin: EdgeInsets.zero,
                    child: Padding(
                      padding: EdgeInsets.all(AppSpacing.md),
                      child: Center(child: Text('Ninguém falou nesta daily.')),
                    ),
                  )
                else
                  Card(
                    margin: EdgeInsets.zero,
                    child: Column(
                      children: [
                        for (final turn in spokenTurns)
                          ListTile(
                            title: Text(turn.person.name),
                            subtitle: Text(
                              '${formatDailyDuration(turn.actualSeconds!)} de '
                              '${formatDailyDuration(turn.allowedSeconds)}',
                            ),
                            trailing: Text(
                              computeDraftStatus(
                                allottedSeconds: turn.allowedSeconds,
                                actualSeconds: turn.actualSeconds!,
                              ).label,
                            ),
                          ),
                      ],
                    ),
                  ),
                const SizedBox(height: AppSpacing.sm),
                _TopicsReview(topics: viewModel.topics),
                const SizedBox(height: AppSpacing.sm),
                _BlockersReview(blockers: viewModel.blockers),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Selector<DailySessionViewModel, bool>(
            selector: (_, vm) => vm.isSaving,
            builder: (context, isSaving, _) {
              final vm = context.read<DailySessionViewModel>();

              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (vm.saveErrorMessage != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                      child: Text(
                        vm.saveErrorMessage!,
                        style: TextStyle(color: theme.colorScheme.error),
                      ),
                    ),
                  AppPrimaryButton(
                    label: vm.saveErrorMessage != null
                        ? 'Tentar novamente'
                        : 'Salvar',
                    loading: isSaving,
                    onPressed: vm.save,
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _TopicsReview extends StatelessWidget {
  const _TopicsReview({required this.topics});

  final List<String> topics;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Tópicos levantados', style: theme.textTheme.titleMedium),
        const SizedBox(height: AppSpacing.sm),
        Card(
          margin: EdgeInsets.zero,
          child: topics.isEmpty
              ? const Padding(
                  padding: EdgeInsets.all(AppSpacing.md),
                  child: Text('Nenhum tópico registrado.'),
                )
              : Column(
                  children: [
                    for (final topic in topics)
                      ListTile(
                        dense: true,
                        leading: const Icon(Icons.chat_bubble_outline),
                        title: Text(topic),
                      ),
                  ],
                ),
        ),
      ],
    );
  }
}

class _BlockersReview extends StatelessWidget {
  const _BlockersReview({required this.blockers});

  final List<DailyBlockerDraft> blockers;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.extension<AppThemeExtension>()!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Bloqueios', style: theme.textTheme.titleMedium),
        const SizedBox(height: AppSpacing.sm),
        Card(
          margin: EdgeInsets.zero,
          child: blockers.isEmpty
              ? const Padding(
                  padding: EdgeInsets.all(AppSpacing.md),
                  child: Text('Nenhum bloqueio registrado.'),
                )
              : Column(
                  children: [
                    for (final blocker in blockers)
                      ListTile(
                        dense: true,
                        leading: Icon(
                          blocker.resolved
                              ? Icons.check_circle_outline
                              : Icons.error_outline,
                          color: blocker.resolved
                              ? colors.success
                              : theme.colorScheme.error,
                        ),
                        title: Text(
                          blocker.text,
                          style: TextStyle(
                            decoration: blocker.resolved
                                ? TextDecoration.lineThrough
                                : null,
                          ),
                        ),
                        trailing: Text(
                          blocker.resolved ? 'resolvido' : 'aberto',
                        ),
                      ),
                  ],
                ),
        ),
      ],
    );
  }
}
