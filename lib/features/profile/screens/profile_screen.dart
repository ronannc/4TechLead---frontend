import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../bootstrap.dart';
import '../../../core/routing/route_paths.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/viewmodels/base_view_model.dart';
import '../../../core/widgets/buttons/app_primary_button.dart';
import '../../../core/widgets/data/app_key_value_row.dart';
import '../../../core/widgets/navigation/app_page_header.dart';
import '../../../core/widgets/states/error_view.dart';
import '../../../core/widgets/states/loading_view.dart';
import '../../auth/repositories/auth_repository.dart';
import '../../people/models/person.dart';
import '../../people/repositories/person_repository.dart';
import '../viewmodels/profile_view_model.dart';

/// Screen only ever depends on [ProfileViewModel] and [AuthRepository] (the
/// single DI wiring point below) — never on `AuthService`.
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) =>
          ProfileViewModel(getIt<AuthRepository>(), getIt<PersonRepository>())
            ..load(),
      child: Scaffold(
        appBar: const AppPageHeader(subtitle: 'Sua conta', title: 'Perfil'),
        body: Selector<ProfileViewModel, ViewState>(
          selector: (_, vm) => vm.state,
          builder: (context, state, _) {
            final viewModel = context.read<ProfileViewModel>();

            return switch (state) {
              ViewState.idle || ViewState.loading => const LoadingView(),
              ViewState.error => ErrorView(
                message: viewModel.errorMessage ?? 'Algo deu errado.',
                onRetry: viewModel.load,
              ),
              ViewState.loaded => _ProfileBody(viewModel: viewModel),
            };
          },
        ),
      ),
    );
  }
}

class _ProfileBody extends StatelessWidget {
  const _ProfileBody({required this.viewModel});

  final ProfileViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final user = viewModel.user;
    final person = viewModel.person;

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: ListView(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 32,
                backgroundColor: theme.colorScheme.primary,
                child: Text(
                  (user != null && user.name.isNotEmpty)
                      ? user.name[0].toUpperCase()
                      : '?',
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: theme.colorScheme.onPrimary,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(user?.name ?? '', style: theme.textTheme.titleMedium),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      user?.email ?? '',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          if (person == null)
            _MissingPersonProfile(userEmail: user?.email)
          else
            _PersonProfileCard(person: person, onSaved: viewModel.load),
          const SizedBox(height: AppSpacing.lg),
          AppSecondaryButton(label: 'Sair', onPressed: viewModel.signOut),
        ],
      ),
    );
  }
}

class _MissingPersonProfile extends StatelessWidget {
  const _MissingPersonProfile({required this.userEmail});

  final String? userEmail;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Perfil profissional', style: theme.textTheme.titleMedium),
            const SizedBox(height: AppSpacing.sm),
            Text(
              userEmail == null
                  ? 'Nenhum perfil de pessoa está vinculado a este login.'
                  : 'Nenhum perfil de pessoa foi encontrado para $userEmail.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PersonProfileCard extends StatelessWidget {
  const _PersonProfileCard({required this.person, required this.onSaved});

  final Person person;
  final AsyncCallback onSaved;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Perfil profissional',
                    style: theme.textTheme.titleMedium,
                  ),
                ),
                IconButton.filledTonal(
                  tooltip: 'Editar perfil',
                  onPressed: () => _edit(context),
                  icon: const Icon(Icons.edit_outlined),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            AppKeyValueRow(label: 'Nome', value: person.name),
            AppKeyValueRow(label: 'Cargo', value: person.position),
            AppKeyValueRow(label: 'Senioridade', value: person.seniority.label),
            AppKeyValueRow(label: 'Contrato', value: person.contractType.label),
            AppKeyValueRow(label: 'E-mail', value: person.email ?? '-'),
            AppKeyValueRow(label: 'Telefone', value: person.phone ?? '-'),
          ],
        ),
      ),
    );
  }

  Future<void> _edit(BuildContext context) async {
    final saved = await context.push<bool>(
      RoutePaths.personEditPath(
        '${person.teamId}',
        '${person.id}',
        fromProfile: true,
      ),
    );

    if (saved == true) {
      await onSaved();
    }
  }
}
