import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/buttons/app_primary_button.dart';
import '../../people/models/person.dart';
import '../utils/daily_time_limit.dart';
import '../viewmodels/daily_session_view_model.dart';

class DailyConfigBody extends StatelessWidget {
  const DailyConfigBody({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Selector<DailySessionViewModel, List<Person>>(
            selector: (_, vm) => vm.members,
            builder: (context, members, _) => Card(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Row(
                  children: [
                    Icon(
                      Icons.groups_outlined,
                      color: theme.colorScheme.primary,
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Text(
                        '${members.length} participantes presentes',
                        style: theme.textTheme.titleMedium,
                      ),
                    ),
                    Selector<DailySessionViewModel, int>(
                      selector: (_, vm) => vm.timeLimitSeconds,
                      builder: (context, seconds, _) => Text(
                        formatDailyDuration(seconds),
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Text('Tempo por pessoa', style: theme.textTheme.titleMedium),
          const SizedBox(height: AppSpacing.sm),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Selector<DailySessionViewModel, int>(
                selector: (_, vm) => vm.timeLimitSeconds,
                builder: (context, timeLimitSeconds, _) {
                  final viewModel = context.read<DailySessionViewModel>();

                  return Row(
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
                              'limite individual',
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
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text('Ordem de fala', style: theme.textTheme.titleMedium),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Arraste para reorganizar antes de iniciar.',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Expanded(
            child: Selector<DailySessionViewModel, List<Person>>(
              selector: (_, vm) => vm.members,
              builder: (context, members, _) {
                if (members.isEmpty) {
                  return const Center(
                    child: Text(
                      'Este time ainda não tem integrantes cadastrados.',
                    ),
                  );
                }

                final viewModel = context.read<DailySessionViewModel>();

                return ReorderableListView.builder(
                  itemCount: members.length,
                  onReorderItem: viewModel.reorderMembers,
                  buildDefaultDragHandles: false,
                  itemBuilder: (context, index) {
                    final member = members[index];

                    return Card(
                      key: ValueKey(member.id),
                      child: ListTile(
                        leading: CircleAvatar(child: Text('${index + 1}')),
                        title: Text(member.name),
                        subtitle: Text(member.position),
                        trailing: ReorderableDragStartListener(
                          index: index,
                          child: const Icon(Icons.drag_indicator),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Selector<DailySessionViewModel, List<Person>>(
            selector: (_, vm) => vm.members,
            builder: (context, members, _) {
              final viewModel = context.read<DailySessionViewModel>();

              return AppPrimaryButton(
                label: 'Iniciar daily',
                onPressed: members.isEmpty ? null : viewModel.start,
              );
            },
          ),
        ],
      ),
    );
  }
}
