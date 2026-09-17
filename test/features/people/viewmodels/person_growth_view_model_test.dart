import 'dart:async';

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

  test(
    'ignores concurrent PDI creation while the first request is pending',
    () async {
      final request = Completer<DevelopmentPlan>();
      when(
        () => repository.createDevelopmentPlan(
          personId: 10,
          title: 'PDI autonomia',
          summary: null,
          targetRole: null,
        ),
      ).thenAnswer((_) => request.future);
      when(
        () => repository.getDevelopmentPlans(10),
      ).thenAnswer((_) async => []);

      final viewModel = PersonGrowthViewModel(repository, 10);
      final first = viewModel.createPlan(title: 'PDI autonomia');
      final second = viewModel.createPlan(title: 'PDI autonomia');

      expect(await second, isFalse);
      request.complete(
        const DevelopmentPlan(
          id: 1,
          personId: 10,
          title: 'PDI autonomia',
          status: 'active',
          progress: 0,
        ),
      );
      expect(await first, isTrue);
      verify(
        () => repository.createDevelopmentPlan(
          personId: 10,
          title: 'PDI autonomia',
          summary: null,
          targetRole: null,
        ),
      ).called(1);
    },
  );
}
