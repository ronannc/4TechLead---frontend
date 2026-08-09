import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:for_tech_lead/core/widgets/cards/app_summary_card.dart';

void main() {
  testWidgets('renders two-line labels inside compact summary cards', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 168,
            height: 152,
            child: AppSummaryCard(
              icon: Icons.local_fire_department_outlined,
              value: '0%',
              label: 'Queimaram o tempo',
            ),
          ),
        ),
      ),
    );

    expect(tester.takeException(), isNull);
  });
}
