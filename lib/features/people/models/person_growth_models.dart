class OneOnOneTemplate {
  const OneOnOneTemplate({
    required this.id,
    required this.title,
    required this.questions,
    this.description,
    this.isDefault = false,
    this.active = true,
  });

  final int id;
  final String title;
  final String? description;
  final List<String> questions;
  final bool isDefault;
  final bool active;

  factory OneOnOneTemplate.fromJson(Map<String, dynamic> json) {
    return OneOnOneTemplate(
      id: json['id'] as int,
      title: json['title'] as String,
      description: json['description'] as String?,
      questions: _stringList(json['questions']),
      isDefault: json['is_default'] as bool? ?? false,
      active: json['active'] as bool? ?? true,
    );
  }
}

class OneOnOneSession {
  const OneOnOneSession({
    required this.id,
    required this.personId,
    required this.title,
    required this.status,
    this.templateId,
    this.scheduledFor,
    this.heldAt,
    this.sentiment,
    this.questions = const [],
    this.notes,
    this.actionItems = const [],
  });

  final int id;
  final int personId;
  final int? templateId;
  final DateTime? scheduledFor;
  final DateTime? heldAt;
  final String title;
  final String status;
  final String? sentiment;
  final List<String> questions;
  final String? notes;
  final List<Map<String, dynamic>> actionItems;

  factory OneOnOneSession.fromJson(Map<String, dynamic> json) {
    return OneOnOneSession(
      id: json['id'] as int,
      personId: json['person_id'] as int,
      templateId: json['one_on_one_template_id'] as int?,
      scheduledFor: _date(json['scheduled_for'] as String?),
      heldAt: _date(json['held_at'] as String?),
      title: json['title'] as String,
      status: json['status'] as String,
      sentiment: json['sentiment'] as String?,
      questions: _stringList(json['questions']),
      notes: json['notes'] as String?,
      actionItems: _mapList(json['action_items']),
    );
  }
}

class DevelopmentPlan {
  const DevelopmentPlan({
    required this.id,
    required this.personId,
    required this.title,
    required this.status,
    required this.progress,
    this.summary,
    this.startDate,
    this.endDate,
    this.targetRole,
    this.targetSeniority,
    this.items = const [],
  });

  final int id;
  final int personId;
  final String title;
  final String? summary;
  final String status;
  final DateTime? startDate;
  final DateTime? endDate;
  final String? targetRole;
  final String? targetSeniority;
  final int progress;
  final List<DevelopmentPlanItem> items;

  factory DevelopmentPlan.fromJson(Map<String, dynamic> json) {
    return DevelopmentPlan(
      id: json['id'] as int,
      personId: json['person_id'] as int,
      title: json['title'] as String,
      summary: json['summary'] as String?,
      status: json['status'] as String,
      startDate: _date(json['start_date'] as String?),
      endDate: _date(json['end_date'] as String?),
      targetRole: json['target_role'] as String?,
      targetSeniority: json['target_seniority'] as String?,
      progress: json['progress'] as int? ?? 0,
      items: [
        for (final item in (json['items'] as List<dynamic>? ?? []))
          DevelopmentPlanItem.fromJson(item as Map<String, dynamic>),
      ],
    );
  }
}

class DevelopmentPlanItem {
  const DevelopmentPlanItem({
    required this.id,
    required this.developmentPlanId,
    required this.title,
    required this.status,
    required this.progress,
    this.description,
    this.competency,
    this.evidence,
    this.dueDate,
  });

  final int id;
  final int developmentPlanId;
  final String title;
  final String? description;
  final String? competency;
  final String? evidence;
  final String status;
  final DateTime? dueDate;
  final int progress;

  factory DevelopmentPlanItem.fromJson(Map<String, dynamic> json) {
    return DevelopmentPlanItem(
      id: json['id'] as int,
      developmentPlanId: json['development_plan_id'] as int,
      title: json['title'] as String,
      description: json['description'] as String?,
      competency: json['competency'] as String?,
      evidence: json['evidence'] as String?,
      status: json['status'] as String,
      dueDate: _date(json['due_date'] as String?),
      progress: json['progress'] as int? ?? 0,
    );
  }
}

class PersonOkr {
  const PersonOkr({
    required this.id,
    required this.personId,
    required this.objective,
    required this.status,
    required this.confidence,
    required this.progress,
    this.developmentPlanId,
    this.cycle,
    this.focusArea,
    this.diagnosis,
    this.evidenceSource,
    this.baseline,
    this.target,
    this.keyResults = const [],
  });

  final int id;
  final int personId;
  final int? developmentPlanId;
  final String objective;
  final String? cycle;
  final String status;
  final String? focusArea;
  final String? diagnosis;
  final String? evidenceSource;
  final String? baseline;
  final String? target;
  final int confidence;
  final int progress;
  final List<OkrKeyResult> keyResults;

  factory PersonOkr.fromJson(Map<String, dynamic> json) {
    return PersonOkr(
      id: json['id'] as int,
      personId: json['person_id'] as int,
      developmentPlanId: json['development_plan_id'] as int?,
      objective: json['objective'] as String,
      cycle: json['cycle'] as String?,
      status: json['status'] as String,
      focusArea: json['focus_area'] as String?,
      diagnosis: json['diagnosis'] as String?,
      evidenceSource: json['evidence_source'] as String?,
      baseline: json['baseline'] as String?,
      target: json['target'] as String?,
      confidence: json['confidence'] as int? ?? 50,
      progress: json['progress'] as int? ?? 0,
      keyResults: [
        for (final item in (json['key_results'] as List<dynamic>? ?? []))
          OkrKeyResult.fromJson(item as Map<String, dynamic>),
      ],
    );
  }
}

class OkrKeyResult {
  const OkrKeyResult({
    required this.id,
    required this.okrId,
    required this.title,
    required this.status,
    required this.progress,
    this.metricName,
    this.currentValue,
    this.targetValue,
    this.unit,
    this.evidence,
  });

  final int id;
  final int okrId;
  final String title;
  final String? metricName;
  final num? currentValue;
  final num? targetValue;
  final String? unit;
  final String status;
  final String? evidence;
  final int progress;

  factory OkrKeyResult.fromJson(Map<String, dynamic> json) {
    return OkrKeyResult(
      id: json['id'] as int,
      okrId: json['okr_id'] as int,
      title: json['title'] as String,
      metricName: json['metric_name'] as String?,
      currentValue: _num(json['current_value']),
      targetValue: _num(json['target_value']),
      unit: json['unit'] as String?,
      status: json['status'] as String,
      evidence: json['evidence'] as String?,
      progress: json['progress'] as int? ?? 0,
    );
  }
}

class GrowthSuggestions {
  const GrowthSuggestions({
    required this.oneOnOneQuestions,
    required this.pdiSuggestions,
    required this.okrSuggestions,
  });

  final List<String> oneOnOneQuestions;
  final List<Map<String, dynamic>> pdiSuggestions;
  final List<Map<String, dynamic>> okrSuggestions;

  factory GrowthSuggestions.fromJson(Map<String, dynamic> json) {
    return GrowthSuggestions(
      oneOnOneQuestions: _stringList(json['one_on_one_questions']),
      pdiSuggestions: _mapList(json['pdi_suggestions']),
      okrSuggestions: _mapList(json['okr_suggestions']),
    );
  }
}

DateTime? _date(String? value) => value == null ? null : DateTime.parse(value);

num? _num(Object? value) {
  if (value == null) {
    return null;
  }
  if (value is num) {
    return value;
  }
  return num.tryParse(value.toString());
}

List<String> _stringList(Object? value) {
  return [for (final item in (value as List<dynamic>? ?? [])) item.toString()];
}

List<Map<String, dynamic>> _mapList(Object? value) {
  return [
    for (final item in (value as List<dynamic>? ?? []))
      Map<String, dynamic>.from(item as Map),
  ];
}
