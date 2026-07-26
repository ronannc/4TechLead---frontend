import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_spacing.dart';
import '../../../core/viewmodels/base_view_model.dart';
import '../../../core/widgets/buttons/app_primary_button.dart';
import '../../../core/widgets/inputs/app_date_field.dart';
import '../../../core/widgets/inputs/app_dropdown_field.dart';
import '../../../core/widgets/inputs/app_text_field.dart';
import '../models/contract_type.dart';
import '../models/seniority_level.dart';
import '../viewmodels/person_form_view_model.dart';

/// The interactive body of [PersonFormScreen], split into its own file/class
/// so only this subtree rebuilds while typing/submitting.
class PersonForm extends StatefulWidget {
  const PersonForm({super.key});

  @override
  State<PersonForm> createState() => _PersonFormState();
}

class _PersonFormState extends State<PersonForm> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _positionController = TextEditingController();

  DateTime? _birthDate;
  DateTime? _admissionDate;
  ContractType? _contractType;
  SeniorityLevel? _seniority;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _positionController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final birthDate = _birthDate;
    final admissionDate = _admissionDate;
    final contractType = _contractType;
    final seniority = _seniority;

    if (birthDate == null || admissionDate == null || contractType == null || seniority == null) {
      return;
    }

    final viewModel = context.read<PersonFormViewModel>();
    await viewModel.createPerson(
      name: _nameController.text,
      birthDate: birthDate,
      position: _positionController.text,
      contractType: contractType,
      admissionDate: admissionDate,
      seniority: seniority,
      email: _emailController.text.isEmpty ? null : _emailController.text,
      phone: _phoneController.text.isEmpty ? null : _phoneController.text,
    );

    if (viewModel.state == ViewState.loaded && mounted) {
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppTextField(label: 'Nome', controller: _nameController),
          const SizedBox(height: AppSpacing.md),
          AppTextField(
            label: 'E-mail',
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: AppSpacing.md),
          AppTextField(
            label: 'Telefone',
            controller: _phoneController,
            keyboardType: TextInputType.phone,
          ),
          const SizedBox(height: AppSpacing.md),
          AppTextField(label: 'Cargo', controller: _positionController),
          const SizedBox(height: AppSpacing.md),
          AppDropdownField<ContractType>(
            label: 'Tipo de contrato',
            items: ContractType.values,
            labelBuilder: (type) => type.label,
            value: _contractType,
            onChanged: (value) => setState(() => _contractType = value),
          ),
          const SizedBox(height: AppSpacing.md),
          AppDropdownField<SeniorityLevel>(
            label: 'Nível de senioridade',
            items: SeniorityLevel.values,
            labelBuilder: (level) => level.label,
            value: _seniority,
            onChanged: (value) => setState(() => _seniority = value),
          ),
          const SizedBox(height: AppSpacing.md),
          AppDateField(
            label: 'Data de nascimento',
            value: _birthDate,
            onChanged: (value) => setState(() => _birthDate = value),
          ),
          const SizedBox(height: AppSpacing.md),
          AppDateField(
            label: 'Data de admissão',
            value: _admissionDate,
            onChanged: (value) => setState(() => _admissionDate = value),
          ),
          const SizedBox(height: AppSpacing.lg),
          Selector<PersonFormViewModel, ViewState>(
            selector: (_, vm) => vm.state,
            builder: (context, state, _) {
              final viewModel = context.read<PersonFormViewModel>();

              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (state == ViewState.error)
                    Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                      child: Text(
                        viewModel.errorMessage ?? 'Algo deu errado.',
                        style: TextStyle(color: theme.colorScheme.error),
                      ),
                    ),
                  AppPrimaryButton(
                    label: 'Adicionar',
                    loading: state == ViewState.loading,
                    onPressed: _submit,
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
