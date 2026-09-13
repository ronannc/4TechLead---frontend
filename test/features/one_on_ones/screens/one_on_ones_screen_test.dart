import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:for_tech_lead/bootstrap.dart';
import 'package:for_tech_lead/core/auth/auth_session.dart';
import 'package:for_tech_lead/features/one_on_ones/screens/one_on_ones_screen.dart';
import 'package:for_tech_lead/features/people/repositories/person_growth_repository.dart';
import 'package:for_tech_lead/features/people/repositories/person_repository.dart';
import 'package:mocktail/mocktail.dart';

class _MockAuthSession extends Mock implements AuthSession {}

class _MockPersonGrowthRepository extends Mock
    implements PersonGrowthRepository {}

class _MockPersonRepository extends Mock implements PersonRepository {}

void main() {
  testWidgets('document fields sit outside cards and the notes field resizes', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(getIt.reset);

    final authSession = _MockAuthSession();
    final growthRepository = _MockPersonGrowthRepository();
    final personRepository = _MockPersonRepository();
    when(() => authSession.isTechLead).thenReturn(true);
    when(() => authSession.personId).thenReturn(null);
    when(growthRepository.getTemplates).thenAnswer((_) async => []);
    when(
      () => growthRepository.getSessions(
        personId: null,
        status: 'completed',
        perPage: 50,
      ),
    ).thenAnswer((_) async => []);
    when(
      () => growthRepository.getPersonOneOnOneNotes(
        personId: null,
        status: 'open',
      ),
    ).thenAnswer((_) async => []);
    when(
      () => personRepository.getPeople(perPage: 100),
    ).thenAnswer((_) async => []);

    getIt.registerSingleton<AuthSession>(authSession);
    getIt.registerSingleton<PersonGrowthRepository>(growthRepository);
    getIt.registerSingleton<PersonRepository>(personRepository);

    await tester.pumpWidget(const MaterialApp(home: OneOnOnesScreen()));
    await tester.pumpAndSettle();

    final questionField = find.byWidgetPredicate(
      (widget) =>
          widget is TextField &&
          widget.decoration?.labelText == 'Perguntas e tópicos, um por linha',
    );
    expect(questionField, findsOneWidget);
    expect(
      find.ancestor(of: questionField, matching: find.byType(Card)),
      findsNothing,
    );

    final initialHeight = tester.getSize(questionField).height;
    await tester.drag(
      find.byTooltip('Arraste para ajustar a altura'),
      const Offset(0, 64),
    );
    await tester.pumpAndSettle();

    expect(tester.getSize(questionField).height, greaterThan(initialHeight));
    expect(tester.takeException(), isNull);
  });
}
