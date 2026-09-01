# Graph Report - frontend  (2026-08-29)

## Corpus Check
- 190 files · ~56,149 words
- Verdict: corpus is large enough that graph structure adds value.

## Summary
- 2321 nodes · 3544 edges · 127 communities (122 shown, 5 thin omitted)
- Extraction: 99% EXTRACTED · 1% INFERRED · 0% AMBIGUOUS · INFERRED: 28 edges (avg confidence: 0.8)
- Token cost: 0 input · 0 output

## Graph Freshness
- Built from commit: `ea85bb7a`
- Run `git rev-parse HEAD` and compare to check if the graph is stale.
- Run `graphify update .` after code changes (no API cost).

## Community Hubs (Navigation)
- person_detail_body.dart
- daily_session_view_model.dart
- Win32Window
- integrations_screen.dart
- generate_daily_sounds.dart
- daily_stats.dart
- home_view_model_test.dart
- integrations_view_model.dart
- person_growth_view_model.dart
- person_form.dart
- person_growth_models.dart
- person_detail_body_layout_test.dart
- AppDelegate
- StatelessWidget
- person.dart
- daily_running_body.dart
- app_data_table.dart
- notifications_screen.dart
- external_notification.dart
- app_colors.dart
- daily_meeting_detail_body_test.dart
- package:mocktail/mocktail.dart
- daily_config_body.dart
- integration_models.dart
- Mock
- route_paths.dart
- profile_screen.dart
- daily_config_body_test.dart
- daily_session_view_model_test.dart
- profile_view_model_test.dart
- bootstrap.dart
- my_application.cc
- package:provider/provider.dart
- app_router.dart
- api_exception.dart
- teams_list_screen.dart
- daily_session_screen.dart
- ../../../core/network/api_exception.dart
- notifications_view_model_test.dart
- daily_meeting_detail_body.dart
- daily_meeting_annotation.dart
- auth_repository_test.dart
- daily_history_body.dart
- IconData
- app_text_field.dart
- BaseViewModel
- person_service.dart
- person_growth_service.dart
- team_detail_view_model.dart
- team_members_section.dart
- home_view_model.dart
- package:flutter/material.dart
- person_growth_repository.dart
- home_body.dart
- ../../../core/viewmodels/base_view_model.dart
- daily_meeting_entry.dart
- person_detail_screen.dart
- auth_session.dart
- daily_running_body_test.dart
- daily_cue_player.dart
- package:dio/dio.dart
- adaptive_scaffold.dart
- app_dialog_actions.dart
- daily_meeting.dart
- daily_history_view_model.dart
- app_typography.dart
- auth_repository.dart
- profile_view_model.dart
- notifications_view_model.dart
- app_page_header.dart
- login_form.dart
- PersonFormViewModel
- accept_invitation_form.dart
- token_storage.dart
- app_user.dart
- team.dart
- daily_meeting_repository.dart
- person_repository_test.dart
- Equatable
- MVVM Feature Architecture
- wWinMain
- logging_interceptor.dart
- access_policy.dart
- daily_timer_ring.dart
- base_view_model.dart
- person_repository.dart
- package:flutter_test/flutter_test.dart
- manifest.json
- DateTime
- DailySessionViewModel
- daily_meeting_repository_test.dart
- integration_service.dart
- people_list_view_model.dart
- person_detail_view_model.dart
- person_form_view_model.dart
- AuthSession
- static const
- List
- daily_time_limit.dart
- team_repository.dart
- team_service.dart
- teams_list_view_model.dart
- person_growth_view_model_test.dart
- _
- person_growth_repository_test.dart
- app_theme_extension.dart
- breakpoints.dart
- app_spacing.dart
- notification_repository.dart
- daily_blocker_draft.dart
- birthday_util.dart
- notification_repository_test.dart
- auth_service.dart
- PersonDetailViewModel
- Linux Relocatable Bundle Build
- MainActivity.kt
- PersonGrowthRepository
- daily_cue.dart
- DailySessionPhase
- @example
- String?
- contract_type.dart
- seniority_level.dart

## God Nodes (most connected - your core abstractions)
1. `PersonRepository` - 33 edges
2. `DailySessionViewModel` - 22 edges
3. `Win32Window` - 22 edges
4. `BaseViewModel` - 19 edges
5. `TeamRepository` - 19 edges
6. `AuthRepository` - 14 edges
7. `DailyMeetingRepository` - 14 edges
8. `Person` - 13 edges
9. `MessageHandler` - 12 edges
10. `AppThemeExtension` - 11 edges

## Surprising Connections (you probably didn't know these)
- `Flutter Starter Template` --semantically_similar_to--> `MVVM Feature Architecture`  [INFERRED] [semantically similar]
  README.md → CLAUDE.md
- `Linux Relocatable Bundle Build` --semantically_similar_to--> `Windows In Place Runtime Bundle`  [INFERRED] [semantically similar]
  linux/CMakeLists.txt → windows/CMakeLists.txt
- `Linux GTK Runner Target` --semantically_similar_to--> `Windows Desktop Runner Target`  [INFERRED] [semantically similar]
  linux/runner/CMakeLists.txt → windows/runner/CMakeLists.txt
- `MVVM Feature Architecture` --conceptually_related_to--> `Strict Dart Analyzer Profile`  [INFERRED]
  CLAUDE.md → analysis_options.yaml
- `_MockPersonRepository` --implements--> `PersonRepository`  [EXTRACTED]
  test/features/home/viewmodels/home_view_model_test.dart → lib/features/people/repositories/person_repository.dart

## Import Cycles
- None detected.

## Hyperedges (group relationships)
- **Frontend Multi Platform Delivery Surface** — frontend_pubspec_flutter_app_manifest, frontend_ios_runner_assets_xcassets_launchimage_imageset_ios_launch_screen_customization, frontend_linux_cmakelists_linux_relocatable_bundle_build, frontend_web_index_flutter_web_bootstrap_shell, frontend_windows_cmakelists_windows_in_place_runtime_bundle [INFERRED 0.75]
- **Frontend Application Architecture** — frontend_claude_mvvm_feature_architecture, frontend_claude_token_driven_design_system, frontend_claude_shell_and_focus_mode_navigation, frontend_claude_bearer_token_authentication_model, frontend_claude_webhook_integration_boundary [INFERRED 0.85]

## Communities (127 total, 5 thin omitted)

### Community 0 - "person_detail_body.dart"
Cohesion: 0.02
Nodes (102): ../../daily/screens/person_daily_section.dart, Iterable, actionErrorMessage, _availableWidth, canGenerateAccessToken, canManageGrowth, canShowOneOnOne, child (+94 more)

### Community 1 - "daily_session_view_model.dart"
Cohesion: 0.03
Nodes (59): DailySessionPhase get, DailyTurnDraft? get, addTopic, _beginCurrentTurn, _blockers, canGoToPreviousTurn, clearCue, clearSelection (+51 more)

### Community 2 - "Win32Window"
Cohesion: 0.07
Nodes (51): Point, RECT, Size, unique_ptr, DartProject, HWND, LPARAM, LRESULT (+43 more)

### Community 3 - "integrations_screen.dart"
Cohesion: 0.04
Nodes (56): build, child, children, _confirmTokenRegeneration, createState, _descriptionController, dispose, _EmptyPanel (+48 more)

### Community 4 - "generate_daily_sounds.dart"
Cohesion: 0.04
Nodes (49): dart:io, dart:math, dart:typed_data, required double decay,
  double, required double durationSeconds,
  double, required double releaseSeconds,
  double, bitsPerSample, blockAlign (+41 more)

### Community 5 - "daily_stats.dart"
Cohesion: 0.11
Nodes (17): averageActualSeconds, burnedPercentage, byPerson, computeDailyStatsSummary, computeDraftStatus, countWithStatus, dailySpokeTooLittleRatio, empty (+9 more)

### Community 6 - "home_view_model_test.dart"
Cohesion: 0.07
Nodes (36): _MockPersonRepository, package:for_tech_lead/core/routing/route_paths.dart, package:for_tech_lead/core/viewmodels/base_view_model.dart, package:for_tech_lead/features/daily/viewmodels/person_daily_stats_view_model.dart, package:for_tech_lead/features/home/screens/home_body.dart, package:for_tech_lead/features/home/viewmodels/home_view_model.dart, package:for_tech_lead/features/people/models/person.dart, package:for_tech_lead/features/people/models/seniority_level.dart (+28 more)

### Community 7 - "integrations_view_model.dart"
Cohesion: 0.04
Nodes (43): createExternalIdentity, createSystem, getDeliveryMetrics, getExternalIdentities, getSystems, regenerateSystemToken, _service, actionErrorMessage (+35 more)

### Community 8 - "person_growth_view_model.dart"
Cohesion: 0.05
Nodes (40): actionErrorMessage, canManageGrowth, clearActionError, createPlan, createPlanItem, createSession, createTemplate, deliveryMetrics (+32 more)

### Community 9 - "person_form.dart"
Cohesion: 0.07
Nodes (26): ../../../core/widgets/inputs/app_date_field.dart, ../../../core/widgets/inputs/app_dropdown_field.dart, _admissionDate, _admissionDateError, _birthDate, _birthDateError, _contractType, _contractTypeError (+18 more)

### Community 10 - "person_growth_models.dart"
Cohesion: 0.05
Nodes (37): actionItems, active, competency, _date, description, DevelopmentPlan, developmentPlanId, DevelopmentPlanItem (+29 more)

### Community 11 - "person_detail_body_layout_test.dart"
Cohesion: 0.05
Nodes (37): package:for_tech_lead/core/responsive/adaptive_scaffold.dart, package:for_tech_lead/features/people/screens/person_detail_body.dart, package:for_tech_lead/features/people/screens/person_detail_screen.dart, PersonGrowthRepository? growthRepository,
  bool, canGenerateAccessToken, _deliveryMetrics, ensureVisible, _expectAnalysisSpacing (+29 more)

### Community 12 - "AppDelegate"
Cohesion: 0.07
Nodes (23): Any, Cocoa, Flutter, FlutterAppDelegate, FlutterImplicitEngineBridge, FlutterImplicitEngineDelegate, FlutterMacOS, FlutterSceneDelegate (+15 more)

### Community 13 - "StatelessWidget"
Cohesion: 0.06
Nodes (36): AppPageHeader, _ActionErrorBanner, _FormColumn, _IntegrationTabButton, _SectionStack, _ActionErrorBanner, _AnalysisTab, _ContextualTabBar (+28 more)

### Community 14 - "person.dart"
Cohesion: 0.08
Nodes (24): contract_type.dart, admissionDate, age, averageActualSeconds, birthDate, burnedPercentage, contractType, createdAt (+16 more)

### Community 15 - "daily_running_body.dart"
Cohesion: 0.06
Nodes (34): daily_timer_ring.dart, addTooltip, allowedSeconds, _AnnotationComposer, _annotationController, _annotationKind, blockers, controller (+26 more)

### Community 16 - "app_data_table.dart"
Cohesion: 0.05
Nodes (41): dart:async, EdgeInsets, ../inputs/app_search_field.dart, AppDataColumn, AppDataTable, _AppDataTableState, build, _buildList (+33 more)

### Community 17 - "notifications_screen.dart"
Cohesion: 0.06
Nodes (31): ../../../core/theme/app_radius.dart, ../../../core/widgets/states/empty_view.dart, build, color, colors, day, _formatDate, hour (+23 more)

### Community 18 - "external_notification.dart"
Cohesion: 0.06
Nodes (31): DateTime? get, createdAt, currentPage, _date, detailsPayload, displayDate, eventId, fromJson (+23 more)

### Community 19 - "app_colors.dart"
Cohesion: 0.06
Nodes (31): accent, accentDark, AppColors, background, backgroundDark, border, borderDark, error (+23 more)

### Community 20 - "daily_meeting_detail_body_test.dart"
Cohesion: 0.07
Nodes (27): package:for_tech_lead/features/daily/models/daily_annotation_type.dart, package:for_tech_lead/features/daily/models/daily_entry_status.dart, package:for_tech_lead/features/daily/models/daily_meeting_annotation.dart, package:for_tech_lead/features/daily/models/daily_meeting_entry.dart, package:for_tech_lead/features/daily/screens/daily_meeting_detail_body.dart, package:for_tech_lead/features/daily/utils/daily_stats.dart, package:for_tech_lead/features/daily/viewmodels/daily_meeting_detail_view_model.dart, required String text,
  bool (+19 more)

### Community 21 - "package:mocktail/mocktail.dart"
Cohesion: 0.08
Nodes (27): class _MockIntegrationRepository extends, IntegrationRepository, IntegrationService, _MockIntegrationRepository, package:for_tech_lead/features/integrations/models/integration_models.dart, package:for_tech_lead/features/integrations/repositories/integration_repository.dart, package:for_tech_lead/features/integrations/screens/integrations_screen.dart, package:for_tech_lead/features/integrations/services/integration_service.dart (+19 more)

### Community 22 - "daily_config_body.dart"
Cohesion: 0.07
Nodes (27): ../../../core/widgets/inputs/app_search_field.dart, canDrag, canReorder, _ConfigHeader, createState, DailyConfigBody, _DailyConfigBodyState, _dailyConfigInnerGap (+19 more)

### Community 23 - "integration_models.dart"
Cohesion: 0.07
Nodes (27): active, currentPage, _date, description, externalCode, fromJson, id, _int (+19 more)

### Community 24 - "Mock"
Cohesion: 0.14
Nodes (24): DailyMeetingRepository, PersonRepository, TeamRepository, Mock, _MockDailyMeetingRepository, _MockPersonRepository, _MockTeamRepository, _MockDailyMeetingRepository (+16 more)

### Community 25 - "route_paths.dart"
Cohesion: 0.08
Nodes (25): acceptInvitation, dailyHistory, dailyHistoryPath, dailyMeetingDetail, dailyMeetingDetailPath, dailySession, dailySessionPath, home (+17 more)

### Community 26 - "profile_screen.dart"
Cohesion: 0.16
Nodes (13): AsyncCallback, build, _edit, _MissingPersonProfile, onSaved, person, _PersonProfileCard, _ProfileBody (+5 more)

### Community 27 - "daily_config_body_test.dart"
Cohesion: 0.07
Nodes (29): _MockTeamRepository, package:for_tech_lead/core/theme/app_theme.dart, package:for_tech_lead/core/widgets/tables/app_data_table.dart, package:for_tech_lead/features/daily/screens/daily_config_body.dart, package:for_tech_lead/features/teams/models/team.dart, package:for_tech_lead/features/teams/repositories/team_repository.dart, package:for_tech_lead/features/teams/screens/team_detail_body.dart, package:for_tech_lead/features/teams/screens/teams_list_body.dart (+21 more)

### Community 28 - "daily_session_view_model_test.dart"
Cohesion: 0.09
Nodes (22): class _MockDailyMeetingRepository extends, _MockDailyMeetingRepository, package:fake_async/fake_async.dart, package:for_tech_lead/features/daily/models/daily_meeting.dart, package:for_tech_lead/features/daily/models/daily_session_phase.dart, package:for_tech_lead/features/daily/viewmodels/daily_history_view_model.dart, package:for_tech_lead/features/daily/viewmodels/daily_session_view_model.dart, _entry (+14 more)

### Community 29 - "profile_view_model_test.dart"
Cohesion: 0.07
Nodes (28): TeamService, _MockAuthRepository, package:for_tech_lead/core/network/api_exception.dart, package:for_tech_lead/features/auth/models/app_user.dart, package:for_tech_lead/features/auth/repositories/auth_repository.dart, package:for_tech_lead/features/auth/viewmodels/login_view_model.dart, package:for_tech_lead/features/auth/viewmodels/register_view_model.dart, package:for_tech_lead/features/profile/viewmodels/profile_view_model.dart (+20 more)

### Community 30 - "bootstrap.dart"
Cohesion: 0.09
Nodes (22): core/storage/token_storage.dart, features/auth/repositories/auth_repository.dart, features/auth/services/auth_service.dart, features/daily/repositories/daily_meeting_repository.dart, features/daily/services/daily_meeting_service.dart, features/integrations/repositories/integration_repository.dart, features/integrations/services/integration_service.dart, features/notifications/repositories/notification_repository.dart (+14 more)

### Community 31 - "my_application.cc"
Cohesion: 0.11
Nodes (20): FlView, GApplication, gboolean, gchar, GObject, GtkApplication, main(), first_frame_cb() (+12 more)

### Community 32 - "package:provider/provider.dart"
Cohesion: 0.11
Nodes (17): accept_invitation_form.dart, app.dart, bootstrap.dart, ../../../core/theme/app_spacing.dart, AcceptInvitationScreen, build, build, LoginScreen (+9 more)

### Community 33 - "app_router.dart"
Cohesion: 0.09
Nodes (21): ../auth/access_policy.dart, ../../features/auth/screens/accept_invitation_screen.dart, ../../features/auth/screens/login_screen.dart, ../../features/auth/screens/register_screen.dart, ../../features/daily/screens/daily_history_screen.dart, ../../features/daily/screens/daily_meeting_detail_screen.dart, ../../features/daily/screens/daily_session_screen.dart, ../../features/home/screens/home_screen.dart (+13 more)

### Community 34 - "api_exception.dart"
Cohesion: 0.14
Nodes (20): Exception, ApiException, bodyMessage, data, errors, _firstMessage, ForbiddenException, mapDioException (+12 more)

### Community 35 - "teams_list_screen.dart"
Cohesion: 0.19
Nodes (13): ../../../core/widgets/buttons/app_dialog_actions.dart, Team, build, _createdAtFormat, TeamsListBody, build, _showCreateDialog, TeamsListScreen (+5 more)

### Community 36 - "daily_session_screen.dart"
Cohesion: 0.09
Nodes (24): ../../../core/feedback/daily_cue_player.dart, daily_config_body.dart, daily_review_body.dart, daily_running_body.dart, home_body.dart, _confirmExit, createState, _cuePlayer (+16 more)

### Community 37 - "../../../core/network/api_exception.dart"
Cohesion: 0.18
Nodes (10): ../../../core/network/api_exception.dart, ../../../core/network/dio_client.dart, _client, index, indexEntries, show, store, _client (+2 more)

### Community 38 - "notifications_view_model_test.dart"
Cohesion: 0.12
Nodes (17): class _MockNotificationRepository extends, NotificationRepository, _MockNotificationRepository, package:for_tech_lead/bootstrap.dart, package:for_tech_lead/features/notifications/models/external_notification.dart, package:for_tech_lead/features/notifications/screens/notifications_screen.dart, package:for_tech_lead/features/notifications/viewmodels/notifications_view_model.dart, main (+9 more)

### Community 39 - "daily_meeting_detail_body.dart"
Cohesion: 0.10
Nodes (19): apiValue, DailyEntryStatus, fromApiValue, label, annotations, _AnnotationsSection, build, DailyMeetingDetailBody (+11 more)

### Community 40 - "daily_meeting_annotation.dart"
Cohesion: 0.11
Nodes (17): daily_annotation_type.dart, apiValue, DailyAnnotationType, fromApiValue, label, createdAt, DailyMeetingAnnotation, dailyMeetingId (+9 more)

### Community 41 - "auth_repository_test.dart"
Cohesion: 0.12
Nodes (17): TokenStorage, _MockTokenStorage, package:for_tech_lead/core/auth/access_policy.dart, package:for_tech_lead/core/auth/auth_session.dart, package:for_tech_lead/core/storage/token_storage.dart, package:for_tech_lead/features/auth/services/auth_service.dart, authSession, main (+9 more)

### Community 42 - "daily_history_body.dart"
Cohesion: 0.12
Nodes (20): ../../../core/widgets/cards/app_summary_card.dart, daily_history_body.dart, build, createState, DailyHistoryBody, _DailyHistoryBodyState, _dateFormat, _HistorySummaryCard (+12 more)

### Community 43 - "IconData"
Cohesion: 0.12
Nodes (15): IconData, AppSummaryCard, build, icon, label, value, AppKeyValueRow, build (+7 more)

### Community 44 - "app_text_field.dart"
Cohesion: 0.04
Nodes (41): app_colors.dart, app_radius.dart, app_spacing.dart, app_theme_extension.dart, app_typography.dart, CustomPainter, ElevatedButton, AppTheme (+33 more)

### Community 45 - "BaseViewModel"
Cohesion: 0.16
Nodes (14): BaseViewModel, build, createState, dispose, _emailController, _nameController, _passwordConfirmationController, _passwordController (+6 more)

### Community 46 - "person_service.dart"
Cohesion: 0.20
Nodes (9): _client, createInvitation, _dateFormat, index, show, showMe, store, update (+1 more)

### Community 47 - "person_growth_service.dart"
Cohesion: 0.12
Nodes (16): _client, createDevelopmentPlan, createDevelopmentPlanItem, createSession, createTemplate, _dateFormat, _get, getDeliveryMetrics (+8 more)

### Community 48 - "team_detail_view_model.dart"
Cohesion: 0.12
Nodes (16): changeMembersPage, hasMembers, isChangingMembersPage, load, members, membersErrorMessage, membersLastPage, membersPage (+8 more)

### Community 49 - "team_members_section.dart"
Cohesion: 0.12
Nodes (20): ../../../core/routing/route_paths.dart, ../../../core/widgets/buttons/app_primary_button.dart, ../../../core/widgets/tables/app_data_table.dart, TeamDetailBody, build, TeamDetailScreen, teamId, _InlinePagination (+12 more)

### Community 50 - "home_view_model.dart"
Cohesion: 0.06
Nodes (31): ../../../core/widgets/data/app_key_value_row.dart, build, _DailyStatsContent, _historyLink, PersonDailySection, stats, teamId, PersonDailyStatsViewModel (+23 more)

### Community 51 - "package:flutter/material.dart"
Cohesion: 0.18
Nodes (8): build, LoadingView, package:flutter/material.dart, package:for_tech_lead/core/widgets/branding/app_logo.dart, package:for_tech_lead/core/widgets/cards/app_summary_card.dart, package:for_tech_lead/core/widgets/navigation/app_page_header.dart, main, main

### Community 52 - "person_growth_repository.dart"
Cohesion: 0.12
Nodes (15): ../../integrations/models/integration_models.dart, createDevelopmentPlan, createDevelopmentPlanItem, createSession, createTemplate, getDeliveryMetrics, getDevelopmentPlans, getMyDevelopmentPlans (+7 more)

### Community 53 - "home_body.dart"
Cohesion: 0.12
Nodes (15): _BirthdayCard, _DailyCallout, _daysUntilLabel, HomeBody, _homeInnerGap, _homeOuterGap, _initials, parts (+7 more)

### Community 54 - "../../../core/viewmodels/base_view_model.dart"
Cohesion: 0.17
Nodes (12): ../../../core/viewmodels/base_view_model.dart, AuthRepository, accept, _repository, login, _repository, register, _repository (+4 more)

### Community 55 - "daily_meeting_entry.dart"
Cohesion: 0.13
Nodes (14): daily_entry_status.dart, actualSeconds, allottedSeconds, createdAt, dailyMeetingId, fromJson, id, person (+6 more)

### Community 56 - "person_detail_screen.dart"
Cohesion: 0.08
Nodes (26): ../../../core/widgets/navigation/app_page_header.dart, ../../../core/widgets/states/error_view.dart, ../../../core/widgets/states/loading_view.dart, daily_meeting_detail_body.dart, DailyMeeting? get, DailyMeeting, build, DailyMeetingDetailScreen (+18 more)

### Community 57 - "auth_session.dart"
Cohesion: 0.13
Nodes (14): int get, hasResolvedAccess, isAuthenticated, isMember, isTechLead, _personId, restore, _role (+6 more)

### Community 58 - "daily_running_body_test.dart"
Cohesion: 0.12
Nodes (15): OutlinedButton, package:for_tech_lead/core/theme/app_spacing.dart, package:for_tech_lead/features/daily/screens/daily_running_body.dart, package:for_tech_lead/features/daily/screens/daily_timer_ring.dart, return, loadParticipants, main, meetingRepository (+7 more)

### Community 59 - "daily_cue_player.dart"
Cohesion: 0.14
Nodes (13): AudioPlayer, daily_cue_sound_theme.dart, _cuePlayer, DailyCuePlayer, dispose, _hapticByCue, _isTicking, play (+5 more)

### Community 60 - "package:dio/dio.dart"
Cohesion: 0.15
Nodes (12): ../auth/auth_session.dart, auth_interceptor.dart, ../config/env.dart, Dio, Dio get, _authSession, onError, onRequest (+4 more)

### Community 61 - "adaptive_scaffold.dart"
Cohesion: 0.14
Nodes (13): breakpoints.dart, AdaptiveScaffold, AppNavDestination, build, child, destinations, _hasNav, icon (+5 more)

### Community 62 - "app_dialog_actions.dart"
Cohesion: 0.09
Nodes (20): app_primary_button.dart, ../buttons/app_primary_button.dart, AppDialogActions, build, onPrimaryPressed, onSecondaryPressed, primaryLabel, primaryLoading (+12 more)

### Community 63 - "daily_meeting.dart"
Cohesion: 0.14
Nodes (13): daily_meeting_annotation.dart, daily_meeting_entry.dart, annotations, createdAt, endedAt, entries, fromJson, id (+5 more)

### Community 64 - "daily_history_view_model.dart"
Cohesion: 0.15
Nodes (12): DailyStatsSummary get, load, _meetings, _namesByPersonId, personName, _personRepository, _rankings, rankingsByBurned (+4 more)

### Community 65 - "app_typography.dart"
Cohesion: 0.14
Nodes (13): AppTypography, bodyLarge, bodyMedium, bodySmall, displaySmall, _inter, labelLarge, labelMedium (+5 more)

### Community 66 - "auth_repository.dart"
Cohesion: 0.14
Nodes (13): acceptPersonInvitation, _authSession, login, logout, me, register, resolveCurrentUserAccess, _service (+5 more)

### Community 67 - "profile_view_model.dart"
Cohesion: 0.18
Nodes (10): AppUser? get, ../../auth/models/app_user.dart, ../../auth/repositories/auth_repository.dart, _authRepository, load, _loadLinkedPerson, _person, _personRepository (+2 more)

### Community 68 - "notifications_view_model.dart"
Cohesion: 0.14
Nodes (13): changePage, clearPageError, isChangingPage, lastPage, load, _loadPage, notifications, page (+5 more)

### Community 69 - "app_page_header.dart"
Cohesion: 0.18
Nodes (10): ../branding/app_logo.dart, build, preferredSize, showBrandMark, showNotifications, subtitle, title, RoutePaths.notifications (+2 more)

### Community 70 - "login_form.dart"
Cohesion: 0.19
Nodes (12): ../../../core/widgets/branding/app_logo.dart, ../../../core/widgets/inputs/app_text_field.dart, build, createState, dispose, _emailController, LoginForm, _LoginFormState (+4 more)

### Community 71 - "PersonFormViewModel"
Cohesion: 0.29
Nodes (7): build, PersonForm, _PersonFormState, build, PersonFormScreen, _submit, PersonFormViewModel

### Community 72 - "accept_invitation_form.dart"
Cohesion: 0.19
Nodes (12): AcceptInvitationForm, _AcceptInvitationFormState, build, createState, dispose, _emailController, _passwordConfirmationController, _passwordController (+4 more)

### Community 73 - "token_storage.dart"
Cohesion: 0.15
Nodes (12): FlutterSecureStorage, delete, _personIdKey, read, readPersonId, readRole, _roleKey, _storage (+4 more)

### Community 74 - "app_user.dart"
Cohesion: 0.15
Nodes (12): createdAt, email, fromJson, id, isMember, isTechLead, name, personId (+4 more)

### Community 75 - "team.dart"
Cohesion: 0.15
Nodes (12): createdAt, fromJson, id, name, people, peopleLastPage, peoplePage, peoplePerPage (+4 more)

### Community 76 - "daily_meeting_repository.dart"
Cohesion: 0.20
Nodes (9): createMeeting, getAllEntries, getMeeting, getMeetings, _maxStatsPages, _service, ../models/daily_meeting.dart, ../models/daily_meeting_entry.dart (+1 more)

### Community 77 - "person_repository_test.dart"
Cohesion: 0.20
Nodes (9): PersonService, package:for_tech_lead/features/people/models/contract_type.dart, package:for_tech_lead/features/people/services/person_service.dart, main, _MockPersonService, _personJson, _personWithoutDatesJson, repository (+1 more)

### Community 78 - "Equatable"
Cohesion: 0.17
Nodes (12): Equatable, AppUser, DailyMeetingEntry, DailyPersonRanking, DailyStatsSummary, DeliveryMetricsPage, IntegrationSystem, PersonDeliveryMetric (+4 more)

### Community 79 - "MVVM Feature Architecture"
Cohesion: 0.18
Nodes (12): PR Metrics Workflow, Strict Dart Analyzer Profile, Bearer Token Authentication Model, MVVM Feature Architecture, Shell And Focus Mode Navigation, Token Driven Design System, Webhook Integration Boundary, iOS Launch Screen Customization (+4 more)

### Community 80 - "wWinMain"
Cohesion: 0.24
Nodes (9): _In_, _In_opt_, vector, wWinMain(), string, wchar_t, CreateAndAttachConsole(), GetCommandLineArguments() (+1 more)

### Community 81 - "logging_interceptor.dart"
Cohesion: 0.17
Nodes (11): Interceptor, AuthInterceptor, AppLoggingInterceptor, _logger, onError, onRequest, onResponse, _redact (+3 more)

### Community 83 - "access_policy.dart"
Cohesion: 0.18
Nodes (10): auth_session.dart, AccessPolicy, _authSession, canAccessRoute, canManageIntegrations, canManagePeople, canManageTeams, canReadNotifications (+2 more)

### Community 84 - "daily_timer_ring.dart"
Cohesion: 0.15
Nodes (13): @immutable, ../../../core/theme/app_theme_extension.dart, AppThemeExtension, allowedSeconds, build, _dailyTimerMaxDiameter, _dailyTimerOuterPadding, DailyTimerRing (+5 more)

### Community 85 - "base_view_model.dart"
Cohesion: 0.18
Nodes (10): _errorMessage, hasError, isLoading, runCatching, setState, _state, ViewState, ../network/api_exception.dart (+2 more)

### Community 86 - "person_repository.dart"
Cohesion: 0.18
Nodes (10): createInvitationToken, createPerson, getMyPerson, getPeople, getPerson, _service, updatePerson, ../models/contract_type.dart (+2 more)

### Community 87 - "package:flutter_test/flutter_test.dart"
Cohesion: 0.18
Nodes (8): package:flutter_test/flutter_test.dart, package:for_tech_lead/core/feedback/daily_cue_sound_theme.dart, package:for_tech_lead/features/daily/models/daily_cue.dart, package:for_tech_lead/features/daily/utils/daily_time_limit.dart, package:for_tech_lead/features/people/utils/birthday_util.dart, main, main, main

### Community 88 - "manifest.json"
Cohesion: 0.18
Nodes (10): background_color, description, display, icons, name, orientation, prefer_related_applications, short_name (+2 more)

### Community 89 - "DateTime"
Cohesion: 0.20
Nodes (9): DateTime, AppDateField, build, errorText, firstDate, label, lastDate, onChanged (+1 more)

### Community 90 - "DailySessionViewModel"
Cohesion: 0.11
Nodes (19): build, _PeoplePicker, _TeamSelector, _TimeLimitControl, blockers, _BlockersReview, build, DailyReviewBody (+11 more)

### Community 91 - "daily_meeting_repository_test.dart"
Cohesion: 0.20
Nodes (9): DailyMeetingService, package:for_tech_lead/features/daily/repositories/daily_meeting_repository.dart, package:for_tech_lead/features/daily/services/daily_meeting_service.dart, _entryJson, main, _meetingJson, _MockDailyMeetingService, repository (+1 more)

### Community 92 - "integration_service.dart"
Cohesion: 0.20
Nodes (9): _client, createExternalIdentity, createSystem, _get, getDeliveryMetrics, getExternalIdentities, getSystems, _post (+1 more)

### Community 93 - "people_list_view_model.dart"
Cohesion: 0.20
Nodes (9): hasPeople, load, _people, _query, _repository, search, teamId, ../models/person.dart (+1 more)

### Community 94 - "person_detail_view_model.dart"
Cohesion: 0.20
Nodes (9): clearInvitationToken, createInvitationToken, _invitationErrorMessage, _invitationToken, load, _person, personId, _repository (+1 more)

### Community 96 - "person_form_view_model.dart"
Cohesion: 0.12
Nodes (16): bool get, int?, actualSeconds, allowedSeconds, DailyTurnDraft, hasSpoken, person, Person (+8 more)

### Community 97 - "AuthSession"
Cohesion: 0.22
Nodes (8): ChangeNotifier, ../../../core/auth/auth_session.dart, core/routing/app_router.dart, core/theme/app_theme.dart, App, build, AuthSession, package:flutter_localizations/flutter_localizations.dart

### Community 98 - "static const"
Cohesion: 0.22
Nodes (7): apiBaseUrl, Env, AppRadius, lg, md, sm, static const

### Community 99 - "List"
Cohesion: 0.22
Nodes (8): AppDropdownField, build, errorText, items, label, onChanged, value, List

### Community 100 - "daily_time_limit.dart"
Cohesion: 0.22
Nodes (8): dailyTimeLimitMinSeconds, dailyTimeLimitStepSeconds, formatDailyDuration, isValidDailyTimeLimit, minutes, remainingSeconds, seconds, sign

### Community 102 - "team_repository.dart"
Cohesion: 0.22
Nodes (8): createTeam, deleteTeam, getTeam, getTeams, _service, updateTeam, ../models/team.dart, ../services/team_service.dart

### Community 103 - "team_service.dart"
Cohesion: 0.29
Nodes (6): _client, destroy, index, show, store, update

### Community 104 - "teams_list_view_model.dart"
Cohesion: 0.22
Nodes (8): createTeam, hasTeams, load, _query, _repository, search, _teams, ../repositories/team_repository.dart

### Community 105 - "person_growth_view_model_test.dart"
Cohesion: 0.25
Nodes (7): class _MockPersonGrowthRepository extends, _MockPersonGrowthRepository, package:for_tech_lead/features/people/models/person_growth_models.dart, package:for_tech_lead/features/people/viewmodels/person_growth_view_model.dart, main, Mock, repository

### Community 106 - "_"
Cohesion: 0.29
Nodes (8): ../../features/daily/models/daily_cue.dart, _, assetPath, byCue, DailyCueSound, DailyCueSoundTheme, ticking, volume

### Community 107 - "person_growth_repository_test.dart"
Cohesion: 0.25
Nodes (7): package:for_tech_lead/features/people/repositories/person_growth_repository.dart, package:for_tech_lead/features/people/services/person_growth_service.dart, main, _planJson, repository, service, _sessionJson

### Community 108 - "app_theme_extension.dart"
Cohesion: 0.29
Nodes (6): Color, border, copyWith, lerp, success, warning

### Community 109 - "breakpoints.dart"
Cohesion: 0.29
Nodes (6): Breakpoints, isDesktop, isMobile, mobile, tablet, package:flutter/widgets.dart

### Community 110 - "app_spacing.dart"
Cohesion: 0.29
Nodes (6): AppSpacing, lg, md, sm, xl, xs

### Community 111 - "notification_repository.dart"
Cohesion: 0.29
Nodes (6): getNotifications, _service, NotificationService, ../models/external_notification.dart, ../services/notification_service.dart, _MockNotificationService

### Community 112 - "daily_blocker_draft.dart"
Cohesion: 0.33
Nodes (5): DailyBlockerDraft, resolved, text, toggleResolved, addBlocker

### Community 113 - "birthday_util.dart"
Cohesion: 0.33
Nodes (5): _dateOnly, daysUntilNextBirthday, difference, next, today

### Community 114 - "notification_repository_test.dart"
Cohesion: 0.33
Nodes (5): package:for_tech_lead/features/notifications/repositories/notification_repository.dart, package:for_tech_lead/features/notifications/services/notification_service.dart, main, repository, service

### Community 115 - "auth_service.dart"
Cohesion: 0.25
Nodes (7): DioClient, acceptPersonInvitation, _client, login, logout, me, register

### Community 116 - "PersonDetailViewModel"
Cohesion: 0.40
Nodes (5): build, _PersonHeader, build, PersonDetailScreen, PersonDetailViewModel

### Community 117 - "Linux Relocatable Bundle Build"
Cohesion: 0.67
Nodes (4): Linux Relocatable Bundle Build, Linux GTK Runner Target, Windows In Place Runtime Bundle, Windows Desktop Runner Target

### Community 120 - "PersonGrowthRepository"
Cohesion: 0.67
Nodes (3): PersonGrowthRepository, _MockPersonGrowthRepository, _MockPersonGrowthRepository

### Community 130 - "contract_type.dart"
Cohesion: 0.40
Nodes (4): apiValue, ContractType, fromApiValue, label

### Community 131 - "seniority_level.dart"
Cohesion: 0.40
Nodes (4): apiValue, fromApiValue, label, SeniorityLevel

## Knowledge Gaps
- **1380 isolated node(s):** `build`, `getIt`, `authSession`, `configureDependencies`, `restore` (+1375 more)
  These have ≤1 connection - possible missing edges or undocumented components.
- **5 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `PersonRepository` connect `Mock` to `daily_session_view_model.dart`, `integrations_screen.dart`, `home_view_model_test.dart`, `integrations_view_model.dart`, `person_detail_body_layout_test.dart`, `package:mocktail/mocktail.dart`, `profile_screen.dart`, `profile_view_model_test.dart`, `bootstrap.dart`, `daily_session_screen.dart`, `daily_history_body.dart`, `home_view_model.dart`, `person_detail_screen.dart`, `daily_history_view_model.dart`, `profile_view_model.dart`, `person_repository_test.dart`, `person_repository.dart`, `people_list_view_model.dart`, `person_detail_view_model.dart`, `person_form_view_model.dart`?**
  _High betweenness centrality (0.043) - this node is a cross-community bridge._
- **Why does `DailyMeetingRepository` connect `Mock` to `daily_history_view_model.dart`, `daily_session_view_model.dart`, `daily_session_screen.dart`, `daily_history_body.dart`, `daily_meeting_repository.dart`, `person_detail_screen.dart`, `daily_meeting_repository_test.dart`, `bootstrap.dart`?**
  _High betweenness centrality (0.017) - this node is a cross-community bridge._
- **Why does `TeamRepository` connect `Mock` to `daily_session_view_model.dart`, `teams_list_screen.dart`, `daily_session_screen.dart`, `team_repository.dart`, `teams_list_view_model.dart`, `team_detail_view_model.dart`, `team_members_section.dart`, `home_view_model.dart`, `profile_view_model_test.dart`, `bootstrap.dart`?**
  _High betweenness centrality (0.015) - this node is a cross-community bridge._
- **What connects `build`, `getIt`, `authSession` to the rest of the system?**
  _1380 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Should `person_detail_body.dart` be split into smaller, more focused modules?**
  _Cohesion score 0.019988577955454025 - nodes in this community are weakly interconnected._
- **Should `daily_session_view_model.dart` be split into smaller, more focused modules?**
  _Cohesion score 0.03333333333333333 - nodes in this community are weakly interconnected._
- **Should `Win32Window` be split into smaller, more focused modules?**
  _Cohesion score 0.06594071385359952 - nodes in this community are weakly interconnected._