import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_spacing.dart';
import '../models/daily_meeting.dart';
import '../utils/daily_time_limit.dart';
import '../viewmodels/daily_meeting_detail_view_model.dart';

/// The loaded-state body of `DailyMeetingDetailScreen`: every turn of one
/// past meeting, with its note (if any).
class DailyMeetingDetailBody extends StatelessWidget {
  const DailyMeetingDetailBody({super.key});

  static final _dateFormat = DateFormat.yMMMd('pt_BR').add_Hm();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Selector<DailyMeetingDetailViewModel, DailyMeeting?>(
      selector: (_, vm) => vm.meeting,
      builder: (context, meeting, _) {
        if (meeting == null) {
          return const SizedBox.shrink();
        }

        final entries = [...meeting.entries]
          ..sort((a, b) => a.speakingOrder.compareTo(b.speakingOrder));

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _dateFormat.format(meeting.startedAt.toLocal()),
              style: theme.textTheme.headlineSmall,
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'Limite: ${formatDailyDuration(meeting.timeLimitSeconds)} por pessoa',
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: AppSpacing.lg),
            Expanded(
              child: ListView.separated(
                itemCount: entries.length,
                separatorBuilder: (_, _) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final entry = entries[index];

                  return ListTile(
                    title: Text(
                      entry.person?.name ?? 'Pessoa #${entry.personId}',
                    ),
                    subtitle: Text(
                      '${formatDailyDuration(entry.actualSeconds)} de '
                      '${formatDailyDuration(entry.allottedSeconds)} — ${entry.status.label}'
                      '${entry.note != null ? '\n${entry.noteType?.label}: ${entry.note}' : ''}',
                    ),
                    isThreeLine: entry.note != null,
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
