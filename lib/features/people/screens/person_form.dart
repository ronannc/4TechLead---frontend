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
  static final RegExp _emailRegex = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _positionController = TextEditingController();

  DateTime? _birthDate;
  DateTime? _admissionDate;
  ContractType? _contractType;
  SeniorityLevel? _seniority;

  String? _nameError;
  String? _birthDateError;
  String? _positionError;
  String? _contractTypeError;
  String? _admissionDateError;
  String? _seniorityError;
  String? _emailError;
  String? _phoneError;
  int? _filledPersonId;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _positionController.dispose();
    super.dispose();
  }

  DateTime _dateOnly(DateTime value) =>
      DateTime(value.year, value.month, value.day);

  DateTime get _today {
    final now = DateTime.now();

    return DateTime(now.year, now.month, now.day);
  }

  bool _validateForm() {
    final name = _nameController.text.trim();
    final position = _positionController.text.trim();
    final email = _emailController.text.trim();
    final phone = _phoneController.text.trim();
    final birthDate = _birthDate;
    final admissionDate = _admissionDate;
    final today = _today;

    String? nameError;
    String? birthDateError;
    String? positionError;
    String? contractTypeError;
    String? admissionDateError;
    String? seniorityError;
    String? emailError;
    String? phoneError;

    if (name.isEmpty) {
      nameError = 'Informe o nome.';
    } else if (name.length > 255) {
      nameError = 'O nome deve ter no máximo 255 caracteres.';
    }

    if (birthDate != null && !_dateOnly(birthDate).isBefore(today)) {
      birthDateError = 'A data de nascimento deve ser anterior a hoje.';
    }

    if (position.isEmpty) {
      positionError = 'Informe o cargo.';
    } else if (position.length > 255) {
      positionError = 'O cargo deve ter no máximo 255 caracteres.';
    }

    if (_contractType == null) {
      contractTypeError = 'Selecione o tipo de contrato.';
    }

    if (admissionDate != null) {
      final normalizedAdmission = _dateOnly(admissionDate);
      if (normalizedAdmission.isAfter(today)) {
        admissionDateError = 'A data de admissão deve ser hoje ou anterior.';
      } else if (birthDate != null &&
          !normalizedAdmission.isAfter(_dateOnly(birthDate))) {
        admissionDateError =
            'A admissão deve ser posterior à data de nascimento.';
      }
    }

    if (_seniority == null) {
      seniorityError = 'Selecione a senioridade.';
    }

    if (email.isNotEmpty) {
      if (email.length > 255) {
        emailError = 'O e-mail deve ter no máximo 255 caracteres.';
      } else if (!_emailRegex.hasMatch(email)) {
        emailError = 'Informe um e-mail válido.';
      }
    }

    if (phone.isNotEmpty && phone.length > 30) {
      phoneError = 'O telefone deve ter no máximo 30 caracteres.';
    }

    setState(() {
      _nameError = nameError;
      _birthDateError = birthDateError;
      _positionError = positionError;
      _contractTypeError = contractTypeError;
      _admissionDateError = admissionDateError;
      _seniorityError = seniorityError;
      _emailError = emailError;
      _phoneError = phoneError;
    });

    return [
      nameError,
      birthDateError,
      positionError,
      contractTypeError,
      admissionDateError,
      seniorityError,
      emailError,
      phoneError,
    ].every((error) => error == null);
  }

  Future<void> _submit() async {
    if (!_validateForm()) {
      return;
    }

    final birthDate = _birthDate;
    final admissionDate = _admissionDate;
    final contractType = _contractType!;
    final seniority = _seniority!;
    final name = _nameController.text.trim();
    final position = _positionController.text.trim();
    final email = _emailController.text.trim();
    final phone = _phoneController.text.trim();

    final viewModel = context.read<PersonFormViewModel>();
    await viewModel.savePerson(
      name: name,
      birthDate: birthDate,
      position: position,
      contractType: contractType,
      admissionDate: admissionDate,
      seniority: seniority,
      email: email.isEmpty ? null : email,
      phone: phone.isEmpty ? null : phone,
    );

    if (viewModel.state == ViewState.loaded && mounted) {
      context.pop(true);
    }
  }

  void _fillFromPerson(PersonFormViewModel viewModel) {
    final person = viewModel.person;
    if (person == null || _filledPersonId == person.id) {
      return;
    }

    _filledPersonId = person.id;
    _nameController.text = person.name;
    _emailController.text = person.email ?? '';
    _phoneController.text = person.phone ?? '';
    _positionController.text = person.position;
    _birthDate = person.birthDate;
    _admissionDate = person.admissionDate;
    _contractType = person.contractType;
    _seniority = person.seniority;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final viewModel = context.watch<PersonFormViewModel>();
    _fillFromPerson(viewModel);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppTextField(
            label: 'Nome',
            controller: _nameController,
            errorText: _nameError,
            onChanged: (_) {
              if (_nameError != null) {
                setState(() => _nameError = null);
              }
            },
          ),
          const SizedBox(height: AppSpacing.md),
          AppTextField(
            label: 'E-mail',
            controller: _emailController,
            errorText: _emailError,
            keyboardType: TextInputType.emailAddress,
            onChanged: (_) {
              if (_emailError != null) {
                setState(() => _emailError = null);
              }
            },
          ),
          const SizedBox(height: AppSpacing.md),
          AppTextField(
            label: 'Telefone',
            controller: _phoneController,
            errorText: _phoneError,
            keyboardType: TextInputType.phone,
            onChanged: (_) {
              if (_phoneError != null) {
                setState(() => _phoneError = null);
              }
            },
          ),
          const SizedBox(height: AppSpacing.md),
          AppTextField(
            label: 'Cargo',
            controller: _positionController,
            errorText: _positionError,
            onChanged: (_) {
              if (_positionError != null) {
                setState(() => _positionError = null);
              }
            },
          ),
          const SizedBox(height: AppSpacing.md),
          AppDropdownField<ContractType>(
            label: 'Tipo de contrato',
            items: ContractType.values,
            labelBuilder: (type) => type.label,
            value: _contractType,
            errorText: _contractTypeError,
            onChanged: (value) => setState(() {
              _contractType = value;
              _contractTypeError = null;
            }),
          ),
          const SizedBox(height: AppSpacing.md),
          AppDropdownField<SeniorityLevel>(
            label: 'Nível de senioridade',
            items: SeniorityLevel.values,
            labelBuilder: (level) => level.label,
            value: _seniority,
            errorText: _seniorityError,
            onChanged: (value) => setState(() {
              _seniority = value;
              _seniorityError = null;
            }),
          ),
          const SizedBox(height: AppSpacing.md),
          AppDateField(
            label: 'Data de nascimento (opcional)',
            value: _birthDate,
            errorText: _birthDateError,
            lastDate: _today.subtract(const Duration(days: 1)),
            onChanged: (value) => setState(() {
              _birthDate = value;
              _birthDateError = null;
              if (_admissionDateError != null) {
                _admissionDateError = null;
              }
            }),
          ),
          const SizedBox(height: AppSpacing.md),
          AppDateField(
            label: 'Data de admissão (opcional)',
            value: _admissionDate,
            errorText: _admissionDateError,
            onChanged: (value) => setState(() {
              _admissionDate = value;
              _admissionDateError = null;
            }),
          ),
          const SizedBox(height: AppSpacing.lg),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (viewModel.state == ViewState.error)
                Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: Text(
                    viewModel.errorMessage ?? 'Algo deu errado.',
                    style: TextStyle(color: theme.colorScheme.error),
                  ),
                ),
              AppPrimaryButton(
                label: viewModel.isEditing ? 'Salvar alterações' : 'Adicionar',
                loading: viewModel.state == ViewState.loading,
                onPressed: _submit,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
