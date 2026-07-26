import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Standard date input used across the app instead of a raw [TextFormField]
/// + manual [showDatePicker] wiring per screen. Displays the selected date
/// formatted via `intl`; tapping anywhere on the field opens the date picker
/// (the underlying text field is read-only, so no keyboard ever shows).
class AppDateField extends StatelessWidget {
  AppDateField({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    this.errorText,
    DateTime? firstDate,
    DateTime? lastDate,
  }) : firstDate = firstDate ?? DateTime(1900),
       lastDate = lastDate ?? DateTime.now();

  final String label;
  final DateTime? value;
  final ValueChanged<DateTime> onChanged;
  final String? errorText;
  final DateTime firstDate;
  final DateTime lastDate;

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat.yMMMd('pt_BR');

    return InkWell(
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: value ?? lastDate,
          firstDate: firstDate,
          lastDate: lastDate,
        );

        if (picked != null) {
          onChanged(picked);
        }
      },
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          errorText: errorText,
          suffixIcon: const Icon(Icons.calendar_today_outlined),
        ),
        child: Text(value == null ? '' : dateFormat.format(value!)),
      ),
    );
  }
}
