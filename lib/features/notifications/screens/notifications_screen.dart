import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../bootstrap.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/viewmodels/base_view_model.dart';
import '../../../core/widgets/buttons/app_primary_button.dart';
import '../../../core/widgets/navigation/app_page_header.dart';
import '../../../core/widgets/states/empty_view.dart';
import '../../../core/widgets/states/error_view.dart';
import '../../../core/widgets/states/loading_view.dart';
import '../models/external_notification.dart';
import '../repositories/notification_repository.dart';
import '../viewmodels/notifications_view_model.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) =>
          NotificationsViewModel(getIt<NotificationRepository>())..load(),
      child: Scaffold(
        appBar: const AppPageHeader(
          subtitle: 'Fique por dentro',
          title: 'Notificações',
          showNotifications: false,
        ),
        body: Consumer<NotificationsViewModel>(
          builder: (context, viewModel, _) {
            final hasContent = viewModel.notifications.isNotEmpty;

            if (viewModel.state == ViewState.loading && !hasContent) {
              return const LoadingView();
            }

            if (viewModel.state == ViewState.error && !hasContent) {
              return ErrorView(
                message: viewModel.errorMessage ?? 'Algo deu errado.',
                onRetry: viewModel.load,
              );
            }

            if (!hasContent) {
              return const EmptyView(
                icon: Icons.notifications_none,
                message: 'Nenhuma notificação recebida por enquanto.',
              );
            }

            return _NotificationsList(viewModel: viewModel);
          },
        ),
      ),
    );
  }
}

class _NotificationsList extends StatelessWidget {
  const _NotificationsList({required this.viewModel});

  final NotificationsViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: viewModel.refresh,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          Text(
            viewModel.total == 1
                ? '1 notificação recebida'
                : '${viewModel.total} notificações recebidas',
            style: Theme.of(context).textTheme.titleSmall,
          ),
          if (viewModel.pageErrorMessage != null) ...[
            const SizedBox(height: AppSpacing.sm),
            _PageErrorBanner(
              message: viewModel.pageErrorMessage!,
              onDismiss: viewModel.clearPageError,
            ),
          ],
          const SizedBox(height: AppSpacing.sm),
          for (final notification in viewModel.notifications)
            _NotificationTile(notification: notification),
          const SizedBox(height: AppSpacing.sm),
          _InlinePagination(
            page: viewModel.page,
            lastPage: viewModel.lastPage,
            loading: viewModel.isChangingPage,
            onPrevious: viewModel.page <= 1 || viewModel.isChangingPage
                ? null
                : () => viewModel.changePage(viewModel.page - 1),
            onNext:
                viewModel.page >= viewModel.lastPage || viewModel.isChangingPage
                ? null
                : () => viewModel.changePage(viewModel.page + 1),
          ),
        ],
      ),
    );
  }
}

class _NotificationTile extends StatelessWidget {
  const _NotificationTile({required this.notification});

  final ExternalNotification notification;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final severity = _severityStyle(context, notification.severity);
    final sourceName =
        notification.integrationSystem?.name ?? notification.source;

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(severity.icon, color: severity.color),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          notification.title,
                          style: theme.textTheme.titleSmall,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      _SeverityBadge(
                        label: severity.label,
                        color: severity.color,
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    notification.message,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Wrap(
                    spacing: AppSpacing.sm,
                    runSpacing: AppSpacing.xs,
                    children: [
                      _MetadataChip(
                        icon: Icons.hub_outlined,
                        label: sourceName,
                      ),
                      if (notification.type != null)
                        _MetadataChip(
                          icon: Icons.category_outlined,
                          label: notification.type!,
                        ),
                      if (notification.sourceRef != null)
                        _MetadataChip(
                          icon: Icons.tag_outlined,
                          label: notification.sourceRef!,
                        ),
                      if (notification.displayDate != null)
                        _MetadataChip(
                          icon: Icons.schedule_outlined,
                          label: _formatDate(notification.displayDate!),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SeverityBadge extends StatelessWidget {
  const _SeverityBadge({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        border: Border.all(color: color),
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: Text(
        label,
        style: theme.textTheme.labelSmall?.copyWith(color: color),
      ),
    );
  }
}

class _MetadataChip extends StatelessWidget {
  const _MetadataChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: theme.colorScheme.onSurfaceVariant),
        const SizedBox(width: 4),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

class _PageErrorBanner extends StatelessWidget {
  const _PageErrorBanner({required this.message, required this.onDismiss});

  final String message;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: theme.colorScheme.errorContainer,
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline, color: theme.colorScheme.onErrorContainer),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              message,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onErrorContainer,
              ),
            ),
          ),
          IconButton(
            onPressed: onDismiss,
            icon: const Icon(Icons.close),
            tooltip: 'Fechar',
            color: theme.colorScheme.onErrorContainer,
          ),
        ],
      ),
    );
  }
}

class _InlinePagination extends StatelessWidget {
  const _InlinePagination({
    required this.page,
    required this.lastPage,
    required this.loading,
    required this.onPrevious,
    required this.onNext,
  });

  final int page;
  final int lastPage;
  final bool loading;
  final VoidCallback? onPrevious;
  final VoidCallback? onNext;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 64,
              child: AppSecondaryButton(label: '←', onPressed: onPrevious),
            ),
            const SizedBox(width: AppSpacing.sm),
            SizedBox(
              width: 120,
              child: loading
                  ? const Center(
                      child: SizedBox.square(
                        dimension: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    )
                  : Text(
                      'Página $page de $lastPage',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
            ),
            const SizedBox(width: AppSpacing.sm),
            SizedBox(
              width: 64,
              child: AppSecondaryButton(label: '→', onPressed: onNext),
            ),
          ],
        ),
      ),
    );
  }
}

_SeverityStyle _severityStyle(BuildContext context, String severity) {
  final colors = Theme.of(context).colorScheme;

  return switch (severity) {
    'success' => _SeverityStyle(
      label: 'Sucesso',
      icon: Icons.check_circle_outline,
      color: Colors.green,
    ),
    'warning' => _SeverityStyle(
      label: 'Atenção',
      icon: Icons.warning_amber_outlined,
      color: Colors.orange,
    ),
    'error' => _SeverityStyle(
      label: 'Erro',
      icon: Icons.error_outline,
      color: colors.error,
    ),
    _ => _SeverityStyle(
      label: 'Info',
      icon: Icons.info_outline,
      color: colors.primary,
    ),
  };
}

class _SeverityStyle {
  const _SeverityStyle({
    required this.label,
    required this.icon,
    required this.color,
  });

  final String label;
  final IconData icon;
  final Color color;
}

String _formatDate(DateTime value) {
  final local = value.toLocal();
  final day = local.day.toString().padLeft(2, '0');
  final month = local.month.toString().padLeft(2, '0');
  final hour = local.hour.toString().padLeft(2, '0');
  final minute = local.minute.toString().padLeft(2, '0');

  return '$day/$month $hour:$minute';
}
