import '../../../core/viewmodels/base_view_model.dart';
import '../models/daily_meeting.dart';
import '../repositories/daily_meeting_repository.dart';

/// Backs `DailyMeetingDetailScreen` — a single past meeting with its turns
/// and notes.
class DailyMeetingDetailViewModel extends BaseViewModel {
  DailyMeetingDetailViewModel(this._repository, this.meetingId);

  final DailyMeetingRepository _repository;
  final int meetingId;

  DailyMeeting? _meeting;
  DailyMeeting? get meeting => _meeting;

  Future<void> load() => runCatching(() async {
    _meeting = await _repository.getMeeting(meetingId);
  });
}
