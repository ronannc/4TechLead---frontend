import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_theme_extension.dart';
import '../models/daily_annotation_type.dart';
import '../models/daily_entry_status.dart';
import '../models/daily_meeting.dart';
import '../models/daily_meeting_annotation.dart';
import '../models/daily_meeting_entry.dart';
import '../utils/daily_time_limit.dart';
import '../viewmodels/daily_meeting_detail_view_model.dart';

/// The loaded-state body of `DailyMeetingDetailScreen`: every turn and
/// annotation of one past meeting.
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
            _MeetingSummaryCard(meeting: meeting),
            const SizedBox(height: AppSpacing.sm),
            Expanded(
              child: ListView(
                children: [
                  Text('Participantes', style: theme.textTheme.titleMedium),
                  const SizedBox(height: AppSpacing.sm),
                  _EntriesList(entries: entries),
                  const SizedBox(height: AppSpacing.sm),
                  _AnnotationsSection(annotations: meeting.annotations),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class _MeetingSummaryCard extends StatelessWidget {
  const _MeetingSummaryCard({required this.meeting});

  final DailyMeeting meeting;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final duration = meeting.endedAt.difference(meeting.startedAt).inSeconds;

    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withValues(alpha: 0.14),
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
                  Text(
                    DailyMeetingDetailBody._dateFormat.format(
                      meeting.startedAt.toLocal(),
                    ),
                    style: theme.textTheme.titleMedium,
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    '${meeting.entries.length} participantes · '
                    '${formatDailyDuration(duration)} total',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  Text(
                    'Limite: ${formatDailyDuration(meeting.timeLimitSeconds)} por pessoa',
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

class _EntriesList extends StatelessWidget {
  const _EntriesList({required this.entries});

  final List<DailyMeetingEntry> entries;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (entries.isEmpty) {
      return Card(
        margin: EdgeInsets.zero,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Text(
            'Nenhum participante registrado.',
            style: theme.textTheme.bodyMedium,
          ),
        ),
      );
    }

    return Card(
      margin: EdgeInsets.zero,
      child: Column(
        children: [
          for (final (index, entry) in entries.indexed) ...[
            _EntryRow(entry: entry),
            if (index < entries.length - 1)
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

class _EntryRow extends StatelessWidget {
  const _EntryRow({required this.entry});

  final DailyMeetingEntry entry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(child: Text('${entry.speakingOrder}')),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  entry.person?.name ?? 'Pessoa #${entry.personId}',
                  style: theme.textTheme.titleSmall,
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  '${formatDailyDuration(entry.actualSeconds)} de '
                  '${formatDailyDuration(entry.allottedSeconds)}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          _StatusPill(status: entry.status),
        ],
      ),
    );
  }
}

class _AnnotationsSection extends StatelessWidget {
  const _AnnotationsSection({required this.annotations});

  final List<DailyMeetingAnnotation> annotations;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.extension<AppThemeExtension>()!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Anotações', style: theme.textTheme.titleMedium),
        const SizedBox(height: AppSpacing.sm),
        Card(
          margin: EdgeInsets.zero,
          child: annotations.isEmpty
              ? const Padding(
                  padding: EdgeInsets.all(AppSpacing.md),
                  child: Text('Nenhuma anotação registrada.'),
                )
              : Column(
                  children: [
                    for (final annotation in annotations)
                      ListTile(
                        dense: true,
                        leading: Icon(
                          annotation.type == DailyAnnotationType.blocker
                              ? Icons.report_problem_outlined
                              : Icons.chat_bubble_outline,
                          color: annotation.type == DailyAnnotationType.blocker
                              ? theme.colorScheme.error
                              : colors.success,
                        ),
                        title: Text(annotation.text),
                        subtitle: Text(annotation.type.label),
                        trailing: annotation.type == DailyAnnotationType.blocker
                            ? Text(annotation.resolved ? 'resolvido' : 'aberto')
                            : null,
                      ),
                  ],
                ),
        ),
      ],
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
          vertical: AppSpacing.xs,
        ),
        child: Text(
          status.label,
          style: theme.textTheme.labelSmall?.copyWith(color: color),
        ),
      ),
    );
  }
}
