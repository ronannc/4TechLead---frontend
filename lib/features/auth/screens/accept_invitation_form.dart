import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../core/routing/route_paths.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/viewmodels/base_view_model.dart';
import '../../../core/widgets/buttons/app_primary_button.dart';
import '../../../core/widgets/inputs/app_text_field.dart';
import '../viewmodels/accept_invitation_view_model.dart';

class AcceptInvitationForm extends StatefulWidget {
  const AcceptInvitationForm({super.key});

  @override
  State<AcceptInvitationForm> createState() => _AcceptInvitationFormState();
}

class _AcceptInvitationFormState extends State<AcceptInvitationForm> {
  final _emailController = TextEditingController();
  final _tokenController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordConfirmationController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _tokenController.dispose();
    _passwordController.dispose();
    _passwordConfirmationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('Validar convite', style: theme.textTheme.headlineMedium),
        const SizedBox(height: AppSpacing.xs),
        Text(
          'Use o código recebido. Se você já tem login, informe sua senha atual para vincular o acesso.',
          style: theme.textTheme.bodyMedium,
        ),
        const SizedBox(height: AppSpacing.lg),
        AppTextField(
          label: 'E-mail cadastrado',
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: AppSpacing.md),
        AppTextField(label: 'Token', controller: _tokenController),
        const SizedBox(height: AppSpacing.md),
        AppTextField(
          label: 'Senha atual ou nova senha',
          controller: _passwordController,
          obscureText: true,
        ),
        const SizedBox(height: AppSpacing.md),
        AppTextField(
          label: 'Confirmar senha',
          controller: _passwordConfirmationController,
          obscureText: true,
        ),
        const SizedBox(height: AppSpacing.md),
        Selector<AcceptInvitationViewModel, ViewState>(
          selector: (_, vm) => vm.state,
          builder: (context, state, _) {
            final viewModel = context.read<AcceptInvitationViewModel>();

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (state == ViewState.error)
                  Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                    child: Text(
                      viewModel.errorMessage ?? 'Algo deu errado.',
                      style: TextStyle(color: theme.colorScheme.error),
                    ),
                  ),
                AppPrimaryButton(
                  label: 'Criar acesso',
                  loading: state == ViewState.loading,
                  onPressed: () => viewModel.accept(
                    email: _emailController.text,
                    token: _tokenController.text,
                    password: _passwordController.text,
                    passwordConfirmation: _passwordConfirmationController.text,
                  ),
                ),
              ],
            );
          },
        ),
        const SizedBox(height: AppSpacing.md),
        TextButton(
          onPressed: () => context.go(RoutePaths.login),
          child: const Text('Voltar para login'),
        ),
      ],
    );
  }
}
