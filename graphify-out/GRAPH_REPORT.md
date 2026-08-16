# Graph Report - frontend  (2026-08-16)

## Corpus Check
- cluster-only mode — file stats not available

## Summary
- 2169 nodes · 3288 edges · 129 communities (123 shown, 6 thin omitted)
- Extraction: 100% EXTRACTED · 0% INFERRED · 0% AMBIGUOUS · INFERRED: 15 edges (avg confidence: 0.8)
- Token cost: 0 input · 0 output

## Graph Freshness
- Built from commit: `0a32b8fd`
- Run `git rev-parse HEAD` and compare to check if the graph is stale.
- Run `graphify update .` after code changes (no API cost).

## Community Hubs (Navigation)
- person_detail_body.dart
- daily_session_view_model.dart
- Win32Window
- integrations_screen.dart
- generate_daily_sounds.dart
- person_detail_body_layout_test.dart
- integration_models.dart
- person_growth_view_model.dart
- StatelessWidget
- person_growth_models.dart
- home_view_model_test.dart
- AppDelegate
- daily_running_body.dart
- app_data_table.dart
- integrations_view_model.dart
- notifications_screen.dart
- external_notification.dart
- app_colors.dart
- daily_running_body_test.dart
- profile_screen.dart
- daily_config_body.dart
- person.dart
- bootstrap.dart
- person_form.dart
- package:mocktail/mocktail.dart
- person_detail_screen.dart
- daily_history_view_model_test.dart
- team_members_section.dart
- my_application.cc
- daily_history_body.dart
- api_exception.dart
- route_paths.dart
- ../../../core/network/api_exception.dart
- BaseViewModel
- package:flutter_test/flutter_test.dart
- login_view_model_test.dart
- daily_session_screen.dart
- person_daily_section.dart
- daily_meeting_annotation.dart
- app_router.dart
- IconData
- app_text_field.dart
- daily_stats.dart
- daily_meeting_detail_body_test.dart
- team_detail_view_model.dart
- Mock
- daily_meeting_detail_body.dart
- home_body.dart
- integration_repository.dart
- person_growth_service.dart
- daily_session_view_model_test.dart
- package:flutter/material.dart
- teams_list_screen.dart
- daily_meeting_entry.dart
- person_growth_repository.dart
- daily_cue_player.dart
- package:dio/dio.dart
- adaptive_scaffold.dart
- VoidCallback
- daily_meeting.dart
- daily_history_view_model.dart
- home_view_model.dart
- app_typography.dart
- notifications_view_model.dart
- team.dart
- person_form_view_model.dart
- daily_config_body_test.dart
- login_form.dart
- app_logo.dart
- wWinMain
- logging_interceptor.dart
- auth_repository_test.dart
- auth_repository.dart
- register_form.dart
- package:for_tech_lead/core/viewmodels/base_view_model.dart
- app_theme.dart
- notifications_screen_test.dart
- daily_timer_ring.dart
- State
- manifest.json
- package:provider/provider.dart
- DateTime
- base_view_model.dart
- DailySessionViewModel
- daily_review_body.dart
- integration_service.dart
- PersonRepository
- app_dialog_actions.dart
- people_list_view_model.dart
- app.dart
- daily_meeting_detail_view_model.dart
- auth_session.dart
- static const
- List
- app_user.dart
- daily_meeting_repository.dart
- daily_time_limit.dart
- notifications_view_model_test.dart
- team_repository.dart
- teams_list_view_model.dart
- _
- token_storage.dart
- person_repository.dart
- person_service.dart
- app_theme_extension.dart
- int?
- breakpoints.dart
- app_spacing.dart
- notification_repository.dart
- team_service.dart
- daily_blocker_draft.dart
- birthday_util.dart
- notification_repository_test.dart
- DailyEntryStatus
- contract_type.dart
- seniority_level.dart
- PersonFormViewModel
- PersonGrowthViewModel
- MainActivity.kt
- AppThemeExtension
- daily_cue.dart
- DailySessionPhase
- DailyMeetingService
- @example
- String?

## God Nodes (most connected - your core abstractions)
1. `PersonRepository` - 29 edges
2. `Win32Window` - 22 edges
3. `DailySessionViewModel` - 22 edges
4. `TeamRepository` - 19 edges
5. `BaseViewModel` - 18 edges
6. `DailyMeetingRepository` - 14 edges
7. `MessageHandler` - 12 edges
8. `AppThemeExtension` - 11 edges
9. `AuthRepository` - 11 edges
10. `Person` - 11 edges

## Surprising Connections (you probably didn't know these)
- `_MockPersonRepository` --implements--> `PersonRepository`  [EXTRACTED]
  test/features/integrations/screens/integrations_screen_test.dart → lib/features/people/repositories/person_repository.dart
- `_MockPersonRepository` --implements--> `PersonRepository`  [EXTRACTED]
  test/features/integrations/viewmodels/integrations_view_model_test.dart → lib/features/people/repositories/person_repository.dart
- `Win32Window::Win32Window()` --calls--> `Destroy`  [INFERRED]
  windows/runner/win32_window.cpp → windows/runner/win32_window.h
- `wWinMain()` --calls--> `CreateAndAttachConsole()`  [INFERRED]
  windows/runner/main.cpp → windows/runner/utils.cpp
- `_MockPersonRepository` --implements--> `PersonRepository`  [EXTRACTED]
  test/features/home/screens/home_body_test.dart → lib/features/people/repositories/person_repository.dart

## Import Cycles
- None detected.

## Communities (129 total, 6 thin omitted)

### Community 0 - "person_detail_body.dart"
Cohesion: 0.02
Nodes (92): ../../daily/screens/person_daily_section.dart, Iterable, actionErrorMessage, _availableWidth, build, child, children, _closeFocusedFlow (+84 more)

### Community 1 - "daily_session_view_model.dart"
Cohesion: 0.03
Nodes (57): DailySessionPhase get, DailyTurnDraft? get, addTopic, _beginCurrentTurn, _blockers, clearCue, clearSelection, cue (+49 more)

### Community 2 - "Win32Window"
Cohesion: 0.07
Nodes (51): Point, RECT, Size, unique_ptr, DartProject, HWND, LPARAM, LRESULT (+43 more)

### Community 3 - "integrations_screen.dart"
Cohesion: 0.04
Nodes (54): _ActionErrorBanner, build, child, children, _confirmTokenRegeneration, createState, _descriptionController, dispose (+46 more)

### Community 4 - "generate_daily_sounds.dart"
Cohesion: 0.04
Nodes (49): dart:io, dart:math, dart:typed_data, required double decay,
  double, required double durationSeconds,
  double, required double releaseSeconds,
  double, bitsPerSample, blockAlign (+41 more)

### Community 5 - "person_detail_body_layout_test.dart"
Cohesion: 0.04
Nodes (47): class _MockPersonGrowthRepository extends, PersonGrowthRepository, package:for_tech_lead/core/responsive/adaptive_scaffold.dart, package:for_tech_lead/features/people/models/person_growth_models.dart, package:for_tech_lead/features/people/repositories/person_growth_repository.dart, package:for_tech_lead/features/people/screens/person_detail_body.dart, package:for_tech_lead/features/people/screens/person_detail_screen.dart, package:for_tech_lead/features/people/services/person_growth_service.dart (+39 more)

### Community 6 - "integration_models.dart"
Cohesion: 0.06
Nodes (38): Equatable, DailyMeetingAnnotation, DailyMeetingEntry, DailyPersonRanking, active, currentPage, _date, DeliveryMetricsPage (+30 more)

### Community 7 - "person_growth_view_model.dart"
Cohesion: 0.05
Nodes (38): actionErrorMessage, clearActionError, createPlan, createPlanItem, createSession, createTemplate, deliveryMetrics, _ensureMetrics (+30 more)

### Community 8 - "StatelessWidget"
Cohesion: 0.05
Nodes (38): AppPageHeader, _EmptyPanel, _GeneratedCodeHint, _InlinePagination, _IntegrationTabBar, _SectionStack, _SectionTitle, _ActionErrorBanner (+30 more)

### Community 9 - "person_growth_models.dart"
Cohesion: 0.05
Nodes (37): actionItems, active, competency, _date, description, DevelopmentPlan, developmentPlanId, DevelopmentPlanItem (+29 more)

### Community 10 - "home_view_model_test.dart"
Cohesion: 0.08
Nodes (31): _MockPersonRepository, package:for_tech_lead/features/home/screens/home_body.dart, package:for_tech_lead/features/home/viewmodels/home_view_model.dart, package:for_tech_lead/features/people/models/contract_type.dart, package:for_tech_lead/features/people/models/person.dart, package:for_tech_lead/features/people/models/seniority_level.dart, package:for_tech_lead/features/people/repositories/person_repository.dart, package:for_tech_lead/features/people/services/person_service.dart (+23 more)

### Community 11 - "AppDelegate"
Cohesion: 0.07
Nodes (23): Any, Cocoa, Flutter, FlutterAppDelegate, FlutterImplicitEngineBridge, FlutterImplicitEngineDelegate, FlutterMacOS, FlutterSceneDelegate (+15 more)

### Community 12 - "daily_running_body.dart"
Cohesion: 0.06
Nodes (34): daily_timer_ring.dart, addTooltip, allowedSeconds, _AnnotationComposer, _annotationController, _annotationKind, blockers, controller (+26 more)

### Community 13 - "app_data_table.dart"
Cohesion: 0.06
Nodes (33): dart:async, EdgeInsets, ../inputs/app_search_field.dart, AppDataColumn, build, _buildList, _buildTable, child (+25 more)

### Community 14 - "integrations_view_model.dart"
Cohesion: 0.06
Nodes (33): actionErrorMessage, changeIdentitiesPage, changeMetricsPage, changeSystemsPage, clearActionError, createExternalIdentity, createSystem, identities (+25 more)

### Community 15 - "notifications_screen.dart"
Cohesion: 0.06
Nodes (31): ../../../core/theme/app_radius.dart, ../../../core/widgets/states/empty_view.dart, build, color, colors, day, _formatDate, hour (+23 more)

### Community 16 - "external_notification.dart"
Cohesion: 0.06
Nodes (31): DateTime? get, createdAt, currentPage, _date, detailsPayload, displayDate, eventId, fromJson (+23 more)

### Community 17 - "app_colors.dart"
Cohesion: 0.06
Nodes (31): accent, accentDark, AppColors, background, backgroundDark, border, borderDark, error (+23 more)

### Community 18 - "daily_running_body_test.dart"
Cohesion: 0.09
Nodes (21): package:for_tech_lead/core/theme/app_spacing.dart, package:for_tech_lead/features/daily/repositories/daily_meeting_repository.dart, package:for_tech_lead/features/daily/screens/daily_running_body.dart, package:for_tech_lead/features/daily/screens/daily_timer_ring.dart, package:for_tech_lead/features/daily/services/daily_meeting_service.dart, return, _entryJson, main (+13 more)

### Community 19 - "profile_screen.dart"
Cohesion: 0.14
Nodes (15): AppUser? get, ../../auth/models/app_user.dart, ../../auth/repositories/auth_repository.dart, ../../../core/widgets/states/loading_view.dart, AppUser, build, _ProfileBody, ProfileScreen (+7 more)

### Community 20 - "daily_config_body.dart"
Cohesion: 0.08
Nodes (25): ../../../core/widgets/inputs/app_search_field.dart, canDrag, canReorder, _ConfigHeader, createState, _dailyConfigInnerGap, _dailyConfigOuterGap, dispose (+17 more)

### Community 21 - "person.dart"
Cohesion: 0.08
Nodes (24): contract_type.dart, admissionDate, age, averageActualSeconds, birthDate, burnedPercentage, contractType, createdAt (+16 more)

### Community 22 - "bootstrap.dart"
Cohesion: 0.07
Nodes (26): core/storage/token_storage.dart, features/auth/repositories/auth_repository.dart, features/auth/services/auth_service.dart, features/daily/repositories/daily_meeting_repository.dart, features/daily/services/daily_meeting_service.dart, features/integrations/repositories/integration_repository.dart, features/integrations/services/integration_service.dart, features/notifications/repositories/notification_repository.dart (+18 more)

### Community 23 - "person_form.dart"
Cohesion: 0.08
Nodes (24): ../../../core/widgets/inputs/app_date_field.dart, ../../../core/widgets/inputs/app_dropdown_field.dart, _admissionDate, _admissionDateError, _birthDate, _birthDateError, _contractType, _contractTypeError (+16 more)

### Community 24 - "package:mocktail/mocktail.dart"
Cohesion: 0.09
Nodes (22): class _MockIntegrationRepository extends, _MockIntegrationRepository, package:for_tech_lead/features/integrations/models/integration_models.dart, package:for_tech_lead/features/integrations/repositories/integration_repository.dart, package:for_tech_lead/features/integrations/screens/integrations_screen.dart, package:for_tech_lead/features/integrations/services/integration_service.dart, package:for_tech_lead/features/integrations/viewmodels/integrations_view_model.dart, package:mocktail/mocktail.dart (+14 more)

### Community 25 - "person_detail_screen.dart"
Cohesion: 0.10
Nodes (20): app.dart, bootstrap.dart, ../../../core/widgets/navigation/app_page_header.dart, build, PersonDetailScreen, personId, build, PersonFormScreen (+12 more)

### Community 26 - "daily_history_view_model_test.dart"
Cohesion: 0.09
Nodes (21): class _MockDailyMeetingRepository extends, _MockDailyMeetingRepository, package:for_tech_lead/features/daily/models/daily_entry_status.dart, package:for_tech_lead/features/daily/models/daily_meeting.dart, package:for_tech_lead/features/daily/models/daily_meeting_entry.dart, package:for_tech_lead/features/daily/utils/daily_stats.dart, package:for_tech_lead/features/daily/viewmodels/daily_history_view_model.dart, actualSeconds (+13 more)

### Community 27 - "team_members_section.dart"
Cohesion: 0.11
Nodes (20): ../../../core/routing/route_paths.dart, ../../../core/widgets/buttons/app_primary_button.dart, TeamDetailBody, build, TeamDetailScreen, teamId, build, _InlinePagination (+12 more)

### Community 28 - "my_application.cc"
Cohesion: 0.11
Nodes (20): FlView, GApplication, gboolean, gchar, GObject, GtkApplication, main(), first_frame_cb() (+12 more)

### Community 29 - "daily_history_body.dart"
Cohesion: 0.12
Nodes (20): ../../../core/widgets/cards/app_summary_card.dart, daily_history_body.dart, build, createState, DailyHistoryBody, _DailyHistoryBodyState, _dateFormat, _HistorySummaryCard (+12 more)

### Community 30 - "api_exception.dart"
Cohesion: 0.14
Nodes (20): Exception, ApiException, bodyMessage, data, errors, _firstMessage, ForbiddenException, mapDioException (+12 more)

### Community 31 - "route_paths.dart"
Cohesion: 0.10
Nodes (20): dailyHistory, dailyHistoryPath, dailyMeetingDetail, dailyMeetingDetailPath, dailySession, dailySessionPath, home, integrations (+12 more)

### Community 32 - "../../../core/network/api_exception.dart"
Cohesion: 0.13
Nodes (16): ../../../core/network/api_exception.dart, core/network/dio_client.dart, DioClient, _client, login, logout, me, register (+8 more)

### Community 33 - "BaseViewModel"
Cohesion: 0.13
Nodes (17): ../../../core/widgets/states/error_view.dart, daily_meeting_detail_body.dart, home_body.dart, BaseViewModel, build, DailyMeetingDetailScreen, meetingId, DailyMeetingDetailViewModel (+9 more)

### Community 34 - "package:flutter_test/flutter_test.dart"
Cohesion: 0.11
Nodes (14): ElevatedButton, package:flutter_test/flutter_test.dart, package:for_tech_lead/core/widgets/branding/app_logo.dart, package:for_tech_lead/core/widgets/buttons/app_dialog_actions.dart, package:for_tech_lead/core/widgets/buttons/app_primary_button.dart, package:for_tech_lead/core/widgets/cards/app_summary_card.dart, package:for_tech_lead/core/widgets/navigation/app_page_header.dart, package:for_tech_lead/features/daily/utils/daily_time_limit.dart (+6 more)

### Community 35 - "login_view_model_test.dart"
Cohesion: 0.12
Nodes (16): _MockAuthRepository, package:for_tech_lead/core/network/api_exception.dart, package:for_tech_lead/features/auth/models/app_user.dart, package:for_tech_lead/features/auth/repositories/auth_repository.dart, package:for_tech_lead/features/auth/viewmodels/login_view_model.dart, package:for_tech_lead/features/auth/viewmodels/register_view_model.dart, package:for_tech_lead/features/teams/services/team_service.dart, main (+8 more)

### Community 36 - "daily_session_screen.dart"
Cohesion: 0.11
Nodes (17): core/feedback/daily_cue_player.dart, daily_config_body.dart, daily_review_body.dart, daily_running_body.dart, _confirmExit, createState, _cuePlayer, _DailyFinishedBody (+9 more)

### Community 37 - "person_daily_section.dart"
Cohesion: 0.12
Nodes (16): ../../../core/widgets/data/app_key_value_row.dart, build, _DailyStatsContent, _historyLink, PersonDailySection, stats, teamId, setStats (+8 more)

### Community 38 - "daily_meeting_annotation.dart"
Cohesion: 0.11
Nodes (16): daily_annotation_type.dart, apiValue, DailyAnnotationType, fromApiValue, label, createdAt, dailyMeetingId, fromJson (+8 more)

### Community 39 - "app_router.dart"
Cohesion: 0.11
Nodes (17): ../../features/auth/screens/login_screen.dart, ../../features/auth/screens/register_screen.dart, ../../features/daily/screens/daily_history_screen.dart, ../../features/daily/screens/daily_meeting_detail_screen.dart, ../../features/daily/screens/daily_session_screen.dart, ../../features/home/screens/home_screen.dart, ../../features/integrations/screens/integrations_screen.dart, ../../features/notifications/screens/notifications_screen.dart (+9 more)

### Community 40 - "IconData"
Cohesion: 0.12
Nodes (15): IconData, AppSummaryCard, build, icon, label, value, AppKeyValueRow, build (+7 more)

### Community 41 - "app_text_field.dart"
Cohesion: 0.12
Nodes (16): AppSearchField, build, controller, hintText, onChanged, AppTextField, build, controller (+8 more)

### Community 42 - "daily_stats.dart"
Cohesion: 0.11
Nodes (17): averageActualSeconds, burnedPercentage, byPerson, computeDailyStatsSummary, computeDraftStatus, countWithStatus, dailySpokeTooLittleRatio, empty (+9 more)

### Community 43 - "daily_meeting_detail_body_test.dart"
Cohesion: 0.11
Nodes (17): package:for_tech_lead/features/daily/models/daily_annotation_type.dart, package:for_tech_lead/features/daily/models/daily_meeting_annotation.dart, package:for_tech_lead/features/daily/screens/daily_meeting_detail_body.dart, package:for_tech_lead/features/daily/viewmodels/daily_meeting_detail_view_model.dart, required String text,
  bool, _annotation, endedAt, _entry (+9 more)

### Community 44 - "team_detail_view_model.dart"
Cohesion: 0.12
Nodes (16): changeMembersPage, hasMembers, isChangingMembersPage, load, members, membersErrorMessage, membersLastPage, membersPage (+8 more)

### Community 45 - "Mock"
Cohesion: 0.22
Nodes (16): DailyMeetingRepository, TeamRepository, Mock, _MockDailyMeetingRepository, _MockTeamRepository, _MockDailyMeetingRepository, _MockDailyMeetingRepository, _MockTeamRepository (+8 more)

### Community 46 - "daily_meeting_detail_body.dart"
Cohesion: 0.12
Nodes (15): annotations, _AnnotationsSection, build, DailyMeetingDetailBody, _dateFormat, entries, _EntriesList, entry (+7 more)

### Community 47 - "home_body.dart"
Cohesion: 0.12
Nodes (15): _BirthdayCard, _DailyCallout, _daysUntilLabel, HomeBody, _homeInnerGap, _homeOuterGap, _initials, parts (+7 more)

### Community 48 - "integration_repository.dart"
Cohesion: 0.12
Nodes (15): createExternalIdentity, createSystem, getDeliveryMetrics, getExternalIdentities, getSystems, IntegrationRepository, regenerateSystemToken, _service (+7 more)

### Community 49 - "person_growth_service.dart"
Cohesion: 0.12
Nodes (15): _client, createDevelopmentPlan, createDevelopmentPlanItem, createSession, createTemplate, _dateFormat, _get, getDeliveryMetrics (+7 more)

### Community 50 - "daily_session_view_model_test.dart"
Cohesion: 0.12
Nodes (14): package:fake_async/fake_async.dart, package:for_tech_lead/core/feedback/daily_cue_sound_theme.dart, package:for_tech_lead/features/daily/models/daily_cue.dart, package:for_tech_lead/features/daily/models/daily_session_phase.dart, package:for_tech_lead/features/daily/viewmodels/daily_session_view_model.dart, main, main, meetingRepository (+6 more)

### Community 51 - "package:flutter/material.dart"
Cohesion: 0.13
Nodes (13): ../branding/app_logo.dart, build, preferredSize, showBrandMark, showNotifications, subtitle, title, build (+5 more)

### Community 52 - "teams_list_screen.dart"
Cohesion: 0.19
Nodes (13): ../../../core/widgets/buttons/app_dialog_actions.dart, ../../../core/widgets/tables/app_data_table.dart, build, _createdAtFormat, TeamsListBody, build, _showCreateDialog, TeamsListScreen (+5 more)

### Community 53 - "daily_meeting_entry.dart"
Cohesion: 0.13
Nodes (14): daily_entry_status.dart, actualSeconds, allottedSeconds, createdAt, dailyMeetingId, fromJson, id, person (+6 more)

### Community 54 - "person_growth_repository.dart"
Cohesion: 0.13
Nodes (14): ../../integrations/models/integration_models.dart, createDevelopmentPlan, createDevelopmentPlanItem, createSession, createTemplate, getDeliveryMetrics, getDevelopmentPlans, getSessions (+6 more)

### Community 55 - "daily_cue_player.dart"
Cohesion: 0.14
Nodes (13): AudioPlayer, daily_cue_sound_theme.dart, _cuePlayer, DailyCuePlayer, dispose, _hapticByCue, _isTicking, play (+5 more)

### Community 56 - "package:dio/dio.dart"
Cohesion: 0.15
Nodes (12): ../auth/auth_session.dart, auth_interceptor.dart, ../config/env.dart, Dio, Dio get, _authSession, onError, onRequest (+4 more)

### Community 57 - "adaptive_scaffold.dart"
Cohesion: 0.14
Nodes (13): breakpoints.dart, AdaptiveScaffold, AppNavDestination, build, child, destinations, _hasNav, icon (+5 more)

### Community 58 - "VoidCallback"
Cohesion: 0.14
Nodes (12): ../buttons/app_primary_button.dart, AppPrimaryButton, AppSecondaryButton, build, label, loading, onPressed, build (+4 more)

### Community 59 - "daily_meeting.dart"
Cohesion: 0.14
Nodes (13): daily_meeting_annotation.dart, daily_meeting_entry.dart, annotations, createdAt, endedAt, entries, fromJson, id (+5 more)

### Community 60 - "daily_history_view_model.dart"
Cohesion: 0.14
Nodes (13): DailyStatsSummary get, DailyStatsSummary, load, _meetings, _namesByPersonId, personName, _personRepository, _rankings (+5 more)

### Community 61 - "home_view_model.dart"
Cohesion: 0.14
Nodes (13): int get, firstTeamId, load, _peopleCount, _personRepository, _teamRepository, _teams, _teamsCount (+5 more)

### Community 62 - "app_typography.dart"
Cohesion: 0.14
Nodes (13): AppTypography, bodyLarge, bodyMedium, bodySmall, displaySmall, _inter, labelLarge, labelMedium (+5 more)

### Community 63 - "notifications_view_model.dart"
Cohesion: 0.14
Nodes (13): changePage, clearPageError, isChangingPage, lastPage, load, _loadPage, notifications, page (+5 more)

### Community 64 - "team.dart"
Cohesion: 0.14
Nodes (13): createdAt, fromJson, id, name, people, peopleLastPage, peoplePage, peoplePerPage (+5 more)

### Community 65 - "person_form_view_model.dart"
Cohesion: 0.18
Nodes (11): Person, load, _person, personId, _repository, _created, createPerson, _repository (+3 more)

### Community 66 - "daily_config_body_test.dart"
Cohesion: 0.12
Nodes (15): package:for_tech_lead/core/theme/app_theme.dart, package:for_tech_lead/core/widgets/tables/app_data_table.dart, package:for_tech_lead/features/daily/screens/daily_config_body.dart, build, main, meetingRepository, Mock, _person (+7 more)

### Community 67 - "login_form.dart"
Cohesion: 0.20
Nodes (11): ../../../core/widgets/branding/app_logo.dart, ../../../core/widgets/inputs/app_text_field.dart, build, createState, dispose, _emailController, _LoginFormState, _passwordController (+3 more)

### Community 68 - "app_logo.dart"
Cohesion: 0.17
Nodes (11): CustomPainter, AppLogo, AppLogoMark, _AppLogoMarkPainter, build, markSize, paint, shouldRepaint (+3 more)

### Community 69 - "wWinMain"
Cohesion: 0.24
Nodes (9): _In_, _In_opt_, vector, wWinMain(), string, wchar_t, CreateAndAttachConsole(), GetCommandLineArguments() (+1 more)

### Community 70 - "logging_interceptor.dart"
Cohesion: 0.17
Nodes (11): Interceptor, AuthInterceptor, AppLoggingInterceptor, _logger, onError, onRequest, onResponse, _redact (+3 more)

### Community 71 - "auth_repository_test.dart"
Cohesion: 0.17
Nodes (11): TokenStorage, package:for_tech_lead/core/auth/auth_session.dart, package:for_tech_lead/core/storage/token_storage.dart, package:for_tech_lead/features/auth/services/auth_service.dart, authSession, main, _MockTokenStorage, repository (+3 more)

### Community 72 - "auth_repository.dart"
Cohesion: 0.17
Nodes (11): _authSession, login, logout, me, register, _service, _signInFromResponse, AuthService (+3 more)

### Community 73 - "register_form.dart"
Cohesion: 0.21
Nodes (11): build, createState, dispose, _emailController, _nameController, _passwordConfirmationController, _passwordController, RegisterForm (+3 more)

### Community 74 - "package:for_tech_lead/core/viewmodels/base_view_model.dart"
Cohesion: 0.12
Nodes (18): _MockTeamRepository, package:for_tech_lead/core/viewmodels/base_view_model.dart, package:for_tech_lead/features/daily/viewmodels/person_daily_stats_view_model.dart, package:for_tech_lead/features/teams/models/team.dart, package:for_tech_lead/features/teams/repositories/team_repository.dart, package:for_tech_lead/features/teams/screens/team_detail_body.dart, package:for_tech_lead/features/teams/screens/teams_list_body.dart, package:for_tech_lead/features/teams/viewmodels/team_detail_view_model.dart (+10 more)

### Community 75 - "app_theme.dart"
Cohesion: 0.18
Nodes (10): app_colors.dart, app_radius.dart, app_spacing.dart, app_theme_extension.dart, app_typography.dart, AppTheme, _build, dark (+2 more)

### Community 76 - "notifications_screen_test.dart"
Cohesion: 0.20
Nodes (10): class _MockNotificationRepository extends, NotificationRepository, package:for_tech_lead/bootstrap.dart, package:for_tech_lead/features/notifications/models/external_notification.dart, package:for_tech_lead/features/notifications/screens/notifications_screen.dart, main, Mock, _MockNotificationRepository (+2 more)

### Community 77 - "daily_timer_ring.dart"
Cohesion: 0.18
Nodes (10): ../../../core/theme/app_theme_extension.dart, allowedSeconds, build, _dailyTimerMaxDiameter, _dailyTimerOuterPadding, DailyTimerRing, _dailyTimerStrokeWidth, elapsedSeconds (+2 more)

### Community 78 - "State"
Cohesion: 0.24
Nodes (11): AppDataTable, _AppDataTableState, LoginForm, DailyConfigBody, _DailyConfigBodyState, DailyRunningBody, _DailyRunningBodyState, _DailySessionView (+3 more)

### Community 79 - "manifest.json"
Cohesion: 0.18
Nodes (10): background_color, description, display, icons, name, orientation, prefer_related_applications, short_name (+2 more)

### Community 80 - "package:provider/provider.dart"
Cohesion: 0.12
Nodes (17): ../../../core/theme/app_spacing.dart, ../../../core/viewmodels/base_view_model.dart, AuthRepository, build, LoginScreen, build, RegisterScreen, login (+9 more)

### Community 81 - "DateTime"
Cohesion: 0.20
Nodes (9): DateTime, AppDateField, build, errorText, firstDate, label, lastDate, onChanged (+1 more)

### Community 82 - "base_view_model.dart"
Cohesion: 0.20
Nodes (9): _errorMessage, hasError, isLoading, runCatching, setState, _state, ViewState, ../network/api_exception.dart (+1 more)

### Community 83 - "DailySessionViewModel"
Cohesion: 0.20
Nodes (10): build, _PeoplePicker, _TeamSelector, _TimeLimitControl, _AnnotationList, build, _LiveHeader, build (+2 more)

### Community 84 - "daily_review_body.dart"
Cohesion: 0.20
Nodes (9): blockers, _BlockersReview, build, DailyReviewBody, topics, _TopicsReview, ../models/daily_blocker_draft.dart, ../utils/daily_stats.dart (+1 more)

### Community 85 - "integration_service.dart"
Cohesion: 0.20
Nodes (9): _client, createExternalIdentity, createSystem, _get, getDeliveryMetrics, getExternalIdentities, getSystems, _post (+1 more)

### Community 86 - "PersonRepository"
Cohesion: 0.20
Nodes (10): PersonRepository, _MockPersonRepository, _MockPersonRepository, _MockPersonRepository, _MockPersonRepository, _MockPersonRepository, _MockPersonRepository, _MockPersonRepository (+2 more)

### Community 87 - "app_dialog_actions.dart"
Cohesion: 0.22
Nodes (8): app_primary_button.dart, AppDialogActions, build, onPrimaryPressed, onSecondaryPressed, primaryLabel, primaryLoading, secondaryLabel

### Community 88 - "people_list_view_model.dart"
Cohesion: 0.22
Nodes (8): bool get, hasPeople, load, _people, _query, _repository, search, teamId

### Community 89 - "app.dart"
Cohesion: 0.22
Nodes (8): ChangeNotifier, core/auth/auth_session.dart, core/routing/app_router.dart, core/theme/app_theme.dart, App, build, AuthSession, package:flutter_localizations/flutter_localizations.dart

### Community 90 - "daily_meeting_detail_view_model.dart"
Cohesion: 0.22
Nodes (8): DailyMeeting? get, DailyMeeting, load, _meeting, meetingId, _repository, ../models/daily_meeting.dart, ../repositories/daily_meeting_repository.dart

### Community 91 - "auth_session.dart"
Cohesion: 0.22
Nodes (8): isAuthenticated, restore, signIn, signOut, _token, _tokenStorage, ../storage/token_storage.dart, String get

### Community 92 - "static const"
Cohesion: 0.22
Nodes (7): apiBaseUrl, Env, AppRadius, lg, md, sm, static const

### Community 93 - "List"
Cohesion: 0.22
Nodes (8): AppDropdownField, build, errorText, items, label, onChanged, value, List

### Community 94 - "app_user.dart"
Cohesion: 0.22
Nodes (8): createdAt, email, fromJson, id, name, props, toJson, package:equatable/equatable.dart

### Community 95 - "daily_meeting_repository.dart"
Cohesion: 0.22
Nodes (8): createMeeting, getAllEntries, getMeeting, getMeetings, _maxStatsPages, _service, ../models/daily_meeting_entry.dart, ../services/daily_meeting_service.dart

### Community 96 - "daily_time_limit.dart"
Cohesion: 0.22
Nodes (8): dailyTimeLimitMinSeconds, dailyTimeLimitStepSeconds, formatDailyDuration, isValidDailyTimeLimit, minutes, remainingSeconds, seconds, sign

### Community 97 - "notifications_view_model_test.dart"
Cohesion: 0.22
Nodes (8): NotificationsViewModel, _MockNotificationRepository, package:for_tech_lead/features/notifications/viewmodels/notifications_view_model.dart, main, Mock, _notification, repository, viewModel

### Community 98 - "team_repository.dart"
Cohesion: 0.22
Nodes (8): createTeam, deleteTeam, getTeam, getTeams, _service, updateTeam, ../models/team.dart, ../services/team_service.dart

### Community 99 - "teams_list_view_model.dart"
Cohesion: 0.22
Nodes (8): createTeam, hasTeams, load, _query, _repository, search, _teams, ../repositories/team_repository.dart

### Community 100 - "_"
Cohesion: 0.29
Nodes (8): ../../features/daily/models/daily_cue.dart, _, assetPath, byCue, DailyCueSound, DailyCueSoundTheme, ticking, volume

### Community 101 - "token_storage.dart"
Cohesion: 0.25
Nodes (7): FlutterSecureStorage, delete, read, _storage, _tokenKey, write, package:flutter_secure_storage/flutter_secure_storage.dart

### Community 102 - "person_repository.dart"
Cohesion: 0.25
Nodes (7): createPerson, getPeople, getPerson, _service, ../models/contract_type.dart, ../models/seniority_level.dart, ../services/person_service.dart

### Community 103 - "person_service.dart"
Cohesion: 0.25
Nodes (7): _client, _dateFormat, index, show, store, package:intl/intl.dart, static final

### Community 105 - "app_theme_extension.dart"
Cohesion: 0.29
Nodes (6): Color, border, copyWith, lerp, success, warning

### Community 106 - "int?"
Cohesion: 0.29
Nodes (6): int?, actualSeconds, allowedSeconds, DailyTurnDraft, hasSpoken, person

### Community 107 - "breakpoints.dart"
Cohesion: 0.29
Nodes (6): Breakpoints, isDesktop, isMobile, mobile, tablet, package:flutter/widgets.dart

### Community 108 - "app_spacing.dart"
Cohesion: 0.29
Nodes (6): AppSpacing, lg, md, sm, xl, xs

### Community 109 - "notification_repository.dart"
Cohesion: 0.29
Nodes (6): getNotifications, _service, NotificationService, ../models/external_notification.dart, ../services/notification_service.dart, _MockNotificationService

### Community 110 - "team_service.dart"
Cohesion: 0.29
Nodes (6): _client, destroy, index, show, store, update

### Community 111 - "daily_blocker_draft.dart"
Cohesion: 0.33
Nodes (5): DailyBlockerDraft, resolved, text, toggleResolved, addBlocker

### Community 112 - "birthday_util.dart"
Cohesion: 0.33
Nodes (5): _dateOnly, daysUntilNextBirthday, difference, next, today

### Community 113 - "notification_repository_test.dart"
Cohesion: 0.33
Nodes (5): package:for_tech_lead/features/notifications/repositories/notification_repository.dart, package:for_tech_lead/features/notifications/services/notification_service.dart, main, repository, service

### Community 114 - "DailyEntryStatus"
Cohesion: 0.40
Nodes (4): apiValue, DailyEntryStatus, fromApiValue, label

### Community 115 - "contract_type.dart"
Cohesion: 0.40
Nodes (4): apiValue, ContractType, fromApiValue, label

### Community 116 - "seniority_level.dart"
Cohesion: 0.40
Nodes (4): apiValue, fromApiValue, label, SeniorityLevel

### Community 117 - "PersonFormViewModel"
Cohesion: 0.40
Nodes (5): build, PersonForm, _PersonFormState, _submit, PersonFormViewModel

### Community 118 - "PersonGrowthViewModel"
Cohesion: 0.50
Nodes (4): _openFocusedFlow, PersonDetailBody, _PersonDetailBodyState, PersonGrowthViewModel

### Community 120 - "AppThemeExtension"
Cohesion: 1.00
Nodes (3): @immutable, AppThemeExtension, ThemeExtension

## Knowledge Gaps
- **1278 isolated node(s):** `actionErrorMessage`, `_availableWidth`, `build`, `child`, `children` (+1273 more)
  These have ≤1 connection - possible missing edges or undocumented components.
- **6 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `PersonRepository` connect `PersonRepository` to `daily_session_view_model.dart`, `BaseViewModel`, `integrations_screen.dart`, `daily_session_screen.dart`, `person_form_view_model.dart`, `person_repository.dart`, `person_detail_body_layout_test.dart`, `home_view_model_test.dart`, `integrations_view_model.dart`, `home_view_model.dart`, `bootstrap.dart`, `people_list_view_model.dart`, `person_detail_screen.dart`, `daily_history_view_model.dart`, `daily_history_body.dart`, `package:mocktail/mocktail.dart`?**
  _High betweenness centrality (0.032) - this node is a cross-community bridge._
- **Why does `TeamRepository` connect `Mock` to `daily_session_view_model.dart`, `BaseViewModel`, `team_repository.dart`, `daily_session_screen.dart`, `teams_list_view_model.dart`, `login_view_model_test.dart`, `team_detail_view_model.dart`, `teams_list_screen.dart`, `bootstrap.dart`, `team_members_section.dart`, `home_view_model.dart`?**
  _High betweenness centrality (0.017) - this node is a cross-community bridge._
- **Why does `AppThemeExtension` connect `AppThemeExtension` to `app_theme_extension.dart`, `daily_running_body.dart`, `app_data_table.dart`, `daily_meeting_detail_body.dart`, `daily_timer_ring.dart`, `daily_config_body.dart`, `daily_review_body.dart`?**
  _High betweenness centrality (0.013) - this node is a cross-community bridge._
- **What connects `actionErrorMessage`, `_availableWidth`, `build` to the rest of the system?**
  _1278 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Should `person_detail_body.dart` be split into smaller, more focused modules?**
  _Cohesion score 0.021505376344086023 - nodes in this community are weakly interconnected._
- **Should `daily_session_view_model.dart` be split into smaller, more focused modules?**
  _Cohesion score 0.034482758620689655 - nodes in this community are weakly interconnected._
- **Should `Win32Window` be split into smaller, more focused modules?**
  _Cohesion score 0.06594071385359952 - nodes in this community are weakly interconnected._