# Graph Report - frontend  (2026-09-13)

## Corpus Check
- 195 files · ~63,750 words
- Verdict: corpus is large enough that graph structure adds value.

## Summary
- 2565 nodes · 3901 edges · 131 communities (125 shown, 6 thin omitted)
- Extraction: 99% EXTRACTED · 1% INFERRED · 0% AMBIGUOUS · INFERRED: 27 edges (avg confidence: 0.81)
- Token cost: 0 input · 0 output

## Graph Freshness
- Built from commit: `c804b314`
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
- integrations_view_model_test.dart
- daily_config_body.dart
- integration_models.dart
- Mock
- route_paths.dart
- profile_screen.dart
- package:flutter_test/flutter_test.dart
- daily_session_view_model_test.dart
- package:mocktail/mocktail.dart
- bootstrap.dart
- my_application.cc
- one_on_ones_screen.dart
- app_router.dart
- api_exception.dart
- register_form.dart
- daily_session_screen.dart
- app_text_field.dart
- notifications_view_model.dart
- team_members_section.dart
- daily_meeting_annotation.dart
- auth_repository_test.dart
- daily_history_body.dart
- IconData
- adaptive_scaffold.dart
- daily_review_body.dart
- person_service.dart
- person_growth_service.dart
- team_detail_view_model.dart
- app_theme.dart
- DailySessionViewModel
- people_list_view_model.dart
- person_growth_repository.dart
- home_body.dart
- package:provider/provider.dart
- daily_meeting_entry.dart
- daily_config_body_test.dart
- auth_session.dart
- daily_running_body_test.dart
- daily_cue_player.dart
- dio_client.dart
- NotificationRepository
- VoidCallback?
- daily_meeting.dart
- daily_history_view_model.dart
- person_detail_screen.dart
- auth_repository.dart
- one_on_ones_view_model.dart
- State
- auth_service.dart
- login_form.dart
- daily_meeting_detail_body.dart
- person_detail_view_model.dart
- team_detail_screen.dart
- app_user.dart
- team.dart
- app_typography.dart
- person_form_screen.dart
- app_logo.dart
- MVVM Feature Architecture
- home_view_model.dart
- package:dio/dio.dart
- ../../people/models/person.dart
- access_policy.dart
- daily_timer_ring.dart
- base_view_model.dart
- person_repository.dart
- package:flutter/material.dart
- manifest.json
- DateTime
- teams_list_screen.dart
- ../../../core/viewmodels/base_view_model.dart
- integration_service.dart
- integration_repository.dart
- person_form_view_model.dart
- daily_meeting_detail_view_model.dart
- accept_invitation_form.dart
- static const
- List
- daily_time_limit.dart
- app_dialog_actions.dart
- daily_meeting_repository.dart
- one_on_ones_view_model_test.dart
- notifications_view_model_test.dart
- ../../../core/network/api_exception.dart
- _
- app_theme_extension.dart
- breakpoints.dart
- app_spacing.dart
- daily_blocker_draft.dart
- birthday_util.dart
- BaseViewModel
- Linux Relocatable Bundle Build
- adaptive_scaffold_test.dart
- MainActivity.kt
- contract_type.dart
- daily_cue.dart
- DailySessionPhase
- @example
- String?
- team_repository.dart
- DailyEntryStatus
- Equatable
- teams_list_view_model.dart
- seniority_level.dart
- OneOnOnesViewModel
- _tabBody

## God Nodes (most connected - your core abstractions)
1. `PersonRepository` - 38 edges
2. `DailySessionViewModel` - 22 edges
3. `Win32Window` - 22 edges
4. `BaseViewModel` - 20 edges
5. `TeamRepository` - 19 edges
6. `AuthRepository` - 14 edges
7. `DailyMeetingRepository` - 14 edges
8. `AuthSession` - 13 edges
9. `Person` - 13 edges
10. `PersonGrowthRepository` - 13 edges

## Surprising Connections (you probably didn't know these)
- `Flutter Starter Template` --semantically_similar_to--> `MVVM Feature Architecture`  [INFERRED] [semantically similar]
  README.md → CLAUDE.md
- `Linux Relocatable Bundle Build` --semantically_similar_to--> `Windows In Place Runtime Bundle`  [INFERRED] [semantically similar]
  linux/CMakeLists.txt → windows/CMakeLists.txt
- `Linux GTK Runner Target` --semantically_similar_to--> `Windows Desktop Runner Target`  [INFERRED] [semantically similar]
  linux/runner/CMakeLists.txt → windows/runner/CMakeLists.txt
- `MVVM Feature Architecture` --conceptually_related_to--> `Strict Dart Analyzer Profile`  [INFERRED]
  CLAUDE.md → analysis_options.yaml
- `_MockAuthRepository` --implements--> `AuthRepository`  [EXTRACTED]
  test/features/auth/viewmodels/register_view_model_test.dart → lib/features/auth/repositories/auth_repository.dart

## Import Cycles
- None detected.

## Hyperedges (group relationships)
- **Frontend Multi Platform Delivery Surface** — frontend_pubspec_flutter_app_manifest, frontend_ios_runner_assets_xcassets_launchimage_imageset_ios_launch_screen_customization, frontend_linux_cmakelists_linux_relocatable_bundle_build, frontend_web_index_flutter_web_bootstrap_shell, frontend_windows_cmakelists_windows_in_place_runtime_bundle [INFERRED 0.75]
- **Frontend Application Architecture** — frontend_claude_mvvm_feature_architecture, frontend_claude_token_driven_design_system, frontend_claude_shell_and_focus_mode_navigation, frontend_claude_bearer_token_authentication_model, frontend_claude_webhook_integration_boundary [INFERRED 0.85]

## Communities (131 total, 6 thin omitted)

### Community 0 - "person_detail_body.dart"
Cohesion: 0.02
Nodes (86): ../../daily/screens/person_daily_section.dart, Iterable, actionErrorMessage, _availableWidth, canGenerateAccessToken, canManageGrowth, canShowOneOnOne, child (+78 more)

### Community 1 - "daily_session_view_model.dart"
Cohesion: 0.03
Nodes (59): DailySessionPhase get, DailyTurnDraft? get, addTopic, _beginCurrentTurn, _blockers, canGoToPreviousTurn, clearCue, clearSelection (+51 more)

### Community 2 - "Win32Window"
Cohesion: 0.05
Nodes (60): _In_, _In_opt_, Point, RECT, Size, unique_ptr, vector, DartProject (+52 more)

### Community 3 - "integrations_screen.dart"
Cohesion: 0.03
Nodes (70): ../../../core/responsive/breakpoints.dart, dart:convert, build, child, children, _confirmSystemDeletion, _confirmTokenRegeneration, _confirmWebhookEventArchive (+62 more)

### Community 4 - "generate_daily_sounds.dart"
Cohesion: 0.04
Nodes (49): dart:io, dart:math, dart:typed_data, required double decay,
  double, required double durationSeconds,
  double, required double releaseSeconds,
  double, bitsPerSample, blockAlign (+41 more)

### Community 5 - "daily_stats.dart"
Cohesion: 0.11
Nodes (17): averageActualSeconds, burnedPercentage, byPerson, computeDailyStatsSummary, computeDraftStatus, countWithStatus, DailyPersonRanking, dailySpokeTooLittleRatio (+9 more)

### Community 6 - "home_view_model_test.dart"
Cohesion: 0.06
Nodes (40): PeopleListViewModel, _MockPersonRepository, package:for_tech_lead/core/routing/route_paths.dart, package:for_tech_lead/core/viewmodels/base_view_model.dart, package:for_tech_lead/features/daily/viewmodels/person_daily_stats_view_model.dart, package:for_tech_lead/features/home/screens/home_body.dart, package:for_tech_lead/features/home/viewmodels/home_view_model.dart, package:for_tech_lead/features/people/models/contract_type.dart (+32 more)

### Community 7 - "integrations_view_model.dart"
Cohesion: 0.04
Nodes (54): actionErrorMessage, archiveWebhookEvent, changeIdentitiesPage, changeMetricsPage, changeSystemsPage, changeWebhookEventsPage, clearActionError, clearWebhookEventFilters (+46 more)

### Community 8 - "person_growth_view_model.dart"
Cohesion: 0.05
Nodes (42): DeliveryKpiSummary, actionErrorMessage, canManageGrowth, clearActionError, createPlan, createPlanItem, createSession, createTemplate (+34 more)

### Community 9 - "person_form.dart"
Cohesion: 0.06
Nodes (33): ../../../core/widgets/inputs/app_date_field.dart, ../../../core/widgets/inputs/app_dropdown_field.dart, _admissionDate, _admissionDateError, _birthDate, _birthDateError, _clickupUserIdController, _clickupUserIdError (+25 more)

### Community 10 - "person_growth_models.dart"
Cohesion: 0.03
Nodes (58): actionItems, active, answers, associatedCases, associationRate, blockedHours, body, casesInScope (+50 more)

### Community 11 - "person_detail_body_layout_test.dart"
Cohesion: 0.06
Nodes (35): package:for_tech_lead/features/people/screens/person_detail_body.dart, package:for_tech_lead/features/people/screens/person_detail_screen.dart, PersonGrowthRepository? growthRepository,
  bool, canGenerateAccessToken, _deliveryKpis, ensureVisible, _expectAnalysisSpacing, _expectOneOnOneHistorySpacing (+27 more)

### Community 12 - "AppDelegate"
Cohesion: 0.07
Nodes (23): Any, Cocoa, Flutter, FlutterAppDelegate, FlutterImplicitEngineBridge, FlutterImplicitEngineDelegate, FlutterMacOS, FlutterSceneDelegate (+15 more)

### Community 13 - "StatelessWidget"
Cohesion: 0.04
Nodes (53): _ActionErrorBanner, _CopyableValue, _DetailItem, _EmptyPanel, _FormColumn, _GeneratedCodeHint, _IdentityTile, _InlinePagination (+45 more)

### Community 14 - "person.dart"
Cohesion: 0.07
Nodes (26): contract_type.dart, admissionDate, age, averageActualSeconds, birthDate, burnedPercentage, clickupUserId, contractType (+18 more)

### Community 15 - "daily_running_body.dart"
Cohesion: 0.06
Nodes (34): daily_timer_ring.dart, addTooltip, allowedSeconds, _AnnotationComposer, _annotationController, _annotationKind, blockers, controller (+26 more)

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
Cohesion: 0.06
Nodes (31): accent, accentDark, AppColors, background, backgroundDark, border, borderDark, error (+23 more)

### Community 20 - "daily_meeting_detail_body_test.dart"
Cohesion: 0.05
Nodes (38): class _MockDailyMeetingRepository extends, _MockDailyMeetingRepository, package:for_tech_lead/features/daily/models/daily_annotation_type.dart, package:for_tech_lead/features/daily/models/daily_entry_status.dart, package:for_tech_lead/features/daily/models/daily_meeting_annotation.dart, package:for_tech_lead/features/daily/models/daily_meeting.dart, package:for_tech_lead/features/daily/models/daily_meeting_entry.dart, package:for_tech_lead/features/daily/screens/daily_meeting_detail_body.dart (+30 more)

### Community 21 - "integrations_view_model_test.dart"
Cohesion: 0.10
Nodes (22): class _MockIntegrationRepository extends, IntegrationRepository, _MockIntegrationRepository, package:for_tech_lead/features/integrations/models/integration_models.dart, package:for_tech_lead/features/integrations/repositories/integration_repository.dart, package:for_tech_lead/features/integrations/screens/integrations_screen.dart, package:for_tech_lead/features/integrations/services/integration_service.dart, package:for_tech_lead/features/integrations/viewmodels/integrations_view_model.dart (+14 more)

### Community 22 - "daily_config_body.dart"
Cohesion: 0.08
Nodes (25): ../../../core/widgets/inputs/app_search_field.dart, canDrag, canReorder, _ConfigHeader, createState, _dailyConfigInnerGap, _dailyConfigOuterGap, dispose (+17 more)

### Community 23 - "integration_models.dart"
Cohesion: 0.04
Nodes (44): active, createdAt, currentPage, _date, deliveryMetrics, deliveryMetricsCount, description, eventId (+36 more)

### Community 24 - "Mock"
Cohesion: 0.11
Nodes (31): DailyMeetingRepository, PersonRepository, PersonService, TeamRepository, Mock, _MockDailyMeetingRepository, _MockPersonRepository, _MockTeamRepository (+23 more)

### Community 25 - "route_paths.dart"
Cohesion: 0.07
Nodes (27): acceptInvitation, dailyHistory, dailyHistoryPath, dailyMeetingDetail, dailyMeetingDetailPath, dailySession, dailySessionPath, home (+19 more)

### Community 26 - "profile_screen.dart"
Cohesion: 0.09
Nodes (23): AppUser? get, AsyncCallback, ../../auth/models/app_user.dart, ../../auth/repositories/auth_repository.dart, build, _edit, _MissingPersonProfile, onSaved (+15 more)

### Community 27 - "package:flutter_test/flutter_test.dart"
Cohesion: 0.07
Nodes (29): _MockTeamRepository, package:flutter_test/flutter_test.dart, package:for_tech_lead/core/theme/app_theme.dart, package:for_tech_lead/core/widgets/tables/app_data_table.dart, package:for_tech_lead/features/daily/utils/daily_time_limit.dart, package:for_tech_lead/features/people/utils/birthday_util.dart, package:for_tech_lead/features/teams/models/team.dart, package:for_tech_lead/features/teams/repositories/team_repository.dart (+21 more)

### Community 28 - "daily_session_view_model_test.dart"
Cohesion: 0.12
Nodes (14): package:fake_async/fake_async.dart, package:for_tech_lead/core/feedback/daily_cue_sound_theme.dart, package:for_tech_lead/features/daily/models/daily_cue.dart, package:for_tech_lead/features/daily/models/daily_session_phase.dart, package:for_tech_lead/features/daily/viewmodels/daily_session_view_model.dart, main, main, meetingRepository (+6 more)

### Community 29 - "package:mocktail/mocktail.dart"
Cohesion: 0.08
Nodes (26): _MockAuthRepository, package:for_tech_lead/features/auth/models/app_user.dart, package:for_tech_lead/features/auth/repositories/auth_repository.dart, package:for_tech_lead/features/auth/viewmodels/login_view_model.dart, package:for_tech_lead/features/auth/viewmodels/register_view_model.dart, package:for_tech_lead/features/notifications/services/notification_service.dart, package:for_tech_lead/features/profile/viewmodels/profile_view_model.dart, package:mocktail/mocktail.dart (+18 more)

### Community 30 - "bootstrap.dart"
Cohesion: 0.09
Nodes (22): core/storage/token_storage.dart, features/auth/repositories/auth_repository.dart, features/auth/services/auth_service.dart, features/daily/repositories/daily_meeting_repository.dart, features/daily/services/daily_meeting_service.dart, features/integrations/repositories/integration_repository.dart, features/integrations/services/integration_service.dart, features/notifications/repositories/notification_repository.dart (+14 more)

### Community 31 - "my_application.cc"
Cohesion: 0.11
Nodes (20): FlView, GApplication, gboolean, gchar, GObject, GtkApplication, main(), first_frame_cb() (+12 more)

### Community 32 - "one_on_ones_screen.dart"
Cohesion: 0.03
Nodes (68): InputDecoration, _ActionErrorBanner, child, children, controller, _createDocument, _createPoint, createState (+60 more)

### Community 33 - "app_router.dart"
Cohesion: 0.05
Nodes (35): ../auth/access_policy.dart, ../branding/app_logo.dart, ../../features/auth/screens/accept_invitation_screen.dart, ../../features/auth/screens/login_screen.dart, ../../features/auth/screens/register_screen.dart, ../../features/daily/screens/daily_history_screen.dart, ../../features/daily/screens/daily_meeting_detail_screen.dart, ../../features/daily/screens/daily_session_screen.dart (+27 more)

### Community 34 - "api_exception.dart"
Cohesion: 0.13
Nodes (21): Exception, ApiException, bodyMessage, data, errors, _firstMessage, ForbiddenException, mapDioException (+13 more)

### Community 35 - "register_form.dart"
Cohesion: 0.21
Nodes (11): build, createState, dispose, _emailController, _nameController, _passwordConfirmationController, _passwordController, RegisterForm (+3 more)

### Community 36 - "daily_session_screen.dart"
Cohesion: 0.11
Nodes (17): ../../../core/feedback/daily_cue_player.dart, daily_config_body.dart, daily_review_body.dart, daily_running_body.dart, _confirmExit, createState, _cuePlayer, _DailyFinishedBody (+9 more)

### Community 37 - "app_text_field.dart"
Cohesion: 0.12
Nodes (16): AppSearchField, build, controller, hintText, onChanged, AppTextField, build, controller (+8 more)

### Community 38 - "notifications_view_model.dart"
Cohesion: 0.14
Nodes (13): changePage, clearPageError, isChangingPage, lastPage, load, _loadPage, notifications, page (+5 more)

### Community 39 - "team_members_section.dart"
Cohesion: 0.13
Nodes (14): ../../../core/widgets/buttons/app_primary_button.dart, ../../../core/widgets/tables/app_data_table.dart, TeamDetailBody, build, _InlinePagination, lastPage, loading, onNext (+6 more)

### Community 40 - "daily_meeting_annotation.dart"
Cohesion: 0.11
Nodes (17): daily_annotation_type.dart, apiValue, DailyAnnotationType, fromApiValue, label, createdAt, DailyMeetingAnnotation, dailyMeetingId (+9 more)

### Community 41 - "auth_repository_test.dart"
Cohesion: 0.07
Nodes (29): FlutterSecureStorage, delete, _personIdKey, read, readPersonId, readRole, _roleKey, _storage (+21 more)

### Community 42 - "daily_history_body.dart"
Cohesion: 0.11
Nodes (21): ../../../core/widgets/cards/app_summary_card.dart, daily_history_body.dart, build, createState, DailyHistoryBody, _DailyHistoryBodyState, _dateFormat, _HistorySummaryCard (+13 more)

### Community 43 - "IconData"
Cohesion: 0.12
Nodes (15): IconData, AppSummaryCard, build, icon, label, value, AppKeyValueRow, build (+7 more)

### Community 44 - "adaptive_scaffold.dart"
Cohesion: 0.11
Nodes (17): breakpoints.dart, AdaptiveScaffold, AppNavDestination, build, child, destinations, _hasNav, icon (+9 more)

### Community 45 - "daily_review_body.dart"
Cohesion: 0.20
Nodes (9): blockers, _BlockersReview, build, DailyReviewBody, topics, _TopicsReview, ../models/daily_blocker_draft.dart, ../utils/daily_stats.dart (+1 more)

### Community 46 - "person_service.dart"
Cohesion: 0.20
Nodes (9): _client, createInvitation, _dateFormat, index, show, showMe, store, update (+1 more)

### Community 47 - "person_growth_service.dart"
Cohesion: 0.10
Nodes (20): _client, createDevelopmentPlan, createDevelopmentPlanItem, createPersonOneOnOneNote, createSession, createTemplate, _dateFormat, _get (+12 more)

### Community 48 - "team_detail_view_model.dart"
Cohesion: 0.12
Nodes (16): changeMembersPage, hasMembers, isChangingMembersPage, load, members, membersErrorMessage, membersLastPage, membersPage (+8 more)

### Community 49 - "app_theme.dart"
Cohesion: 0.18
Nodes (10): app_colors.dart, app_radius.dart, app_spacing.dart, app_theme_extension.dart, app_typography.dart, AppTheme, _build, dark (+2 more)

### Community 50 - "DailySessionViewModel"
Cohesion: 0.20
Nodes (10): build, _PeoplePicker, _TeamSelector, _TimeLimitControl, _AnnotationList, build, _LiveHeader, build (+2 more)

### Community 51 - "people_list_view_model.dart"
Cohesion: 0.22
Nodes (8): hasPeople, load, _people, _query, _repository, search, teamId, ../models/person.dart

### Community 52 - "person_growth_repository.dart"
Cohesion: 0.09
Nodes (21): ../../integrations/models/integration_models.dart, createDevelopmentPlan, createDevelopmentPlanItem, createPersonOneOnOneNote, createSession, createTemplate, getDeliveryKpis, getDeliveryMetrics (+13 more)

### Community 53 - "home_body.dart"
Cohesion: 0.10
Nodes (20): _historyLink, _BirthdayCard, build, _DailyCallout, _daysUntilLabel, HomeBody, _homeInnerGap, _homeOuterGap (+12 more)

### Community 54 - "package:provider/provider.dart"
Cohesion: 0.11
Nodes (17): accept_invitation_form.dart, app.dart, bootstrap.dart, ../../../core/theme/app_spacing.dart, AcceptInvitationScreen, build, build, LoginScreen (+9 more)

### Community 55 - "daily_meeting_entry.dart"
Cohesion: 0.12
Nodes (15): daily_entry_status.dart, actualSeconds, allottedSeconds, createdAt, DailyMeetingEntry, dailyMeetingId, fromJson, id (+7 more)

### Community 56 - "daily_config_body_test.dart"
Cohesion: 0.09
Nodes (21): DailyMeetingService, package:for_tech_lead/features/daily/repositories/daily_meeting_repository.dart, package:for_tech_lead/features/daily/screens/daily_config_body.dart, package:for_tech_lead/features/daily/services/daily_meeting_service.dart, _entryJson, main, _meetingJson, _MockDailyMeetingService (+13 more)

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

### Community 61 - "NotificationRepository"
Cohesion: 0.25
Nodes (7): getNotifications, NotificationRepository, _service, ../models/external_notification.dart, ../services/notification_service.dart, _MockNotificationRepository, _MockNotificationRepository

### Community 62 - "VoidCallback?"
Cohesion: 0.14
Nodes (12): ../buttons/app_primary_button.dart, AppPrimaryButton, AppSecondaryButton, build, label, loading, onPressed, build (+4 more)

### Community 63 - "daily_meeting.dart"
Cohesion: 0.14
Nodes (13): daily_meeting_annotation.dart, daily_meeting_entry.dart, annotations, createdAt, endedAt, entries, fromJson, id (+5 more)

### Community 64 - "daily_history_view_model.dart"
Cohesion: 0.14
Nodes (13): DailyStatsSummary get, DailyStatsSummary, load, _meetings, _namesByPersonId, personName, _personRepository, _rankings (+5 more)

### Community 65 - "person_detail_screen.dart"
Cohesion: 0.22
Nodes (10): build, _PersonHeader, build, PersonDetailScreen, personId, PersonDetailViewModel, person_detail_body.dart, ../repositories/person_growth_repository.dart (+2 more)

### Community 66 - "auth_repository.dart"
Cohesion: 0.10
Nodes (20): ChangeNotifier, ../../../core/auth/auth_session.dart, core/routing/app_router.dart, core/theme/app_theme.dart, App, build, AuthSession, acceptPersonInvitation (+12 more)

### Community 67 - "one_on_ones_view_model.dart"
Cohesion: 0.06
Nodes (34): actionErrorMessage, canManageOneOnOnes, clearActionError, completedSessions, createPersonNote, createTemplate, currentPersonId, executeSession (+26 more)

### Community 68 - "State"
Cohesion: 0.23
Nodes (12): AppDataTable, _AppDataTableState, DailyConfigBody, _DailyConfigBodyState, DailyRunningBody, _DailyRunningBodyState, _DailySessionView, _DailySessionViewState (+4 more)

### Community 69 - "auth_service.dart"
Cohesion: 0.22
Nodes (8): acceptPersonInvitation, AuthService, _client, login, logout, me, register, _MockAuthService

### Community 70 - "login_form.dart"
Cohesion: 0.19
Nodes (12): ../../../core/widgets/branding/app_logo.dart, build, createState, dispose, _emailController, LoginForm, _LoginFormState, _passwordController (+4 more)

### Community 71 - "daily_meeting_detail_body.dart"
Cohesion: 0.12
Nodes (16): annotations, _AnnotationsSection, build, DailyMeetingDetailBody, _dateFormat, entries, _EntriesList, entry (+8 more)

### Community 72 - "person_detail_view_model.dart"
Cohesion: 0.20
Nodes (9): clearInvitationToken, createInvitationToken, _invitationErrorMessage, _invitationToken, load, _person, personId, _repository (+1 more)

### Community 73 - "team_detail_screen.dart"
Cohesion: 0.28
Nodes (8): build, TeamDetailScreen, teamId, TeamDetailViewModel, ../repositories/team_repository.dart, RoutePaths.personCreatePath, team_detail_body.dart, team_members_section.dart

### Community 74 - "app_user.dart"
Cohesion: 0.14
Nodes (13): AppUser, createdAt, email, fromJson, id, isMember, isTechLead, name (+5 more)

### Community 75 - "team.dart"
Cohesion: 0.15
Nodes (12): createdAt, fromJson, id, name, people, peopleLastPage, peoplePage, peoplePerPage (+4 more)

### Community 76 - "app_typography.dart"
Cohesion: 0.14
Nodes (13): AppTypography, bodyLarge, bodyMedium, bodySmall, displaySmall, _inter, labelLarge, labelMedium (+5 more)

### Community 77 - "person_form_screen.dart"
Cohesion: 0.20
Nodes (11): build, appBarTitle, build, PersonFormScreen, personId, teamId, _submit, PersonFormViewModel (+3 more)

### Community 78 - "app_logo.dart"
Cohesion: 0.17
Nodes (11): CustomPainter, AppLogo, AppLogoMark, _AppLogoMarkPainter, build, markSize, paint, shouldRepaint (+3 more)

### Community 79 - "MVVM Feature Architecture"
Cohesion: 0.20
Nodes (11): Strict Dart Analyzer Profile, Bearer Token Authentication Model, MVVM Feature Architecture, Shell And Focus Mode Navigation, Token Driven Design System, Webhook Integration Boundary, iOS Launch Screen Customization, Flutter App Manifest (+3 more)

### Community 80 - "home_view_model.dart"
Cohesion: 0.11
Nodes (19): ../../../core/widgets/states/error_view.dart, home_body.dart, build, HomeScreen, firstTeamId, HomeViewModel, load, _peopleCount (+11 more)

### Community 81 - "package:dio/dio.dart"
Cohesion: 0.12
Nodes (16): ../auth/auth_session.dart, Interceptor, AuthInterceptor, _authSession, onError, onRequest, AppLoggingInterceptor, _logger (+8 more)

### Community 82 - "../../people/models/person.dart"
Cohesion: 0.15
Nodes (12): ../../../core/routing/route_paths.dart, ../../../core/widgets/data/app_key_value_row.dart, build, _DailyStatsContent, PersonDailySection, stats, teamId, setStats (+4 more)

### Community 83 - "access_policy.dart"
Cohesion: 0.17
Nodes (11): auth_session.dart, AccessPolicy, _authSession, canAccessRoute, canManageIntegrations, canManagePeople, canManageTeams, canReadNotifications (+3 more)

### Community 84 - "daily_timer_ring.dart"
Cohesion: 0.15
Nodes (13): @immutable, ../../../core/theme/app_theme_extension.dart, AppThemeExtension, allowedSeconds, build, _dailyTimerMaxDiameter, _dailyTimerOuterPadding, DailyTimerRing (+5 more)

### Community 85 - "base_view_model.dart"
Cohesion: 0.18
Nodes (10): _errorMessage, hasError, isLoading, runCatching, setState, _state, ViewState, ../network/api_exception.dart (+2 more)

### Community 86 - "person_repository.dart"
Cohesion: 0.20
Nodes (9): createInvitationToken, createPerson, getMyPerson, getPeople, getPerson, _service, updatePerson, ../models/contract_type.dart (+1 more)

### Community 87 - "package:flutter/material.dart"
Cohesion: 0.12
Nodes (12): ElevatedButton, build, LoadingView, package:flutter/material.dart, package:for_tech_lead/core/widgets/branding/app_logo.dart, package:for_tech_lead/core/widgets/buttons/app_dialog_actions.dart, package:for_tech_lead/core/widgets/buttons/app_primary_button.dart, package:for_tech_lead/core/widgets/cards/app_summary_card.dart (+4 more)

### Community 88 - "manifest.json"
Cohesion: 0.18
Nodes (10): background_color, description, display, icons, name, orientation, prefer_related_applications, short_name (+2 more)

### Community 89 - "DateTime"
Cohesion: 0.20
Nodes (9): DateTime, AppDateField, build, errorText, firstDate, label, lastDate, onChanged (+1 more)

### Community 90 - "teams_list_screen.dart"
Cohesion: 0.19
Nodes (13): ../../../core/widgets/buttons/app_dialog_actions.dart, Team, build, _createdAtFormat, TeamsListBody, build, _showCreateDialog, TeamsListScreen (+5 more)

### Community 91 - "../../../core/viewmodels/base_view_model.dart"
Cohesion: 0.19
Nodes (11): ../../../core/viewmodels/base_view_model.dart, AuthRepository, accept, _repository, login, _repository, register, _repository (+3 more)

### Community 92 - "integration_service.dart"
Cohesion: 0.12
Nodes (15): archiveWebhookEvent, _client, createExternalIdentity, createSystem, deleteSystem, _get, getDeliveryMetrics, getExternalIdentities (+7 more)

### Community 93 - "integration_repository.dart"
Cohesion: 0.13
Nodes (14): archiveWebhookEvent, createExternalIdentity, createSystem, deleteSystem, getDeliveryMetrics, getExternalIdentities, getSystems, getWebhookEvent (+6 more)

### Community 94 - "person_form_view_model.dart"
Cohesion: 0.12
Nodes (15): int?, actualSeconds, allowedSeconds, DailyTurnDraft, hasSpoken, person, Person, createPerson (+7 more)

### Community 95 - "daily_meeting_detail_view_model.dart"
Cohesion: 0.22
Nodes (8): DailyMeeting? get, DailyMeeting, load, _meeting, meetingId, _repository, ../models/daily_meeting.dart, ../repositories/daily_meeting_repository.dart

### Community 97 - "accept_invitation_form.dart"
Cohesion: 0.19
Nodes (12): ../../../core/widgets/inputs/app_text_field.dart, AcceptInvitationForm, _AcceptInvitationFormState, build, createState, dispose, _emailController, _passwordConfirmationController (+4 more)

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

### Community 103 - "one_on_ones_view_model_test.dart"
Cohesion: 0.07
Nodes (30): class _MockPersonGrowthRepository extends, PersonGrowthRepository, _MockPersonGrowthRepository, package:for_tech_lead/features/one_on_ones/screens/one_on_ones_screen.dart, package:for_tech_lead/features/one_on_ones/viewmodels/one_on_ones_view_model.dart, package:for_tech_lead/features/people/models/person_growth_models.dart, package:for_tech_lead/features/people/repositories/person_growth_repository.dart, package:for_tech_lead/features/people/repositories/person_repository.dart (+22 more)

### Community 104 - "notifications_view_model_test.dart"
Cohesion: 0.12
Nodes (16): class _MockNotificationRepository extends, NotificationsViewModel, _MockNotificationRepository, package:for_tech_lead/bootstrap.dart, package:for_tech_lead/features/notifications/models/external_notification.dart, package:for_tech_lead/features/notifications/repositories/notification_repository.dart, package:for_tech_lead/features/notifications/screens/notifications_screen.dart, package:for_tech_lead/features/notifications/viewmodels/notifications_view_model.dart (+8 more)

### Community 105 - "../../../core/network/api_exception.dart"
Cohesion: 0.12
Nodes (17): ../../../core/network/api_exception.dart, ../../../core/network/dio_client.dart, DioClient, _client, index, indexEntries, show, store (+9 more)

### Community 106 - "_"
Cohesion: 0.29
Nodes (8): ../../features/daily/models/daily_cue.dart, _, assetPath, byCue, DailyCueSound, DailyCueSoundTheme, ticking, volume

### Community 108 - "app_theme_extension.dart"
Cohesion: 0.29
Nodes (6): Color, border, copyWith, lerp, success, warning

### Community 109 - "breakpoints.dart"
Cohesion: 0.29
Nodes (6): Breakpoints, isDesktop, isMobile, mobile, tablet, package:flutter/widgets.dart

### Community 110 - "app_spacing.dart"
Cohesion: 0.29
Nodes (6): AppSpacing, lg, md, sm, xl, xs

### Community 112 - "daily_blocker_draft.dart"
Cohesion: 0.33
Nodes (5): DailyBlockerDraft, resolved, text, toggleResolved, addBlocker

### Community 113 - "birthday_util.dart"
Cohesion: 0.33
Nodes (5): _dateOnly, daysUntilNextBirthday, difference, next, today

### Community 116 - "BaseViewModel"
Cohesion: 0.20
Nodes (11): ../../../core/widgets/navigation/app_page_header.dart, ../../../core/widgets/states/loading_view.dart, daily_meeting_detail_body.dart, BaseViewModel, build, DailyMeetingDetailScreen, meetingId, DailyMeetingDetailViewModel (+3 more)

### Community 117 - "Linux Relocatable Bundle Build"
Cohesion: 0.67
Nodes (4): Linux Relocatable Bundle Build, Linux GTK Runner Target, Windows In Place Runtime Bundle, Windows Desktop Runner Target

### Community 118 - "adaptive_scaffold_test.dart"
Cohesion: 0.33
Nodes (5): NavigationBar, package:for_tech_lead/core/responsive/adaptive_scaffold.dart, destinations, main, pumpScaffold

### Community 120 - "contract_type.dart"
Cohesion: 0.40
Nodes (4): apiValue, ContractType, fromApiValue, label

### Community 129 - "team_repository.dart"
Cohesion: 0.18
Nodes (10): createTeam, deleteTeam, getTeam, getTeams, _service, updateTeam, TeamService, ../models/team.dart (+2 more)

### Community 130 - "DailyEntryStatus"
Cohesion: 0.40
Nodes (4): apiValue, DailyEntryStatus, fromApiValue, label

### Community 131 - "Equatable"
Cohesion: 0.20
Nodes (10): Equatable, DeliveryMetricsPage, IntegrationSystem, IntegrationWebhookEvent, PersonDeliveryMetric, PersonExternalIdentity, WebhookEventsPage, ExternalNotification (+2 more)

### Community 132 - "teams_list_view_model.dart"
Cohesion: 0.22
Nodes (8): bool get, createTeam, hasTeams, load, _query, _repository, search, _teams

### Community 134 - "seniority_level.dart"
Cohesion: 0.40
Nodes (4): apiValue, fromApiValue, label, SeniorityLevel

### Community 135 - "OneOnOnesViewModel"
Cohesion: 0.50
Nodes (4): build, _OneOnOnesBody, _OneOnOnesBodyState, OneOnOnesViewModel

## Knowledge Gaps
- **1565 isolated node(s):** `build`, `getIt`, `authSession`, `configureDependencies`, `restore` (+1560 more)
  These have ≤1 connection - possible missing edges or undocumented components.
- **6 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `PersonRepository` connect `Mock` to `daily_session_view_model.dart`, `integrations_screen.dart`, `home_view_model_test.dart`, `integrations_view_model.dart`, `person_detail_body_layout_test.dart`, `integrations_view_model_test.dart`, `profile_screen.dart`, `bootstrap.dart`, `one_on_ones_screen.dart`, `daily_session_screen.dart`, `daily_history_body.dart`, `people_list_view_model.dart`, `daily_history_view_model.dart`, `person_detail_screen.dart`, `one_on_ones_view_model.dart`, `person_detail_view_model.dart`, `person_form_screen.dart`, `home_view_model.dart`, `person_repository.dart`, `person_form_view_model.dart`, `one_on_ones_view_model_test.dart`?**
  _High betweenness centrality (0.068) - this node is a cross-community bridge._
- **Why does `PersonGrowthRepository` connect `one_on_ones_view_model_test.dart` to `one_on_ones_screen.dart`, `person_detail_screen.dart`, `one_on_ones_view_model.dart`, `person_growth_view_model.dart`, `person_detail_body_layout_test.dart`, `person_growth_repository.dart`, `bootstrap.dart`?**
  _High betweenness centrality (0.024) - this node is a cross-community bridge._
- **Why does `DailyMeetingRepository` connect `Mock` to `daily_history_view_model.dart`, `daily_session_view_model.dart`, `daily_session_screen.dart`, `daily_meeting_repository.dart`, `daily_history_body.dart`, `BaseViewModel`, `daily_config_body_test.dart`, `bootstrap.dart`, `daily_meeting_detail_view_model.dart`?**
  _High betweenness centrality (0.020) - this node is a cross-community bridge._
- **What connects `build`, `getIt`, `authSession` to the rest of the system?**
  _1565 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Should `person_detail_body.dart` be split into smaller, more focused modules?**
  _Cohesion score 0.022988505747126436 - nodes in this community are weakly interconnected._
- **Should `daily_session_view_model.dart` be split into smaller, more focused modules?**
  _Cohesion score 0.03333333333333333 - nodes in this community are weakly interconnected._
- **Should `Win32Window` be split into smaller, more focused modules?**
  _Cohesion score 0.05217391304347826 - nodes in this community are weakly interconnected._