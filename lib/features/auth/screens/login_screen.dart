import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../bootstrap.dart';
import '../../../core/theme/app_spacing.dart';
import '../repositories/auth_repository.dart';
import '../viewmodels/login_view_model.dart';
import 'login_form.dart';

/// Screen only ever depends on [LoginViewModel] and [AuthRepository] (for
/// the single DI wiring point below) — never on `AuthService`.
class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => LoginViewModel(getIt<AuthRepository>()),
      child: Scaffold(
        body: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: const Padding(
              padding: EdgeInsets.all(AppSpacing.lg),
              child: LoginForm(),
            ),
          ),
        ),
      ),
    );
  }
}
