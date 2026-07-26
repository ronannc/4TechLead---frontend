import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../bootstrap.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/viewmodels/base_view_model.dart';
import '../../../core/widgets/buttons/app_primary_button.dart';
import '../../../core/widgets/states/error_view.dart';
import '../../../core/widgets/states/loading_view.dart';
import '../../auth/repositories/auth_repository.dart';
import '../viewmodels/profile_view_model.dart';

/// Screen only ever depends on [ProfileViewModel] and [AuthRepository] (the
/// single DI wiring point below) — never on `AuthService`.
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ProfileViewModel(getIt<AuthRepository>())..load(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Profile')),
        body: Selector<ProfileViewModel, ViewState>(
          selector: (_, vm) => vm.state,
          builder: (context, state, _) {
            final viewModel = context.read<ProfileViewModel>();

            return switch (state) {
              ViewState.idle || ViewState.loading => const LoadingView(),
              ViewState.error => ErrorView(
                message: viewModel.errorMessage ?? 'Something went wrong.',
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

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 32,
            backgroundColor: theme.colorScheme.primary,
            child: Text(
              (user != null && user.name.isNotEmpty) ? user.name[0].toUpperCase() : '?',
              style: theme.textTheme.titleLarge?.copyWith(color: theme.colorScheme.onPrimary),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(user?.name ?? '', style: theme.textTheme.titleMedium),
          const SizedBox(height: AppSpacing.xs),
          Text(
            user?.email ?? '',
            style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
          ),
          const Spacer(),
          AppPrimaryButton(label: 'Sign out', onPressed: viewModel.signOut),
        ],
      ),
    );
  }
}
