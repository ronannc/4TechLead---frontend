import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:for_tech_lead/core/theme/app_theme.dart';
import 'package:for_tech_lead/core/viewmodels/base_view_model.dart';
import 'package:for_tech_lead/features/daily/models/daily_annotation_type.dart';
import 'package:for_tech_lead/features/daily/models/daily_entry_status.dart';
import 'package:for_tech_lead/features/daily/models/daily_meeting.dart';
import 'package:for_tech_lead/features/daily/models/daily_meeting_annotation.dart';
import 'package:for_tech_lead/features/daily/models/daily_meeting_entry.dart';
import 'package:for_tech_lead/features/daily/repositories/daily_meeting_repository.dart';
import 'package:for_tech_lead/features/daily/screens/daily_meeting_detail_body.dart';
import 'package:for_tech_lead/features/daily/viewmodels/daily_meeting_detail_view_model.dart';
import 'package:for_tech_lead/features/people/models/contract_type.dart';
import 'package:for_tech_lead/features/people/models/person.dart';
import 'package:for_tech_lead/features/people/models/seniority_level.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';

class _MockDailyMeetingRepository extends Mock
    implements DailyMeetingRepository {}

void main() {
  testWidgets('renders daily detail with system spacing and cards on mobile', (
    tester,
  ) async {
    await initializeDateFormatting('pt_BR');

    tester.view.physicalSize = const Size(393, 852);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final repository = _MockDailyMeetingRepository();
    when(() => repository.getMeeting(1)).thenAnswer((_) async => _meeting());

    final viewModel = DailyMeetingDetailViewModel(repository, 1);
    await viewModel.load();
    expect(viewModel.state, ViewState.loaded);

    await tester.pumpWidget(
      ChangeNotifierProvider<DailyMeetingDetailViewModel>.value(
        value: viewModel,
        child: MaterialApp(
          theme: AppTheme.dark(),
          home: const Scaffold(
            body: Padding(
              padding: EdgeInsets.all(16),
              child: DailyMeetingDetailBody(),
            ),
          ),
        ),
      ),
    );

    expect(find.text('Participantes'), findsOneWidget);
    expect(find.text('Ronan'), findsOneWidget);
    expect(find.text('Lucas Farias'), findsOneWidget);
    expect(find.text('Anotações'), findsOneWidget);
    expect(find.text('Falou bem'), findsOneWidget);
    expect(find.text('Aguardando staging'), findsOneWidget);
    expect(find.text('aberto'), findsOneWidget);
    expect(find.text('Webhook validado'), findsOneWidget);
    expect(find.text('Tópico levantado'), findsOneWidget);
    expect(find.byType(Card), findsNWidgets(3));
    expect(tester.takeException(), isNull);
  });
}

DailyMeeting _meeting() {
  final startedAt = DateTime(2026, 8, 9, 11, 25);
  final endedAt = startedAt.add(const Duration(minutes: 3));

  return DailyMeeting(
    id: 1,
    teamId: 1,
    timeLimitSeconds: 90,
    startedAt: startedAt,
    endedAt: endedAt,
    createdAt: startedAt,
    updatedAt: endedAt,
    entries: [
      _entry(
        id: 1,
        personId: 1,
        speakingOrder: 1,
        actualSeconds: 80,
        status: DailyEntryStatus.onTime,
        personName: 'Ronan',
      ),
      _entry(
        id: 2,
        personId: 2,
        speakingOrder: 2,
        actualSeconds: 120,
        status: DailyEntryStatus.burned,
        personName: 'Lucas Farias',
      ),
    ],
    annotations: [
      _annotation(
        id: 1,
        type: DailyAnnotationType.topic,
        text: 'Webhook validado',
      ),
      _annotation(
        id: 2,
        type: DailyAnnotationType.blocker,
        text: 'Aguardando staging',
      ),
    ],
  );
}

DailyMeetingEntry _entry({
  required int id,
  required int personId,
  required int speakingOrder,
  required int actualSeconds,
  required DailyEntryStatus status,
  required String personName,
}) {
  final now = DateTime(2026, 8, 9, 11, 25);

  return DailyMeetingEntry(
    id: id,
    dailyMeetingId: 1,
    teamId: 1,
    personId: personId,
    person: Person(
      id: personId,
      name: personName,
      teamId: 1,
      position: personName == 'Ronan' ? 'Tech Lead' : 'Dev Front End',
      contractType: ContractType.clt,
      seniority: SeniorityLevel.senior,
      createdAt: now,
      updatedAt: now,
    ),
    speakingOrder: speakingOrder,
    allottedSeconds: 90,
    actualSeconds: actualSeconds,
    status: status,
    createdAt: now,
    updatedAt: now,
  );
}

DailyMeetingAnnotation _annotation({
  required int id,
  required DailyAnnotationType type,
  required String text,
  bool resolved = false,
}) {
  final now = DateTime(2026, 8, 9, 11, 25);

  return DailyMeetingAnnotation(
    id: id,
    dailyMeetingId: 1,
    type: type,
    text: text,
    resolved: resolved,
    createdAt: now,
    updatedAt: now,
  );
}
