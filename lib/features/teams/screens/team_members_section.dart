import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../core/routing/route_paths.dart';
import '../../../core/widgets/tables/app_data_table.dart';
import '../../people/models/person.dart';
import '../../people/viewmodels/people_list_view_model.dart';

/// The "Membros" section of [TeamDetailScreen] — the team's people, listed
/// via the same searchable [AppDataTable] every other list in the app uses.
class TeamMembersSection extends StatelessWidget {
  const TeamMembersSection({super.key});

  @override
  Widget build(BuildContext context) {
    final teamId = context.read<PeopleListViewModel>().teamId.toString();

    return Selector<PeopleListViewModel, List<Person>>(
      selector: (_, vm) => vm.people,
      builder: (context, people, _) {
        final viewModel = context.read<PeopleListViewModel>();

        return AppDataTable<Person>(
          items: people,
          columns: [
            AppDataColumn(label: 'Nome', cellBuilder: (person) => person.name),
            AppDataColumn(
              label: 'Cargo',
              cellBuilder: (person) => person.position,
            ),
            AppDataColumn(
              label: 'Contrato',
              cellBuilder: (person) => person.contractType.label,
            ),
          ],
          onRowTap: (person) => context.push(
            RoutePaths.personDetailPath(teamId, person.id.toString()),
          ),
          onSearchChanged: viewModel.search,
          searchHint: 'Buscar pessoas...',
          emptyMessage: viewModel.hasPeople
              ? 'Nenhum resultado para a busca.'
              : 'Nenhuma pessoa neste time ainda.',
        );
      },
    );
  }
}
