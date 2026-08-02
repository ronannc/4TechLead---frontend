import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../core/routing/route_paths.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/cards/app_summary_card.dart';
import '../../../core/widgets/tables/app_data_table.dart';
import '../models/daily_meeting.dart';
import '../viewmodels/daily_history_view_model.dart';

/// The loaded-state body of `DailyHistoryScreen`: aggregated team stats up
/// top (the one sanctioned `Card` use), past meetings below as a searchable
/// list/table.
class DailyHistoryBody extends StatefulWidget {
  const DailyHistoryBody({super.key, required this.teamId});

  final String teamId;

  @override
  State<DailyHistoryBody> createState() => _DailyHistoryBodyState();
}

class _DailyHistoryBodyState extends State<DailyHistoryBody> {
  String _query = '';
  static final _dateFormat = DateFormat.yMMMd('pt_BR').add_Hm();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final viewModel = context.watch<DailyHistoryViewModel>();
    final stats = viewModel.stats;

    final meetings = _query.isEmpty
        ? viewModel.meetings
        : viewModel.meetings
              .where(
                (meeting) => _dateFormat
                    .format(meeting.startedAt.toLocal())
                    .toLowerCase()
                    .contains(_query.toLowerCase()),
              )
              .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              AppSummaryCard(
                icon: Icons.event_repeat,
                value: '${viewModel.meetings.length}',
                label: 'Dailies realizadas',
              ),
              const SizedBox(width: AppSpacing.md),
              AppSummaryCard(
                icon: Icons.check_circle_outline,
                value: '${stats.onTimePercentage.round()}%',
                label: 'No tempo',
              ),
              const SizedBox(width: AppSpacing.md),
              AppSummaryCard(
                icon: Icons.local_fire_department_outlined,
                value: '${stats.burnedPercentage.round()}%',
                label: 'Queimaram o tempo',
              ),
              const SizedBox(width: AppSpacing.md),
              AppSummaryCard(
                icon: Icons.record_voice_over_outlined,
                value: '${stats.spokeTooLittlePercentage.round()}%',
                label: 'Falaram pouco',
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        if (viewModel.rankingsByBurned.isNotEmpty) ...[
          Text(
            'Quem mais queima o tempo: '
            '${viewModel.personName(viewModel.rankingsByBurned.first.personId)}',
            style: theme.textTheme.bodyMedium,
          ),
          Text(
            'Quem fala pouco com mais frequência: '
            '${viewModel.personName(viewModel.rankingsBySpokeTooLittle.first.personId)}',
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: AppSpacing.md),
        ],
        Expanded(
          child: AppDataTable<DailyMeeting>(
            items: meetings,
            title: 'Dailies passadas',
            subtitle: 'Histórico pesquisável das reuniões registradas.',
            itemIcon: Icons.timer_outlined,
            itemCountLabel: (count) =>
                count == 1 ? '1 daily' : '$count dailies',
            onSearchChanged: (query) => setState(() => _query = query),
            searchHint: 'Buscar por data...',
            emptyMessage: 'Nenhuma daily registrada ainda.',
            onRowTap: (meeting) => context.push(
              RoutePaths.dailyMeetingDetailPath(widget.teamId, '${meeting.id}'),
            ),
            columns: [
              AppDataColumn(
                label: 'Data',
                cellBuilder: (meeting) =>
                    _dateFormat.format(meeting.startedAt.toLocal()),
              ),
              AppDataColumn(
                label: 'Participantes',
                cellBuilder: (meeting) => '${meeting.entries.length}',
              ),
            ],
          ),
        ),
      ],
    );
  }
}
