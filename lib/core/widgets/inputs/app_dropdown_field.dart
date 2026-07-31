import 'package:flutter/material.dart';

/// Standard dropdown select used across the app instead of a raw
/// [DropdownButtonFormField] per screen, so label/error styling stays
/// consistent everywhere (mirrors [AppTextField]/[AppDateField]).
class AppDropdownField<T> extends StatelessWidget {
  const AppDropdownField({
    super.key,
    required this.label,
    required this.items,
    required this.labelBuilder,
    required this.value,
    required this.onChanged,
    this.errorText,
  });

  final String label;
  final List<T> items;
  final String Function(T item) labelBuilder;
  final T? value;
  final ValueChanged<T?> onChanged;
  final String? errorText;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      initialValue: value,
      decoration: InputDecoration(labelText: label, errorText: errorText),
      items: [
        for (final item in items)
          DropdownMenuItem(value: item, child: Text(labelBuilder(item))),
      ],
      onChanged: onChanged,
    );
  }
}
