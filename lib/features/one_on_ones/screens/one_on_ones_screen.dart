import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../bootstrap.dart';
import '../../../core/auth/auth_session.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/viewmodels/base_view_model.dart';
import '../../../core/widgets/buttons/app_primary_button.dart';
import '../../../core/widgets/navigation/app_page_header.dart';
import '../../../core/widgets/states/error_view.dart';
import '../../../core/widgets/states/loading_view.dart';
import '../../people/models/person_growth_models.dart';
import '../../people/repositories/person_growth_repository.dart';
import '../../people/repositories/person_repository.dart';
import '../viewmodels/one_on_ones_view_model.dart';

enum _OneOnOneTab { documents, execute, points, history }

extension on _OneOnOneTab {
  String get label {
    return switch (this) {
      _OneOnOneTab.documents => 'Documentos',
      _OneOnOneTab.execute => 'Executar',
      _OneOnOneTab.points => 'Pontos',
      _OneOnOneTab.history => 'Histórico',
    };
  }

  IconData get icon {
    return switch (this) {
      _OneOnOneTab.documents => Icons.description_outlined,
      _OneOnOneTab.execute => Icons.forum_outlined,
      _OneOnOneTab.points => Icons.push_pin_outlined,
      _OneOnOneTab.history => Icons.history_outlined,
    };
  }
}

class OneOnOnesScreen extends StatelessWidget {
  const OneOnOnesScreen({super.key, this.initialPersonId, this.initialTab});

  final String? initialPersonId;
  final String? initialTab;

  @override
  Widget build(BuildContext context) {
    final authSession = getIt<AuthSession>();
    final canManageOneOnOnes = authSession.isTechLead;

    return ChangeNotifierProvider(
      create: (_) => OneOnOnesViewModel(
        getIt<PersonGrowthRepository>(),
        getIt<PersonRepository>(),
        canManageOneOnOnes: canManageOneOnOnes,
        currentPersonId: authSession.personId,
      )..load(initialPersonId: int.tryParse(initialPersonId ?? '')),
      child: Scaffold(
        appBar: const AppPageHeader(
          subtitle: 'Documentos, execução e histórico',
          title: '1:1',
        ),
        body: Consumer<OneOnOnesViewModel>(
          builder: (context, viewModel, _) {
            final hasContent =
                viewModel.people.isNotEmpty ||
                viewModel.templates.isNotEmpty ||
                viewModel.completedSessions.isNotEmpty ||
                viewModel.personNotes.isNotEmpty;

            if (viewModel.state == ViewState.loading && !hasContent) {
              return const LoadingView();
            }

            if (viewModel.state == ViewState.error && !hasContent) {
              return ErrorView(
                message: viewModel.errorMessage ?? 'Algo deu errado.',
                onRetry: viewModel.load,
              );
            }

            return _OneOnOnesBody(initialTab: _parseTab(initialTab));
          },
        ),
      ),
    );
  }

  _OneOnOneTab? _parseTab(String? value) {
    return switch (value) {
      'execute' => _OneOnOneTab.execute,
      'points' => _OneOnOneTab.points,
      'history' => _OneOnOneTab.history,
      'documents' => _OneOnOneTab.documents,
      _ => null,
    };
  }
}

class _OneOnOnesBody extends StatefulWidget {
  const _OneOnOnesBody({this.initialTab});

  final _OneOnOneTab? initialTab;

  @override
  State<_OneOnOnesBody> createState() => _OneOnOnesBodyState();
}

class _OneOnOnesBodyState extends State<_OneOnOnesBody> {
  final _documentTitleController = TextEditingController();
  final _documentDescriptionController = TextEditingController();
  final _documentQuestionsController = TextEditingController();
  final _sessionTitleController = TextEditingController();
  final _sessionNotesController = TextEditingController();
  final _pointTitleController = TextEditingController();
  final _pointBodyController = TextEditingController();

  late var _selectedTab = widget.initialTab ?? _OneOnOneTab.documents;

  @override
  void dispose() {
    _documentTitleController.dispose();
    _documentDescriptionController.dispose();
    _documentQuestionsController.dispose();
    _sessionTitleController.dispose();
    _sessionNotesController.dispose();
    _pointTitleController.dispose();
    _pointBodyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<OneOnOnesViewModel>();
    final tabs = viewModel.canManageOneOnOnes
        ? _OneOnOneTab.values
        : const [_OneOnOneTab.history];
    if (!tabs.contains(_selectedTab)) {
      _selectedTab = tabs.first;
    }

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.md),
      children: [
        _TabBar(
          selected: _selectedTab,
          tabs: tabs,
          onChanged: (tab) => setState(() => _selectedTab = tab),
        ),
        if (viewModel.actionErrorMessage != null) ...[
          const SizedBox(height: AppSpacing.md),
          _ActionErrorBanner(
            message: viewModel.actionErrorMessage!,
            onDismiss: viewModel.clearActionError,
          ),
        ],
        const SizedBox(height: AppSpacing.md),
        switch (_selectedTab) {
          _OneOnOneTab.documents => _documents(viewModel),
          _OneOnOneTab.execute => _execute(viewModel),
          _OneOnOneTab.points => _points(viewModel),
          _OneOnOneTab.history => _history(viewModel),
        },
      ],
    );
  }

  Widget _documents(OneOnOnesViewModel viewModel) {
    return _SectionStack(
      children: [
        _Surface(child: _documentForm(viewModel)),
        const _SectionTitle(
          title: 'Documentos de 1:1',
          subtitle: 'Roteiros-base sem vínculo com uma pessoa específica.',
        ),
        if (viewModel.templates.isEmpty)
          const _EmptyPanel(message: 'Nenhum documento de 1:1 criado ainda.')
        else
          for (final document in viewModel.templates)
            _DocumentTile(document: document),
      ],
    );
  }

  Widget _execute(OneOnOnesViewModel viewModel) {
    return _SectionStack(
      children: [
        _Surface(child: _sessionForm(viewModel)),
        const _SectionTitle(
          title: 'Pontos abertos da pessoa',
          subtitle: 'Assuntos anotados pelo TL para apoiar a conversa.',
        ),
        if (viewModel.personNotes.isEmpty)
          const _EmptyPanel(message: 'Nenhum ponto aberto para esta pessoa.')
        else
          for (final note in viewModel.personNotes)
            _PersonNoteTile(note: note, viewModel: viewModel),
      ],
    );
  }

  Widget _points(OneOnOnesViewModel viewModel) {
    return _SectionStack(
      children: [
        _Surface(child: _pointForm(viewModel)),
        const _SectionTitle(
          title: 'Pontos para próximos 1:1',
          subtitle: 'Anotações rápidas por pessoa, privadas ao Tech Lead.',
        ),
        if (viewModel.personNotes.isEmpty)
          const _EmptyPanel(message: 'Nenhum ponto aberto registrado.')
        else
          for (final note in viewModel.personNotes)
            _PersonNoteTile(note: note, viewModel: viewModel),
      ],
    );
  }

  Widget _history(OneOnOnesViewModel viewModel) {
    return _SectionStack(
      children: [
        _SectionTitle(
          title: viewModel.canManageOneOnOnes ? '1:1 realizados' : 'Meus 1:1',
          subtitle: viewModel.canManageOneOnOnes
              ? 'Histórico das conversas executadas com os liderados.'
              : 'Histórico em modo leitura das suas conversas.',
        ),
        if (viewModel.completedSessions.isEmpty)
          const _EmptyPanel(message: 'Nenhum 1:1 registrado ainda.')
        else
          for (final session in viewModel.completedSessions)
            _SessionTile(session: session, viewModel: viewModel),
      ],
    );
  }

  Widget _documentForm(OneOnOnesViewModel viewModel) {
    return _FormColumn(
      children: [
        const _SectionTitle(
          title: 'Criar documento-base',
          subtitle: 'Este documento será clonado quando um 1:1 for executado.',
        ),
        TextField(
          controller: _documentTitleController,
          decoration: const InputDecoration(labelText: 'Nome do documento'),
        ),
        TextField(
          controller: _documentDescriptionController,
          minLines: 2,
          maxLines: 4,
          decoration: const InputDecoration(labelText: 'Objetivo'),
        ),
        TextField(
          controller: _documentQuestionsController,
          minLines: 5,
          maxLines: 10,
          decoration: const InputDecoration(
            labelText: 'Perguntas e tópicos, um por linha',
          ),
        ),
        AppPrimaryButton(
          label: 'Criar documento',
          loading: viewModel.isMutating,
          onPressed: () => _createDocument(viewModel),
        ),
      ],
    );
  }

  Widget _sessionForm(OneOnOnesViewModel viewModel) {
    return _FormColumn(
      children: [
        const _SectionTitle(
          title: 'Executar 1:1',
          subtitle: 'Escolha a pessoa e clone um documento para esta conversa.',
        ),
        _PeopleDropdown(viewModel: viewModel),
        _DocumentDropdown(viewModel: viewModel),
        if (viewModel.selectedDocument != null)
          _DocumentPreview(document: viewModel.selectedDocument!),
        TextField(
          controller: _sessionTitleController,
          decoration: const InputDecoration(
            labelText: 'Título do 1:1',
            helperText: 'Ex.: 1:1 Setembro - conversa com Ada.',
          ),
        ),
        TextField(
          controller: _sessionNotesController,
          minLines: 10,
          maxLines: 18,
          decoration: const InputDecoration(
            labelText: 'Respostas, tópicos discutidos e decisões',
          ),
        ),
        AppPrimaryButton(
          label: 'Salvar 1:1 executado',
          loading: viewModel.isMutating,
          onPressed: () => _executeSession(viewModel),
        ),
      ],
    );
  }

  Widget _pointForm(OneOnOnesViewModel viewModel) {
    return _FormColumn(
      children: [
        const _SectionTitle(
          title: 'Anotar ponto',
          subtitle: 'Registre algo para trazer no próximo 1:1.',
        ),
        _PeopleDropdown(viewModel: viewModel),
        TextField(
          controller: _pointTitleController,
          decoration: const InputDecoration(labelText: 'Assunto'),
        ),
        TextField(
          controller: _pointBodyController,
          minLines: 3,
          maxLines: 6,
          decoration: const InputDecoration(labelText: 'Contexto'),
        ),
        AppPrimaryButton(
          label: 'Salvar ponto',
          loading: viewModel.isMutating,
          onPressed: () => _createPoint(viewModel),
        ),
      ],
    );
  }

  Future<void> _createDocument(OneOnOnesViewModel viewModel) async {
    final title = _documentTitleController.text.trim();
    final questions = _lines(_documentQuestionsController.text);
    if (title.isEmpty || questions.isEmpty) {
      return;
    }

    await viewModel.createTemplate(
      title: title,
      description: _nullable(_documentDescriptionController.text),
      questions: questions,
    );
    _documentTitleController.clear();
    _documentDescriptionController.clear();
    _documentQuestionsController.clear();
  }

  Future<void> _executeSession(OneOnOnesViewModel viewModel) async {
    final title = _sessionTitleController.text.trim();
    if (title.isEmpty) {
      return;
    }

    final notes = _nullable(_sessionNotesController.text);
    final saved = await viewModel.executeSession(
      title: title,
      notes: notes,
      answers: _sessionAnswers(viewModel, notes),
    );
    if (!saved) {
      return;
    }

    _sessionTitleController.clear();
    _sessionNotesController.clear();
  }

  Future<void> _createPoint(OneOnOnesViewModel viewModel) async {
    final title = _pointTitleController.text.trim();
    if (title.isEmpty) {
      return;
    }

    await viewModel.createPersonNote(
      title: title,
      body: _nullable(_pointBodyController.text),
    );
    _pointTitleController.clear();
    _pointBodyController.clear();
  }

  Map<String, dynamic>? _sessionAnswers(
    OneOnOnesViewModel viewModel,
    String? notes,
  ) {
    if (notes == null) {
      return null;
    }

    final document = viewModel.selectedDocument;
    if (document == null || document.questions.isEmpty) {
      return {'respostas': notes};
    }

    return {for (final question in document.questions) question: notes};
  }
}

class _PeopleDropdown extends StatelessWidget {
  const _PeopleDropdown({required this.viewModel});

  final OneOnOnesViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final selectedPersonId =
        viewModel.personById(viewModel.selectedPersonId) == null
        ? null
        : viewModel.selectedPersonId;

    return DropdownButtonFormField<int>(
      key: ValueKey('person-$selectedPersonId'),
      initialValue: selectedPersonId,
      decoration: const InputDecoration(labelText: 'Pessoa'),
      items: [
        for (final person in viewModel.people)
          DropdownMenuItem(value: person.id, child: Text(person.name)),
      ],
      onChanged: viewModel.selectPerson,
    );
  }
}

class _DocumentDropdown extends StatelessWidget {
  const _DocumentDropdown({required this.viewModel});

  final OneOnOnesViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final selectedTemplateId =
        viewModel.templates.any(
          (template) => template.id == viewModel.selectedTemplateId,
        )
        ? viewModel.selectedTemplateId
        : null;

    return DropdownButtonFormField<int>(
      key: ValueKey('document-$selectedTemplateId'),
      initialValue: selectedTemplateId,
      decoration: const InputDecoration(labelText: 'Documento-base'),
      items: [
        for (final template in viewModel.templates)
          DropdownMenuItem(value: template.id, child: Text(template.title)),
      ],
      onChanged: viewModel.selectTemplate,
    );
  }
}

class _SessionTile extends StatelessWidget {
  const _SessionTile({required this.session, required this.viewModel});

  final OneOnOneSession session;
  final OneOnOnesViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final date = session.heldAt ?? session.scheduledFor;
    final formattedDate = date == null
        ? 'sem data'
        : DateFormat.yMMMd('pt_BR').format(date);
    final documentTitle = session.documentSnapshot?['title']?.toString();

    return _TextTile(
      icon: Icons.forum_outlined,
      title: session.title,
      subtitle: [
        if (viewModel.canManageOneOnOnes)
          viewModel.personName(session.personId),
        formattedDate,
        if (documentTitle != null) 'documento: $documentTitle',
      ].join(' · '),
    );
  }
}

class _DocumentTile extends StatelessWidget {
  const _DocumentTile({required this.document});

  final OneOnOneTemplate document;

  @override
  Widget build(BuildContext context) {
    return _TextTile(
      icon: Icons.description_outlined,
      title: document.title,
      subtitle: [
        if (document.description != null) document.description!,
        '${document.questions.length} tópicos',
      ].join(' · '),
    );
  }
}

class _DocumentPreview extends StatelessWidget {
  const _DocumentPreview({required this.document});

  final OneOnOneTemplate document;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(
          alpha: 0.35,
        ),
        border: Border.all(color: theme.colorScheme.outlineVariant),
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SectionTitle(
              title: document.title,
              subtitle: document.description,
            ),
            const SizedBox(height: AppSpacing.sm),
            for (final question in document.questions)
              Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.xs),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.notes_outlined, size: 18),
                    const SizedBox(width: AppSpacing.xs),
                    Expanded(child: Text(question)),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _PersonNoteTile extends StatelessWidget {
  const _PersonNoteTile({required this.note, required this.viewModel});

  final PersonOneOnOneNote note;
  final OneOnOnesViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final date = note.occurredAt == null
        ? null
        : DateFormat.yMMMd('pt_BR').format(note.occurredAt!);

    return _TextTile(
      icon: Icons.push_pin_outlined,
      title: note.title,
      subtitle: [
        viewModel.personName(note.personId),
        note.status,
        ?date,
        ?note.body,
      ].join(' · '),
    );
  }
}

class _TabBar extends StatelessWidget {
  const _TabBar({
    required this.selected,
    required this.tabs,
    required this.onChanged,
  });

  final _OneOnOneTab selected;
  final List<_OneOnOneTab> tabs;
  final ValueChanged<_OneOnOneTab> onChanged;

  @override
  Widget build(BuildContext context) {
    return SegmentedButton<_OneOnOneTab>(
      selected: {selected},
      onSelectionChanged: (value) => onChanged(value.first),
      segments: [
        for (final tab in tabs)
          ButtonSegment(
            value: tab,
            icon: Icon(tab.icon),
            label: Text(tab.label),
          ),
      ],
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

    return Material(
      color: theme.colorScheme.errorContainer,
      borderRadius: BorderRadius.circular(AppRadius.sm),
      child: ListTile(
        leading: Icon(Icons.error_outline, color: theme.colorScheme.error),
        title: Text(
          message,
          style: TextStyle(color: theme.colorScheme.onErrorContainer),
        ),
        trailing: IconButton(
          tooltip: 'Fechar',
          onPressed: onDismiss,
          icon: const Icon(Icons.close),
        ),
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
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final (index, child) in children.indexed) ...[
          if (index > 0) const SizedBox(height: AppSpacing.md),
          child,
        ],
      ],
    );
  }
}

class _FormColumn extends StatelessWidget {
  const _FormColumn({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final (index, child) in children.indexed) ...[
          if (index > 0) const SizedBox(height: AppSpacing.sm),
          child,
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

    return Column(
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
    );
  }
}

class _TextTile extends StatelessWidget {
  const _TextTile({required this.icon, required this.title, this.subtitle});

  final IconData icon;
  final String title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return _Surface(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: theme.colorScheme.primary),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: theme.textTheme.titleSmall),
                if (subtitle != null)
                  Text(
                    subtitle!,
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

class _EmptyPanel extends StatelessWidget {
  const _EmptyPanel({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return _Surface(
      child: Row(
        children: [
          const Icon(Icons.inbox_outlined),
          const SizedBox(width: AppSpacing.sm),
          Expanded(child: Text(message)),
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
      margin: EdgeInsets.zero,
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

List<String> _lines(String text) {
  return text
      .split('\n')
      .map((line) => line.trim())
      .where((line) => line.isNotEmpty)
      .toList();
}

String? _nullable(String text) {
  final value = text.trim();
  return value.isEmpty ? null : value;
}
