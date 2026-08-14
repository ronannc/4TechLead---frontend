import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:for_tech_lead/core/viewmodels/base_view_model.dart';
import 'package:for_tech_lead/features/teams/models/team.dart';
import 'package:for_tech_lead/features/teams/repositories/team_repository.dart';
import 'package:for_tech_lead/features/teams/screens/team_detail_body.dart';
import 'package:for_tech_lead/features/teams/viewmodels/team_detail_view_model.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';

class _MockTeamRepository extends Mock implements TeamRepository {}

void main() {
  testWidgets('keeps daily actions side by side on mobile width', (
    tester,
  ) async {
    await initializeDateFormatting('pt_BR');
    tester.view.physicalSize = const Size(390, 852);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final repository = _MockTeamRepository();
    when(
      () => repository.getTeam(
        1,
        peoplePage: 1,
        peoplePerPage: 10,
        peopleSearch: null,
      ),
    ).thenAnswer(
      (_) async => Team(
        id: 1,
        name: '4TechLead',
        createdAt: DateTime(2026),
        updatedAt: DateTime(2026),
      ),
    );

    final viewModel = TeamDetailViewModel(repository, 1);
    await viewModel.load();
    expect(viewModel.state, ViewState.loaded);

    await tester.pumpWidget(
      ChangeNotifierProvider<TeamDetailViewModel>.value(
        value: viewModel,
        child: const MaterialApp(home: Scaffold(body: TeamDetailBody())),
      ),
    );

    final startButton = tester.getRect(find.byType(ElevatedButton));
    final historyButton = tester.getRect(find.byType(OutlinedButton));

    expect(startButton.top, historyButton.top);
    expect(historyButton.left - startButton.right, closeTo(8, 0.1));
    expect(tester.takeException(), isNull);
  });
}
