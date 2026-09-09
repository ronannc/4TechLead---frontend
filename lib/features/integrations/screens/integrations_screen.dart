import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../bootstrap.dart';
import '../../../core/responsive/breakpoints.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/viewmodels/base_view_model.dart';
import '../../../core/widgets/buttons/app_dialog_actions.dart';
import '../../../core/widgets/buttons/app_primary_button.dart';
import '../../../core/widgets/navigation/app_page_header.dart';
import '../../../core/widgets/states/error_view.dart';
import '../../../core/widgets/states/loading_view.dart';
import '../../people/repositories/person_repository.dart';
import '../models/integration_models.dart';
import '../repositories/integration_repository.dart';
import '../viewmodels/integrations_view_model.dart';

class IntegrationsScreen extends StatelessWidget {
  const IntegrationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => IntegrationsViewModel(
        getIt<IntegrationRepository>(),
        getIt<PersonRepository>(),
      )..load(),
      child: Scaffold(
        appBar: const AppPageHeader(
          subtitle: 'Webhooks e evidências externas',
          title: 'Integrações',
        ),
        body: Consumer<IntegrationsViewModel>(
          builder: (context, viewModel, _) {
            final hasLoadedContent =
                viewModel.systems.isNotEmpty ||
                viewModel.people.isNotEmpty ||
                viewModel.identities.isNotEmpty ||
                viewModel.metrics.isNotEmpty;

            if (viewModel.state == ViewState.loading && !hasLoadedContent) {
              return const LoadingView();
            }

            if (viewModel.state == ViewState.error && !hasLoadedContent) {
              return ErrorView(
                message: viewModel.errorMessage ?? 'Algo deu errado.',
                onRetry: viewModel.load,
              );
            }

            return const _IntegrationsBody();
          },
        ),
      ),
    );
  }
}

class _IntegrationsBody extends StatefulWidget {
  const _IntegrationsBody();

  @override
  State<_IntegrationsBody> createState() => _IntegrationsBodyState();
}

class _IntegrationsBodyState extends State<_IntegrationsBody> {
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _eventSearchController = TextEditingController();

  var _provider = 'github';
  var _selectedTab = _IntegrationTab.systems;
  int? _selectedPersonId;
  int? _selectedSystemId;

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _eventSearchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<IntegrationsViewModel>();

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.md),
      children: [
        _IntegrationTabBar(
          selected: _selectedTab,
          onChanged: (tab) => setState(() => _selectedTab = tab),
        ),
        if (viewModel.actionErrorMessage != null) ...[
          const SizedBox(height: AppSpacing.md),
          _ActionErrorBanner(
            message: viewModel.actionErrorMessage!,
            onDismiss: viewModel.clearActionError,
          ),
        ],
        if (viewModel.latestToken != null) ...[
          const SizedBox(height: AppSpacing.md),
          _TokenPanel(token: viewModel.latestToken!),
        ],
        const SizedBox(height: AppSpacing.md),
        switch (_selectedTab) {
          _IntegrationTab.systems => _systemsSection(viewModel),
          _IntegrationTab.identities => _identitiesSection(viewModel),
          _IntegrationTab.metrics => _metricsSection(viewModel),
          _IntegrationTab.events => _eventsSection(viewModel),
        },
      ],
    );
  }

  Widget _systemsSection(IntegrationsViewModel viewModel) {
    return _SectionStack(
      children: [
        _Surface(child: _integrationForm(viewModel)),
        const _SectionTitle(title: 'Integrações cadastradas'),
        if (viewModel.systems.isEmpty)
          const _EmptyPanel(message: 'Nenhuma integração cadastrada ainda.')
        else ...[
          for (final system in viewModel.pagedSystems)
            _SystemTile(system: system, viewModel: viewModel),
          _InlinePagination(
            page: viewModel.systemsPage,
            lastPage: viewModel.systemsLastPage,
            onPrevious: viewModel.systemsPage <= 1
                ? null
                : () => viewModel.changeSystemsPage(viewModel.systemsPage - 1),
            onNext: viewModel.systemsPage >= viewModel.systemsLastPage
                ? null
                : () => viewModel.changeSystemsPage(viewModel.systemsPage + 1),
          ),
        ],
      ],
    );
  }

  Widget _identitiesSection(IntegrationsViewModel viewModel) {
    return _SectionStack(
      children: [
        _Surface(child: _identityForm(viewModel)),
        const _SectionTitle(title: 'Códigos externos por pessoa'),
        if (viewModel.identities.isEmpty)
          const _EmptyPanel(message: 'Nenhum vínculo externo cadastrado.')
        else ...[
          for (final identity in viewModel.pagedIdentities)
            _IdentityTile(identity: identity, viewModel: viewModel),
          _InlinePagination(
            page: viewModel.identitiesPage,
            lastPage: viewModel.identitiesLastPage,
            onPrevious: viewModel.identitiesPage <= 1
                ? null
                : () => viewModel.changeIdentitiesPage(
                    viewModel.identitiesPage - 1,
                  ),
            onNext: viewModel.identitiesPage >= viewModel.identitiesLastPage
                ? null
                : () => viewModel.changeIdentitiesPage(
                    viewModel.identitiesPage + 1,
                  ),
          ),
        ],
      ],
    );
  }

  Widget _metricsSection(IntegrationsViewModel viewModel) {
    return _SectionStack(
      children: [
        _SectionTitle(
          title: 'Métricas recebidas',
          subtitle: viewModel.metricsTotal == 0
              ? 'Dados calculados a partir dos webhooks recebidos.'
              : '${viewModel.metricsTotal} métricas calculadas via webhook.',
        ),
        if (viewModel.metrics.isEmpty)
          const _EmptyPanel(message: 'Nenhuma métrica recebida via webhook.')
        else ...[
          for (final metric in viewModel.metrics)
            _MetricTile(metric: metric, viewModel: viewModel),
          _InlinePagination(
            page: viewModel.metricsPage,
            lastPage: viewModel.metricsLastPage,
            onPrevious: viewModel.metricsPage <= 1 || viewModel.isMutating
                ? null
                : () => viewModel.changeMetricsPage(viewModel.metricsPage - 1),
            onNext:
                viewModel.metricsPage >= viewModel.metricsLastPage ||
                    viewModel.isMutating
                ? null
                : () => viewModel.changeMetricsPage(viewModel.metricsPage + 1),
          ),
        ],
      ],
    );
  }

  Widget _eventsSection(IntegrationsViewModel viewModel) {
    if (!Breakpoints.isDesktop(context)) {
      return const _EmptyPanel(
        message: 'A análise detalhada dos webhooks está disponível no desktop.',
      );
    }

    return _SectionStack(
      children: [
        _SectionTitle(
          title: 'Eventos recebidos',
          subtitle: viewModel.webhookEventsTotal == 0
              ? 'Dados processados recebidos pelos webhooks.'
              : '${viewModel.webhookEventsTotal} eventos encontrados.',
        ),
        _WebhookEventSummary(events: viewModel.webhookEvents),
        _Surface(
          child: _WebhookEventFilters(
            viewModel: viewModel,
            searchController: _eventSearchController,
          ),
        ),
        if (viewModel.webhookEvents.isEmpty)
          const _EmptyPanel(message: 'Nenhum evento encontrado.')
        else
          _WebhookEventTable(
            viewModel: viewModel,
            onOpen: (event) => _openWebhookEventDetail(viewModel, event),
            onArchive: (event) =>
                _confirmWebhookEventArchive(context, viewModel, event),
          ),
        _InlinePagination(
          page: viewModel.webhookEventsPage,
          lastPage: viewModel.webhookEventsLastPage,
          onPrevious: viewModel.webhookEventsPage <= 1 || viewModel.isMutating
              ? null
              : () => viewModel.changeWebhookEventsPage(
                  viewModel.webhookEventsPage - 1,
                ),
          onNext:
              viewModel.webhookEventsPage >= viewModel.webhookEventsLastPage ||
                  viewModel.isMutating
              ? null
              : () => viewModel.changeWebhookEventsPage(
                  viewModel.webhookEventsPage + 1,
                ),
        ),
      ],
    );
  }

  Future<void> _openWebhookEventDetail(
    IntegrationsViewModel viewModel,
    IntegrationWebhookEvent event,
  ) async {
    final loaded = await viewModel.loadWebhookEventDetail(event.id);
    if (!loaded || !mounted || viewModel.selectedWebhookEvent == null) {
      return;
    }

    await showDialog<void>(
      context: context,
      builder: (context) => _WebhookEventDetailDialog(
        event: viewModel.selectedWebhookEvent!,
        viewModel: viewModel,
      ),
    );
  }

  Future<void> _confirmWebhookEventArchive(
    BuildContext context,
    IntegrationsViewModel viewModel,
    IntegrationWebhookEvent event,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Arquivar evento?'),
        content: Text(
          'O evento ${event.eventId} será ocultado da lista principal, '
          'mas continuará preservado no banco para auditoria.',
        ),
        actionsPadding: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          0,
          AppSpacing.lg,
          AppSpacing.lg,
        ),
        actions: [
          AppDialogActions(
            secondaryLabel: 'Cancelar',
            onSecondaryPressed: () => Navigator.of(context).pop(false),
            primaryLabel: 'Arquivar',
            onPrimaryPressed: () => Navigator.of(context).pop(true),
          ),
        ],
      ),
    );

    if (confirmed != true || !context.mounted) {
      return;
    }

    final archived = await viewModel.archiveWebhookEvent(event.id);
    if (archived && context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Evento arquivado.')));
    }
  }

  Widget _integrationForm(IntegrationsViewModel viewModel) {
    return _FormColumn(
      children: [
        const _SectionTitle(
          title: 'Novo sistema',
          subtitle: 'Cadastre GitHub, ClickUp ou outro emissor de webhook.',
        ),
        DropdownButtonFormField<String>(
          initialValue: _provider,
          decoration: const InputDecoration(labelText: 'Sistema'),
          items: const [
            DropdownMenuItem(value: 'github', child: Text('GitHub')),
            DropdownMenuItem(value: 'clickup', child: Text('ClickUp')),
            DropdownMenuItem(value: 'custom', child: Text('Customizado')),
          ],
          onChanged: (value) {
            if (value != null) {
              setState(() => _provider = value);
            }
          },
        ),
        TextField(
          controller: _nameController,
          decoration: const InputDecoration(labelText: 'Nome da integração'),
        ),
        TextField(
          controller: _descriptionController,
          minLines: 2,
          maxLines: 4,
          decoration: const InputDecoration(labelText: 'Descrição'),
        ),
        SizedBox(
          width: double.infinity,
          child: AppPrimaryButton(
            label: 'Criar integração',
            onPressed: () async {
              if (_nameController.text.trim().isEmpty) {
                return;
              }

              final saved = await viewModel.createSystem(
                name: _nameController.text.trim(),
                provider: _provider,
                description: _nullable(_descriptionController.text),
              );
              if (saved) {
                _nameController.clear();
                _descriptionController.clear();
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _identityForm(IntegrationsViewModel viewModel) {
    return _FormColumn(
      children: [
        const _SectionTitle(
          title: 'Vínculo externo',
          subtitle: 'O sistema gera o código que o webhook deve enviar.',
        ),
        DropdownButtonFormField<int>(
          key: ValueKey('system-$_selectedSystemId'),
          initialValue: _selectedSystemId,
          decoration: const InputDecoration(labelText: 'Integração'),
          items: [
            for (final system in viewModel.systems)
              DropdownMenuItem(value: system.id, child: Text(system.name)),
          ],
          onChanged: (value) => setState(() => _selectedSystemId = value),
        ),
        DropdownButtonFormField<int>(
          key: ValueKey('person-$_selectedPersonId'),
          initialValue: _selectedPersonId,
          decoration: const InputDecoration(labelText: 'Pessoa'),
          items: [
            for (final person in viewModel.people)
              DropdownMenuItem(value: person.id, child: Text(person.name)),
          ],
          onChanged: (value) => setState(() => _selectedPersonId = value),
        ),
        const _GeneratedCodeHint(),
        Row(
          children: [
            Expanded(
              child: AppSecondaryButton(
                label: 'Limpar',
                onPressed: () {
                  setState(() {
                    _selectedPersonId = null;
                    _selectedSystemId = null;
                  });
                },
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: AppPrimaryButton(
                label: 'Gerar vínculo',
                onPressed: () async {
                  final personId = _selectedPersonId;
                  final systemId = _selectedSystemId;
                  if (personId == null || systemId == null) {
                    return;
                  }

                  await viewModel.createExternalIdentity(
                    personId: personId,
                    integrationSystemId: systemId,
                  );
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _GeneratedCodeHint extends StatelessWidget {
  const _GeneratedCodeHint();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(Icons.key_outlined, color: theme.colorScheme.primary),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Text(
            'Depois de gerar, use o código exibido na lista como '
            'external_actor_code no JSON do webhook.',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      ],
    );
  }
}

enum _IntegrationTab {
  systems(Icons.hub_outlined, 'Sistemas'),
  identities(Icons.link_outlined, 'Vínculos'),
  metrics(Icons.analytics_outlined, 'Métricas'),
  events(Icons.receipt_long_outlined, 'Eventos');

  const _IntegrationTab(this.icon, this.label);

  final IconData icon;
  final String label;
}

class _IntegrationTabBar extends StatelessWidget {
  const _IntegrationTabBar({required this.selected, required this.onChanged});

  final _IntegrationTab selected;
  final ValueChanged<_IntegrationTab> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final borderColor = theme.colorScheme.outlineVariant.withValues(
      alpha: 0.55,
    );

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Container(
        height: 44,
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          border: Border.all(color: borderColor),
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
        clipBehavior: Clip.antiAlias,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (
              var index = 0;
              index < _IntegrationTab.values.length;
              index++
            ) ...[
              if (index > 0)
                VerticalDivider(width: 1, thickness: 1, color: borderColor),
              _IntegrationTabButton(
                tab: _IntegrationTab.values[index],
                selected: _IntegrationTab.values[index] == selected,
                onPressed: () => onChanged(_IntegrationTab.values[index]),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _IntegrationTabButton extends StatelessWidget {
  const _IntegrationTabButton({
    required this.tab,
    required this.selected,
    required this.onPressed,
  });

  final _IntegrationTab tab;
  final bool selected;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final foreground = selected
        ? theme.colorScheme.onPrimary
        : theme.colorScheme.onSurface;

    return Material(
      color: selected ? theme.colorScheme.primary : Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(tab.icon, size: 19, color: foreground),
              const SizedBox(width: AppSpacing.xs),
              Text(
                tab.label,
                style: theme.textTheme.labelLarge?.copyWith(color: foreground),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TokenPanel extends StatelessWidget {
  const _TokenPanel({required this.token});

  final String token;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return _Surface(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Token gerado', style: theme.textTheme.titleSmall),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Guarde este valor agora. Depois o sistema mostra apenas o prefixo.',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          SelectableText(token),
        ],
      ),
    );
  }
}

class _SystemTile extends StatelessWidget {
  const _SystemTile({required this.system, required this.viewModel});

  final IntegrationSystem system;
  final IntegrationsViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return _Surface(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(_providerIcon(system.provider)),
            title: Text(system.name),
            subtitle: Text(
              '${system.provider} · token ${system.tokenPrefix}...'
              '${system.lastReceivedAt == null ? '' : ' · recebeu evento'}',
            ),
            trailing: Icon(
              system.active
                  ? Icons.check_circle_outline
                  : Icons.pause_circle_outline,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'O token completo só aparece ao criar ou gerar um novo token.',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Align(
            alignment: Alignment.centerRight,
            child: OutlinedButton.icon(
              onPressed: viewModel.isMutating
                  ? null
                  : () => _confirmTokenRegeneration(context, system, viewModel),
              icon: const Icon(Icons.sync),
              label: const Text('Gerar novo token'),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmTokenRegeneration(
    BuildContext context,
    IntegrationSystem system,
    IntegrationsViewModel viewModel,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Gerar novo token?'),
        content: Text(
          'O token atual de ${system.name} vai parar de funcionar. '
          'Atualize o segredo no sistema externo depois de copiar o novo token.',
        ),
        actionsPadding: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          0,
          AppSpacing.lg,
          AppSpacing.lg,
        ),
        actions: [
          AppDialogActions(
            secondaryLabel: 'Cancelar',
            onSecondaryPressed: () => Navigator.of(context).pop(false),
            primaryLabel: 'Gerar token',
            onPrimaryPressed: () => Navigator.of(context).pop(true),
          ),
        ],
      ),
    );

    if (confirmed != true || !context.mounted) {
      return;
    }

    final saved = await viewModel.regenerateSystemToken(system.id);
    if (saved && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Novo token gerado. Copie antes de sair da tela.'),
        ),
      );
    }
  }
}

class _IdentityTile extends StatelessWidget {
  const _IdentityTile({required this.identity, required this.viewModel});

  final PersonExternalIdentity identity;
  final IntegrationsViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return _Surface(
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        leading: const Icon(Icons.link_outlined),
        title: Text(viewModel.personName(identity.personId)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(viewModel.systemName(identity.integrationSystemId)),
            const SizedBox(height: AppSpacing.xs),
            SelectableText('external_actor_code: ${identity.externalCode}'),
          ],
        ),
      ),
    );
  }
}

class _MetricTile extends StatelessWidget {
  const _MetricTile({required this.metric, required this.viewModel});

  final PersonDeliveryMetric metric;
  final IntegrationsViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return _Surface(
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        leading: const Icon(Icons.analytics_outlined),
        title: Text(_metricLabel(metric.metricType)),
        subtitle: Text(
          '${viewModel.personName(metric.personId)}'
          '${metric.sourceRef == null ? '' : ' · ${metric.sourceRef}'}',
        ),
        trailing: Text('${metric.metricValue} ${metric.unit ?? ''}'.trim()),
      ),
    );
  }
}

class _WebhookEventSummary extends StatelessWidget {
  const _WebhookEventSummary({required this.events});

  final List<IntegrationWebhookEvent> events;

  @override
  Widget build(BuildContext context) {
    final failures = events
        .where((event) => event.failureReason != null)
        .length;
    final unmapped = events.where((event) => event.personId == null).length;
    final processed = events
        .where((event) => event.status == 'processed')
        .length;

    return Row(
      children: [
        Expanded(
          child: _SummaryTile(
            label: 'Na página',
            value: '${events.length}',
            icon: Icons.receipt_long_outlined,
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: _SummaryTile(
            label: 'Processados',
            value: '$processed',
            icon: Icons.check_circle_outline,
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: _SummaryTile(
            label: 'Sem pessoa',
            value: '$unmapped',
            icon: Icons.person_off_outlined,
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: _SummaryTile(
            label: 'Com erro',
            value: '$failures',
            icon: Icons.error_outline,
          ),
        ),
      ],
    );
  }
}

class _SummaryTile extends StatelessWidget {
  const _SummaryTile({
    required this.label,
    required this.value,
    required this.icon,
  });

  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return _Surface(
      child: Row(
        children: [
          Icon(icon, color: theme.colorScheme.primary),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(value, style: theme.textTheme.titleLarge),
                Text(
                  label,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _WebhookEventFilters extends StatelessWidget {
  const _WebhookEventFilters({
    required this.viewModel,
    required this.searchController,
  });

  final IntegrationsViewModel viewModel;
  final TextEditingController searchController;

  @override
  Widget build(BuildContext context) {
    return _FormColumn(
      children: [
        Row(
          children: [
            Expanded(
              flex: 2,
              child: TextField(
                controller: searchController,
                decoration: const InputDecoration(
                  labelText: 'Buscar evento, tipo, ator ou erro',
                  prefixIcon: Icon(Icons.search),
                ),
                onSubmitted: (value) =>
                    viewModel.updateWebhookEventFilters(search: value),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: DropdownButtonFormField<int>(
                initialValue: viewModel.webhookEventSystemId,
                decoration: const InputDecoration(labelText: 'Integração'),
                items: [
                  for (final system in viewModel.systems)
                    DropdownMenuItem(
                      value: system.id,
                      child: Text(system.name),
                    ),
                ],
                onChanged: (value) => viewModel.updateWebhookEventFilters(
                  systemId: value,
                  clearSystemId: value == null,
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: DropdownButtonFormField<int>(
                initialValue: viewModel.webhookEventPersonId,
                decoration: const InputDecoration(labelText: 'Pessoa'),
                items: [
                  for (final person in viewModel.people)
                    DropdownMenuItem(
                      value: person.id,
                      child: Text(person.name),
                    ),
                ],
                onChanged: (value) => viewModel.updateWebhookEventFilters(
                  personId: value,
                  clearPersonId: value == null,
                ),
              ),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: DropdownButtonFormField<String>(
                initialValue: viewModel.webhookEventStatus,
                decoration: const InputDecoration(labelText: 'Status'),
                items: const [
                  DropdownMenuItem(
                    value: 'processed',
                    child: Text('Processado'),
                  ),
                  DropdownMenuItem(
                    value: 'unmapped_person',
                    child: Text('Sem pessoa'),
                  ),
                  DropdownMenuItem(value: 'received', child: Text('Recebido')),
                ],
                onChanged: (value) => viewModel.updateWebhookEventFilters(
                  status: value,
                  clearStatus: value == null,
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: DropdownButtonFormField<String>(
                initialValue: viewModel.webhookEventsOrderDirection,
                decoration: const InputDecoration(labelText: 'Ordem'),
                items: const [
                  DropdownMenuItem(value: 'desc', child: Text('Mais recentes')),
                  DropdownMenuItem(value: 'asc', child: Text('Mais antigos')),
                ],
                onChanged: (value) => viewModel.updateWebhookEventFilters(
                  orderDirection: value ?? 'desc',
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Sem pessoa'),
                value: viewModel.webhookEventsOnlyUnmapped,
                onChanged: (value) => viewModel.updateWebhookEventFilters(
                  onlyUnmapped: value ?? false,
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Com erro'),
                value: viewModel.webhookEventsOnlyFailures,
                onChanged: (value) => viewModel.updateWebhookEventFilters(
                  onlyFailures: value ?? false,
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            IconButton.filledTonal(
              tooltip: 'Limpar filtros',
              onPressed: () {
                searchController.clear();
                viewModel.clearWebhookEventFilters();
              },
              icon: const Icon(Icons.filter_alt_off_outlined),
            ),
          ],
        ),
      ],
    );
  }
}

class _WebhookEventTable extends StatelessWidget {
  const _WebhookEventTable({
    required this.viewModel,
    required this.onOpen,
    required this.onArchive,
  });

  final IntegrationsViewModel viewModel;
  final ValueChanged<IntegrationWebhookEvent> onOpen;
  final ValueChanged<IntegrationWebhookEvent> onArchive;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return _Surface(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          headingTextStyle: theme.textTheme.labelMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
          showCheckboxColumn: false,
          columns: const [
            DataColumn(label: Text('Recebido')),
            DataColumn(label: Text('Integração')),
            DataColumn(label: Text('Tipo')),
            DataColumn(label: Text('Status')),
            DataColumn(label: Text('Pessoa')),
            DataColumn(label: Text('Métricas')),
            DataColumn(label: Text('')),
          ],
          rows: [
            for (final event in viewModel.webhookEvents)
              DataRow(
                onSelectChanged: (_) => onOpen(event),
                cells: [
                  DataCell(Text(_formatDateTime(event.receivedAt))),
                  DataCell(
                    Text(viewModel.systemName(event.integrationSystemId)),
                  ),
                  DataCell(Text(event.eventType)),
                  DataCell(_StatusChip(status: event.status)),
                  DataCell(Text(_eventPersonName(viewModel, event))),
                  DataCell(Text('${event.deliveryMetricsCount ?? 0}')),
                  DataCell(
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          tooltip: 'Detalhar',
                          onPressed: () => onOpen(event),
                          icon: const Icon(Icons.visibility_outlined),
                        ),
                        IconButton(
                          tooltip: 'Arquivar',
                          onPressed: viewModel.isMutating
                              ? null
                              : () => onArchive(event),
                          icon: const Icon(Icons.archive_outlined),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Chip(
      label: Text(_statusLabel(status)),
      visualDensity: VisualDensity.compact,
      side: BorderSide(color: theme.colorScheme.outlineVariant),
    );
  }
}

class _WebhookEventDetailDialog extends StatelessWidget {
  const _WebhookEventDetailDialog({
    required this.event,
    required this.viewModel,
  });

  final IntegrationWebhookEvent event;
  final IntegrationsViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(event.eventType),
      content: SizedBox(
        width: 920,
        child: SingleChildScrollView(
          child: _SectionStack(
            children: [
              _WebhookEventDetailHeader(event: event, viewModel: viewModel),
              _JsonPanel(title: 'Payload armazenado', value: event.payload),
              _JsonPanel(
                title: 'Payload normalizado',
                value: event.normalizedPayload ?? const {},
              ),
              _WebhookEventMetrics(metrics: event.deliveryMetrics),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Fechar'),
        ),
      ],
    );
  }
}

class _WebhookEventDetailHeader extends StatelessWidget {
  const _WebhookEventDetailHeader({
    required this.event,
    required this.viewModel,
  });

  final IntegrationWebhookEvent event;
  final IntegrationsViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return _Surface(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: AppSpacing.md,
            runSpacing: AppSpacing.sm,
            children: [
              _DetailItem(label: 'Evento', value: event.eventId),
              _DetailItem(
                label: 'Integração',
                value: viewModel.systemName(event.integrationSystemId),
              ),
              _DetailItem(
                label: 'Pessoa',
                value: _eventPersonName(viewModel, event),
              ),
              _DetailItem(
                label: 'Recebido',
                value: _formatDateTime(event.receivedAt),
              ),
              _DetailItem(
                label: 'Tamanho',
                value: event.payloadSizeBytes == null
                    ? '-'
                    : '${event.payloadSizeBytes} bytes',
              ),
            ],
          ),
          if (event.payloadHash != null) ...[
            const SizedBox(height: AppSpacing.sm),
            SelectableText('hash: ${event.payloadHash}'),
          ],
          if (event.failureReason != null) ...[
            const SizedBox(height: AppSpacing.sm),
            Text(
              event.failureReason!,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.error,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _DetailItem extends StatelessWidget {
  const _DetailItem({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      width: 160,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          SelectableText(value, maxLines: 3),
        ],
      ),
    );
  }
}

class _JsonPanel extends StatelessWidget {
  const _JsonPanel({required this.title, required this.value});

  final String title;
  final Map<String, dynamic> value;

  @override
  Widget build(BuildContext context) {
    final formatted = const JsonEncoder.withIndent('  ').convert(value);

    return _Surface(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ),
              IconButton(
                tooltip: 'Copiar JSON',
                onPressed: () async {
                  await Clipboard.setData(ClipboardData(text: formatted));
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('JSON copiado.')),
                    );
                  }
                },
                icon: const Icon(Icons.copy_outlined),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          SelectableText(formatted),
        ],
      ),
    );
  }
}

class _WebhookEventMetrics extends StatelessWidget {
  const _WebhookEventMetrics({required this.metrics});

  final List<PersonDeliveryMetric> metrics;

  @override
  Widget build(BuildContext context) {
    if (metrics.isEmpty) {
      return const _EmptyPanel(
        message: 'Nenhuma métrica foi gerada por este evento.',
      );
    }

    return _Surface(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Métricas geradas',
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(height: AppSpacing.sm),
          for (final metric in metrics)
            ListTile(
              contentPadding: EdgeInsets.zero,
              dense: true,
              title: Text(_metricLabel(metric.metricType)),
              subtitle: Text(metric.sourceRef ?? '-'),
              trailing: Text(
                '${metric.metricValue} ${metric.unit ?? ''}'.trim(),
              ),
            ),
        ],
      ),
    );
  }
}

class _SectionStack extends StatelessWidget {
  const _SectionStack({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var index = 0; index < children.length; index++) ...[
          if (index > 0) const SizedBox(height: AppSpacing.sm),
          children[index],
        ],
      ],
    );
  }
}

class _InlinePagination extends StatelessWidget {
  const _InlinePagination({
    required this.page,
    required this.lastPage,
    required this.onPrevious,
    required this.onNext,
  });

  final int page;
  final int lastPage;
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
              child: Text(
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

class _FormColumn extends StatelessWidget {
  const _FormColumn({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var index = 0; index < children.length; index++) ...[
          if (index > 0) const SizedBox(height: AppSpacing.sm),
          children[index],
        ],
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title, this.subtitle});

  final String title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Align(
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: theme.textTheme.titleMedium),
          if (subtitle != null)
            Text(
              subtitle!,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
        ],
      ),
    );
  }
}

class _EmptyPanel extends StatelessWidget {
  const _EmptyPanel({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return _Surface(
      child: Row(
        children: [
          Icon(
            Icons.info_outline,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(child: Text(message)),
        ],
      ),
    );
  }
}

class _ActionErrorBanner extends StatelessWidget {
  const _ActionErrorBanner({required this.message, required this.onDismiss});

  final String message;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: colorScheme.errorContainer,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: colorScheme.error),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline, color: colorScheme.onErrorContainer),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              message,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onErrorContainer,
              ),
            ),
          ),
          IconButton(
            tooltip: 'Dispensar',
            onPressed: onDismiss,
            icon: Icon(Icons.close, color: colorScheme.onErrorContainer),
          ),
        ],
      ),
    );
  }
}

class _Surface extends StatelessWidget {
  const _Surface({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: child,
      ),
    );
  }
}

IconData _providerIcon(String provider) {
  return switch (provider) {
    'github' => Icons.code,
    'clickup' => Icons.task_alt,
    _ => Icons.hub_outlined,
  };
}

String _eventPersonName(
  IntegrationsViewModel viewModel,
  IntegrationWebhookEvent event,
) {
  final personId = event.personId;
  return personId == null ? 'Sem pessoa' : viewModel.personName(personId);
}

String _statusLabel(String status) {
  return switch (status) {
    'processed' => 'Processado',
    'unmapped_person' => 'Sem pessoa',
    'received' => 'Recebido',
    'ignored' => 'Ignorado',
    'failed' => 'Com erro',
    _ => status,
  };
}

String _formatDateTime(DateTime? value) {
  if (value == null) {
    return '-';
  }

  return DateFormat.yMMMd('pt_BR').add_Hm().format(value.toLocal());
}

String _metricLabel(String type) {
  return switch (type) {
    'code_quality_score' => 'Qualidade do código',
    'delivery_points' => 'Pontos entregues',
    'task_completed_count' => 'Tarefas concluídas',
    'task_status_change_count' => 'Mudanças de status',
    'task_delivery_points' => 'Pontos de tarefas',
    'task_delivery_count' => 'Tarefas entregues',
    'pull_request_count' => 'Pull requests',
    'pull_request_merged_count' => 'PRs mesclados',
    'pull_request_closed_without_merge_count' => 'PRs fechados sem merge',
    'pull_request_open_time' => 'Tempo até fechamento',
    'pull_request_merge_time' => 'Tempo até merge',
    'pull_request_changed_files' => 'Arquivos alterados',
    'pull_request_changed_lines' => 'Linhas alteradas',
    'review_count' => 'Reviews',
    'review_approved_count' => 'Reviews aprovados',
    'review_changes_requested_count' => 'Reviews com alterações',
    'review_commented_count' => 'Reviews comentados',
    'ci_run_count' => 'Execuções de CI',
    'ci_success_count' => 'CI com sucesso',
    'ci_failure_count' => 'Falhas de CI',
    'deployment_count' => 'Deployments',
    'deployment_success_count' => 'Deployments com sucesso',
    'deployment_failure_count' => 'Falhas de deploy',
    'task_pull_request_link_count' => 'Tarefa vinculada a PR',
    'task_to_pull_request_hours' => 'Tempo tarefa até PR',
    'review_comments_count' => 'Comentários de review',
    'ci_failures_count' => 'Falhas de CI',
    'rework_count' => 'Retrabalho',
    'changed_files_count' => 'Arquivos alterados',
    'changed_lines_count' => 'Linhas alteradas',
    'pr_merge_time_hours' => 'Tempo até merge',
    'review_acceptance_rate' => 'Aceite em review',
    'ci_success_rate' => 'CI com sucesso',
    'annual_pull_request_count' => 'PRs no ano',
    'annual_task_delivery_count' => 'Tarefas no ano',
    'annual_quality_average' => 'Qualidade média anual',
    'annual_review_comment_average' => 'Review / PR',
    'annual_ci_failure_average' => 'CI falhando / PR',
    'annual_rework_average' => 'Retrabalho / PR',
    'annual_delivery_points_total' => 'Pontos entregues no ano',
    'annual_pr_size_average' => 'Tamanho médio de PR',
    'annual_pr_merge_time_average' => 'Tempo médio até merge',
    'annual_review_acceptance_rate' => 'Aceite anual em review',
    'annual_ci_success_rate' => 'Sucesso anual de CI',
    _ => type,
  };
}

String? _nullable(String value) {
  final trimmed = value.trim();
  return trimmed.isEmpty ? null : trimmed;
}
