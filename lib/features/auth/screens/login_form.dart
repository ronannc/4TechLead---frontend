import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../core/routing/route_paths.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/viewmodels/base_view_model.dart';
import '../../../core/widgets/buttons/app_primary_button.dart';
import '../../../core/widgets/inputs/app_text_field.dart';
import '../viewmodels/login_view_model.dart';

/// The interactive body of [LoginScreen], split into its own file/class so
/// only this subtree rebuilds while typing/submitting.
class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('Sign in', style: theme.textTheme.headlineMedium),
        const SizedBox(height: AppSpacing.lg),
        AppTextField(label: 'Email', controller: _emailController, keyboardType: TextInputType.emailAddress),
        const SizedBox(height: AppSpacing.md),
        AppTextField(label: 'Password', controller: _passwordController, obscureText: true),
        const SizedBox(height: AppSpacing.md),
        Selector<LoginViewModel, ViewState>(
          selector: (_, vm) => vm.state,
          builder: (context, state, _) {
            final viewModel = context.read<LoginViewModel>();

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
                  label: 'Sign in',
                  loading: state == ViewState.loading,
                  onPressed: () => viewModel.login(
                    email: _emailController.text,
                    password: _passwordController.text,
                  ),
                ),
              ],
            );
          },
        ),
        const SizedBox(height: AppSpacing.md),
        TextButton(
          onPressed: () => context.push(RoutePaths.register),
          child: const Text("Don't have an account? Register"),
        ),
      ],
    );
  }
}
