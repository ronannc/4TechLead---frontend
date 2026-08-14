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
import '../repositories/team_repository.dart';
import '../viewmodels/team_detail_view_model.dart';
import 'team_detail_body.dart';
import 'team_members_section.dart';

/// Screen depends only on [TeamDetailViewModel]/[TeamRepository]. The team
/// header and paginated "Membros" section come from the same `/teams/{id}`
/// payload, so the screen no longer needs a second request for people.
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
      ],
      // Builder gives us a context BELOW the providers above so the FAB can
      // refresh the already-provided TeamDetailViewModel after creating a
      // new team member.
      child: Builder(
        builder: (context) => Scaffold(
          appBar: const AppPageHeader(
            subtitle: 'Detalhes',
            title: 'Time',
            showNotifications: false,
          ),
          body: Selector<TeamDetailViewModel, ViewState>(
            selector: (_, vm) => vm.state,
            builder: (context, state, _) {
              final viewModel = context.read<TeamDetailViewModel>();

              return switch (state) {
                ViewState.idle || ViewState.loading => const LoadingView(),
                ViewState.error => ErrorView(
                  message: viewModel.errorMessage ?? 'Algo deu errado.',
                  onRetry: viewModel.load,
                ),
                ViewState.loaded => const SizedBox.expand(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(AppSpacing.md),
                        child: TeamDetailBody(),
                      ),
                      Expanded(child: TeamMembersSection()),
                    ],
                  ),
                ),
              };
            },
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              await context.push(RoutePaths.personCreatePath(teamId));

              if (context.mounted) {
                await context.read<TeamDetailViewModel>().load();
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
