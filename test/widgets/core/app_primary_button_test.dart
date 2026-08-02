import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/core/widgets/buttons/app_dialog_actions.dart';
import 'package:frontend/core/widgets/buttons/app_primary_button.dart';

void main() {
  testWidgets('invokes onPressed when tapped', (tester) async {
    var tapped = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AppPrimaryButton(label: 'Save', onPressed: () => tapped = true),
        ),
      ),
    );

    await tester.tap(find.text('Save'));
    await tester.pump();

    expect(tapped, isTrue);
  });

  testWidgets('shows a spinner and disables tapping while loading', (
    tester,
  ) async {
    var tapped = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AppPrimaryButton(
            label: 'Save',
            loading: true,
            onPressed: () => tapped = true,
          ),
        ),
      ),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.text('Save'), findsNothing);

    final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
    expect(button.onPressed, isNull);

    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();

    expect(tapped, isFalse);
  });

  testWidgets('secondary button uses an outlined style', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AppSecondaryButton(label: 'Cancel', onPressed: () {}),
        ),
      ),
    );

    expect(find.byType(OutlinedButton), findsOneWidget);
    expect(find.text('Cancel'), findsOneWidget);
  });

  testWidgets('dialog actions keep the primary action on the right', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AppDialogActions(
            secondaryLabel: 'Cancelar',
            onSecondaryPressed: () {},
            primaryLabel: 'Salvar',
            onPrimaryPressed: () {},
          ),
        ),
      ),
    );

    final cancelCenter = tester.getCenter(find.text('Cancelar'));
    final saveCenter = tester.getCenter(find.text('Salvar'));

    expect(cancelCenter.dx, lessThan(saveCenter.dx));
    expect(find.byType(OutlinedButton), findsOneWidget);
    expect(find.byType(ElevatedButton), findsOneWidget);
  });
}
