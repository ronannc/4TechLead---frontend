import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../bootstrap.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/viewmodels/base_view_model.dart';
import '../../../core/widgets/navigation/app_page_header.dart';
import '../../../core/widgets/states/error_view.dart';
import '../../../core/widgets/states/loading_view.dart';
import '../repositories/daily_meeting_repository.dart';
import '../viewmodels/daily_meeting_detail_view_model.dart';
import 'daily_meeting_detail_body.dart';

class DailyMeetingDetailScreen extends StatelessWidget {
  const DailyMeetingDetailScreen({super.key, required this.meetingId});

  final String meetingId;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => DailyMeetingDetailViewModel(
        getIt<DailyMeetingRepository>(),
        int.parse(meetingId),
      )..load(),
      child: Scaffold(
        appBar: const AppPageHeader(
          subtitle: 'Daily',
          title: 'Detalhe',
          showNotifications: false,
        ),
        body: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Selector<DailyMeetingDetailViewModel, ViewState>(
            selector: (_, vm) => vm.state,
            builder: (context, state, _) {
              final viewModel = context.read<DailyMeetingDetailViewModel>();

              return switch (state) {
                ViewState.idle || ViewState.loading => const LoadingView(),
                ViewState.error => ErrorView(
                  message: viewModel.errorMessage ?? 'Algo deu errado.',
                  onRetry: viewModel.load,
                ),
                ViewState.loaded => const DailyMeetingDetailBody(),
              };
            },
          ),
        ),
      ),
    );
  }
}
