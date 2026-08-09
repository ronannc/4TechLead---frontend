import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:for_tech_lead/core/widgets/branding/app_logo.dart';
import 'package:for_tech_lead/core/widgets/navigation/app_page_header.dart';

void main() {
  testWidgets('renders the brand mark when enabled', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          appBar: AppPageHeader(
            subtitle: 'Painel',
            title: '4TechLead',
            showBrandMark: true,
            showNotifications: false,
          ),
        ),
      ),
    );

    expect(find.byType(AppLogoMark), findsOneWidget);
    expect(find.text('4TechLead'), findsOneWidget);
    expect(find.text('Painel'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
