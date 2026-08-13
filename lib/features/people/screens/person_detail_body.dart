import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/viewmodels/base_view_model.dart';
import '../../../core/widgets/buttons/app_dialog_actions.dart';
import '../../../core/widgets/buttons/app_primary_button.dart';
import '../../../core/widgets/cards/app_summary_card.dart';
import '../../../core/widgets/data/app_key_value_row.dart';
import '../../../core/widgets/states/error_view.dart';
import '../../../core/widgets/states/loading_view.dart';
import '../../daily/screens/person_daily_section.dart';
import '../../integrations/models/integration_models.dart';
import '../models/person.dart';
import '../models/person_growth_models.dart';
import '../viewmodels/person_detail_view_model.dart';
import '../viewmodels/person_growth_view_model.dart';

enum _PersonTab { info, oneOnOne, pdi, analysis }

enum _FocusedFlow { oneOnOne, pdi }

enum _OneOnOneView { register, templates, suggestions, history }

enum _PdiView { create, suggestions, tracking }

extension on _PdiView {
  String get label {
    return switch (this) {
      _PdiView.create => 'Criar',
      _PdiView.suggestions => 'Sugestões',
      _PdiView.tracking => 'Acompanhar',
    };
  }

  IconData get icon {
    return switch (this) {
      _PdiView.create => Icons.add_task_outlined,
      _PdiView.suggestions => Icons.lightbulb_outline,
      _PdiView.tracking => Icons.fact_check_outlined,
    };
  }
}

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
      _PersonTab.info => 'Geral',
      _PersonTab.oneOnOne => '1:1',
      _PersonTab.pdi => 'PDI',
      _PersonTab.analysis => 'KPIs',
    };
  }

  IconData get icon {
    return switch (this) {
      _PersonTab.info => Icons.badge_outlined,
      _PersonTab.oneOnOne => Icons.forum_outlined,
      _PersonTab.pdi => Icons.trending_up,
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

  var _tab = _PersonTab.info;
  var _oneOnOneView = _OneOnOneView.history;
  var _pdiView = _PdiView.tracking;
  _FocusedFlow? _focusedFlow;
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: _focusedFlow == null,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop && _focusedFlow != null) {
          _closeFocusedFlow();
        }
      },
      child: Selector<PersonDetailViewModel, Person?>(
        selector: (_, vm) => vm.person,
        builder: (context, person, _) {
          if (person == null) {
            return const SizedBox.shrink();
          }

          return Consumer<PersonGrowthViewModel>(
            builder: (context, growth, _) {
              if (_focusedFlow != null) {
                return _focusedFlowBody(context, growth);
              }

              return _PersonDetailScrollView(
                children: [
                  _PersonHeader(person: person),
                  const SizedBox(height: AppSpacing.md),
                  _PersonTabSelector(
                    selected: _tab,
                    onChanged: (value) => setState(() => _tab = value),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  if (growth.actionErrorMessage != null) ...[
                    _ActionErrorBanner(
                      message: growth.actionErrorMessage!,
                      onDismiss: growth.clearActionError,
                    ),
                    const SizedBox(height: AppSpacing.md),
                  ],
                  if (growth.state == ViewState.loading &&
                      growth.templates.isEmpty &&
                      growth.sessions.isEmpty)
                    const LoadingView()
                  else if (growth.state == ViewState.error &&
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
      ),
    );
  }

  Widget _tabBody(
    BuildContext context,
    Person person,
    PersonGrowthViewModel growth,
  ) {
    return switch (_tab) {
      _PersonTab.info => _PersonInfoTab(person: person),
      _PersonTab.oneOnOne => _OneOnOneTab(
        growth: growth,
        selectedView: _oneOnOneView,
        onViewChanged: (value) => setState(() => _oneOnOneView = value),
        sessionSearchController: _sessionSearchController,
        templateTitleController: _templateTitleController,
        templateQuestionsController: _templateQuestionsController,
        onCreateTemplate: () => _createTemplate(growth),
        onCreateSession: () => _openFocusedFlow(_FocusedFlow.oneOnOne),
      ),
      _PersonTab.pdi => _PdiTab(
        growth: growth,
        selectedView: _pdiView,
        onViewChanged: (value) => setState(() => _pdiView = value),
        onCreateItem: (plan) => _showPlanItemDialog(context, growth, plan),
        onEditPlan: (plan) => _showEditPlanDialog(context, growth, plan),
        onCreatePlan: () => _openFocusedFlow(_FocusedFlow.pdi),
      ),
      _PersonTab.analysis => _AnalysisTab(person: person, growth: growth),
    };
  }

  Widget _focusedFlowBody(BuildContext context, PersonGrowthViewModel growth) {
    final flow = _focusedFlow!;

    return _FocusedFlowView(
      title: switch (flow) {
        _FocusedFlow.oneOnOne => 'Novo 1:1',
        _FocusedFlow.pdi => 'Novo PDI',
      },
      subtitle: switch (flow) {
        _FocusedFlow.oneOnOne => 'Conduza e registre a conversa.',
        _FocusedFlow.pdi => 'Transforme uma evolução em plano de ação.',
      },
      onBack: _closeFocusedFlow,
      actionErrorMessage: growth.actionErrorMessage,
      onDismissActionError: growth.clearActionError,
      child: switch (flow) {
        _FocusedFlow.oneOnOne => _OneOnOneRegisterView(
          growth: growth,
          selectedTemplateId: _selectedTemplateId,
          onTemplateChanged: (value) => _selectSessionTemplate(value, growth),
          titleController: _sessionTitleController,
          notesController: _sessionNotesController,
          onCreateSession: () => _createSession(growth),
        ),
        _FocusedFlow.pdi => _PdiCreateView(
          titleController: _planTitleController,
          summaryController: _planSummaryController,
          targetRoleController: _planTargetRoleController,
          onCreatePlan: () => _createPlan(growth),
        ),
      },
    );
  }

  void _openFocusedFlow(_FocusedFlow flow) {
    setState(() => _focusedFlow = flow);
  }

  void _closeFocusedFlow() {
    setState(() => _focusedFlow = null);
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
    if (mounted) {
      setState(() {
        _focusedFlow = null;
        _oneOnOneView = _OneOnOneView.history;
      });
    }
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
    if (mounted) {
      setState(() {
        _focusedFlow = null;
        _pdiView = _PdiView.tracking;
      });
    }
  }

  Future<void> _showPlanItemDialog(
    BuildContext context,
    PersonGrowthViewModel growth,
    DevelopmentPlan plan,
  ) async {
    final titleController = TextEditingController();
    final competencyController = TextEditingController();
    final evidenceController = TextEditingController();

    await _showEditorSheet(
      context: context,
      title: 'Nova ação do PDI',
      subtitle:
          'Defina uma prática concreta e como a evolução será comprovada.',
      primaryLabel: 'Adicionar ação',
      children: [
        TextField(
          controller: titleController,
          decoration: const InputDecoration(
            labelText: 'Ação',
            helperText:
                'Entrega objetiva. Ex.: conduzir o desenho técnico do próximo card.',
          ),
        ),
        TextField(
          controller: competencyController,
          decoration: const InputDecoration(
            labelText: 'Competência',
            helperText:
                'Habilidade trabalhada. Ex.: comunicação, arquitetura, autonomia.',
          ),
        ),
        TextField(
          controller: evidenceController,
          minLines: 2,
          maxLines: 4,
          decoration: const InputDecoration(
            labelText: 'Evidência esperada',
            helperText:
                'Como a evolução será percebida? Ex.: decisão registrada e validada.',
          ),
        ),
      ],
      onSubmit: (sheetContext) async {
        if (titleController.text.trim().isEmpty) {
          return;
        }
        await growth.createPlanItem(
          planId: plan.id,
          title: titleController.text.trim(),
          competency: _nullable(competencyController.text),
          evidence: _nullable(evidenceController.text),
        );
        if (sheetContext.mounted) {
          Navigator.pop(sheetContext);
        }
      },
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

    await _showEditorSheet(
      context: context,
      title: 'Editar PDI',
      subtitle: 'Ajuste o objetivo do plano e reflita o acompanhamento atual.',
      primaryLabel: 'Atualizar PDI',
      children: [
        TextField(
          controller: titleController,
          decoration: const InputDecoration(
            labelText: 'Título',
            helperText: 'Nome curto do plano. Ex.: Evoluir autonomia técnica.',
          ),
        ),
        TextField(
          controller: summaryController,
          decoration: const InputDecoration(
            labelText: 'Resumo',
            helperText:
                'Explique o contexto, lacuna observada e resultado esperado.',
          ),
        ),
        TextField(
          controller: statusController,
          decoration: const InputDecoration(
            labelText: 'Status',
            helperText: 'Use algo simples: active, paused, completed.',
          ),
        ),
        TextField(
          controller: progressController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Progresso 0-100',
            helperText:
                'Atualize conforme ações concluídas, evidências e mudança de comportamento.',
          ),
        ),
      ],
      onSubmit: (sheetContext) async {
        await growth.updatePlan(
          id: plan.id,
          title: titleController.text.trim(),
          summary: _nullable(summaryController.text),
          status: statusController.text.trim(),
          progress: int.tryParse(progressController.text.trim()),
        );
        if (sheetContext.mounted) {
          Navigator.pop(sheetContext);
        }
      },
    );

    titleController.dispose();
    summaryController.dispose();
    statusController.dispose();
    progressController.dispose();
  }
}

class _PersonHeader extends StatelessWidget {
  const _PersonHeader({required this.person});

  final Person person;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        final detailsWidth =
            _availableWidth(constraints, context) - (56 + AppSpacing.md);

        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(radius: 28, child: Text(_initials(person.name))),
                const SizedBox(width: AppSpacing.md),
                SizedBox(
                  width: detailsWidth > 0 ? detailsWidth : 0,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(person.name, style: theme.textTheme.headlineMedium),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        'Perfil do colaborador',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}

class _PersonInfoTab extends StatelessWidget {
  const _PersonInfoTab({required this.person});

  final Person person;

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat.yMMMd('pt_BR');

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionTitle(
          title: 'Informações gerais',
          subtitle: 'Dados básicos e sinais recentes do colaborador.',
        ),
        const SizedBox(height: AppSpacing.sm),
        _Surface(
          child: Wrap(
            spacing: AppSpacing.lg,
            runSpacing: AppSpacing.sm,
            children: [
              AppKeyValueRow(label: 'Cargo', value: person.position),
              AppKeyValueRow(
                label: 'Senioridade',
                value: person.seniority.label,
              ),
              AppKeyValueRow(
                label: 'Contrato',
                value: person.contractType.label,
              ),
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
        ),
        const SizedBox(height: AppSpacing.md),
        PersonDailySection(teamId: person.teamId),
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
    return _ContextualTabBar<_PersonTab>(
      selected: selected,
      values: _PersonTab.values,
      labelOf: (tab) => tab.label,
      iconOf: (tab) => tab.icon,
      onChanged: onChanged,
    );
  }
}

class _OneOnOneTab extends StatelessWidget {
  const _OneOnOneTab({
    required this.growth,
    required this.selectedView,
    required this.onViewChanged,
    required this.sessionSearchController,
    required this.templateTitleController,
    required this.templateQuestionsController,
    required this.onCreateSession,
    required this.onCreateTemplate,
  });

  final PersonGrowthViewModel growth;
  final _OneOnOneView selectedView;
  final ValueChanged<_OneOnOneView> onViewChanged;
  final TextEditingController sessionSearchController;
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
        _ModuleHeader(
          title: '1:1',
          subtitle: 'Consulte registros e prepare os próximos encontros.',
          helpMessage:
              'Prepare 2 ou 3 perguntas, anote respostas importantes, decisões, combinados e sinais de evolução ou bloqueio.',
          primaryLabel: 'Novo 1:1',
          onPrimaryPressed: onCreateSession,
        ),
        const SizedBox(height: AppSpacing.sm),
        _ContextualTabBar<_OneOnOneView>(
          selected: selectedView,
          values: const [
            _OneOnOneView.history,
            _OneOnOneView.templates,
            _OneOnOneView.suggestions,
          ],
          labelOf: (view) => view.label,
          iconOf: (view) => view.icon,
          onChanged: onViewChanged,
        ),
        const SizedBox(height: AppSpacing.sm),
        switch (selectedView) {
          _OneOnOneView.register ||
          _OneOnOneView.history => _OneOnOneHistoryView(
            growth: growth,
            searchController: sessionSearchController,
          ),
          _OneOnOneView.templates => _OneOnOneTemplateView(
            titleController: templateTitleController,
            questionsController: templateQuestionsController,
            onCreateTemplate: onCreateTemplate,
          ),
          _OneOnOneView.suggestions => _OneOnOneSuggestionsView(
            suggestions: growth.suggestions,
          ),
        },
      ],
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
        const _SectionTitle(
          title: 'Registrar conversa',
          subtitle: 'Use template, título e notas para guiar o encontro.',
          helpMessage:
              'Prepare poucas perguntas, registre respostas relevantes, decisões, combinados e próximos passos.',
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
                decoration: const InputDecoration(
                  labelText: 'Template',
                  helperText:
                      'Escolha um roteiro. As perguntas entram nas notas para guiar a conversa.',
                ),
              ),
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: 'Título',
                  helperText:
                      'Use data ou tema central. Ex.: 1:1 sobre autonomia no ciclo atual.',
                ),
              ),
              TextField(
                controller: notesController,
                minLines: 12,
                maxLines: 24,
                decoration: const InputDecoration(
                  labelText: 'Notas da conversa',
                  helperText:
                      'Registre perguntas, respostas, fatos observados, acordos e próximos passos.',
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
          helpMessage:
              'Crie perguntas abertas que ajudem a entender contexto, motivação, bloqueios, feedback e próximos passos.',
        ),
        const SizedBox(height: AppSpacing.sm),
        _Surface(
          child: _FormColumn(
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: 'Nome do template',
                  helperText:
                      'Nome do roteiro. Ex.: Acompanhamento quinzenal, carreira, feedback.',
                ),
              ),
              TextField(
                controller: questionsController,
                minLines: 3,
                maxLines: 6,
                decoration: const InputDecoration(
                  labelText: 'Perguntas, uma por linha',
                  helperText:
                      'Uma pergunta por linha. Ex.: O que mais te bloqueou desde nosso último 1:1?',
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
        TextField(
          controller: searchController,
          decoration: InputDecoration(
            labelText: 'Buscar histórico',
            suffixIcon: IconButton(
              tooltip: 'Buscar',
              onPressed: () => growth.searchSessions(searchController.text),
              icon: const Icon(Icons.search),
            ),
          ),
          onSubmitted: growth.searchSessions,
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
    required this.selectedView,
    required this.onViewChanged,
    required this.onCreatePlan,
    required this.onCreateItem,
    required this.onEditPlan,
  });

  final PersonGrowthViewModel growth;
  final _PdiView selectedView;
  final ValueChanged<_PdiView> onViewChanged;
  final VoidCallback onCreatePlan;
  final ValueChanged<DevelopmentPlan> onCreateItem;
  final ValueChanged<DevelopmentPlan> onEditPlan;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _ModuleHeader(
          title: 'PDI',
          subtitle: 'Organize planos de desenvolvimento e evidências.',
          helpMessage:
              'Descreva uma evolução esperada, conecte com uma competência e acompanhe por ações concretas e evidências observáveis.',
          primaryLabel: 'Novo PDI',
          onPrimaryPressed: onCreatePlan,
        ),
        const SizedBox(height: AppSpacing.sm),
        _ContextualTabBar<_PdiView>(
          selected: selectedView,
          values: const [_PdiView.tracking, _PdiView.suggestions],
          labelOf: (view) => view == _PdiView.tracking ? 'Planos' : view.label,
          iconOf: (view) => view.icon,
          onChanged: onViewChanged,
        ),
        const SizedBox(height: AppSpacing.md),
        switch (selectedView) {
          _PdiView.create || _PdiView.tracking => _PdiTrackingView(
            plans: growth.plans,
            onCreateItem: onCreateItem,
            onEditPlan: onEditPlan,
          ),
          _PdiView.suggestions => _PdiSuggestionsView(
            suggestions: growth.suggestions,
          ),
        },
      ],
    );
  }
}

class _PdiCreateView extends StatelessWidget {
  const _PdiCreateView({
    required this.titleController,
    required this.summaryController,
    required this.targetRoleController,
    required this.onCreatePlan,
  });

  final TextEditingController titleController;
  final TextEditingController summaryController;
  final TextEditingController targetRoleController;
  final VoidCallback onCreatePlan;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionTitle(
          title: 'Criar PDI',
          subtitle: 'Defina o objetivo antes de cadastrar ações de evolução.',
          helpMessage:
              'Use o PDI para transformar uma necessidade de evolução em ações acompanháveis e evidências observáveis.',
        ),
        const SizedBox(height: AppSpacing.sm),
        _Surface(
          child: _FormColumn(
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: 'Título',
                  helperText:
                      'Nome curto do plano. Ex.: Evoluir autonomia técnica.',
                ),
              ),
              TextField(
                controller: targetRoleController,
                decoration: const InputDecoration(
                  labelText: 'Papel alvo',
                  helperText:
                      'Cargo, papel ou responsabilidade desejada. Ex.: referência técnica do squad.',
                ),
              ),
              TextField(
                controller: summaryController,
                minLines: 8,
                maxLines: 16,
                decoration: const InputDecoration(
                  labelText: 'Resumo',
                  helperText:
                      'Explique contexto, lacuna, expectativa e como a evolução será percebida.',
                ),
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
      ],
    );
  }
}

class _PdiSuggestionsView extends StatelessWidget {
  const _PdiSuggestionsView({required this.suggestions});

  final GrowthSuggestions? suggestions;

  @override
  Widget build(BuildContext context) {
    final pdiSuggestions = suggestions?.pdiSuggestions ?? const [];

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionTitle(
          title: 'Sugestões para PDI',
          subtitle: 'Use insumos da análise para planejar próximas ações.',
        ),
        const SizedBox(height: AppSpacing.sm),
        if (pdiSuggestions.isEmpty)
          const _EmptyState(
            icon: Icons.lightbulb_outline,
            message: 'Ainda não há sugestões de PDI para esta pessoa.',
          )
        else
          for (final suggestion in pdiSuggestions)
            _TextTile(
              icon: Icons.lightbulb_outline,
              title: suggestion['title'].toString(),
              subtitle: suggestion['evidence']?.toString(),
            ),
      ],
    );
  }
}

class _PdiTrackingView extends StatelessWidget {
  const _PdiTrackingView({
    required this.plans,
    required this.onCreateItem,
    required this.onEditPlan,
  });

  final List<DevelopmentPlan> plans;
  final ValueChanged<DevelopmentPlan> onCreateItem;
  final ValueChanged<DevelopmentPlan> onEditPlan;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionTitle(
          title: 'Acompanhar PDIs',
          subtitle:
              'Atualize progresso e cadastre ações do plano em andamento.',
        ),
        const SizedBox(height: AppSpacing.sm),
        if (plans.isEmpty)
          const _EmptyState(
            icon: Icons.fact_check_outlined,
            message: 'Nenhum PDI cadastrado ainda.',
          )
        else
          for (final plan in plans)
            _PlanTile(
              plan: plan,
              onCreateItem: () => onCreateItem(plan),
              onEditPlan: () => onEditPlan(plan),
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
    final recentMetrics = growth.deliveryMetrics
        .where((metric) => !metric.metricType.startsWith('annual_'))
        .take(6)
        .toList(growable: false);
    final pullRequests =
        _metricLatestValue(
          growth.deliveryMetrics,
          'annual_pull_request_count',
        ) ??
        _metricSum(growth.deliveryMetrics, 'pull_request_count');
    final qualityAverage =
        _metricLatestValue(growth.deliveryMetrics, 'annual_quality_average') ??
        _metricAverage(growth.deliveryMetrics, 'code_quality_score');
    final ciFailureAverage = _metricLatestValue(
      growth.deliveryMetrics,
      'annual_ci_failure_average',
    );
    final reviewAverage = _metricLatestValue(
      growth.deliveryMetrics,
      'annual_review_comment_average',
    );
    final reworkAverage = _metricLatestValue(
      growth.deliveryMetrics,
      'annual_rework_average',
    );
    final prSizeAverage = _metricLatestValue(
      growth.deliveryMetrics,
      'annual_pr_size_average',
    );
    final mergeTimeAverage = _metricLatestValue(
      growth.deliveryMetrics,
      'annual_pr_merge_time_average',
    );
    final reviewAcceptanceRate = _metricLatestValue(
      growth.deliveryMetrics,
      'annual_review_acceptance_rate',
    );
    final ciSuccessRate = _metricLatestValue(
      growth.deliveryMetrics,
      'annual_ci_success_rate',
    );
    final deliveryPoints =
        _metricLatestValue(
          growth.deliveryMetrics,
          'annual_delivery_points_total',
        ) ??
        _metricSum(growth.deliveryMetrics, 'delivery_points');

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionTitle(
          title: 'KPIs do colaborador',
          subtitle: 'Indicadores calculados a partir das integrações.',
        ),
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
                  child: AppSummaryCard(
                    icon: Icons.forum_outlined,
                    label: '1:1 registrados',
                    value: '${growth.sessions.length}',
                  ),
                ),
                SizedBox(
                  width: itemWidth,
                  child: AppSummaryCard(
                    icon: Icons.trending_up,
                    label: 'PDIs ativos',
                    value: '${growth.plans.length}',
                  ),
                ),
                SizedBox(
                  width: itemWidth,
                  child: AppSummaryCard(
                    icon: Icons.commit_outlined,
                    label: 'PRs no ano',
                    value: _compactMetric(pullRequests),
                  ),
                ),
                SizedBox(
                  width: itemWidth,
                  child: AppSummaryCard(
                    icon: Icons.verified_outlined,
                    label: 'Qualidade média',
                    value: qualityAverage == null
                        ? '-'
                        : qualityAverage.toStringAsFixed(0),
                  ),
                ),
                SizedBox(
                  width: itemWidth,
                  child: AppSummaryCard(
                    icon: Icons.error_outline,
                    label: 'CI falhando / PR',
                    value: _decimalMetric(ciFailureAverage),
                  ),
                ),
                SizedBox(
                  width: itemWidth,
                  child: AppSummaryCard(
                    icon: Icons.rate_review_outlined,
                    label: 'Review / PR',
                    value: _decimalMetric(reviewAverage),
                  ),
                ),
                SizedBox(
                  width: itemWidth,
                  child: AppSummaryCard(
                    icon: Icons.build_outlined,
                    label: 'Retrabalho / PR',
                    value: _decimalMetric(reworkAverage),
                  ),
                ),
                SizedBox(
                  width: itemWidth,
                  child: AppSummaryCard(
                    icon: Icons.task_alt_outlined,
                    label: 'Pontos entregues',
                    value: _compactMetric(deliveryPoints),
                  ),
                ),
                SizedBox(
                  width: itemWidth,
                  child: AppSummaryCard(
                    icon: Icons.timeline_outlined,
                    label: 'Tempo merge / PR',
                    value: _unitMetric(mergeTimeAverage, 'h'),
                  ),
                ),
                SizedBox(
                  width: itemWidth,
                  child: AppSummaryCard(
                    icon: Icons.stacked_line_chart_outlined,
                    label: 'Tamanho médio PR',
                    value: _unitMetric(prSizeAverage, 'linhas'),
                  ),
                ),
                SizedBox(
                  width: itemWidth,
                  child: AppSummaryCard(
                    icon: Icons.fact_check_outlined,
                    label: 'Aceite em review',
                    value: _percentageMetric(reviewAcceptanceRate),
                  ),
                ),
                SizedBox(
                  width: itemWidth,
                  child: AppSummaryCard(
                    icon: Icons.check_circle_outline,
                    label: 'CI com sucesso',
                    value: _percentageMetric(ciSuccessRate),
                  ),
                ),
              ],
            );
          },
        ),
        const SizedBox(height: AppSpacing.md),
        _SectionTitle(
          title: 'Evidências recentes',
          subtitle: 'Últimas métricas numéricas recebidas por webhook.',
        ),
        const SizedBox(height: AppSpacing.sm),
        if (recentMetrics.isEmpty)
          const _EmptyState(
            icon: Icons.insights_outlined,
            message: 'Nenhuma métrica de webhook encontrada para esta pessoa.',
          )
        else
          for (var index = 0; index < recentMetrics.length; index++) ...[
            if (index > 0) const SizedBox(height: AppSpacing.sm),
            _DeliveryMetricTile(metric: recentMetrics[index]),
          ],
      ],
    );
  }
}

class _DeliveryMetricTile extends StatelessWidget {
  const _DeliveryMetricTile({required this.metric});

  final PersonDeliveryMetric metric;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return _Surface(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.analytics_outlined, color: theme.colorScheme.primary),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _deliveryMetricLabel(metric.metricType),
                  style: theme.textTheme.titleSmall,
                ),
                if (metric.sourceRef != null)
                  Text(
                    metric.sourceRef!,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
              ],
            ),
          ),
          Text(
            '${metric.metricValue} ${metric.unit ?? ''}'.trim(),
            style: theme.textTheme.labelLarge,
          ),
        ],
      ),
    );
  }
}

String _deliveryMetricLabel(String type) {
  return switch (type) {
    'code_quality_score' => 'Qualidade do código',
    'delivery_points' => 'Pontos entregues',
    'pull_request_count' => 'Pull requests',
    'review_comments_count' => 'Comentários de review',
    'ci_failures_count' => 'Falhas de CI',
    'rework_count' => 'Retrabalho',
    'changed_files_count' => 'Arquivos alterados',
    'changed_lines_count' => 'Linhas alteradas',
    'pr_merge_time_hours' => 'Tempo até merge',
    'review_acceptance_rate' => 'Aceite em review',
    'ci_success_rate' => 'CI com sucesso',
    'annual_pull_request_count' => 'PRs no ano',
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
              width: 78,
              child: Text(
                'Página $page',
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

class _ModuleHeader extends StatelessWidget {
  const _ModuleHeader({
    required this.title,
    required this.subtitle,
    required this.helpMessage,
    required this.primaryLabel,
    required this.onPrimaryPressed,
  });

  final String title;
  final String subtitle;
  final String helpMessage;
  final String primaryLabel;
  final VoidCallback onPrimaryPressed;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final availableWidth = _availableWidth(constraints, context);
        final titleBlock = _SectionTitle(
          title: title,
          subtitle: subtitle,
          helpMessage: helpMessage,
        );
        final primaryAction = AppPrimaryButton(
          label: primaryLabel,
          onPressed: onPrimaryPressed,
        );

        return SizedBox(
          width: availableWidth,
          child: availableWidth < 460
              ? Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    titleBlock,
                    const SizedBox(height: AppSpacing.sm),
                    SizedBox(width: double.infinity, child: primaryAction),
                  ],
                )
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(width: availableWidth - 160, child: titleBlock),
                    const SizedBox(width: AppSpacing.md),
                    SizedBox(width: 144, child: primaryAction),
                  ],
                ),
        );
      },
    );
  }
}

class _ContextualTabBar<T> extends StatelessWidget {
  const _ContextualTabBar({
    required this.selected,
    required this.values,
    required this.labelOf,
    required this.iconOf,
    required this.onChanged,
  });

  final T selected;
  final Iterable<T> values;
  final String Function(T value) labelOf;
  final IconData Function(T value) iconOf;
  final ValueChanged<T> onChanged;

  @override
  Widget build(BuildContext context) {
    final items = values.toList(growable: false);
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
            for (var index = 0; index < items.length; index++) ...[
              if (index > 0)
                VerticalDivider(width: 1, thickness: 1, color: borderColor),
              _TabPill(
                icon: iconOf(items[index]),
                label: labelOf(items[index]),
                selected: items[index] == selected,
                onPressed: () => onChanged(items[index]),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _TabPill extends StatelessWidget {
  const _TabPill({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onPressed,
  });

  final IconData icon;
  final String label;
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
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            child: DefaultTextStyle.merge(
              style: theme.textTheme.labelLarge?.copyWith(color: foreground),
              child: IconTheme.merge(
                data: IconThemeData(color: foreground),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(icon, size: 18),
                    const SizedBox(width: AppSpacing.xs),
                    Text(label),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _FocusedFlowView extends StatelessWidget {
  const _FocusedFlowView({
    required this.title,
    required this.subtitle,
    required this.onBack,
    required this.actionErrorMessage,
    required this.onDismissActionError,
    required this.child,
  });

  final String title;
  final String subtitle;
  final VoidCallback onBack;
  final String? actionErrorMessage;
  final VoidCallback onDismissActionError;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return _PersonDetailScrollView(
      children: [
        LayoutBuilder(
          builder: (context, constraints) {
            final width = _availableWidth(constraints, context);

            return SizedBox(
              width: width,
              child: Row(
                children: [
                  IconButton(
                    tooltip: 'Voltar para Pessoa',
                    onPressed: onBack,
                    icon: const Icon(Icons.arrow_back),
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  SizedBox(
                    width: _nonNegative(width - (48 + AppSpacing.xs)),
                    child: _SectionTitle(title: title, subtitle: subtitle),
                  ),
                ],
              ),
            );
          },
        ),
        const SizedBox(height: AppSpacing.md),
        if (actionErrorMessage != null) ...[
          _ActionErrorBanner(
            message: actionErrorMessage!,
            onDismiss: onDismissActionError,
          ),
          const SizedBox(height: AppSpacing.md),
        ],
        child,
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

class _PersonDetailScrollView extends StatelessWidget {
  const _PersonDetailScrollView({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final viewport = MediaQuery.sizeOf(context);
        final hasBoundedHeight = constraints.hasBoundedHeight;

        return SizedBox(
          width: constraints.hasBoundedWidth
              ? constraints.maxWidth
              : viewport.width,
          height: hasBoundedHeight ? constraints.maxHeight : null,
          child: ListView(
            padding: EdgeInsets.zero,
            primary: hasBoundedHeight,
            shrinkWrap: !hasBoundedHeight,
            children: children,
          ),
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

class _EditorSheet extends StatelessWidget {
  const _EditorSheet({
    required this.title,
    required this.subtitle,
    required this.children,
    required this.primaryLabel,
    required this.onSubmit,
  });

  final String title;
  final String subtitle;
  final List<Widget> children;
  final String primaryLabel;
  final Future<void> Function(BuildContext context) onSubmit;

  @override
  Widget build(BuildContext context) {
    final maxHeight = MediaQuery.sizeOf(context).height * .92;

    return SafeArea(
      top: false,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 720, maxHeight: maxHeight),
          child: SizedBox(
            height: maxHeight,
            child: Material(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(AppRadius.md),
              ),
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: _SectionTitle(
                            title: title,
                            subtitle: subtitle,
                          ),
                        ),
                        IconButton(
                          tooltip: 'Fechar',
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.close),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Expanded(
                      child: SingleChildScrollView(
                        child: _FormColumn(children: children),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    AppDialogActions(
                      secondaryLabel: 'Cancelar',
                      onSecondaryPressed: () => Navigator.pop(context),
                      primaryLabel: primaryLabel,
                      onPrimaryPressed: () => onSubmit(context),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Future<void> _showEditorSheet({
  required BuildContext context,
  required String title,
  required String subtitle,
  required List<Widget> children,
  required String primaryLabel,
  required Future<void> Function(BuildContext context) onSubmit,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    builder: (_) => _EditorSheet(
      title: title,
      subtitle: subtitle,
      primaryLabel: primaryLabel,
      onSubmit: onSubmit,
      children: children,
    ),
  );
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
  const _SectionTitle({required this.title, this.subtitle, this.helpMessage});

  final String title;
  final String? subtitle;
  final String? helpMessage;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(child: Text(title, style: theme.textTheme.titleMedium)),
            if (helpMessage != null) ...[
              const SizedBox(width: AppSpacing.xs),
              Tooltip(
                message: helpMessage!,
                triggerMode: TooltipTriggerMode.tap,
                child: Icon(
                  Icons.help_outline,
                  size: 18,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ],
        ),
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
        child: LayoutBuilder(
          builder: (context, constraints) {
            final contentWidth = _nonNegative(
              _availableWidth(constraints, context) - (24 + AppSpacing.sm),
            );

            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(icon, color: theme.colorScheme.primary),
                const SizedBox(width: AppSpacing.sm),
                SizedBox(
                  width: contentWidth,
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
            );
          },
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

String _initials(String name) {
  final parts = name.trim().split(RegExp(r'\s+'));
  if (parts.length == 1) {
    return parts.first.characters.take(2).toString().toUpperCase();
  }

  return '${parts.first.characters.first}${parts.last.characters.first}'
      .toUpperCase();
}

double _availableWidth(BoxConstraints constraints, BuildContext context) {
  return constraints.hasBoundedWidth
      ? constraints.maxWidth
      : MediaQuery.sizeOf(context).width;
}

double _nonNegative(double value) => value > 0 ? value : 0;

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

num? _metricAverage(List<PersonDeliveryMetric> metrics, String type) {
  final values = metrics
      .where((metric) => metric.metricType == type)
      .map((metric) => metric.metricValue)
      .toList(growable: false);

  if (values.isEmpty) {
    return null;
  }

  return values.reduce((sum, value) => sum + value) / values.length;
}

num? _metricSum(List<PersonDeliveryMetric> metrics, String type) {
  final values = metrics
      .where((metric) => metric.metricType == type)
      .map((metric) => metric.metricValue)
      .toList(growable: false);

  if (values.isEmpty) {
    return null;
  }

  return values.reduce((sum, value) => sum + value);
}

num? _metricLatestValue(List<PersonDeliveryMetric> metrics, String type) {
  final values = metrics
      .where((metric) => metric.metricType == type)
      .toList(growable: false);

  if (values.isEmpty) {
    return null;
  }

  values.sort((a, b) {
    final aDate = a.occurredAt ?? DateTime.fromMillisecondsSinceEpoch(0);
    final bDate = b.occurredAt ?? DateTime.fromMillisecondsSinceEpoch(0);
    return bDate.compareTo(aDate);
  });

  return values.first.metricValue;
}

String _compactMetric(num? value) {
  if (value == null) {
    return '-';
  }

  return value == value.roundToDouble()
      ? value.toInt().toString()
      : value.toStringAsFixed(1);
}

String _decimalMetric(num? value) {
  return value == null ? '-' : value.toStringAsFixed(1);
}

String _percentageMetric(num? value) {
  return value == null ? '-' : '${value.toStringAsFixed(0)}%';
}

String _unitMetric(num? value, String unit) {
  if (value == null) {
    return '-';
  }

  return '${_compactMetric(value)} $unit';
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
