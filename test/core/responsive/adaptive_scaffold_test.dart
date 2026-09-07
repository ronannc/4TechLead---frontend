import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:for_tech_lead/core/responsive/adaptive_scaffold.dart';

void main() {
  const destinations = [
    AppNavDestination(
      label: 'Início',
      icon: Icons.dashboard_outlined,
      path: '/home',
    ),
    AppNavDestination(
      label: 'Times',
      icon: Icons.groups_outlined,
      path: '/teams',
    ),
    AppNavDestination(
      label: 'Notificações',
      icon: Icons.notifications_none,
      path: '/notifications',
      showInMobileBar: false,
    ),
    AppNavDestination(
      label: '1:1',
      icon: Icons.forum_outlined,
      path: '/one-on-ones',
    ),
    AppNavDestination(
      label: 'Integrações',
      icon: Icons.hub_outlined,
      path: '/integrations',
      showInMobileBar: false,
    ),
    AppNavDestination(
      label: 'Perfil',
      icon: Icons.person_outline,
      path: '/profile',
      showInMobileBar: false,
    ),
  ];

  tearDown(() {
    final binding = TestWidgetsFlutterBinding.ensureInitialized();
    binding.platformDispatcher.views.single
      ..resetPhysicalSize()
      ..resetDevicePixelRatio();
  });

  Future<void> pumpScaffold(
    WidgetTester tester, {
    required Size size,
    required int selectedIndex,
    required ValueChanged<int> onDestinationSelected,
  }) async {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1;

    await tester.pumpWidget(
      MaterialApp(
        home: AdaptiveScaffold(
          destinations: destinations,
          selectedIndex: selectedIndex,
          onDestinationSelected: onDestinationSelected,
          child: const Center(child: Text('Conteúdo')),
        ),
      ),
    );
  }

  testWidgets('keeps mobile navigation compact and opens secondary items', (
    tester,
  ) async {
    int? selectedIndex;

    await pumpScaffold(
      tester,
      size: const Size(390, 844),
      selectedIndex: 0,
      onDestinationSelected: (index) => selectedIndex = index,
    );

    expect(find.text('Início'), findsOneWidget);
    expect(find.text('Times'), findsOneWidget);
    expect(find.text('1:1'), findsOneWidget);
    expect(find.text('Mais'), findsOneWidget);
    expect(find.text('Notificações'), findsNothing);
    expect(find.text('Integrações'), findsNothing);
    expect(find.text('Perfil'), findsNothing);

    await tester.tap(find.text('Mais'));
    await tester.pumpAndSettle();

    expect(find.text('Notificações'), findsOneWidget);
    expect(find.text('Integrações'), findsOneWidget);
    expect(find.text('Perfil'), findsOneWidget);

    await tester.tap(find.text('Integrações'));
    await tester.pumpAndSettle();

    expect(selectedIndex, 4);
  });

  testWidgets('selects more on mobile when the current route is secondary', (
    tester,
  ) async {
    await pumpScaffold(
      tester,
      size: const Size(390, 844),
      selectedIndex: 4,
      onDestinationSelected: (_) {},
    );

    final navigationBar = tester.widget<NavigationBar>(
      find.byType(NavigationBar),
    );

    expect(navigationBar.selectedIndex, 3);
  });

  testWidgets('keeps every destination visible on desktop rail', (
    tester,
  ) async {
    await pumpScaffold(
      tester,
      size: const Size(1280, 900),
      selectedIndex: 4,
      onDestinationSelected: (_) {},
    );

    expect(find.byType(NavigationRail), findsOneWidget);
    expect(find.text('Início'), findsOneWidget);
    expect(find.text('Times'), findsOneWidget);
    expect(find.text('Notificações'), findsOneWidget);
    expect(find.text('1:1'), findsOneWidget);
    expect(find.text('Integrações'), findsOneWidget);
    expect(find.text('Perfil'), findsOneWidget);
    expect(find.text('Mais'), findsNothing);
  });
}
