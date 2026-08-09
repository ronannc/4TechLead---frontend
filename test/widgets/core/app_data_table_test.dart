import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:for_tech_lead/core/theme/app_theme.dart';
import 'package:for_tech_lead/core/widgets/tables/app_data_table.dart';

void main() {
  testWidgets('renders the system list header, count, and tappable rows', (
    tester,
  ) async {
    String? tapped;

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light(),
        home: Scaffold(
          body: SizedBox(
            height: 420,
            child: AppDataTable<String>(
              title: 'Pessoas cadastradas',
              subtitle: 'Membros ativos',
              itemIcon: Icons.person_outline,
              itemCountLabel: (count) => '$count pessoas',
              items: const ['Ada Lovelace', 'Grace Hopper'],
              columns: [
                AppDataColumn(label: 'Nome', cellBuilder: (name) => name),
                AppDataColumn(
                  label: 'Cargo',
                  cellBuilder: (_) => 'Software Engineer',
                ),
              ],
              onSearchChanged: (_) {},
              onRowTap: (name) => tapped = name,
            ),
          ),
        ),
      ),
    );

    expect(find.text('Pessoas cadastradas'), findsOneWidget);
    expect(find.text('Membros ativos'), findsOneWidget);
    expect(find.text('2 pessoas'), findsOneWidget);
    expect(find.byIcon(Icons.person_outline), findsNWidgets(2));

    await tester.tap(find.text('Grace Hopper'));
    await tester.pump();

    expect(tapped, 'Grace Hopper');
  });

  testWidgets('can remove internal horizontal padding when embedded', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light(),
        home: Scaffold(
          body: SizedBox(
            width: 393,
            height: 420,
            child: AppDataTable<String>(
              title: 'Dailies passadas',
              contentPadding: EdgeInsets.zero,
              items: const ['9 de ago. de 2026 11:25'],
              columns: [
                AppDataColumn(label: 'Data', cellBuilder: (date) => date),
              ],
              onSearchChanged: (_) {},
            ),
          ),
        ),
      ),
    );

    expect(tester.getTopLeft(find.text('Dailies passadas')).dx, 0);
  });
}
