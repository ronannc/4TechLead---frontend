import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../bootstrap.dart';
import '../../../core/viewmodels/base_view_model.dart';
import '../../../core/widgets/states/error_view.dart';
import '../../../core/widgets/states/loading_view.dart';
import '../../teams/repositories/team_repository.dart';
import '../viewmodels/home_view_model.dart';
import 'home_body.dart';

/// Dashboard landing screen: summary cards (above the fold, per the
/// tech-lead-first design — quick-glance numbers over a chart) followed by
/// a trend placeholder. Screen only ever depends on [HomeViewModel] and
/// [TeamRepository] (the single DI wiring point below).
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => HomeViewModel(getIt<TeamRepository>())..load(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Home')),
        body: Selector<HomeViewModel, ViewState>(
          selector: (_, vm) => vm.state,
          builder: (context, state, _) {
            final viewModel = context.read<HomeViewModel>();

            return switch (state) {
              ViewState.idle || ViewState.loading => const LoadingView(),
              ViewState.error => ErrorView(
                message: viewModel.errorMessage ?? 'Something went wrong.',
                onRetry: viewModel.load,
              ),
              ViewState.loaded => const HomeBody(),
            };
          },
        ),
      ),
    );
  }
}
