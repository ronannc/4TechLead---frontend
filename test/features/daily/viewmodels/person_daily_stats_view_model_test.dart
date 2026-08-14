import 'package:flutter_test/flutter_test.dart';
import 'package:for_tech_lead/core/viewmodels/base_view_model.dart';
import 'package:for_tech_lead/features/daily/viewmodels/person_daily_stats_view_model.dart';
import 'package:for_tech_lead/features/people/models/person.dart';

void main() {
  late PersonDailyStatsViewModel viewModel;

  setUp(() {
    viewModel = PersonDailyStatsViewModel();
  });

  test('setStats() exposes the summary returned by the API', () {
    viewModel.setStats(
      const PersonDailyStatsSummary(
        entryCount: 2,
        averageActualSeconds: 110,
        onTimePercentage: 50,
        burnedPercentage: 50,
        spokeTooLittlePercentage: 0,
      ),
    );

    expect(viewModel.state, ViewState.loaded);
    expect(viewModel.stats.entryCount, 2);
    expect(viewModel.stats.averageActualSeconds, 110);
    expect(viewModel.stats.burnedPercentage, 50);
  });

  test('setStats() falls back to an empty summary when the API omits it', () {
    viewModel.setStats(null);

    expect(viewModel.state, ViewState.loaded);
    expect(viewModel.stats.entryCount, 0);
    expect(viewModel.stats.averageActualSeconds, 0);
    expect(viewModel.stats.onTimePercentage, 0);
  });
}
