import 'package:flutter/material.dart';

import 'bootstrap.dart';
import 'core/auth/auth_session.dart';
import 'core/routing/app_router.dart';
import 'core/theme/app_theme.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'ForTechLead',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: ThemeMode.system,
      routerConfig: createAppRouter(getIt<AuthSession>()),
    );
  }
}
