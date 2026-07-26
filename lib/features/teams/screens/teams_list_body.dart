import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../core/routing/route_paths.dart';
import '../../../core/widgets/tables/app_data_table.dart';
import '../models/team.dart';
import '../viewmodels/teams_list_view_model.dart';

/// The loaded-state body of [TeamsListScreen], split into its own file/class
/// so only this subtree rebuilds when the team list changes.
class TeamsListBody extends StatelessWidget {
  const TeamsListBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Selector<TeamsListViewModel, List<Team>>(
      selector: (_, vm) => vm.teams,
      builder: (context, teams, _) {
        final viewModel = context.read<TeamsListViewModel>();

        return AppDataTable<Team>(
          items: teams,
          columns: [
            AppDataColumn(label: 'Nome', cellBuilder: (team) => team.name),
            AppDataColumn(
              label: 'Criado em',
              cellBuilder: (team) => team.createdAt.toLocal().toString(),
            ),
          ],
          onRowTap: (team) => context.push(RoutePaths.teamDetailPath(team.id.toString())),
          onSearchChanged: viewModel.search,
          searchHint: 'Buscar times...',
          emptyMessage: viewModel.hasTeams ? 'Nenhum resultado para a busca.' : 'Nenhum time ainda.',
        );
      },
    );
  }
}
