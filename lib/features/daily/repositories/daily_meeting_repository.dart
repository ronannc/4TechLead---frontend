import '../models/daily_meeting.dart';
import '../models/daily_meeting_entry.dart';
import '../models/daily_note_category.dart';
import '../services/daily_meeting_service.dart';

/// Safety cap on how many pages [getAllEntries] will follow. The API's
/// `per_page` ceiling is 100 (`ListParams::fromRequest`), and daily entries
/// keep growing over time (unlike the Home birthday card's fixed headcount),
/// so a single page can't be assumed to cover a team/person's full history.
/// This caps at ~1000 of the most recent entries rather than paging forever.
const int _maxStatsPages = 10;

/// Maps [DailyMeetingService]'s raw JSON into [DailyMeeting]/
/// [DailyMeetingEntry] instances.
class DailyMeetingRepository {
  DailyMeetingRepository(this._service);

  final DailyMeetingService _service;

  Future<List<DailyMeeting>> getMeetings({
    required int teamId,
    int page = 1,
    int perPage = 15,
  }) async {
    final json = await _service.index(
      teamId: teamId,
      page: page,
      perPage: perPage,
    );
    final data = json['data'] as List<dynamic>;

    return [
      for (final item in data)
        DailyMeeting.fromJson(item as Map<String, dynamic>),
    ];
  }

  Future<DailyMeeting> getMeeting(int id) async {
    final json = await _service.show(id);

    return DailyMeeting.fromJson(json['data'] as Map<String, dynamic>);
  }

  Future<DailyMeeting> createMeeting({
    required int teamId,
    required int timeLimitSeconds,
    required DateTime startedAt,
    required DateTime endedAt,
    required List<Map<String, dynamic>> entries,
  }) async {
    final json = await _service.store(
      teamId: teamId,
      timeLimitSeconds: timeLimitSeconds,
      startedAt: startedAt,
      endedAt: endedAt,
      entries: entries,
    );

    return DailyMeeting.fromJson(json['data'] as Map<String, dynamic>);
  }

  /// Follows `meta.last_page` up to [_maxStatsPages], collecting every entry
  /// along the way — used for stats, where truncating to a single page of
  /// 100 would silently understate older history.
  Future<List<DailyMeetingEntry>> getAllEntries({
    int? teamId,
    int? personId,
    int? dailyMeetingId,
    DailyNoteCategory? noteType,
  }) async {
    final entries = <DailyMeetingEntry>[];
    var page = 1;
    var lastPage = 1;

    do {
      final json = await _service.indexEntries(
        teamId: teamId,
        personId: personId,
        dailyMeetingId: dailyMeetingId,
        noteType: noteType,
        page: page,
        perPage: 100,
      );
      final data = json['data'] as List<dynamic>;
      entries.addAll(
        data.map(
          (item) => DailyMeetingEntry.fromJson(item as Map<String, dynamic>),
        ),
      );

      lastPage =
          (json['meta'] as Map<String, dynamic>?)?['last_page'] as int? ?? page;
      page++;
    } while (page <= lastPage && page <= _maxStatsPages);

    return entries;
  }
}
