import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../bootstrap.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/navigation/app_page_header.dart';
import '../repositories/person_repository.dart';
import '../viewmodels/person_form_view_model.dart';
import 'person_form.dart';

/// Screen only ever depends on [PersonFormViewModel] and [PersonRepository]
/// (for the single DI wiring point below) — never on `PersonService`.
class PersonFormScreen extends StatelessWidget {
  const PersonFormScreen({super.key, required this.teamId});

  final String teamId;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) =>
          PersonFormViewModel(getIt<PersonRepository>(), int.parse(teamId)),
      child: Scaffold(
        appBar: const AppPageHeader(
          subtitle: 'Novo integrante',
          title: 'Time',
          showNotifications: false,
        ),
        body: const Padding(
          padding: EdgeInsets.all(AppSpacing.md),
          child: PersonForm(),
        ),
      ),
    );
  }
}
