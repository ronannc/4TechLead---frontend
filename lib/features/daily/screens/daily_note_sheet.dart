import 'package:flutter/material.dart';

import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/buttons/app_primary_button.dart';
import '../../../core/widgets/inputs/app_dropdown_field.dart';
import '../../../core/widgets/inputs/app_text_field.dart';
import '../models/daily_note_category.dart';
import '../viewmodels/daily_session_view_model.dart';

/// Bottom sheet for attaching an optional categorized note (impediment/
/// alignment/event) to the current turn — opened from [DailyRunningBody].
Future<void> showDailyNoteSheet(
  BuildContext context,
  DailySessionViewModel viewModel,
) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    builder: (context) => Padding(
      padding: EdgeInsets.only(
        left: AppSpacing.md,
        right: AppSpacing.md,
        top: AppSpacing.md,
        bottom: MediaQuery.of(context).viewInsets.bottom + AppSpacing.md,
      ),
      child: _DailyNoteForm(viewModel: viewModel),
    ),
  );
}

class _DailyNoteForm extends StatefulWidget {
  const _DailyNoteForm({required this.viewModel});

  final DailySessionViewModel viewModel;

  @override
  State<_DailyNoteForm> createState() => _DailyNoteFormState();
}

class _DailyNoteFormState extends State<_DailyNoteForm> {
  DailyNoteCategory? _category;
  late final TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    _category = widget.viewModel.currentTurn?.noteCategory;
    _textController = TextEditingController(
      text: widget.viewModel.currentTurn?.noteText,
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Anotação do turno',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: AppSpacing.md),
        AppDropdownField<DailyNoteCategory>(
          label: 'Categoria',
          items: DailyNoteCategory.values,
          labelBuilder: (category) => category.label,
          value: _category,
          onChanged: (value) => setState(() => _category = value),
        ),
        const SizedBox(height: AppSpacing.md),
        AppTextField(label: 'Descrição', controller: _textController),
        const SizedBox(height: AppSpacing.lg),
        AppPrimaryButton(
          label: 'Salvar anotação',
          onPressed: () {
            widget.viewModel.setCurrentNote(
              category: _category,
              text: _textController.text,
            );
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
