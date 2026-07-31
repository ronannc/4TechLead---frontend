import 'dart:async';

import 'package:flutter/material.dart';

import '../../responsive/breakpoints.dart';
import '../../theme/app_spacing.dart';
import '../inputs/app_search_field.dart';
import '../states/empty_view.dart';

/// One column of an [AppDataTable]: a header label and how to render a
/// given item's value for that column.
class AppDataColumn<T> {
  const AppDataColumn({required this.label, required this.cellBuilder});

  final String label;
  final String Function(T item) cellBuilder;
}

/// Reusable, responsive list/table: a search field always sits above the
/// content (never a toggle to reveal it — every list is searchable from the
/// start), and the rows themselves render as a plain divided list on mobile
/// widths (no per-row `Card`) or a [DataTable] on desktop widths, so a
/// Screen never has to make either decision itself.
///
/// [items] is expected to already be filtered by the caller's ViewModel —
/// [onSearchChanged] just reports the (debounced) query text back to it.
class AppDataTable<T> extends StatefulWidget {
  const AppDataTable({
    super.key,
    required this.items,
    required this.columns,
    required this.onSearchChanged,
    this.onRowTap,
    this.searchHint = 'Buscar...',
    this.emptyMessage = 'Nenhum item encontrado.',
  });

  final List<T> items;
  final List<AppDataColumn<T>> columns;
  final ValueChanged<String> onSearchChanged;
  final ValueChanged<T>? onRowTap;
  final String searchHint;
  final String emptyMessage;

  @override
  State<AppDataTable<T>> createState() => _AppDataTableState<T>();
}

class _AppDataTableState<T> extends State<AppDataTable<T>> {
  final _searchController = TextEditingController();
  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    setState(() {}); // rebuilds the clear button's visibility
    _debounce?.cancel();
    _debounce = Timer(
      const Duration(milliseconds: 300),
      () => widget.onSearchChanged(query),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: AppSearchField(
            controller: _searchController,
            onChanged: _onSearchChanged,
            hintText: widget.searchHint,
          ),
        ),
        Expanded(
          child: widget.items.isEmpty
              ? EmptyView(message: widget.emptyMessage)
              : Breakpoints.isDesktop(context)
              ? _buildTable(context)
              : _buildList(context),
        ),
      ],
    );
  }

  Widget _buildTable(BuildContext context) {
    return SingleChildScrollView(
      child: DataTable(
        columns: [
          for (final column in widget.columns)
            DataColumn(label: Text(column.label)),
        ],
        rows: [
          for (final item in widget.items)
            DataRow(
              onSelectChanged: widget.onRowTap == null
                  ? null
                  : (_) => widget.onRowTap!(item),
              cells: [
                for (final column in widget.columns)
                  DataCell(Text(column.cellBuilder(item))),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildList(BuildContext context) {
    return ListView.separated(
      itemCount: widget.items.length,
      separatorBuilder: (_, _) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final item = widget.items[index];

        return ListTile(
          onTap: widget.onRowTap == null ? null : () => widget.onRowTap!(item),
          title: Text(widget.columns.first.cellBuilder(item)),
          subtitle: widget.columns.length > 1
              ? Text(widget.columns[1].cellBuilder(item))
              : null,
        );
      },
    );
  }
}
