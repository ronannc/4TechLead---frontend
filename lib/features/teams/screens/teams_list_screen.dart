import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../bootstrap.dart';
import '../../../core/viewmodels/base_view_model.dart';
import '../../../core/widgets/buttons/app_primary_button.dart';
import '../../../core/widgets/inputs/app_text_field.dart';
import '../../../core/widgets/states/error_view.dart';
import '../../../core/widgets/states/loading_view.dart';
import '../repositories/team_repository.dart';
import '../viewmodels/teams_list_view_model.dart';
import 'teams_list_body.dart';

/// Screen only ever depends on [TeamsListViewModel] and [TeamRepository]
/// (for the single DI wiring point below) — never on `TeamService`.
class TeamsListScreen extends StatelessWidget {
  const TeamsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TeamsListViewModel(getIt<TeamRepository>())..load(),
      // Builder gives us a context BELOW the provider above — the `context`
      // from `build()` itself is the location TeamsListScreen was inserted
      // at (above the provider), so reading the ViewModel from it (e.g. in
      // the FAB's onPressed) would fail with a "could not find provider" error.
      child: Builder(
        builder: (context) => Scaffold(
          appBar: AppBar(title: const Text('Teams')),
          body: Selector<TeamsListViewModel, ViewState>(
            selector: (_, vm) => vm.state,
            builder: (context, state, _) {
              final viewModel = context.read<TeamsListViewModel>();

              return switch (state) {
                ViewState.idle || ViewState.loading => const LoadingView(),
                ViewState.error => ErrorView(
                  message: viewModel.errorMessage ?? 'Something went wrong.',
                  onRetry: viewModel.load,
                ),
                ViewState.loaded => const TeamsListBody(),
              };
            },
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => _showCreateDialog(context),
            child: const Icon(Icons.add),
          ),
        ),
      ),
    );
  }

  Future<void> _showCreateDialog(BuildContext context) async {
    final viewModel = context.read<TeamsListViewModel>();
    final controller = TextEditingController();

    await showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('New team'),
        content: AppTextField(label: 'Name', controller: controller),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogContext), child: const Text('Cancel')),
          AppPrimaryButton(
            label: 'Create',
            onPressed: () {
              Navigator.pop(dialogContext);
              viewModel.createTeam(controller.text);
            },
          ),
        ],
      ),
    );
  }
}
