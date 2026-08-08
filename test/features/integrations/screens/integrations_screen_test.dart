import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:for_tech_lead/bootstrap.dart';
import 'package:for_tech_lead/features/integrations/models/integration_models.dart';
import 'package:for_tech_lead/features/integrations/repositories/integration_repository.dart';
import 'package:for_tech_lead/features/integrations/screens/integrations_screen.dart';
import 'package:for_tech_lead/features/people/models/contract_type.dart';
import 'package:for_tech_lead/features/people/models/person.dart';
import 'package:for_tech_lead/features/people/models/seniority_level.dart';
import 'package:for_tech_lead/features/people/repositories/person_repository.dart';
import 'package:mocktail/mocktail.dart';

class _MockIntegrationRepository extends Mock
    implements IntegrationRepository {}

class _MockPersonRepository extends Mock implements PersonRepository {}

void main() {
  tearDown(getIt.reset);

  testWidgets('renders integration management sections', (tester) async {
    final integrationRepository = _MockIntegrationRepository();
    final personRepository = _MockPersonRepository();

    when(integrationRepository.getSystems).thenAnswer(
      (_) async => const [
        IntegrationSystem(
          id: 1,
          name: 'GitHub Produto',
          provider: 'github',
          tokenPrefix: 'abc12345',
          active: true,
        ),
      ],
    );
    when(integrationRepository.getExternalIdentities).thenAnswer(
      (_) async => const [
        PersonExternalIdentity(
          id: 1,
          personId: 1,
          integrationSystemId: 1,
          externalCode: 'lucas-github',
          active: true,
        ),
      ],
    );
    when(() => integrationRepository.getDeliveryMetrics()).thenAnswer(
      (_) async => const [
        PersonDeliveryMetric(
          id: 1,
          personId: 1,
          integrationSystemId: 1,
          metricType: 'code_quality_score',
          metricValue: 91,
          unit: 'score',
          sourceRef: 'org/repo#42',
        ),
      ],
    );
    when(
      () => personRepository.getPeople(page: 1, perPage: 100),
    ).thenAnswer((_) async => [_person()]);

    getIt.registerSingleton<IntegrationRepository>(integrationRepository);
    getIt.registerSingleton<PersonRepository>(personRepository);

    await tester.pumpWidget(const MaterialApp(home: IntegrationsScreen()));
    await tester.pumpAndSettle();

    expect(find.text('Integrações'), findsOneWidget);
    expect(find.text('Novo sistema'), findsOneWidget);
    expect(find.text('Vínculo externo'), findsOneWidget);
    expect(find.text('GitHub Produto', skipOffstage: false), findsWidgets);
    await tester.drag(find.byType(ListView), const Offset(0, -900));
    await tester.pumpAndSettle();
    expect(
      find.text('Qualidade do código'),
      findsOneWidget,
    );
    expect(tester.takeException(), isNull);
  });
}

Person _person() {
  return Person(
    id: 1,
    name: 'Lucas Farias',
    teamId: 1,
    position: 'Dev Front End',
    contractType: ContractType.clt,
    seniority: SeniorityLevel.junior,
    createdAt: DateTime(2026, 8, 8),
    updatedAt: DateTime(2026, 8, 8),
  );
}
