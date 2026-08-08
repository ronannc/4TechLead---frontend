import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../bootstrap.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/viewmodels/base_view_model.dart';
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
  final _externalCodeController = TextEditingController();
  final _externalUsernameController = TextEditingController();

  var _provider = 'github';
  int? _selectedPersonId;
  int? _selectedSystemId;

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _externalCodeController.dispose();
    _externalUsernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<IntegrationsViewModel>();

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.md),
      children: [
        _ResponsiveGrid(
          children: [
            _Surface(child: _integrationForm(viewModel)),
            _Surface(child: _identityForm(viewModel)),
          ],
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
        _SectionTitle(title: 'Integrações cadastradas'),
        const SizedBox(height: AppSpacing.sm),
        if (viewModel.systems.isEmpty)
          const _EmptyPanel(message: 'Nenhuma integração cadastrada ainda.')
        else
          for (final system in viewModel.systems) _SystemTile(system: system),
        const SizedBox(height: AppSpacing.md),
        _SectionTitle(title: 'Códigos externos por pessoa'),
        const SizedBox(height: AppSpacing.sm),
        if (viewModel.identities.isEmpty)
          const _EmptyPanel(message: 'Nenhum vínculo externo cadastrado.')
        else
          for (final identity in viewModel.identities)
            _IdentityTile(identity: identity, viewModel: viewModel),
        const SizedBox(height: AppSpacing.md),
        _SectionTitle(title: 'Métricas recebidas'),
        const SizedBox(height: AppSpacing.sm),
        if (viewModel.metrics.isEmpty)
          const _EmptyPanel(message: 'Nenhuma métrica recebida via webhook.')
        else
          for (final metric in viewModel.metrics)
            _MetricTile(metric: metric, viewModel: viewModel),
      ],
    );
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
          subtitle: 'Associe o código enviado no webhook a uma pessoa.',
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
        TextField(
          controller: _externalCodeController,
          decoration: const InputDecoration(
            labelText: 'Código externo',
            helperText: 'Ex.: usuário GitHub, ID ClickUp ou e-mail externo.',
          ),
        ),
        TextField(
          controller: _externalUsernameController,
          decoration: const InputDecoration(labelText: 'Nome externo'),
        ),
        Row(
          children: [
            Expanded(
              child: AppSecondaryButton(
                label: 'Limpar',
                onPressed: () {
                  _externalCodeController.clear();
                  _externalUsernameController.clear();
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
                label: 'Vincular',
                onPressed: () async {
                  final personId = _selectedPersonId;
                  final systemId = _selectedSystemId;
                  final externalCode = _externalCodeController.text.trim();
                  if (personId == null ||
                      systemId == null ||
                      externalCode.isEmpty) {
                    return;
                  }

                  final saved = await viewModel.createExternalIdentity(
                    personId: personId,
                    integrationSystemId: systemId,
                    externalCode: externalCode,
                    externalUsername: _nullable(
                      _externalUsernameController.text,
                    ),
                  );
                  if (saved) {
                    _externalCodeController.clear();
                    _externalUsernameController.clear();
                  }
                },
              ),
            ),
          ],
        ),
      ],
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
  const _SystemTile({required this.system});

  final IntegrationSystem system;

  @override
  Widget build(BuildContext context) {
    return _Surface(
      child: ListTile(
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
    );
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
        subtitle: Text(
          '${viewModel.systemName(identity.integrationSystemId)} · ${identity.externalCode}',
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
        trailing: Text('${metric.metricValue} ${metric.unit ?? ''}'),
      ),
    );
  }
}

class _ResponsiveGrid extends StatelessWidget {
  const _ResponsiveGrid({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 840;
        final itemWidth = compact
            ? constraints.maxWidth
            : (constraints.maxWidth - AppSpacing.md) / 2;

        return Wrap(
          spacing: AppSpacing.md,
          runSpacing: AppSpacing.md,
          children: [
            for (final child in children)
              SizedBox(width: itemWidth, child: child),
          ],
        );
      },
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

String _metricLabel(String type) {
  return switch (type) {
    'code_quality_score' => 'Qualidade do código',
    'delivery_points' => 'Pontos entregues',
    'pull_request_count' => 'Pull requests',
    'review_comments_count' => 'Comentários de review',
    'ci_failures_count' => 'Falhas de CI',
    'rework_count' => 'Retrabalho',
    'changed_files_count' => 'Arquivos alterados',
    _ => type,
  };
}

String? _nullable(String value) {
  final trimmed = value.trim();
  return trimmed.isEmpty ? null : trimmed;
}
