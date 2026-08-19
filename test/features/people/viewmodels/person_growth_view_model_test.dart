import 'package:flutter_test/flutter_test.dart';
import 'package:for_tech_lead/core/viewmodels/base_view_model.dart';
import 'package:for_tech_lead/features/people/models/person_growth_models.dart';
import 'package:for_tech_lead/features/people/repositories/person_growth_repository.dart';
import 'package:for_tech_lead/features/people/viewmodels/person_growth_view_model.dart';
import 'package:mocktail/mocktail.dart';

class _MockPersonGrowthRepository extends Mock
    implements PersonGrowthRepository {}

void main() {
  late _MockPersonGrowthRepository repository;

  setUp(() {
    repository = _MockPersonGrowthRepository();
  });

  test(
    'loadPdiTracking() uses my development plans for member access',
    () async {
      const plans = [
        DevelopmentPlan(
          id: 1,
          personId: 10,
          title: 'PDI autonomia',
          status: 'active',
          progress: 30,
          items: [],
        ),
      ];
      when(
        () => repository.getMyDevelopmentPlans(),
      ).thenAnswer((_) async => plans);

      final viewModel = PersonGrowthViewModel(
        repository,
        10,
        canManageGrowth: false,
      );

      await viewModel.loadPdiTracking();

      expect(viewModel.state, ViewState.loaded);
      expect(viewModel.plans, plans);
      verify(() => repository.getMyDevelopmentPlans()).called(1);
      verifyNever(() => repository.getDevelopmentPlans(any()));
    },
  );
}
