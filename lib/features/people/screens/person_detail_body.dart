import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/data/app_key_value_row.dart';
import '../../daily/screens/person_daily_section.dart';
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
              AppKeyValueRow(
                label: 'Tipo de contrato',
                value: person.contractType.label,
              ),
              AppKeyValueRow(
                label: 'Senioridade',
                value: person.seniority.label,
              ),
              AppKeyValueRow(
                label: 'Nascimento',
                value:
                    '${dateFormat.format(person.birthDate)} (${person.age} anos)',
              ),
              AppKeyValueRow(
                label: 'Admissão',
                value: dateFormat.format(person.admissionDate),
              ),
              if (person.email != null)
                AppKeyValueRow(label: 'E-mail', value: person.email!),
              if (person.phone != null)
                AppKeyValueRow(label: 'Telefone', value: person.phone!),
              const SizedBox(height: AppSpacing.lg),
              PersonDailySection(teamId: person.teamId),
            ],
          ),
        );
      },
    );
  }
}
