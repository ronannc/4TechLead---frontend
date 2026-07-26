import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../bootstrap.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/viewmodels/base_view_model.dart';
import '../../../core/widgets/navigation/app_page_header.dart';
import '../../../core/widgets/states/error_view.dart';
import '../../../core/widgets/states/loading_view.dart';
import '../repositories/person_repository.dart';
import '../viewmodels/person_detail_view_model.dart';
import 'person_detail_body.dart';

/// Screen only ever depends on [PersonDetailViewModel] and
/// [PersonRepository] (for the single DI wiring point below) — never on
/// `PersonService`.
class PersonDetailScreen extends StatelessWidget {
  const PersonDetailScreen({super.key, required this.personId});

  final String personId;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => PersonDetailViewModel(getIt<PersonRepository>(), int.parse(personId))..load(),
      child: Scaffold(
        appBar: const AppPageHeader(subtitle: 'Detalhes', title: 'Pessoa', showNotifications: false),
        body: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Selector<PersonDetailViewModel, ViewState>(
            selector: (_, vm) => vm.state,
            builder: (context, state, _) {
              final viewModel = context.read<PersonDetailViewModel>();

              return switch (state) {
                ViewState.idle || ViewState.loading => const LoadingView(),
                ViewState.error => ErrorView(
                  message: viewModel.errorMessage ?? 'Algo deu errado.',
                  onRetry: viewModel.load,
                ),
                ViewState.loaded => const PersonDetailBody(),
              };
            },
          ),
        ),
      ),
    );
  }
}
