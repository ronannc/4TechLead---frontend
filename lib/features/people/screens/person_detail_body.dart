import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/viewmodels/base_view_model.dart';
import '../../../core/widgets/buttons/app_dialog_actions.dart';
import '../../../core/widgets/buttons/app_primary_button.dart';
import '../../../core/widgets/data/app_key_value_row.dart';
import '../../../core/widgets/states/error_view.dart';
import '../../../core/widgets/states/loading_view.dart';
import '../../daily/screens/person_daily_section.dart';
import '../models/person.dart';
import '../models/person_growth_models.dart';
import '../viewmodels/person_detail_view_model.dart';
import '../viewmodels/person_growth_view_model.dart';

enum _PersonTab { oneOnOne, pdi, okrs, analysis }

enum _OneOnOneView { register, templates, suggestions, history }

extension on _OneOnOneView {
  String get label {
    return switch (this) {
      _OneOnOneView.register => 'Registro',
      _OneOnOneView.templates => 'Templates',
      _OneOnOneView.suggestions => 'Sugestões',
      _OneOnOneView.history => 'Histórico',
    };
  }

  IconData get icon {
    return switch (this) {
      _OneOnOneView.register => Icons.edit_note_outlined,
      _OneOnOneView.templates => Icons.tune_outlined,
      _OneOnOneView.suggestions => Icons.auto_awesome_outlined,
      _OneOnOneView.history => Icons.history_outlined,
    };
  }
}

extension on _PersonTab {
  String get label {
    return switch (this) {
      _PersonTab.oneOnOne => '1:1',
      _PersonTab.pdi => 'PDI',
      _PersonTab.okrs => 'OKRs',
      _PersonTab.analysis => 'Análises',
    };
  }

  IconData get icon {
    return switch (this) {
      _PersonTab.oneOnOne => Icons.forum_outlined,
      _PersonTab.pdi => Icons.trending_up,
      _PersonTab.okrs => Icons.track_changes_outlined,
      _PersonTab.analysis => Icons.insights_outlined,
    };
  }
}

class PersonDetailBody extends StatefulWidget {
  const PersonDetailBody({super.key});

  @override
  State<PersonDetailBody> createState() => _PersonDetailBodyState();
}

class _PersonDetailBodyState extends State<PersonDetailBody> {
  final _sessionSearchController = TextEditingController();
  final _sessionTitleController = TextEditingController();
  final _sessionNotesController = TextEditingController();
  final _templateTitleController = TextEditingController();
  final _templateQuestionsController = TextEditingController();
  final _planTitleController = TextEditingController();
  final _planSummaryController = TextEditingController();
  final _planTargetRoleController = TextEditingController();
  final _okrObjectiveController = TextEditingController();
  final _okrFocusController = TextEditingController();
  final _okrDiagnosisController = TextEditingController();
  final _okrEvidenceController = TextEditingController();
  final _okrTargetController = TextEditingController();

  var _tab = _PersonTab.oneOnOne;
  var _oneOnOneView = _OneOnOneView.register;
  int? _selectedTemplateId;

  @override
  void dispose() {
    _sessionSearchController.dispose();
    _sessionTitleController.dispose();
    _sessionNotesController.dispose();
    _templateTitleController.dispose();
    _templateQuestionsController.dispose();
    _planTitleController.dispose();
    _planSummaryController.dispose();
    _planTargetRoleController.dispose();
    _okrObjectiveController.dispose();
    _okrFocusController.dispose();
    _okrDiagnosisController.dispose();
    _okrEvidenceController.dispose();
    _okrTargetController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Selector<PersonDetailViewModel, Person?>(
      selector: (_, vm) => vm.person,
      builder: (context, person, _) {
        if (person == null) {
          return const SizedBox.shrink();
        }

        return Selector<PersonGrowthViewModel, ViewState>(
          selector: (_, vm) => vm.state,
          builder: (context, growthState, _) {
            final growth = context.read<PersonGrowthViewModel>();

            return ListView(
              children: [
                _PersonHeader(person: person),
                const SizedBox(height: AppSpacing.md),
                _PersonTabSelector(
                  selected: _tab,
                  onChanged: (value) => setState(() => _tab = value),
                ),
                const SizedBox(height: AppSpacing.md),
                if (growthState == ViewState.loading &&
                    growth.templates.isEmpty &&
                    growth.sessions.isEmpty)
                  const LoadingView()
                else if (growthState == ViewState.error &&
                    growth.templates.isEmpty &&
                    growth.sessions.isEmpty)
                  ErrorView(
                    message: growth.errorMessage ?? 'Algo deu errado.',
                    onRetry: growth.load,
                  )
                else
                  _tabBody(context, person, growth),
              ],
            );
          },
        );
      },
    );
  }

  Widget _tabBody(
    BuildContext context,
    Person person,
    PersonGrowthViewModel growth,
  ) {
    return switch (_tab) {
      _PersonTab.oneOnOne => _OneOnOneTab(
        growth: growth,
        selectedView: _oneOnOneView,
        onViewChanged: (value) => setState(() => _oneOnOneView = value),
        selectedTemplateId: _selectedTemplateId,
        onTemplateChanged: (value) => _selectSessionTemplate(value, growth),
        sessionSearchController: _sessionSearchController,
        sessionTitleController: _sessionTitleController,
        sessionNotesController: _sessionNotesController,
        templateTitleController: _templateTitleController,
        templateQuestionsController: _templateQuestionsController,
        onCreateSession: () => _createSession(growth),
        onCreateTemplate: () => _createTemplate(growth),
      ),
      _PersonTab.pdi => _PdiTab(
        growth: growth,
        titleController: _planTitleController,
        summaryController: _planSummaryController,
        targetRoleController: _planTargetRoleController,
        onCreatePlan: () => _createPlan(growth),
        onCreateItem: (plan) => _showPlanItemDialog(context, growth, plan),
        onEditPlan: (plan) => _showEditPlanDialog(context, growth, plan),
      ),
      _PersonTab.okrs => _OkrsTab(
        growth: growth,
        objectiveController: _okrObjectiveController,
        focusController: _okrFocusController,
        diagnosisController: _okrDiagnosisController,
        evidenceController: _okrEvidenceController,
        targetController: _okrTargetController,
        onCreateOkr: () => _createOkr(growth),
        onGenerateSuggestions: () => growth.generateSuggestions(
          focusArea: _okrFocusController.text.trim(),
          context: _okrDiagnosisController.text.trim(),
        ),
        onCreateKeyResult: (okr) => _showKeyResultDialog(context, growth, okr),
        onEditOkr: (okr) => _showEditOkrDialog(context, growth, okr),
      ),
      _PersonTab.analysis => _AnalysisTab(person: person, growth: growth),
    };
  }

  void _selectSessionTemplate(int? templateId, PersonGrowthViewModel growth) {
    setState(() => _selectedTemplateId = templateId);

    if (templateId == null) {
      return;
    }

    final template = growth.templates
        .where((item) => item.id == templateId)
        .firstOrNull;
    if (template == null || template.questions.isEmpty) {
      return;
    }

    final draft = _templateDraft(template);
    final currentNotes = _sessionNotesController.text.trim();
    if (currentNotes.isEmpty || _looksLikeTemplateDraft(currentNotes)) {
      _sessionNotesController.text = draft;
    } else if (!currentNotes.contains(draft)) {
      _sessionNotesController.text = '$currentNotes\n\n$draft';
    }
  }

  Future<void> _createTemplate(PersonGrowthViewModel growth) async {
    final title = _templateTitleController.text.trim();
    final questions = _lines(_templateQuestionsController.text);
    if (title.isEmpty || questions.isEmpty) {
      return;
    }

    await growth.createTemplate(title: title, questions: questions);
    _templateTitleController.clear();
    _templateQuestionsController.clear();
  }

  Future<void> _createSession(PersonGrowthViewModel growth) async {
    final title = _sessionTitleController.text.trim();
    if (title.isEmpty) {
      return;
    }

    final template = growth.templates
        .where((item) => item.id == _selectedTemplateId)
        .firstOrNull;

    await growth.createSession(
      title: title,
      notes: _nullable(_sessionNotesController.text),
      templateId: _selectedTemplateId,
      questions: template?.questions,
    );
    _sessionTitleController.clear();
    _sessionNotesController.clear();
  }

  Future<void> _createPlan(PersonGrowthViewModel growth) async {
    final title = _planTitleController.text.trim();
    if (title.isEmpty) {
      return;
    }

    await growth.createPlan(
      title: title,
      summary: _nullable(_planSummaryController.text),
      targetRole: _nullable(_planTargetRoleController.text),
    );
    _planTitleController.clear();
    _planSummaryController.clear();
    _planTargetRoleController.clear();
  }

  Future<void> _createOkr(PersonGrowthViewModel growth) async {
    final objective = _okrObjectiveController.text.trim();
    if (objective.isEmpty) {
      return;
    }

    await growth.createOkr(
      objective: objective,
      focusArea: _nullable(_okrFocusController.text),
      diagnosis: _nullable(_okrDiagnosisController.text),
      evidenceSource: _nullable(_okrEvidenceController.text),
      target: _nullable(_okrTargetController.text),
    );
    _okrObjectiveController.clear();
    _okrFocusController.clear();
    _okrDiagnosisController.clear();
    _okrEvidenceController.clear();
    _okrTargetController.clear();
  }

  Future<void> _showPlanItemDialog(
    BuildContext context,
    PersonGrowthViewModel growth,
    DevelopmentPlan plan,
  ) async {
    final titleController = TextEditingController();
    final competencyController = TextEditingController();
    final evidenceController = TextEditingController();

    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Adicionar ação do PDI'),
        content: _DialogFormContent(
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Ação'),
            ),
            TextField(
              controller: competencyController,
              decoration: const InputDecoration(labelText: 'Competência'),
            ),
            TextField(
              controller: evidenceController,
              decoration: const InputDecoration(
                labelText: 'Evidência esperada',
              ),
            ),
          ],
        ),
        actions: [
          AppDialogActions(
            secondaryLabel: 'Cancelar',
            onSecondaryPressed: () => Navigator.pop(context),
            primaryLabel: 'Adicionar',
            onPrimaryPressed: () async {
              if (titleController.text.trim().isEmpty) {
                return;
              }
              await growth.createPlanItem(
                planId: plan.id,
                title: titleController.text.trim(),
                competency: _nullable(competencyController.text),
                evidence: _nullable(evidenceController.text),
              );
              if (context.mounted) {
                Navigator.pop(context);
              }
            },
          ),
        ],
      ),
    );

    titleController.dispose();
    competencyController.dispose();
    evidenceController.dispose();
  }

  Future<void> _showEditPlanDialog(
    BuildContext context,
    PersonGrowthViewModel growth,
    DevelopmentPlan plan,
  ) async {
    final titleController = TextEditingController(text: plan.title);
    final summaryController = TextEditingController(text: plan.summary);
    final statusController = TextEditingController(text: plan.status);
    final progressController = TextEditingController(text: '${plan.progress}');

    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Editar PDI'),
        content: _DialogFormContent(
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Título'),
            ),
            TextField(
              controller: summaryController,
              decoration: const InputDecoration(labelText: 'Resumo'),
            ),
            TextField(
              controller: statusController,
              decoration: const InputDecoration(labelText: 'Status'),
            ),
            TextField(
              controller: progressController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Progresso 0-100'),
            ),
          ],
        ),
        actions: [
          AppDialogActions(
            secondaryLabel: 'Cancelar',
            onSecondaryPressed: () => Navigator.pop(context),
            primaryLabel: 'Atualizar',
            onPrimaryPressed: () async {
              await growth.updatePlan(
                id: plan.id,
                title: titleController.text.trim(),
                summary: _nullable(summaryController.text),
                status: statusController.text.trim(),
                progress: int.tryParse(progressController.text.trim()),
              );
              if (context.mounted) {
                Navigator.pop(context);
              }
            },
          ),
        ],
      ),
    );

    titleController.dispose();
    summaryController.dispose();
    statusController.dispose();
    progressController.dispose();
  }

  Future<void> _showKeyResultDialog(
    BuildContext context,
    PersonGrowthViewModel growth,
    PersonOkr okr,
  ) async {
    final titleController = TextEditingController();
    final metricController = TextEditingController();
    final targetController = TextEditingController();

    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Adicionar KR'),
        content: _DialogFormContent(
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Resultado-chave'),
            ),
            TextField(
              controller: metricController,
              decoration: const InputDecoration(labelText: 'Métrica'),
            ),
            TextField(
              controller: targetController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Valor alvo'),
            ),
          ],
        ),
        actions: [
          AppDialogActions(
            secondaryLabel: 'Cancelar',
            onSecondaryPressed: () => Navigator.pop(context),
            primaryLabel: 'Adicionar',
            onPrimaryPressed: () async {
              if (titleController.text.trim().isEmpty) {
                return;
              }
              await growth.createKeyResult(
                okrId: okr.id,
                title: titleController.text.trim(),
                metricName: _nullable(metricController.text),
                targetValue: num.tryParse(targetController.text.trim()),
              );
              if (context.mounted) {
                Navigator.pop(context);
              }
            },
          ),
        ],
      ),
    );

    titleController.dispose();
    metricController.dispose();
    targetController.dispose();
  }

  Future<void> _showEditOkrDialog(
    BuildContext context,
    PersonGrowthViewModel growth,
    PersonOkr okr,
  ) async {
    final objectiveController = TextEditingController(text: okr.objective);
    final statusController = TextEditingController(text: okr.status);
    final confidenceController = TextEditingController(
      text: '${okr.confidence}',
    );
    final progressController = TextEditingController(text: '${okr.progress}');

    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Editar OKR'),
        content: _DialogFormContent(
          children: [
            TextField(
              controller: objectiveController,
              decoration: const InputDecoration(labelText: 'Objetivo'),
            ),
            TextField(
              controller: statusController,
              decoration: const InputDecoration(labelText: 'Status'),
            ),
            TextField(
              controller: confidenceController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Confiança 0-100'),
            ),
            TextField(
              controller: progressController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Progresso 0-100'),
            ),
          ],
        ),
        actions: [
          AppDialogActions(
            secondaryLabel: 'Cancelar',
            onSecondaryPressed: () => Navigator.pop(context),
            primaryLabel: 'Atualizar',
            onPrimaryPressed: () async {
              await growth.updateOkr(
                id: okr.id,
                objective: objectiveController.text.trim(),
                status: statusController.text.trim(),
                confidence: int.tryParse(confidenceController.text.trim()),
                progress: int.tryParse(progressController.text.trim()),
              );
              if (context.mounted) {
                Navigator.pop(context);
              }
            },
          ),
        ],
      ),
    );

    objectiveController.dispose();
    statusController.dispose();
    confidenceController.dispose();
    progressController.dispose();
  }
}

class _PersonHeader extends StatelessWidget {
  const _PersonHeader({required this.person});

  final Person person;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dateFormat = DateFormat.yMMMd('pt_BR');

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CircleAvatar(radius: 28, child: Text(_initials(person.name))),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(person.name, style: theme.textTheme.headlineMedium),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    '${person.position} · ${person.seniority.label}',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        Wrap(
          spacing: AppSpacing.lg,
          runSpacing: AppSpacing.sm,
          children: [
            AppKeyValueRow(label: 'Contrato', value: person.contractType.label),
            AppKeyValueRow(
              label: 'Nascimento',
              value: person.birthDate == null
                  ? 'Não informado'
                  : '${dateFormat.format(person.birthDate!)} (${person.age} anos)',
            ),
            AppKeyValueRow(
              label: 'Admissão',
              value: person.admissionDate == null
                  ? 'Não informado'
                  : dateFormat.format(person.admissionDate!),
            ),
          ],
        ),
      ],
    );
  }
}

class _PersonTabSelector extends StatelessWidget {
  const _PersonTabSelector({required this.selected, required this.onChanged});

  final _PersonTab selected;
  final ValueChanged<_PersonTab> onChanged;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SegmentedButton<_PersonTab>(
        segments: [
          for (final tab in _PersonTab.values)
            ButtonSegment(
              value: tab,
              icon: Icon(tab.icon),
              label: Text(tab.label),
            ),
        ],
        selected: {selected},
        onSelectionChanged: (values) => onChanged(values.single),
      ),
    );
  }
}

class _OneOnOneTab extends StatelessWidget {
  const _OneOnOneTab({
    required this.growth,
    required this.selectedView,
    required this.onViewChanged,
    required this.selectedTemplateId,
    required this.onTemplateChanged,
    required this.sessionSearchController,
    required this.sessionTitleController,
    required this.sessionNotesController,
    required this.templateTitleController,
    required this.templateQuestionsController,
    required this.onCreateSession,
    required this.onCreateTemplate,
  });

  final PersonGrowthViewModel growth;
  final _OneOnOneView selectedView;
  final ValueChanged<_OneOnOneView> onViewChanged;
  final int? selectedTemplateId;
  final ValueChanged<int?> onTemplateChanged;
  final TextEditingController sessionSearchController;
  final TextEditingController sessionTitleController;
  final TextEditingController sessionNotesController;
  final TextEditingController templateTitleController;
  final TextEditingController templateQuestionsController;
  final VoidCallback onCreateSession;
  final VoidCallback onCreateTemplate;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionTitle(
          title: '1:1',
          subtitle:
              'Registre conversas, configure templates e consulte o histórico.',
        ),
        const SizedBox(height: AppSpacing.sm),
        _OneOnOneNavigation(selected: selectedView, onChanged: onViewChanged),
        const SizedBox(height: AppSpacing.md),
        switch (selectedView) {
          _OneOnOneView.register => _OneOnOneRegisterView(
            growth: growth,
            selectedTemplateId: selectedTemplateId,
            onTemplateChanged: onTemplateChanged,
            titleController: sessionTitleController,
            notesController: sessionNotesController,
            onCreateSession: onCreateSession,
          ),
          _OneOnOneView.templates => _OneOnOneTemplateView(
            titleController: templateTitleController,
            questionsController: templateQuestionsController,
            onCreateTemplate: onCreateTemplate,
          ),
          _OneOnOneView.suggestions => _OneOnOneSuggestionsView(
            suggestions: growth.suggestions,
          ),
          _OneOnOneView.history => _OneOnOneHistoryView(
            growth: growth,
            searchController: sessionSearchController,
          ),
        },
      ],
    );
  }
}

class _OneOnOneNavigation extends StatelessWidget {
  const _OneOnOneNavigation({required this.selected, required this.onChanged});

  final _OneOnOneView selected;
  final ValueChanged<_OneOnOneView> onChanged;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SegmentedButton<_OneOnOneView>(
        segments: [
          for (final view in _OneOnOneView.values)
            ButtonSegment(
              value: view,
              icon: Icon(view.icon),
              label: Text(view.label),
            ),
        ],
        selected: {selected},
        onSelectionChanged: (values) => onChanged(values.single),
      ),
    );
  }
}

class _OneOnOneRegisterView extends StatelessWidget {
  const _OneOnOneRegisterView({
    required this.growth,
    required this.selectedTemplateId,
    required this.onTemplateChanged,
    required this.titleController,
    required this.notesController,
    required this.onCreateSession,
  });

  final PersonGrowthViewModel growth;
  final int? selectedTemplateId;
  final ValueChanged<int?> onTemplateChanged;
  final TextEditingController titleController;
  final TextEditingController notesController;
  final VoidCallback onCreateSession;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionTitle(
          title: 'Registrar conversa',
          subtitle:
              'Use um template como roteiro e salve as notas do encontro.',
        ),
        const SizedBox(height: AppSpacing.sm),
        _Surface(
          child: _FormColumn(
            children: [
              DropdownButtonFormField<int>(
                initialValue: selectedTemplateId,
                items: [
                  for (final template in growth.templates)
                    DropdownMenuItem(
                      value: template.id,
                      child: Text(template.title),
                    ),
                ],
                onChanged: onTemplateChanged,
                decoration: const InputDecoration(labelText: 'Template'),
              ),
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Título'),
              ),
              TextField(
                controller: notesController,
                minLines: 3,
                maxLines: 6,
                decoration: const InputDecoration(
                  labelText: 'Notas da conversa',
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Row(
                children: [
                  Expanded(
                    child: AppPrimaryButton(
                      label: 'Cadastrar 1:1',
                      onPressed: onCreateSession,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _OneOnOneTemplateView extends StatelessWidget {
  const _OneOnOneTemplateView({
    required this.titleController,
    required this.questionsController,
    required this.onCreateTemplate,
  });

  final TextEditingController titleController;
  final TextEditingController questionsController;
  final VoidCallback onCreateTemplate;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionTitle(
          title: 'Configurar templates',
          subtitle:
              'Cadastre roteiros reutilizáveis para conduzir os próximos 1:1s.',
        ),
        const SizedBox(height: AppSpacing.sm),
        _Surface(
          child: _FormColumn(
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: 'Nome do template',
                ),
              ),
              TextField(
                controller: questionsController,
                minLines: 3,
                maxLines: 6,
                decoration: const InputDecoration(
                  labelText: 'Perguntas, uma por linha',
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Row(
                children: [
                  Expanded(
                    child: AppPrimaryButton(
                      label: 'Criar template',
                      onPressed: onCreateTemplate,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _OneOnOneSuggestionsView extends StatelessWidget {
  const _OneOnOneSuggestionsView({required this.suggestions});

  final GrowthSuggestions? suggestions;

  @override
  Widget build(BuildContext context) {
    final questions = suggestions?.oneOnOneQuestions ?? const <String>[];

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionTitle(
          title: 'Perguntas sugeridas',
          subtitle:
              'Use como inspiração para preparar a pauta do próximo encontro.',
        ),
        const SizedBox(height: AppSpacing.sm),
        if (questions.isEmpty)
          const _EmptyState(
            icon: Icons.help_outline,
            message: 'Ainda não há perguntas sugeridas para esta pessoa.',
          )
        else
          for (final question in questions)
            _TextTile(icon: Icons.help_outline, title: question),
      ],
    );
  }
}

class _OneOnOneHistoryView extends StatelessWidget {
  const _OneOnOneHistoryView({
    required this.growth,
    required this.searchController,
  });

  final PersonGrowthViewModel growth;
  final TextEditingController searchController;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionTitle(
          title: 'Histórico de 1:1',
          subtitle: 'Paginado e pesquisável por título/notas.',
        ),
        const SizedBox(height: AppSpacing.sm),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: searchController,
                decoration: const InputDecoration(
                  labelText: 'Buscar histórico',
                ),
                onSubmitted: growth.searchSessions,
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            IconButton(
              tooltip: 'Buscar',
              onPressed: () => growth.searchSessions(searchController.text),
              icon: const Icon(Icons.search),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        if (growth.sessions.isEmpty)
          const _EmptyState(
            icon: Icons.history_outlined,
            message: 'Nenhum 1:1 registrado ainda.',
          )
        else
          for (final session in growth.sessions) _SessionTile(session: session),
        const SizedBox(height: AppSpacing.xs),
        _InlinePagination(
          page: growth.sessionPage,
          onPrevious: growth.sessionPage == 1
              ? null
              : growth.previousSessionPage,
          onNext: growth.sessions.length < 10 ? null : growth.nextSessionPage,
        ),
      ],
    );
  }
}

class _PdiTab extends StatelessWidget {
  const _PdiTab({
    required this.growth,
    required this.titleController,
    required this.summaryController,
    required this.targetRoleController,
    required this.onCreatePlan,
    required this.onCreateItem,
    required this.onEditPlan,
  });

  final PersonGrowthViewModel growth;
  final TextEditingController titleController;
  final TextEditingController summaryController;
  final TextEditingController targetRoleController;
  final VoidCallback onCreatePlan;
  final ValueChanged<DevelopmentPlan> onCreateItem;
  final ValueChanged<DevelopmentPlan> onEditPlan;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionTitle(
          title: 'Criar PDI',
          subtitle: 'Transforme objetivos de carreira em ações acompanháveis.',
        ),
        const SizedBox(height: AppSpacing.sm),
        _Surface(
          child: _FormColumn(
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Título'),
              ),
              TextField(
                controller: targetRoleController,
                decoration: const InputDecoration(labelText: 'Papel alvo'),
              ),
              TextField(
                controller: summaryController,
                minLines: 2,
                maxLines: 4,
                decoration: const InputDecoration(labelText: 'Resumo'),
              ),
              const SizedBox(height: AppSpacing.md),
              Row(
                children: [
                  Expanded(
                    child: AppPrimaryButton(
                      label: 'Criar PDI',
                      onPressed: onCreatePlan,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        if (growth.suggestions != null) ...[
          _SectionTitle(title: 'Sugestões para PDI'),
          const SizedBox(height: AppSpacing.sm),
          for (final suggestion in growth.suggestions!.pdiSuggestions)
            _TextTile(
              icon: Icons.lightbulb_outline,
              title: suggestion['title'].toString(),
              subtitle: suggestion['evidence']?.toString(),
            ),
          const SizedBox(height: AppSpacing.md),
        ],
        _SectionTitle(title: 'PDIs cadastrados'),
        const SizedBox(height: AppSpacing.sm),
        for (final plan in growth.plans)
          _PlanTile(
            plan: plan,
            onCreateItem: () => onCreateItem(plan),
            onEditPlan: () => onEditPlan(plan),
          ),
      ],
    );
  }
}

class _OkrsTab extends StatelessWidget {
  const _OkrsTab({
    required this.growth,
    required this.objectiveController,
    required this.focusController,
    required this.diagnosisController,
    required this.evidenceController,
    required this.targetController,
    required this.onCreateOkr,
    required this.onGenerateSuggestions,
    required this.onCreateKeyResult,
    required this.onEditOkr,
  });

  final PersonGrowthViewModel growth;
  final TextEditingController objectiveController;
  final TextEditingController focusController;
  final TextEditingController diagnosisController;
  final TextEditingController evidenceController;
  final TextEditingController targetController;
  final VoidCallback onCreateOkr;
  final VoidCallback onGenerateSuggestions;
  final ValueChanged<PersonOkr> onCreateKeyResult;
  final ValueChanged<PersonOkr> onEditOkr;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionTitle(
          title: 'Criar OKR',
          subtitle:
              'Cadastre diagnóstico, evidências e alvo antes do objetivo.',
        ),
        const SizedBox(height: AppSpacing.sm),
        _Surface(
          child: _FormColumn(
            children: [
              TextField(
                controller: focusController,
                decoration: const InputDecoration(labelText: 'Área de foco'),
              ),
              TextField(
                controller: diagnosisController,
                decoration: const InputDecoration(labelText: 'Diagnóstico'),
              ),
              TextField(
                controller: evidenceController,
                decoration: const InputDecoration(
                  labelText: 'Fonte de evidência',
                ),
              ),
              TextField(
                controller: targetController,
                decoration: const InputDecoration(labelText: 'Alvo esperado'),
              ),
              TextField(
                controller: objectiveController,
                decoration: const InputDecoration(labelText: 'Objetivo'),
              ),
              const SizedBox(height: AppSpacing.md),
              Row(
                children: [
                  Expanded(
                    child: AppSecondaryButton(
                      label: 'Sugerir',
                      onPressed: onGenerateSuggestions,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: AppPrimaryButton(
                      label: 'Criar OKR',
                      onPressed: onCreateOkr,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        if (growth.suggestions != null) ...[
          _SectionTitle(title: 'OKRs sugeridos'),
          const SizedBox(height: AppSpacing.sm),
          for (final suggestion in growth.suggestions!.okrSuggestions)
            _TextTile(
              icon: Icons.auto_awesome_outlined,
              title: suggestion['objective'].toString(),
              subtitle: suggestion['diagnosis']?.toString(),
            ),
          const SizedBox(height: AppSpacing.md),
        ],
        _SectionTitle(title: 'OKRs cadastrados'),
        const SizedBox(height: AppSpacing.sm),
        for (final okr in growth.okrs)
          _OkrTile(
            okr: okr,
            onCreateKeyResult: () => onCreateKeyResult(okr),
            onEditOkr: () => onEditOkr(okr),
          ),
      ],
    );
  }
}

class _AnalysisTab extends StatelessWidget {
  const _AnalysisTab({required this.person, required this.growth});

  final Person person;
  final PersonGrowthViewModel growth;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionTitle(title: 'Resumo do colaborador'),
        const SizedBox(height: AppSpacing.sm),
        LayoutBuilder(
          builder: (context, constraints) {
            final isCompact = constraints.maxWidth < 360;
            final itemWidth = isCompact
                ? constraints.maxWidth
                : (constraints.maxWidth - AppSpacing.sm) / 2;

            return Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: [
                SizedBox(
                  width: itemWidth,
                  child: _MetricCard(
                    label: '1:1 registrados',
                    value: '${growth.sessions.length}',
                  ),
                ),
                SizedBox(
                  width: itemWidth,
                  child: _MetricCard(
                    label: 'PDIs ativos',
                    value: '${growth.plans.length}',
                  ),
                ),
                SizedBox(
                  width: itemWidth,
                  child: _MetricCard(
                    label: 'OKRs ativos',
                    value: '${growth.okrs.length}',
                  ),
                ),
                SizedBox(
                  width: itemWidth,
                  child: _MetricCard(
                    label: 'Sugestões',
                    value: '${growth.suggestions?.okrSuggestions.length ?? 0}',
                  ),
                ),
              ],
            );
          },
        ),
        const SizedBox(height: AppSpacing.md),
        PersonDailySection(teamId: person.teamId),
      ],
    );
  }
}

class _SessionTile extends StatelessWidget {
  const _SessionTile({required this.session});

  final OneOnOneSession session;

  @override
  Widget build(BuildContext context) {
    return _TextTile(
      icon: Icons.forum_outlined,
      title: session.title,
      subtitle: [
        if (session.heldAt != null)
          DateFormat.yMMMd('pt_BR').format(session.heldAt!),
        session.status,
        if (session.notes != null) session.notes!,
      ].join(' · '),
    );
  }
}

class _PlanTile extends StatelessWidget {
  const _PlanTile({
    required this.plan,
    required this.onCreateItem,
    required this.onEditPlan,
  });

  final DevelopmentPlan plan;
  final VoidCallback onCreateItem;
  final VoidCallback onEditPlan;

  @override
  Widget build(BuildContext context) {
    return _Surface(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  plan.title,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ),
              Text('${plan.progress}%'),
            ],
          ),
          if (plan.summary != null) Text(plan.summary!),
          const SizedBox(height: AppSpacing.sm),
          LinearProgressIndicator(value: plan.progress / 100),
          const SizedBox(height: AppSpacing.sm),
          for (final item in plan.items)
            _TextTile(
              icon: Icons.check_circle_outline,
              title: item.title,
              subtitle:
                  '${item.status} · ${item.competency ?? 'sem competência'}',
            ),
          Row(
            children: [
              Expanded(
                child: AppSecondaryButton(
                  label: 'Editar',
                  onPressed: onEditPlan,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: AppPrimaryButton(
                  label: 'Adicionar ação',
                  onPressed: onCreateItem,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _OkrTile extends StatelessWidget {
  const _OkrTile({
    required this.okr,
    required this.onCreateKeyResult,
    required this.onEditOkr,
  });

  final PersonOkr okr;
  final VoidCallback onCreateKeyResult;
  final VoidCallback onEditOkr;

  @override
  Widget build(BuildContext context) {
    return _Surface(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(okr.objective, style: Theme.of(context).textTheme.titleSmall),
          if (okr.diagnosis != null) Text(okr.diagnosis!),
          const SizedBox(height: AppSpacing.sm),
          LinearProgressIndicator(value: okr.progress / 100),
          const SizedBox(height: AppSpacing.sm),
          for (final kr in okr.keyResults)
            _TextTile(
              icon: Icons.track_changes_outlined,
              title: kr.title,
              subtitle: '${kr.progress}% · ${kr.metricName ?? 'sem métrica'}',
            ),
          Row(
            children: [
              Expanded(
                child: AppSecondaryButton(
                  label: 'Editar',
                  onPressed: onEditOkr,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: AppPrimaryButton(
                  label: 'Adicionar KR',
                  onPressed: onCreateKeyResult,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _InlinePagination extends StatelessWidget {
  const _InlinePagination({
    required this.page,
    required this.onPrevious,
    required this.onNext,
  });

  final int page;
  final VoidCallback? onPrevious;
  final VoidCallback? onNext;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Row(
        children: [
          Expanded(
            child: AppSecondaryButton(label: 'Anterior', onPressed: onPrevious),
          ),
          const SizedBox(width: AppSpacing.sm),
          SizedBox(
            width: 78,
            child: Text(
              'Página $page',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.labelLarge,
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: AppSecondaryButton(label: 'Próxima', onPressed: onNext),
          ),
        ],
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return _Surface(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(value, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: AppSpacing.sm),
          Text(label),
        ],
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

class _DialogFormContent extends StatelessWidget {
  const _DialogFormContent({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(child: _FormColumn(children: children));
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.icon, required this.message});

  final IconData icon;
  final String message;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return _Surface(
      child: Row(
        children: [
          Icon(icon, color: theme.colorScheme.primary),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              message,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
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
      mainAxisSize: MainAxisSize.min,
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

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: _Surface(
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

String _initials(String name) {
  final parts = name.trim().split(RegExp(r'\s+'));
  if (parts.length == 1) {
    return parts.first.characters.take(2).toString().toUpperCase();
  }

  return '${parts.first.characters.first}${parts.last.characters.first}'
      .toUpperCase();
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

String _templateDraft(OneOnOneTemplate template) {
  final questions = template.questions
      .map((question) => '- $question\n  Resposta:')
      .join('\n\n');

  return 'Perguntas do template: ${template.title}\n\n$questions';
}

bool _looksLikeTemplateDraft(String text) {
  return text.startsWith('Perguntas do template: ') && text.contains('\n- ');
}
