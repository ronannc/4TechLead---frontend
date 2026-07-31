import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../bootstrap.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/viewmodels/base_view_model.dart';
import '../../../core/widgets/navigation/app_page_header.dart';
import '../../../core/widgets/states/error_view.dart';
import '../../../core/widgets/states/loading_view.dart';
import '../../people/repositories/person_repository.dart';
import '../repositories/daily_meeting_repository.dart';
import '../viewmodels/daily_history_view_model.dart';
import 'daily_history_body.dart';

class DailyHistoryScreen extends StatelessWidget {
  const DailyHistoryScreen({super.key, required this.teamId});

  final String teamId;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => DailyHistoryViewModel(
        getIt<DailyMeetingRepository>(),
        getIt<PersonRepository>(),
        int.parse(teamId),
      )..load(),
      child: Scaffold(
        appBar: const AppPageHeader(
          subtitle: 'Time',
          title: 'Histórico de dailies',
          showNotifications: false,
        ),
        body: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Selector<DailyHistoryViewModel, ViewState>(
            selector: (_, vm) => vm.state,
            builder: (context, state, _) {
              final viewModel = context.read<DailyHistoryViewModel>();

              return switch (state) {
                ViewState.idle || ViewState.loading => const LoadingView(),
                ViewState.error => ErrorView(
                  message: viewModel.errorMessage ?? 'Algo deu errado.',
                  onRetry: viewModel.load,
                ),
                ViewState.loaded => DailyHistoryBody(teamId: teamId),
              };
            },
          ),
        ),
      ),
    );
  }
}
