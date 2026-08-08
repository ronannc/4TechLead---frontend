import 'package:flutter_test/flutter_test.dart';
import 'package:for_tech_lead/core/network/api_exception.dart';
import 'package:for_tech_lead/core/viewmodels/base_view_model.dart';
import 'package:for_tech_lead/features/integrations/models/integration_models.dart';
import 'package:for_tech_lead/features/integrations/repositories/integration_repository.dart';
import 'package:for_tech_lead/features/integrations/viewmodels/integrations_view_model.dart';
import 'package:for_tech_lead/features/people/repositories/person_repository.dart';
import 'package:mocktail/mocktail.dart';

class _MockIntegrationRepository extends Mock
    implements IntegrationRepository {}

class _MockPersonRepository extends Mock implements PersonRepository {}

void main() {
  late _MockIntegrationRepository integrationRepository;
  late _MockPersonRepository personRepository;
  late IntegrationsViewModel viewModel;

  const system = IntegrationSystem(
    id: 1,
    name: 'GitHub Produto',
    provider: 'github',
    tokenPrefix: 'abc12345',
    active: true,
  );

  setUp(() {
    integrationRepository = _MockIntegrationRepository();
    personRepository = _MockPersonRepository();
    viewModel = IntegrationsViewModel(integrationRepository, personRepository);
  });

  test(
    'createSystem() keeps loaded data visible when the mutation fails',
    () async {
      when(
        integrationRepository.getSystems,
      ).thenAnswer((_) async => const [system]);
      when(
        () => personRepository.getPeople(perPage: 100),
      ).thenAnswer((_) async => const []);
      when(
        integrationRepository.getExternalIdentities,
      ).thenAnswer((_) async => const []);
      when(
        integrationRepository.getDeliveryMetrics,
      ).thenAnswer((_) async => const []);
      await viewModel.load();

      when(
        () => integrationRepository.createSystem(
          name: 'ClickUp',
          provider: 'clickup',
          description: null,
        ),
      ).thenThrow(
        ValidationException({
          'name': ['Nome já cadastrado.'],
        }),
      );

      final saved = await viewModel.createSystem(
        name: 'ClickUp',
        provider: 'clickup',
      );

      expect(saved, isFalse);
      expect(viewModel.state, ViewState.loaded);
      expect(viewModel.systems, const [system]);
      expect(viewModel.actionErrorMessage, 'Nome já cadastrado.');
      expect(viewModel.isMutating, isFalse);
    },
  );
}
