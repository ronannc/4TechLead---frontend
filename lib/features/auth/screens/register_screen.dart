import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../bootstrap.dart';
import '../../../core/theme/app_spacing.dart';
import '../repositories/auth_repository.dart';
import '../viewmodels/register_view_model.dart';
import 'register_form.dart';

/// Screen only ever depends on [RegisterViewModel] and [AuthRepository] (for
/// the single DI wiring point below) — never on `AuthService`.
class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => RegisterViewModel(getIt<AuthRepository>()),
      child: Scaffold(
        body: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: const Padding(
              padding: EdgeInsets.all(AppSpacing.lg),
              child: RegisterForm(),
            ),
          ),
        ),
      ),
    );
  }
}
