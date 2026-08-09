import 'package:get_it/get_it.dart';

import 'core/auth/auth_session.dart';
import 'core/feedback/daily_cue_player.dart';
import 'core/network/dio_client.dart';
import 'core/storage/token_storage.dart';
import 'features/auth/repositories/auth_repository.dart';
import 'features/auth/services/auth_service.dart';
import 'features/daily/repositories/daily_meeting_repository.dart';
import 'features/daily/services/daily_meeting_service.dart';
import 'features/integrations/repositories/integration_repository.dart';
import 'features/integrations/services/integration_service.dart';
import 'features/notifications/repositories/notification_repository.dart';
import 'features/notifications/services/notification_service.dart';
import 'features/people/repositories/person_growth_repository.dart';
import 'features/people/repositories/person_repository.dart';
import 'features/people/services/person_growth_service.dart';
import 'features/people/services/person_service.dart';
import 'features/teams/repositories/team_repository.dart';
import 'features/teams/services/team_service.dart';

final getIt = GetIt.instance;

/// Registers app-wide singletons (auth session, Dio client, Services,
/// Repositories) with [getIt]. ViewModels are NOT registered here —
/// they're created per-route via `ChangeNotifierProvider` instead, since
/// their lifecycle is scoped to a screen, not the whole app.
///
/// Async because [AuthSession.restore] must load any persisted token
/// *before* the first frame — otherwise the router's first redirect
/// decision (see `app_router.dart`) would incorrectly send a signed-in
/// user to `/login`.
Future<void> configureDependencies() async {
  getIt.registerLazySingleton<TokenStorage>(TokenStorage.new);

  final authSession = AuthSession(getIt<TokenStorage>());
  await authSession.restore();
  getIt.registerSingleton<AuthSession>(authSession);

  getIt.registerLazySingleton<DioClient>(() => DioClient(getIt<AuthSession>()));

  getIt.registerLazySingleton<AuthService>(
    () => AuthService(getIt<DioClient>()),
  );
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepository(getIt<AuthService>(), getIt<AuthSession>()),
  );

  getIt.registerLazySingleton<TeamService>(
    () => TeamService(getIt<DioClient>()),
  );
  getIt.registerLazySingleton<TeamRepository>(
    () => TeamRepository(getIt<TeamService>()),
  );

  getIt.registerLazySingleton<PersonService>(
    () => PersonService(getIt<DioClient>()),
  );
  getIt.registerLazySingleton<PersonRepository>(
    () => PersonRepository(getIt<PersonService>()),
  );
  getIt.registerLazySingleton<PersonGrowthService>(
    () => PersonGrowthService(getIt<DioClient>()),
  );
  getIt.registerLazySingleton<PersonGrowthRepository>(
    () => PersonGrowthRepository(getIt<PersonGrowthService>()),
  );

  getIt.registerLazySingleton<DailyMeetingService>(
    () => DailyMeetingService(getIt<DioClient>()),
  );
  getIt.registerLazySingleton<DailyMeetingRepository>(
    () => DailyMeetingRepository(getIt<DailyMeetingService>()),
  );

  getIt.registerLazySingleton<DailyCuePlayer>(DailyCuePlayer.new);

  getIt.registerLazySingleton<IntegrationService>(
    () => IntegrationService(getIt<DioClient>()),
  );
  getIt.registerLazySingleton<IntegrationRepository>(
    () => IntegrationRepository(getIt<IntegrationService>()),
  );

  getIt.registerLazySingleton<NotificationService>(
    () => NotificationService(getIt<DioClient>()),
  );
  getIt.registerLazySingleton<NotificationRepository>(
    () => NotificationRepository(getIt<NotificationService>()),
  );
}
