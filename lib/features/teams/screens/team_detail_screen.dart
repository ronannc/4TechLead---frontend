import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../bootstrap.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/viewmodels/base_view_model.dart';
import '../../../core/widgets/states/error_view.dart';
import '../../../core/widgets/states/loading_view.dart';
import '../repositories/team_repository.dart';
import '../viewmodels/team_detail_view_model.dart';
import 'team_detail_body.dart';

/// Screen only ever depends on [TeamDetailViewModel] and [TeamRepository]
/// (for the single DI wiring point below) — never on `TeamService`.
class TeamDetailScreen extends StatelessWidget {
  const TeamDetailScreen({super.key, required this.teamId});

  final String teamId;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TeamDetailViewModel(getIt<TeamRepository>(), int.parse(teamId))..load(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Team')),
        body: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Selector<TeamDetailViewModel, ViewState>(
            selector: (_, vm) => vm.state,
            builder: (context, state, _) {
              final viewModel = context.read<TeamDetailViewModel>();

              return switch (state) {
                ViewState.idle || ViewState.loading => const LoadingView(),
                ViewState.error => ErrorView(
                  message: viewModel.errorMessage ?? 'Something went wrong.',
                  onRetry: viewModel.load,
                ),
                ViewState.loaded => const TeamDetailBody(),
              };
            },
          ),
        ),
      ),
    );
  }
}
