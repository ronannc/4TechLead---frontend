import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../bootstrap.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/viewmodels/base_view_model.dart';
import '../../../core/widgets/navigation/app_page_header.dart';
import '../../../core/widgets/states/error_view.dart';
import '../../../core/widgets/states/loading_view.dart';
import '../repositories/person_repository.dart';
import '../viewmodels/person_form_view_model.dart';
import 'person_form.dart';

/// Screen only ever depends on [PersonFormViewModel] and [PersonRepository]
/// (for the single DI wiring point below) — never on `PersonService`.
class PersonFormScreen extends StatelessWidget {
  const PersonFormScreen({
    super.key,
    required this.teamId,
    this.personId,
    this.appBarTitle = 'Time',
  });

  final String teamId;
  final String? personId;
  final String appBarTitle;

  @override
  Widget build(BuildContext context) {
    final parsedPersonId = personId == null ? null : int.parse(personId!);

    return ChangeNotifierProvider(
      create: (_) => PersonFormViewModel(
        getIt<PersonRepository>(),
        int.parse(teamId),
        personId: parsedPersonId,
      )..load(),
      child: Scaffold(
        appBar: AppPageHeader(
          subtitle: parsedPersonId == null ? 'Novo integrante' : 'Editar dados',
          title: appBarTitle,
          showNotifications: false,
        ),
        body: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Selector<PersonFormViewModel, ViewState>(
            selector: (_, vm) => vm.state,
            builder: (context, state, _) {
              final viewModel = context.read<PersonFormViewModel>();

              if (viewModel.isEditing &&
                  state == ViewState.loading &&
                  viewModel.person == null) {
                return const LoadingView();
              }

              if (viewModel.isEditing &&
                  state == ViewState.error &&
                  viewModel.person == null) {
                return ErrorView(
                  message: viewModel.errorMessage ?? 'Algo deu errado.',
                  onRetry: viewModel.load,
                );
              }

              return const PersonForm();
            },
          ),
        ),
      ),
    );
  }
}
