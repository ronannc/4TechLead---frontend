import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:for_tech_lead/core/theme/app_theme.dart';
import 'package:for_tech_lead/core/viewmodels/base_view_model.dart';
import 'package:for_tech_lead/features/teams/models/team.dart';
import 'package:for_tech_lead/features/teams/repositories/team_repository.dart';
import 'package:for_tech_lead/features/teams/screens/teams_list_body.dart';
import 'package:for_tech_lead/features/teams/viewmodels/teams_list_view_model.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';

class _MockTeamRepository extends Mock implements TeamRepository {}

void main() {
  testWidgets('formats the created date in Portuguese', (tester) async {
    await initializeDateFormatting('pt_BR');

    final repository = _MockTeamRepository();
    when(() => repository.getTeams(page: 1, perPage: null)).thenAnswer(
      (_) async => [
        Team(
          id: 1,
          name: 'Frontend',
          createdAt: DateTime(2026, 1, 1, 10),
          updatedAt: DateTime(2026, 1, 1, 10),
        ),
      ],
    );

    final viewModel = TeamsListViewModel(repository);
    await viewModel.load();
    expect(viewModel.state, ViewState.loaded);

    await tester.pumpWidget(
      ChangeNotifierProvider<TeamsListViewModel>.value(
        value: viewModel,
        child: MaterialApp(
          theme: AppTheme.light(),
          home: const Scaffold(
            body: SizedBox(height: 480, child: TeamsListBody()),
          ),
        ),
      ),
    );

    expect(find.text('Frontend'), findsOneWidget);
    expect(find.text('1 de jan. de 2026 10:00'), findsOneWidget);
    expect(find.textContaining('2026-01-01'), findsNothing);
  });
}
