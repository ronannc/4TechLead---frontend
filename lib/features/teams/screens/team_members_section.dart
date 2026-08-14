import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../core/routing/route_paths.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/buttons/app_primary_button.dart';
import '../../../core/widgets/tables/app_data_table.dart';
import '../../people/models/person.dart';
import '../viewmodels/team_detail_view_model.dart';

/// The "Membros" section of [TeamDetailScreen] — the team's people, listed
/// via the same searchable [AppDataTable] every other list in the app uses.
class TeamMembersSection extends StatelessWidget {
  const TeamMembersSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<TeamDetailViewModel>(
      builder: (context, viewModel, _) {
        final teamId = viewModel.teamId.toString();

        return Column(
          children: [
            Expanded(
              child: AppDataTable<Person>(
                items: viewModel.members,
                title: 'Pessoas cadastradas',
                subtitle: 'Membros deste time, com cargo e contrato.',
                itemIcon: Icons.person_outline,
                itemCountLabel: (_) => viewModel.membersTotal == 1
                    ? '1 pessoa'
                    : '${viewModel.membersTotal} pessoas',
                columns: [
                  AppDataColumn(
                    label: 'Nome',
                    cellBuilder: (person) => person.name,
                  ),
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
                onSearchChanged: (query) {
                  viewModel.searchMembers(query);
                },
                searchHint: 'Buscar pessoas...',
                emptyMessage: viewModel.hasMembers
                    ? 'Nenhum resultado para a busca.'
                    : 'Nenhuma pessoa neste time ainda.',
              ),
            ),
            if (viewModel.membersErrorMessage != null) ...[
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.md,
                  0,
                  AppSpacing.md,
                  AppSpacing.sm,
                ),
                child: Text(
                  viewModel.membersErrorMessage!,
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              ),
            ],
            if (viewModel.membersLastPage > 1)
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.md,
                  0,
                  AppSpacing.md,
                  AppSpacing.md,
                ),
                child: _InlinePagination(
                  page: viewModel.membersPage,
                  lastPage: viewModel.membersLastPage,
                  loading: viewModel.isChangingMembersPage,
                  onPrevious: viewModel.membersPage > 1
                      ? () => viewModel.changeMembersPage(
                          viewModel.membersPage - 1,
                        )
                      : null,
                  onNext: viewModel.membersPage < viewModel.membersLastPage
                      ? () => viewModel.changeMembersPage(
                          viewModel.membersPage + 1,
                        )
                      : null,
                ),
              ),
          ],
        );
      },
    );
  }
}

class _InlinePagination extends StatelessWidget {
  const _InlinePagination({
    required this.page,
    required this.lastPage,
    required this.loading,
    required this.onPrevious,
    required this.onNext,
  });

  final int page;
  final int lastPage;
  final bool loading;
  final VoidCallback? onPrevious;
  final VoidCallback? onNext;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 64,
              child: AppSecondaryButton(label: '←', onPressed: onPrevious),
            ),
            const SizedBox(width: AppSpacing.sm),
            SizedBox(
              width: 120,
              child: loading
                  ? const Center(
                      child: SizedBox.square(
                        dimension: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    )
                  : Text(
                      'Página $page de $lastPage',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
            ),
            const SizedBox(width: AppSpacing.sm),
            SizedBox(
              width: 64,
              child: AppSecondaryButton(label: '→', onPressed: onNext),
            ),
          ],
        ),
      ),
    );
  }
}
