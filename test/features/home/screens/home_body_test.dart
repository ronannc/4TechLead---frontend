import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:for_tech_lead/core/viewmodels/base_view_model.dart';
import 'package:for_tech_lead/features/home/screens/home_body.dart';
import 'package:for_tech_lead/features/home/viewmodels/home_view_model.dart';
import 'package:for_tech_lead/features/people/models/contract_type.dart';
import 'package:for_tech_lead/features/people/models/person.dart';
import 'package:for_tech_lead/features/people/models/seniority_level.dart';
import 'package:for_tech_lead/features/people/repositories/person_repository.dart';
import 'package:for_tech_lead/features/teams/models/team.dart';
import 'package:for_tech_lead/features/teams/repositories/team_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';

class _MockTeamRepository extends Mock implements TeamRepository {}

class _MockPersonRepository extends Mock implements PersonRepository {}

Person _person(String name) {
  return Person(
    id: name.hashCode,
    name: name,
    teamId: 1,
    position: 'Software Engineer',
    contractType: ContractType.clt,
    seniority: SeniorityLevel.senior,
    createdAt: DateTime(2026),
    updatedAt: DateTime(2026),
  );
}

void main() {
  testWidgets('metric cards do not overflow on mobile width', (tester) async {
    tester.view.physicalSize = const Size(393, 852);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final teamRepository = _MockTeamRepository();
    final personRepository = _MockPersonRepository();
    when(teamRepository.getTeams).thenAnswer(
      (_) async => [
        Team(
          id: 1,
          name: 'Engineering',
          createdAt: DateTime(2026),
          updatedAt: DateTime(2026),
        ),
      ],
    );
    when(() => personRepository.getPeople(perPage: 100)).thenAnswer(
      (_) async => [_person('Ada'), _person('Grace'), _person('Katherine')],
    );

    final viewModel = HomeViewModel(teamRepository, personRepository);
    await viewModel.load();
    expect(viewModel.state, ViewState.loaded);

    await tester.pumpWidget(
      ChangeNotifierProvider<HomeViewModel>.value(
        value: viewModel,
        child: const MaterialApp(home: Scaffold(body: HomeBody())),
      ),
    );

    const expectedOuterGap = 16.0;
    const expectedInnerGap = 8.0;
    final dailyCard = tester.getRect(find.byType(Card).at(0));
    final peopleCard = tester.getRect(find.byType(Card).at(1));
    final teamsCard = tester.getRect(find.byType(Card).at(2));

    expect(find.text('Pessoas cadastradas'), findsOneWidget);
    expect(find.text('Times ativos'), findsOneWidget);
    expect(find.text('Ritual'), findsNothing);
    expect(find.text('disponível'), findsNothing);
    expect(dailyCard.left, expectedOuterGap);
    expect(dailyCard.top, expectedOuterGap);
    expect(393 - dailyCard.right, expectedOuterGap);
    expect(peopleCard.left, expectedOuterGap);
    expect(peopleCard.top - dailyCard.bottom, expectedInnerGap);
    expect(teamsCard.left - peopleCard.right, expectedInnerGap);
    expect(393 - teamsCard.right, expectedOuterGap);

    expect(tester.takeException(), isNull);
  });
}
