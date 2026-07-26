import 'package:flutter/material.dart';

import '../../responsive/breakpoints.dart';
import '../../theme/app_spacing.dart';

/// One column of an [AppDataTable]: a header label and how to render a
/// given item's value for that column.
class AppDataColumn<T> {
  const AppDataColumn({required this.label, required this.cellBuilder});

  final String label;
  final String Function(T item) cellBuilder;
}

/// Reusable, responsive list/table: renders as a card [ListView] on mobile
/// widths and as a [DataTable] on desktop widths, so a Screen never has to
/// make that layout decision itself.
class AppDataTable<T> extends StatelessWidget {
  const AppDataTable({
    super.key,
    required this.items,
    required this.columns,
    this.onRowTap,
  });

  final List<T> items;
  final List<AppDataColumn<T>> columns;
  final ValueChanged<T>? onRowTap;

  @override
  Widget build(BuildContext context) {
    if (Breakpoints.isDesktop(context)) {
      return _buildTable(context);
    }

    return _buildList(context);
  }

  Widget _buildTable(BuildContext context) {
    return SingleChildScrollView(
      child: DataTable(
        columns: [for (final column in columns) DataColumn(label: Text(column.label))],
        rows: [
          for (final item in items)
            DataRow(
              onSelectChanged: onRowTap == null ? null : (_) => onRowTap!(item),
              cells: [for (final column in columns) DataCell(Text(column.cellBuilder(item)))],
            ),
        ],
      ),
    );
  }

  Widget _buildList(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(AppSpacing.md),
      itemCount: items.length,
      separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.sm),
      itemBuilder: (context, index) {
        final item = items[index];

        return Card(
          child: ListTile(
            onTap: onRowTap == null ? null : () => onRowTap!(item),
            title: Text(columns.first.cellBuilder(item)),
            subtitle: columns.length > 1 ? Text(columns[1].cellBuilder(item)) : null,
          ),
        );
      },
    );
  }
}
