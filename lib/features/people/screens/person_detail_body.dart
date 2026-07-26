import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_spacing.dart';
import '../models/person.dart';
import '../viewmodels/person_detail_view_model.dart';

/// The loaded-state body of [PersonDetailScreen], split into its own
/// file/class so only this subtree rebuilds when the person data changes.
class PersonDetailBody extends StatelessWidget {
  const PersonDetailBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Selector<PersonDetailViewModel, Person?>(
      selector: (_, vm) => vm.person,
      builder: (context, person, _) {
        if (person == null) {
          return const SizedBox.shrink();
        }

        final theme = Theme.of(context);
        final dateFormat = DateFormat.yMMMd('pt_BR');

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(person.name, style: theme.textTheme.headlineMedium),
              const SizedBox(height: AppSpacing.xs),
              Text(person.position, style: theme.textTheme.bodyLarge),
              const SizedBox(height: AppSpacing.lg),
              _field(context, 'Tipo de contrato', person.contractType.label),
              _field(context, 'Senioridade', person.seniority.label),
              _field(
                context,
                'Nascimento',
                '${dateFormat.format(person.birthDate)} (${person.age} anos)',
              ),
              _field(context, 'Admissão', dateFormat.format(person.admissionDate)),
              if (person.email != null) _field(context, 'E-mail', person.email!),
              if (person.phone != null) _field(context, 'Telefone', person.phone!),
            ],
          ),
        );
      },
    );
  }

  Widget _field(BuildContext context, String label, String value) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
          ),
          Text(value, style: theme.textTheme.bodyLarge),
        ],
      ),
    );
  }
}
