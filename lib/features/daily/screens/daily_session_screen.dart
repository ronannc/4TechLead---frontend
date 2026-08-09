import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import '../../../bootstrap.dart';
import '../../../core/feedback/daily_cue_player.dart';
import '../../../core/routing/route_paths.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/viewmodels/base_view_model.dart';
import '../../../core/widgets/buttons/app_dialog_actions.dart';
import '../../../core/widgets/buttons/app_primary_button.dart';
import '../../../core/widgets/states/error_view.dart';
import '../../../core/widgets/states/loading_view.dart';
import '../../people/repositories/person_repository.dart';
import '../../teams/repositories/team_repository.dart';
import '../models/daily_session_phase.dart';
import '../repositories/daily_meeting_repository.dart';
import '../viewmodels/daily_session_view_model.dart';
import 'daily_config_body.dart';
import 'daily_review_body.dart';
import 'daily_running_body.dart';

/// Live "focus mode" flow for running a Daily — deliberately a top-level
/// route (see route_paths.dart) so the app's nav bar/rail is never
/// reachable mid-session.
class DailySessionScreen extends StatelessWidget {
  const DailySessionScreen({super.key, this.initialTeamId});

  final String? initialTeamId;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => DailySessionViewModel(
        getIt<PersonRepository>(),
        getIt<DailyMeetingRepository>(),
        getIt<TeamRepository>(),
        initialTeamId: initialTeamId == null ? null : int.parse(initialTeamId!),
      )..loadParticipants(),
      child: _DailySessionView(initialTeamId: initialTeamId),
    );
  }
}

class _DailySessionView extends StatefulWidget {
  const _DailySessionView({this.initialTeamId});

  final String? initialTeamId;

  @override
  State<_DailySessionView> createState() => _DailySessionViewState();
}

class _DailySessionViewState extends State<_DailySessionView> {
  late final DailySessionViewModel _viewModel;
  final _cuePlayer = getIt<DailyCuePlayer>();

  @override
  void initState() {
    super.initState();
    _viewModel = context.read<DailySessionViewModel>();
    _viewModel.addListener(_onViewModelChanged);
    _viewModel.cue.addListener(_onCueChanged);
  }

  @override
  void dispose() {
    _viewModel.removeListener(_onViewModelChanged);
    _viewModel.cue.removeListener(_onCueChanged);
    WakelockPlus.disable();
    _cuePlayer.stopTicking();
    super.dispose();
  }

  void _onViewModelChanged() {
    if (_viewModel.phase == DailySessionPhase.running && !_viewModel.isPaused) {
      WakelockPlus.enable();
      _cuePlayer.startTicking();
    } else {
      WakelockPlus.disable();
      _cuePlayer.stopTicking();
    }
  }

  void _onCueChanged() {
    final cue = _viewModel.cue.value;
    if (cue != null) {
      _viewModel.clearCue();
      _cuePlayer.play(cue);
    }
  }

  Future<void> _confirmExit() async {
    final blocked =
        _viewModel.phase == DailySessionPhase.running ||
        _viewModel.phase == DailySessionPhase.reviewing;

    if (!blocked) {
      _goBack();
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sair da daily?'),
        content: const Text(
          'O progresso desta daily ainda não foi salvo e será perdido.',
        ),
        actions: [
          AppDialogActions(
            secondaryLabel: 'Cancelar',
            onSecondaryPressed: () => Navigator.of(context).pop(false),
            primaryLabel: 'Sair',
            onPrimaryPressed: () => Navigator.of(context).pop(true),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      _goBack();
    }
  }

  void _goBack() {
    final teamId = widget.initialTeamId;
    context.go(
      teamId == null ? RoutePaths.home : RoutePaths.teamDetailPath(teamId),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          _confirmExit();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Daily'),
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: _confirmExit,
          ),
        ),
        body: Selector<DailySessionViewModel, ViewState>(
          selector: (_, vm) => vm.state,
          builder: (context, state, _) {
            final viewModel = context.read<DailySessionViewModel>();

            return switch (state) {
              ViewState.idle || ViewState.loading => const LoadingView(),
              ViewState.error => ErrorView(
                message: viewModel.errorMessage ?? 'Algo deu errado.',
                onRetry: viewModel.loadParticipants,
              ),
              ViewState.loaded =>
                Selector<DailySessionViewModel, DailySessionPhase>(
                  selector: (_, vm) => vm.phase,
                  builder: (context, phase, _) => switch (phase) {
                    DailySessionPhase.configuring => const DailyConfigBody(),
                    DailySessionPhase.running => const DailyRunningBody(),
                    DailySessionPhase.reviewing => const DailyReviewBody(),
                    DailySessionPhase.finished => _DailyFinishedBody(
                      initialTeamId: widget.initialTeamId,
                    ),
                  },
                ),
            };
          },
        ),
      ),
    );
  }
}

class _DailyFinishedBody extends StatelessWidget {
  const _DailyFinishedBody({this.initialTeamId});

  final String? initialTeamId;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.check_circle_outline,
              color: theme.colorScheme.primary,
              size: 64,
            ),
            const SizedBox(height: AppSpacing.md),
            Text('Daily registrada!', style: theme.textTheme.titleLarge),
            const SizedBox(height: AppSpacing.lg),
            AppPrimaryButton(
              label: initialTeamId == null
                  ? 'Voltar ao início'
                  : 'Voltar para o time',
              onPressed: () => context.go(
                initialTeamId == null
                    ? RoutePaths.home
                    : RoutePaths.teamDetailPath(initialTeamId!),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
