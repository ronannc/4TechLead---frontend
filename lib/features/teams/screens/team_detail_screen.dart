import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../bootstrap.dart';
import '../../../core/routing/route_paths.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/viewmodels/base_view_model.dart';
import '../../../core/widgets/navigation/app_page_header.dart';
import '../../../core/widgets/states/error_view.dart';
import '../../../core/widgets/states/loading_view.dart';
import '../../people/repositories/person_repository.dart';
import '../../people/viewmodels/people_list_view_model.dart';
import '../repositories/team_repository.dart';
import '../viewmodels/team_detail_view_model.dart';
import 'team_detail_body.dart';
import 'team_members_section.dart';

/// Screen depends on [TeamDetailViewModel]/[TeamRepository] for the team
/// itself and [PeopleListViewModel]/[PersonRepository] for its "Membros"
/// section (the single DI wiring points below) — never on
/// `TeamService`/`PersonService` directly.
class TeamDetailScreen extends StatelessWidget {
  const TeamDetailScreen({super.key, required this.teamId});

  final String teamId;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) =>
              TeamDetailViewModel(getIt<TeamRepository>(), int.parse(teamId))
                ..load(),
        ),
        ChangeNotifierProvider(
          create: (_) =>
              PeopleListViewModel(getIt<PersonRepository>(), int.parse(teamId))
                ..load(),
        ),
      ],
      // Builder gives us a context BELOW the providers above — the FAB's
      // onPressed needs a descendant context to read PeopleListViewModel
      // (see TeamsListScreen for the same pattern/rationale).
      child: Builder(
        builder: (context) => Scaffold(
          appBar: const AppPageHeader(
            subtitle: 'Detalhes',
            title: 'Time',
            showNotifications: false,
          ),
          body: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Selector<TeamDetailViewModel, ViewState>(
              selector: (_, vm) => vm.state,
              builder: (context, state, _) {
                final viewModel = context.read<TeamDetailViewModel>();

                return switch (state) {
                  ViewState.idle || ViewState.loading => const LoadingView(),
                  ViewState.error => ErrorView(
                    message: viewModel.errorMessage ?? 'Algo deu errado.',
                    onRetry: viewModel.load,
                  ),
                  ViewState.loaded => SizedBox.expand(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const TeamDetailBody(),
                        const SizedBox(height: AppSpacing.lg),
                        Text(
                          'Membros',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const Expanded(child: TeamMembersSection()),
                      ],
                    ),
                  ),
                };
              },
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              await context.push(RoutePaths.personCreatePath(teamId));

              if (context.mounted) {
                await context.read<PeopleListViewModel>().load();
              }
            },
            tooltip: 'Adicionar pessoa',
            child: const Icon(Icons.person_add_alt),
          ),
        ),
      ),
    );
  }
}
