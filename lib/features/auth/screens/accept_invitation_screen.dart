import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../bootstrap.dart';
import '../../../core/theme/app_spacing.dart';
import '../repositories/auth_repository.dart';
import '../viewmodels/accept_invitation_view_model.dart';
import 'accept_invitation_form.dart';

class AcceptInvitationScreen extends StatelessWidget {
  const AcceptInvitationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AcceptInvitationViewModel(getIt<AuthRepository>()),
      child: Scaffold(
        body: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: const Padding(
              padding: EdgeInsets.all(AppSpacing.lg),
              child: AcceptInvitationForm(),
            ),
          ),
        ),
      ),
    );
  }
}
