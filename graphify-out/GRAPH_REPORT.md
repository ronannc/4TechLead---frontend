# Graph Report - frontend  (2026-09-07)

## Corpus Check
- 194 files · ~59,624 words
- Verdict: corpus is large enough that graph structure adds value.

## Summary
- 2443 nodes · 3736 edges · 138 communities (132 shown, 6 thin omitted)
- Extraction: 99% EXTRACTED · 1% INFERRED · 0% AMBIGUOUS · INFERRED: 27 edges (avg confidence: 0.81)
- Token cost: 0 input · 0 output

## Graph Freshness
- Built from commit: `d32f758c`
- Run `git rev-parse HEAD` and compare to check if the graph is stale.
- Run `graphify update .` after code changes (no API cost).

## Community Hubs (Navigation)
- person_detail_body.dart
- daily_session_view_model.dart
- Win32Window
- integrations_screen.dart
- generate_daily_sounds.dart
- daily_stats.dart
- one_on_ones_view_model_test.dart
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
- integrations_view_model_test.dart
- daily_config_body.dart
- integration_models.dart
- Mock
- route_paths.dart
- profile_screen.dart
- package:mocktail/mocktail.dart
- daily_session_view_model_test.dart
- profile_view_model_test.dart
- bootstrap.dart
- my_application.cc
- one_on_ones_screen.dart
- app_router.dart
- api_exception.dart
- register_form.dart
- daily_session_screen.dart
- auth_service.dart
- notifications_view_model.dart
- home_view_model.dart
- daily_meeting_annotation.dart
- auth_repository_test.dart
- daily_history_body.dart
- IconData
- adaptive_scaffold.dart
- app_text_field.dart
- person_service.dart
- person_growth_service.dart
- teams_list_screen.dart
- team_members_section.dart
- DailySessionViewModel
- team_detail_view_model.dart
- person_growth_repository.dart
- home_body.dart
- ../../../core/viewmodels/base_view_model.dart
- daily_meeting_entry.dart
- daily_config_body_test.dart
- auth_session.dart
- daily_running_body_test.dart
- daily_cue_player.dart
- dio_client.dart
- notification_repository.dart
- VoidCallback?
- daily_meeting.dart
- daily_history_view_model.dart
- PersonDetailViewModel
- auth_repository.dart
- one_on_ones_view_model.dart
- notifications_screen_test.dart
- package:go_router/go_router.dart
- login_form.dart
- daily_meeting_detail_body.dart
- accept_invitation_form.dart
- token_storage.dart
- app_user.dart
- team.dart
- app_typography.dart
- int?
- app_logo.dart
- MVVM Feature Architecture
- BaseViewModel
- logging_interceptor.dart
- integration_repository.dart
- access_policy.dart
- daily_timer_ring.dart
- base_view_model.dart
- person_repository.dart
- package:flutter_test/flutter_test.dart
- manifest.json
- DateTime
- daily_review_body.dart
- app.dart
- integration_service.dart
- person_form_view_model.dart
- person_detail_view_model.dart
- daily_meeting_detail_view_model.dart
- daily_meeting_repository_test.dart
- AuthSession
- static const
- List
- daily_time_limit.dart
- app_dialog_actions.dart
- daily_meeting_repository.dart
- person_growth_view_model_test.dart
- notifications_view_model_test.dart
- package:dio/dio.dart
- _
- package:flutter/material.dart
- app_theme_extension.dart
- breakpoints.dart
- app_spacing.dart
- person_growth_repository_test.dart
- daily_blocker_draft.dart
- birthday_util.dart
- ../../../core/network/api_exception.dart
- profile_view_model.dart
- package:provider/provider.dart
- Linux Relocatable Bundle Build
- adaptive_scaffold_test.dart
- MainActivity.kt
- notification_repository_test.dart
- daily_cue.dart
- DailySessionPhase
- @example
- String?
- DioClient
- DailyEntryStatus
- Equatable
- IntegrationsViewModel
- PersonGrowthRepository
- AppThemeExtension
- _tabBody
- contract_type.dart
- seniority_level.dart

## God Nodes (most connected - your core abstractions)
1. `PersonRepository` - 36 edges
2. `DailySessionViewModel` - 22 edges
3. `Win32Window` - 22 edges
4. `BaseViewModel` - 20 edges
5. `TeamRepository` - 19 edges
6. `AuthRepository` - 14 edges
7. `DailyMeetingRepository` - 14 edges
8. `Person` - 13 edges
9. `MessageHandler` - 12 edges
10. `AuthSession` - 11 edges

## Surprising Connections (you probably didn't know these)
- `Flutter Starter Template` --semantically_similar_to--> `MVVM Feature Architecture`  [INFERRED] [semantically similar]
  README.md → CLAUDE.md
- `Linux Relocatable Bundle Build` --semantically_similar_to--> `Windows In Place Runtime Bundle`  [INFERRED] [semantically similar]
  linux/CMakeLists.txt → windows/CMakeLists.txt
- `Linux GTK Runner Target` --semantically_similar_to--> `Windows Desktop Runner Target`  [INFERRED] [semantically similar]
  linux/runner/CMakeLists.txt → windows/runner/CMakeLists.txt
- `MVVM Feature Architecture` --conceptually_related_to--> `Strict Dart Analyzer Profile`  [INFERRED]
  CLAUDE.md → analysis_options.yaml
- `_MockTeamRepository` --implements--> `TeamRepository`  [EXTRACTED]
  test/features/teams/screens/team_detail_body_test.dart → lib/features/teams/repositories/team_repository.dart

## Import Cycles
- None detected.

## Hyperedges (group relationships)
- **Frontend Multi Platform Delivery Surface** — frontend_pubspec_flutter_app_manifest, frontend_ios_runner_assets_xcassets_launchimage_imageset_ios_launch_screen_customization, frontend_linux_cmakelists_linux_relocatable_bundle_build, frontend_web_index_flutter_web_bootstrap_shell, frontend_windows_cmakelists_windows_in_place_runtime_bundle [INFERRED 0.75]
- **Frontend Application Architecture** — frontend_claude_mvvm_feature_architecture, frontend_claude_token_driven_design_system, frontend_claude_shell_and_focus_mode_navigation, frontend_claude_bearer_token_authentication_model, frontend_claude_webhook_integration_boundary [INFERRED 0.85]

## Communities (138 total, 6 thin omitted)

### Community 0 - "person_detail_body.dart"
Cohesion: 0.02
Nodes (80): ../../daily/screens/person_daily_section.dart, Iterable, actionErrorMessage, _availableWidth, canGenerateAccessToken, canManageGrowth, canShowOneOnOne, child (+72 more)

### Community 1 - "daily_session_view_model.dart"
Cohesion: 0.03
Nodes (59): DailySessionPhase get, DailyTurnDraft? get, addTopic, _beginCurrentTurn, _blockers, canGoToPreviousTurn, clearCue, clearSelection (+51 more)

### Community 2 - "Win32Window"
Cohesion: 0.05
Nodes (60): _In_, _In_opt_, Point, RECT, Size, unique_ptr, vector, DartProject (+52 more)

### Community 3 - "integrations_screen.dart"
Cohesion: 0.04
Nodes (56): _ActionErrorBanner, child, children, _confirmTokenRegeneration, createState, _descriptionController, dispose, _EmptyPanel (+48 more)

### Community 4 - "generate_daily_sounds.dart"
Cohesion: 0.04
Nodes (49): dart:io, dart:math, dart:typed_data, required double decay,
  double, required double durationSeconds,
  double, required double releaseSeconds,
  double, bitsPerSample, blockAlign (+41 more)

### Community 5 - "daily_stats.dart"
Cohesion: 0.11
Nodes (17): averageActualSeconds, burnedPercentage, byPerson, computeDailyStatsSummary, computeDraftStatus, countWithStatus, dailySpokeTooLittleRatio, empty (+9 more)

### Community 6 - "one_on_ones_view_model_test.dart"
Cohesion: 0.06
Nodes (47): _MockPersonRepository, package:for_tech_lead/core/routing/route_paths.dart, package:for_tech_lead/core/viewmodels/base_view_model.dart, package:for_tech_lead/features/daily/viewmodels/person_daily_stats_view_model.dart, package:for_tech_lead/features/home/screens/home_body.dart, package:for_tech_lead/features/home/viewmodels/home_view_model.dart, package:for_tech_lead/features/one_on_ones/viewmodels/one_on_ones_view_model.dart, package:for_tech_lead/features/people/models/contract_type.dart (+39 more)

### Community 7 - "integrations_view_model.dart"
Cohesion: 0.06
Nodes (33): actionErrorMessage, changeIdentitiesPage, changeMetricsPage, changeSystemsPage, clearActionError, createExternalIdentity, createSystem, identities (+25 more)

### Community 8 - "person_growth_view_model.dart"
Cohesion: 0.05
Nodes (40): actionErrorMessage, canManageGrowth, clearActionError, createPlan, createPlanItem, createSession, createTemplate, deliveryMetrics (+32 more)

### Community 9 - "person_form.dart"
Cohesion: 0.06
Nodes (38): ../../../core/widgets/inputs/app_date_field.dart, ../../../core/widgets/inputs/app_dropdown_field.dart, _admissionDate, _admissionDateError, _birthDate, _birthDateError, build, _clickupUserIdController (+30 more)

### Community 10 - "person_growth_models.dart"
Cohesion: 0.05
Nodes (43): actionItems, active, answers, body, competency, createdBy, _date, description (+35 more)

### Community 11 - "person_detail_body_layout_test.dart"
Cohesion: 0.05
Nodes (36): package:for_tech_lead/features/people/screens/person_detail_body.dart, package:for_tech_lead/features/people/screens/person_detail_screen.dart, PersonGrowthRepository? growthRepository,
  bool, canGenerateAccessToken, _deliveryMetrics, ensureVisible, _expectAnalysisSpacing, _expectOneOnOneHistorySpacing (+28 more)

### Community 12 - "AppDelegate"
Cohesion: 0.07
Nodes (23): Any, Cocoa, Flutter, FlutterAppDelegate, FlutterImplicitEngineBridge, FlutterImplicitEngineDelegate, FlutterMacOS, FlutterSceneDelegate (+15 more)

### Community 13 - "StatelessWidget"
Cohesion: 0.05
Nodes (38): AppPageHeader, _DocumentTile, _EmptyPanel, _FormColumn, OneOnOnesScreen, _SectionStack, _Surface, _TabBar (+30 more)

### Community 14 - "person.dart"
Cohesion: 0.07
Nodes (26): contract_type.dart, admissionDate, age, averageActualSeconds, birthDate, burnedPercentage, clickupUserId, contractType (+18 more)

### Community 15 - "daily_running_body.dart"
Cohesion: 0.06
Nodes (36): daily_timer_ring.dart, addTooltip, allowedSeconds, _AnnotationComposer, _annotationController, _annotationKind, blockers, controller (+28 more)

### Community 16 - "app_data_table.dart"
Cohesion: 0.06
Nodes (33): dart:async, EdgeInsets, ../inputs/app_search_field.dart, AppDataColumn, build, _buildList, _buildTable, child (+25 more)

### Community 17 - "notifications_screen.dart"
Cohesion: 0.06
Nodes (31): ../../../core/theme/app_radius.dart, ../../../core/widgets/states/empty_view.dart, build, color, colors, day, _formatDate, hour (+23 more)

### Community 18 - "external_notification.dart"
Cohesion: 0.06
Nodes (31): DateTime? get, createdAt, currentPage, _date, detailsPayload, displayDate, eventId, fromJson (+23 more)

### Community 19 - "app_colors.dart"
Cohesion: 0.05
Nodes (41): app_colors.dart, app_radius.dart, app_spacing.dart, app_theme_extension.dart, app_typography.dart, accent, accentDark, AppColors (+33 more)

### Community 20 - "daily_meeting_detail_body_test.dart"
Cohesion: 0.07
Nodes (27): package:for_tech_lead/features/daily/models/daily_annotation_type.dart, package:for_tech_lead/features/daily/models/daily_entry_status.dart, package:for_tech_lead/features/daily/models/daily_meeting_annotation.dart, package:for_tech_lead/features/daily/models/daily_meeting_entry.dart, package:for_tech_lead/features/daily/screens/daily_meeting_detail_body.dart, package:for_tech_lead/features/daily/utils/daily_stats.dart, package:for_tech_lead/features/daily/viewmodels/daily_meeting_detail_view_model.dart, required String text,
  bool (+19 more)

### Community 21 - "integrations_view_model_test.dart"
Cohesion: 0.09
Nodes (24): class _MockIntegrationRepository extends, IntegrationRepository, IntegrationService, _MockIntegrationRepository, package:for_tech_lead/features/integrations/models/integration_models.dart, package:for_tech_lead/features/integrations/repositories/integration_repository.dart, package:for_tech_lead/features/integrations/screens/integrations_screen.dart, package:for_tech_lead/features/integrations/services/integration_service.dart (+16 more)

### Community 22 - "daily_config_body.dart"
Cohesion: 0.07
Nodes (27): ../../../core/widgets/inputs/app_search_field.dart, canDrag, canReorder, _ConfigHeader, createState, DailyConfigBody, _DailyConfigBodyState, _dailyConfigInnerGap (+19 more)

### Community 23 - "integration_models.dart"
Cohesion: 0.07
Nodes (27): active, currentPage, _date, description, externalCode, fromJson, id, _int (+19 more)

### Community 24 - "Mock"
Cohesion: 0.11
Nodes (31): DailyMeetingRepository, PersonRepository, PersonService, TeamRepository, Mock, _MockDailyMeetingRepository, _MockPersonRepository, _MockTeamRepository (+23 more)

### Community 25 - "route_paths.dart"
Cohesion: 0.07
Nodes (27): acceptInvitation, dailyHistory, dailyHistoryPath, dailyMeetingDetail, dailyMeetingDetailPath, dailySession, dailySessionPath, home (+19 more)

### Community 26 - "profile_screen.dart"
Cohesion: 0.16
Nodes (13): AsyncCallback, build, _edit, _MissingPersonProfile, onSaved, person, _PersonProfileCard, _ProfileBody (+5 more)

### Community 27 - "package:mocktail/mocktail.dart"
Cohesion: 0.09
Nodes (23): TeamService, _MockTeamRepository, package:for_tech_lead/features/teams/models/team.dart, package:for_tech_lead/features/teams/repositories/team_repository.dart, package:for_tech_lead/features/teams/screens/team_detail_body.dart, package:for_tech_lead/features/teams/screens/teams_list_body.dart, package:for_tech_lead/features/teams/services/team_service.dart, package:for_tech_lead/features/teams/viewmodels/team_detail_view_model.dart (+15 more)

### Community 28 - "daily_session_view_model_test.dart"
Cohesion: 0.09
Nodes (22): class _MockDailyMeetingRepository extends, _MockDailyMeetingRepository, package:fake_async/fake_async.dart, package:for_tech_lead/features/daily/models/daily_meeting.dart, package:for_tech_lead/features/daily/models/daily_session_phase.dart, package:for_tech_lead/features/daily/viewmodels/daily_history_view_model.dart, package:for_tech_lead/features/daily/viewmodels/daily_session_view_model.dart, _entry (+14 more)

### Community 29 - "profile_view_model_test.dart"
Cohesion: 0.10
Nodes (20): _MockAuthRepository, package:for_tech_lead/features/auth/models/app_user.dart, package:for_tech_lead/features/auth/repositories/auth_repository.dart, package:for_tech_lead/features/auth/viewmodels/login_view_model.dart, package:for_tech_lead/features/auth/viewmodels/register_view_model.dart, package:for_tech_lead/features/profile/viewmodels/profile_view_model.dart, main, repository (+12 more)

### Community 30 - "bootstrap.dart"
Cohesion: 0.10
Nodes (20): core/storage/token_storage.dart, features/auth/repositories/auth_repository.dart, features/auth/services/auth_service.dart, features/daily/repositories/daily_meeting_repository.dart, features/daily/services/daily_meeting_service.dart, features/integrations/repositories/integration_repository.dart, features/integrations/services/integration_service.dart, features/notifications/repositories/notification_repository.dart (+12 more)

### Community 31 - "my_application.cc"
Cohesion: 0.11
Nodes (20): FlView, GApplication, gboolean, gchar, GObject, GtkApplication, main(), first_frame_cb() (+12 more)

### Community 32 - "one_on_ones_screen.dart"
Cohesion: 0.04
Nodes (56): _ActionErrorBanner, build, child, children, _createDocument, _createPoint, createState, dispose (+48 more)

### Community 33 - "app_router.dart"
Cohesion: 0.09
Nodes (22): ../auth/access_policy.dart, ../../features/auth/screens/accept_invitation_screen.dart, ../../features/auth/screens/login_screen.dart, ../../features/auth/screens/register_screen.dart, ../../features/daily/screens/daily_history_screen.dart, ../../features/daily/screens/daily_meeting_detail_screen.dart, ../../features/daily/screens/daily_session_screen.dart, ../../features/home/screens/home_screen.dart (+14 more)

### Community 34 - "api_exception.dart"
Cohesion: 0.13
Nodes (21): Exception, ApiException, bodyMessage, data, errors, _firstMessage, ForbiddenException, mapDioException (+13 more)

### Community 35 - "register_form.dart"
Cohesion: 0.21
Nodes (11): ../../../core/widgets/inputs/app_text_field.dart, build, createState, dispose, _emailController, _nameController, _passwordConfirmationController, _passwordController (+3 more)

### Community 36 - "daily_session_screen.dart"
Cohesion: 0.09
Nodes (25): ../../../core/feedback/daily_cue_player.dart, daily_config_body.dart, daily_review_body.dart, daily_running_body.dart, AppDataTable, _AppDataTableState, _confirmExit, createState (+17 more)

### Community 37 - "auth_service.dart"
Cohesion: 0.25
Nodes (7): ../../../core/network/dio_client.dart, acceptPersonInvitation, _client, login, logout, me, register

### Community 38 - "notifications_view_model.dart"
Cohesion: 0.14
Nodes (13): changePage, clearPageError, isChangingPage, lastPage, load, _loadPage, notifications, page (+5 more)

### Community 39 - "home_view_model.dart"
Cohesion: 0.06
Nodes (31): ../../../core/widgets/data/app_key_value_row.dart, build, _DailyStatsContent, _historyLink, PersonDailySection, stats, teamId, PersonDailyStatsViewModel (+23 more)

### Community 40 - "daily_meeting_annotation.dart"
Cohesion: 0.11
Nodes (16): daily_annotation_type.dart, apiValue, DailyAnnotationType, fromApiValue, label, createdAt, dailyMeetingId, fromJson (+8 more)

### Community 41 - "auth_repository_test.dart"
Cohesion: 0.12
Nodes (17): TokenStorage, _MockTokenStorage, package:for_tech_lead/core/auth/access_policy.dart, package:for_tech_lead/core/auth/auth_session.dart, package:for_tech_lead/core/storage/token_storage.dart, package:for_tech_lead/features/auth/services/auth_service.dart, authSession, main (+9 more)

### Community 42 - "daily_history_body.dart"
Cohesion: 0.13
Nodes (17): ../../../core/widgets/cards/app_summary_card.dart, build, createState, DailyHistoryBody, _DailyHistoryBodyState, _dateFormat, _HistorySummaryCard, icon (+9 more)

### Community 43 - "IconData"
Cohesion: 0.12
Nodes (15): IconData, AppSummaryCard, build, icon, label, value, AppKeyValueRow, build (+7 more)

### Community 44 - "adaptive_scaffold.dart"
Cohesion: 0.11
Nodes (17): breakpoints.dart, AdaptiveScaffold, AppNavDestination, build, child, destinations, _hasNav, icon (+9 more)

### Community 45 - "app_text_field.dart"
Cohesion: 0.12
Nodes (16): AppSearchField, build, controller, hintText, onChanged, AppTextField, build, controller (+8 more)

### Community 46 - "person_service.dart"
Cohesion: 0.20
Nodes (9): _client, createInvitation, _dateFormat, index, show, showMe, store, update (+1 more)

### Community 47 - "person_growth_service.dart"
Cohesion: 0.10
Nodes (19): _client, createDevelopmentPlan, createDevelopmentPlanItem, createPersonOneOnOneNote, createSession, createTemplate, _dateFormat, _get (+11 more)

### Community 48 - "teams_list_screen.dart"
Cohesion: 0.08
Nodes (29): ../../../core/widgets/buttons/app_dialog_actions.dart, ../../../core/widgets/tables/app_data_table.dart, createTeam, deleteTeam, getTeam, getTeams, _service, updateTeam (+21 more)

### Community 49 - "team_members_section.dart"
Cohesion: 0.12
Nodes (18): ../../../core/routing/route_paths.dart, ../../../core/widgets/buttons/app_primary_button.dart, TeamDetailBody, build, TeamDetailScreen, teamId, _InlinePagination, lastPage (+10 more)

### Community 50 - "DailySessionViewModel"
Cohesion: 0.20
Nodes (10): build, _PeoplePicker, _TeamSelector, _TimeLimitControl, _AnnotationList, build, _LiveHeader, build (+2 more)

### Community 51 - "team_detail_view_model.dart"
Cohesion: 0.12
Nodes (16): changeMembersPage, hasMembers, isChangingMembersPage, load, members, membersErrorMessage, membersLastPage, membersPage (+8 more)

### Community 52 - "person_growth_repository.dart"
Cohesion: 0.10
Nodes (20): ../../integrations/models/integration_models.dart, createDevelopmentPlan, createDevelopmentPlanItem, createPersonOneOnOneNote, createSession, createTemplate, getDeliveryMetrics, getDevelopmentPlans (+12 more)

### Community 53 - "home_body.dart"
Cohesion: 0.12
Nodes (15): _BirthdayCard, _DailyCallout, _daysUntilLabel, HomeBody, _homeInnerGap, _homeOuterGap, _initials, parts (+7 more)

### Community 54 - "../../../core/viewmodels/base_view_model.dart"
Cohesion: 0.13
Nodes (16): ../../../core/viewmodels/base_view_model.dart, AuthRepository, build, RegisterScreen, accept, _repository, login, _repository (+8 more)

### Community 55 - "daily_meeting_entry.dart"
Cohesion: 0.13
Nodes (14): daily_entry_status.dart, actualSeconds, allottedSeconds, createdAt, dailyMeetingId, fromJson, id, person (+6 more)

### Community 56 - "daily_config_body_test.dart"
Cohesion: 0.12
Nodes (15): package:for_tech_lead/core/theme/app_theme.dart, package:for_tech_lead/core/widgets/tables/app_data_table.dart, package:for_tech_lead/features/daily/screens/daily_config_body.dart, build, main, meetingRepository, Mock, _person (+7 more)

### Community 57 - "auth_session.dart"
Cohesion: 0.13
Nodes (14): int get, hasResolvedAccess, isAuthenticated, isMember, isTechLead, _personId, restore, _role (+6 more)

### Community 58 - "daily_running_body_test.dart"
Cohesion: 0.12
Nodes (15): OutlinedButton, package:for_tech_lead/core/theme/app_spacing.dart, package:for_tech_lead/features/daily/screens/daily_running_body.dart, package:for_tech_lead/features/daily/screens/daily_timer_ring.dart, return, loadParticipants, main, meetingRepository (+7 more)

### Community 59 - "daily_cue_player.dart"
Cohesion: 0.14
Nodes (13): AudioPlayer, daily_cue_sound_theme.dart, _cuePlayer, DailyCuePlayer, dispose, _hapticByCue, _isTicking, play (+5 more)

### Community 60 - "dio_client.dart"
Cohesion: 0.25
Nodes (7): auth_interceptor.dart, ../config/env.dart, Dio, Dio get, _dio, logging_interceptor.dart, package:flutter/foundation.dart

### Community 61 - "notification_repository.dart"
Cohesion: 0.29
Nodes (6): getNotifications, _service, NotificationService, ../models/external_notification.dart, ../services/notification_service.dart, _MockNotificationService

### Community 62 - "VoidCallback?"
Cohesion: 0.14
Nodes (12): ../buttons/app_primary_button.dart, AppPrimaryButton, AppSecondaryButton, build, label, loading, onPressed, build (+4 more)

### Community 63 - "daily_meeting.dart"
Cohesion: 0.14
Nodes (13): daily_meeting_annotation.dart, daily_meeting_entry.dart, annotations, createdAt, endedAt, entries, fromJson, id (+5 more)

### Community 64 - "daily_history_view_model.dart"
Cohesion: 0.14
Nodes (13): DailyStatsSummary get, DailyStatsSummary, load, _meetings, _namesByPersonId, personName, _personRepository, _rankings (+5 more)

### Community 65 - "PersonDetailViewModel"
Cohesion: 0.40
Nodes (5): build, _PersonHeader, build, PersonDetailScreen, PersonDetailViewModel

### Community 66 - "auth_repository.dart"
Cohesion: 0.14
Nodes (13): acceptPersonInvitation, _authSession, login, logout, me, register, resolveCurrentUserAccess, _service (+5 more)

### Community 67 - "one_on_ones_view_model.dart"
Cohesion: 0.06
Nodes (34): actionErrorMessage, canManageOneOnOnes, clearActionError, completedSessions, createPersonNote, createTemplate, currentPersonId, executeSession (+26 more)

### Community 68 - "notifications_screen_test.dart"
Cohesion: 0.20
Nodes (10): class _MockNotificationRepository extends, NotificationRepository, package:for_tech_lead/bootstrap.dart, package:for_tech_lead/features/notifications/models/external_notification.dart, package:for_tech_lead/features/notifications/screens/notifications_screen.dart, main, Mock, _MockNotificationRepository (+2 more)

### Community 69 - "package:go_router/go_router.dart"
Cohesion: 0.17
Nodes (11): ../branding/app_logo.dart, build, preferredSize, showBrandMark, showNotifications, subtitle, title, package:go_router/go_router.dart (+3 more)

### Community 70 - "login_form.dart"
Cohesion: 0.19
Nodes (12): ../../../core/widgets/branding/app_logo.dart, build, createState, dispose, _emailController, LoginForm, _LoginFormState, _passwordController (+4 more)

### Community 71 - "daily_meeting_detail_body.dart"
Cohesion: 0.12
Nodes (15): annotations, _AnnotationsSection, build, DailyMeetingDetailBody, _dateFormat, entries, _EntriesList, entry (+7 more)

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
Cohesion: 0.14
Nodes (13): createdAt, fromJson, id, name, people, peopleLastPage, peoplePage, peoplePerPage (+5 more)

### Community 76 - "app_typography.dart"
Cohesion: 0.14
Nodes (13): AppTypography, bodyLarge, bodyMedium, bodySmall, displaySmall, _inter, labelLarge, labelMedium (+5 more)

### Community 77 - "int?"
Cohesion: 0.25
Nodes (7): int?, actualSeconds, allowedSeconds, DailyTurnDraft, hasSpoken, person, Person

### Community 78 - "app_logo.dart"
Cohesion: 0.17
Nodes (11): CustomPainter, AppLogo, AppLogoMark, _AppLogoMarkPainter, build, markSize, paint, shouldRepaint (+3 more)

### Community 79 - "MVVM Feature Architecture"
Cohesion: 0.20
Nodes (11): Strict Dart Analyzer Profile, Bearer Token Authentication Model, MVVM Feature Architecture, Shell And Focus Mode Navigation, Token Driven Design System, Webhook Integration Boundary, iOS Launch Screen Customization, Flutter App Manifest (+3 more)

### Community 80 - "BaseViewModel"
Cohesion: 0.22
Nodes (10): home_body.dart, BaseViewModel, build, HomeScreen, HomeViewModel, PeopleListViewModel, PersonGrowthViewModel, ../../people/repositories/person_repository.dart (+2 more)

### Community 81 - "logging_interceptor.dart"
Cohesion: 0.17
Nodes (11): Interceptor, AuthInterceptor, AppLoggingInterceptor, _logger, onError, onRequest, onResponse, _redact (+3 more)

### Community 82 - "integration_repository.dart"
Cohesion: 0.18
Nodes (10): createExternalIdentity, createSystem, getDeliveryMetrics, getExternalIdentities, getSystems, regenerateSystemToken, _service, ../models/integration_models.dart (+2 more)

### Community 83 - "access_policy.dart"
Cohesion: 0.15
Nodes (12): auth_session.dart, bool get, AccessPolicy, _authSession, canAccessRoute, canManageIntegrations, canManagePeople, canManageTeams (+4 more)

### Community 84 - "daily_timer_ring.dart"
Cohesion: 0.18
Nodes (10): ../../../core/theme/app_theme_extension.dart, allowedSeconds, build, _dailyTimerMaxDiameter, _dailyTimerOuterPadding, DailyTimerRing, _dailyTimerStrokeWidth, elapsedSeconds (+2 more)

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

### Community 90 - "daily_review_body.dart"
Cohesion: 0.20
Nodes (9): blockers, _BlockersReview, build, DailyReviewBody, topics, _TopicsReview, ../models/daily_blocker_draft.dart, ../utils/daily_stats.dart (+1 more)

### Community 91 - "app.dart"
Cohesion: 0.29
Nodes (6): ../../../core/auth/auth_session.dart, core/routing/app_router.dart, core/theme/app_theme.dart, App, build, package:flutter_localizations/flutter_localizations.dart

### Community 92 - "integration_service.dart"
Cohesion: 0.20
Nodes (9): _client, createExternalIdentity, createSystem, _get, getDeliveryMetrics, getExternalIdentities, getSystems, _post (+1 more)

### Community 93 - "person_form_view_model.dart"
Cohesion: 0.11
Nodes (17): hasPeople, load, _people, _query, _repository, search, teamId, createPerson (+9 more)

### Community 94 - "person_detail_view_model.dart"
Cohesion: 0.20
Nodes (9): clearInvitationToken, createInvitationToken, _invitationErrorMessage, _invitationToken, load, _person, personId, _repository (+1 more)

### Community 95 - "daily_meeting_detail_view_model.dart"
Cohesion: 0.22
Nodes (8): DailyMeeting? get, DailyMeeting, load, _meeting, meetingId, _repository, ../models/daily_meeting.dart, ../repositories/daily_meeting_repository.dart

### Community 96 - "daily_meeting_repository_test.dart"
Cohesion: 0.20
Nodes (9): DailyMeetingService, package:for_tech_lead/features/daily/repositories/daily_meeting_repository.dart, package:for_tech_lead/features/daily/services/daily_meeting_service.dart, _entryJson, main, _meetingJson, _MockDailyMeetingService, repository (+1 more)

### Community 97 - "AuthSession"
Cohesion: 0.29
Nodes (6): ../auth/auth_session.dart, ChangeNotifier, AuthSession, _authSession, onError, onRequest

### Community 98 - "static const"
Cohesion: 0.22
Nodes (7): apiBaseUrl, Env, AppRadius, lg, md, sm, static const

### Community 99 - "List"
Cohesion: 0.22
Nodes (8): AppDropdownField, build, errorText, items, label, onChanged, value, List

### Community 100 - "daily_time_limit.dart"
Cohesion: 0.22
Nodes (8): dailyTimeLimitMinSeconds, dailyTimeLimitStepSeconds, formatDailyDuration, isValidDailyTimeLimit, minutes, remainingSeconds, seconds, sign

### Community 101 - "app_dialog_actions.dart"
Cohesion: 0.22
Nodes (8): app_primary_button.dart, AppDialogActions, build, onPrimaryPressed, onSecondaryPressed, primaryLabel, primaryLoading, secondaryLabel

### Community 102 - "daily_meeting_repository.dart"
Cohesion: 0.22
Nodes (8): createMeeting, getAllEntries, getMeeting, getMeetings, _maxStatsPages, _service, ../models/daily_meeting_entry.dart, ../services/daily_meeting_service.dart

### Community 103 - "person_growth_view_model_test.dart"
Cohesion: 0.25
Nodes (7): class _MockPersonGrowthRepository extends, _MockPersonGrowthRepository, package:for_tech_lead/features/people/models/person_growth_models.dart, package:for_tech_lead/features/people/viewmodels/person_growth_view_model.dart, main, Mock, repository

### Community 104 - "notifications_view_model_test.dart"
Cohesion: 0.22
Nodes (8): NotificationsViewModel, _MockNotificationRepository, package:for_tech_lead/features/notifications/viewmodels/notifications_view_model.dart, main, Mock, _notification, repository, viewModel

### Community 105 - "package:dio/dio.dart"
Cohesion: 0.25
Nodes (7): _client, destroy, index, show, store, update, package:dio/dio.dart

### Community 106 - "_"
Cohesion: 0.29
Nodes (8): ../../features/daily/models/daily_cue.dart, _, assetPath, byCue, DailyCueSound, DailyCueSoundTheme, ticking, volume

### Community 107 - "package:flutter/material.dart"
Cohesion: 0.12
Nodes (12): ElevatedButton, build, LoadingView, package:flutter/material.dart, package:for_tech_lead/core/widgets/branding/app_logo.dart, package:for_tech_lead/core/widgets/buttons/app_dialog_actions.dart, package:for_tech_lead/core/widgets/buttons/app_primary_button.dart, package:for_tech_lead/core/widgets/cards/app_summary_card.dart (+4 more)

### Community 108 - "app_theme_extension.dart"
Cohesion: 0.29
Nodes (6): Color, border, copyWith, lerp, success, warning

### Community 109 - "breakpoints.dart"
Cohesion: 0.29
Nodes (6): Breakpoints, isDesktop, isMobile, mobile, tablet, package:flutter/widgets.dart

### Community 110 - "app_spacing.dart"
Cohesion: 0.29
Nodes (6): AppSpacing, lg, md, sm, xl, xs

### Community 111 - "person_growth_repository_test.dart"
Cohesion: 0.25
Nodes (7): package:for_tech_lead/features/people/repositories/person_growth_repository.dart, package:for_tech_lead/features/people/services/person_growth_service.dart, main, _planJson, repository, service, _sessionJson

### Community 112 - "daily_blocker_draft.dart"
Cohesion: 0.33
Nodes (5): DailyBlockerDraft, resolved, text, toggleResolved, addBlocker

### Community 113 - "birthday_util.dart"
Cohesion: 0.33
Nodes (5): _dateOnly, daysUntilNextBirthday, difference, next, today

### Community 114 - "../../../core/network/api_exception.dart"
Cohesion: 0.29
Nodes (6): ../../../core/network/api_exception.dart, _client, index, indexEntries, show, store

### Community 115 - "profile_view_model.dart"
Cohesion: 0.17
Nodes (11): AppUser? get, ../../auth/models/app_user.dart, ../../auth/repositories/auth_repository.dart, AppUser, _authRepository, load, _loadLinkedPerson, _person (+3 more)

### Community 116 - "package:provider/provider.dart"
Cohesion: 0.07
Nodes (35): accept_invitation_form.dart, app.dart, bootstrap.dart, ../../../core/theme/app_spacing.dart, ../../../core/widgets/navigation/app_page_header.dart, ../../../core/widgets/states/error_view.dart, ../../../core/widgets/states/loading_view.dart, daily_history_body.dart (+27 more)

### Community 117 - "Linux Relocatable Bundle Build"
Cohesion: 0.67
Nodes (4): Linux Relocatable Bundle Build, Linux GTK Runner Target, Windows In Place Runtime Bundle, Windows Desktop Runner Target

### Community 118 - "adaptive_scaffold_test.dart"
Cohesion: 0.33
Nodes (5): NavigationBar, package:for_tech_lead/core/responsive/adaptive_scaffold.dart, destinations, main, pumpScaffold

### Community 120 - "notification_repository_test.dart"
Cohesion: 0.33
Nodes (5): package:for_tech_lead/features/notifications/repositories/notification_repository.dart, package:for_tech_lead/features/notifications/services/notification_service.dart, main, repository, service

### Community 129 - "DioClient"
Cohesion: 0.40
Nodes (4): DioClient, _client, _get, getNotifications

### Community 130 - "DailyEntryStatus"
Cohesion: 0.40
Nodes (4): apiValue, DailyEntryStatus, fromApiValue, label

### Community 131 - "Equatable"
Cohesion: 0.18
Nodes (11): Equatable, DailyMeetingAnnotation, DailyMeetingEntry, DailyPersonRanking, DeliveryMetricsPage, IntegrationSystem, PersonDeliveryMetric, PersonExternalIdentity (+3 more)

### Community 132 - "IntegrationsViewModel"
Cohesion: 0.50
Nodes (4): build, _IntegrationsBody, _IntegrationsBodyState, IntegrationsViewModel

### Community 133 - "PersonGrowthRepository"
Cohesion: 0.50
Nodes (4): PersonGrowthRepository, _MockPersonGrowthRepository, _MockPersonGrowthRepository, _MockPersonGrowthRepository

### Community 134 - "AppThemeExtension"
Cohesion: 1.00
Nodes (3): @immutable, AppThemeExtension, ThemeExtension

### Community 138 - "contract_type.dart"
Cohesion: 0.40
Nodes (4): apiValue, ContractType, fromApiValue, label

### Community 139 - "seniority_level.dart"
Cohesion: 0.40
Nodes (4): apiValue, fromApiValue, label, SeniorityLevel

## Knowledge Gaps
- **1468 isolated node(s):** `build`, `getIt`, `authSession`, `configureDependencies`, `restore` (+1463 more)
  These have ≤1 connection - possible missing edges or undocumented components.
- **6 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `PersonRepository` connect `Mock` to `daily_session_view_model.dart`, `integrations_screen.dart`, `one_on_ones_view_model_test.dart`, `integrations_view_model.dart`, `person_detail_body_layout_test.dart`, `integrations_view_model_test.dart`, `profile_screen.dart`, `bootstrap.dart`, `one_on_ones_screen.dart`, `daily_session_screen.dart`, `home_view_model.dart`, `daily_history_view_model.dart`, `one_on_ones_view_model.dart`, `BaseViewModel`, `person_repository.dart`, `person_form_view_model.dart`, `person_detail_view_model.dart`, `profile_view_model.dart`, `package:provider/provider.dart`?**
  _High betweenness centrality (0.055) - this node is a cross-community bridge._
- **Why does `DailyMeetingRepository` connect `Mock` to `daily_history_view_model.dart`, `daily_session_view_model.dart`, `daily_meeting_repository_test.dart`, `daily_session_screen.dart`, `daily_meeting_repository.dart`, `package:provider/provider.dart`, `bootstrap.dart`, `daily_meeting_detail_view_model.dart`?**
  _High betweenness centrality (0.020) - this node is a cross-community bridge._
- **Why does `TeamRepository` connect `Mock` to `daily_session_view_model.dart`, `daily_session_screen.dart`, `home_view_model.dart`, `BaseViewModel`, `teams_list_screen.dart`, `team_members_section.dart`, `team_detail_view_model.dart`, `package:mocktail/mocktail.dart`, `bootstrap.dart`?**
  _High betweenness centrality (0.020) - this node is a cross-community bridge._
- **What connects `build`, `getIt`, `authSession` to the rest of the system?**
  _1468 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Should `person_detail_body.dart` be split into smaller, more focused modules?**
  _Cohesion score 0.024691358024691357 - nodes in this community are weakly interconnected._
- **Should `daily_session_view_model.dart` be split into smaller, more focused modules?**
  _Cohesion score 0.03333333333333333 - nodes in this community are weakly interconnected._
- **Should `Win32Window` be split into smaller, more focused modules?**
  _Cohesion score 0.05217391304347826 - nodes in this community are weakly interconnected._