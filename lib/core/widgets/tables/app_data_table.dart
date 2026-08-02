import 'dart:async';

import 'package:flutter/material.dart';

import '../../responsive/breakpoints.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_theme_extension.dart';
import '../inputs/app_search_field.dart';
import '../states/empty_view.dart';

/// One column of an [AppDataTable]: a header label and how to render a
/// given item's value for that column.
class AppDataColumn<T> {
  const AppDataColumn({required this.label, required this.cellBuilder});

  final String label;
  final String Function(T item) cellBuilder;
}

/// Reusable, responsive list/table for long collections. It keeps search,
/// result count, empty state, mobile list rows, and desktop table surfaces
/// visually consistent across Teams, People, Daily history, and future lists.
///
/// [items] is expected to already be filtered by the caller's ViewModel.
/// [onSearchChanged] only reports the debounced query text back to it.
class AppDataTable<T> extends StatefulWidget {
  const AppDataTable({
    super.key,
    required this.items,
    required this.columns,
    required this.onSearchChanged,
    this.title,
    this.subtitle,
    this.itemIcon = Icons.chevron_right,
    this.onRowTap,
    this.searchHint = 'Buscar...',
    this.emptyMessage = 'Nenhum item encontrado.',
    this.itemCountLabel,
  });

  final List<T> items;
  final List<AppDataColumn<T>> columns;
  final ValueChanged<String> onSearchChanged;
  final String? title;
  final String? subtitle;
  final IconData itemIcon;
  final ValueChanged<T>? onRowTap;
  final String searchHint;
  final String emptyMessage;
  final String Function(int count)? itemCountLabel;

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
    setState(() {});
    _debounce?.cancel();
    _debounce = Timer(
      const Duration(milliseconds: 300),
      () => widget.onSearchChanged(query),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final border = theme.extension<AppThemeExtension>()!.border;
    final countLabel =
        widget.itemCountLabel?.call(widget.items.length) ??
        '${widget.items.length} itens';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.md,
            AppSpacing.md,
            AppSpacing.md,
            AppSpacing.sm,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.title != null || widget.subtitle != null) ...[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (widget.title != null)
                            Text(
                              widget.title!,
                              style: theme.textTheme.titleMedium,
                            ),
                          if (widget.subtitle != null) ...[
                            const SizedBox(height: AppSpacing.xs),
                            Text(
                              widget.subtitle!,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    _CountPill(label: countLabel),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
              ],
              DecoratedBox(
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                  border: Border.all(color: border),
                ),
                child: AppSearchField(
                  controller: _searchController,
                  onChanged: _onSearchChanged,
                  hintText: widget.searchHint,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: widget.items.isEmpty
              ? _ListSurface(child: EmptyView(message: widget.emptyMessage))
              : Breakpoints.isDesktop(context)
              ? _buildTable(context)
              : _buildList(context),
        ),
      ],
    );
  }

  Widget _buildTable(BuildContext context) {
    final theme = Theme.of(context);

    return _ListSurface(
      child: SingleChildScrollView(
        child: SizedBox(
          width: double.infinity,
          child: DataTable(
            headingTextStyle: theme.textTheme.labelMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
            dataTextStyle: theme.textTheme.bodyMedium,
            showCheckboxColumn: false,
            columns: [
              for (final column in widget.columns)
                DataColumn(label: Text(column.label)),
              if (widget.onRowTap != null) const DataColumn(label: Text('')),
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
                    if (widget.onRowTap != null)
                      const DataCell(
                        Align(
                          alignment: Alignment.centerRight,
                          child: Icon(Icons.chevron_right, size: 18),
                        ),
                      ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildList(BuildContext context) {
    return _ListSurface(
      child: ListView.separated(
        itemCount: widget.items.length,
        separatorBuilder: (_, _) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final item = widget.items[index];
          final subtitle = widget.columns
              .skip(1)
              .map((column) => column.cellBuilder(item))
              .where((value) => value.trim().isNotEmpty)
              .join(' · ');

          return _SystemListRow(
            icon: widget.itemIcon,
            title: widget.columns.first.cellBuilder(item),
            subtitle: subtitle,
            onTap: widget.onRowTap == null
                ? null
                : () => widget.onRowTap!(item),
          );
        },
      ),
    );
  }
}

class _ListSurface extends StatelessWidget {
  const _ListSurface({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final border = theme.extension<AppThemeExtension>()!.border;

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        0,
        AppSpacing.md,
        AppSpacing.md,
      ),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(AppRadius.sm),
          border: Border.all(color: border),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppRadius.sm),
          child: child,
        ),
      ),
    );
  }
}

class _SystemListRow extends StatelessWidget {
  const _SystemListRow({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(AppRadius.sm),
              ),
              child: Icon(icon, color: theme.colorScheme.primary, size: 20),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleSmall,
                  ),
                  if (subtitle.isNotEmpty) ...[
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      subtitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (onTap != null) ...[
              const SizedBox(width: AppSpacing.sm),
              Icon(
                Icons.chevron_right,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _CountPill extends StatelessWidget {
  const _CountPill({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: Text(
        label,
        style: theme.textTheme.labelSmall?.copyWith(
          color: theme.colorScheme.primary,
        ),
      ),
    );
  }
}
