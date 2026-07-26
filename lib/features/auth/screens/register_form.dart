import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_spacing.dart';
import '../../../core/viewmodels/base_view_model.dart';
import '../../../core/widgets/buttons/app_primary_button.dart';
import '../../../core/widgets/inputs/app_text_field.dart';
import '../viewmodels/register_view_model.dart';

/// The interactive body of [RegisterScreen], split into its own file/class
/// so only this subtree rebuilds while typing/submitting.
class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordConfirmationController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
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
        Text('Create your account', style: theme.textTheme.headlineMedium),
        const SizedBox(height: AppSpacing.lg),
        AppTextField(label: 'Name', controller: _nameController),
        const SizedBox(height: AppSpacing.md),
        AppTextField(label: 'Email', controller: _emailController, keyboardType: TextInputType.emailAddress),
        const SizedBox(height: AppSpacing.md),
        AppTextField(label: 'Password', controller: _passwordController, obscureText: true),
        const SizedBox(height: AppSpacing.md),
        AppTextField(
          label: 'Confirm password',
          controller: _passwordConfirmationController,
          obscureText: true,
        ),
        const SizedBox(height: AppSpacing.md),
        Selector<RegisterViewModel, ViewState>(
          selector: (_, vm) => vm.state,
          builder: (context, state, _) {
            final viewModel = context.read<RegisterViewModel>();

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (state == ViewState.error)
                  Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                    child: Text(
                      viewModel.errorMessage ?? 'Something went wrong.',
                      style: TextStyle(color: theme.colorScheme.error),
                    ),
                  ),
                AppPrimaryButton(
                  label: 'Create account',
                  loading: state == ViewState.loading,
                  onPressed: () => viewModel.register(
                    name: _nameController.text,
                    email: _emailController.text,
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
          onPressed: () => context.pop(),
          child: const Text('Already have an account? Sign in'),
        ),
      ],
    );
  }
}
