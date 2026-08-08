# CLAUDE.md

Guidance for Claude Code (and other AI agents) working in `frontend/`. Read this before touching
`lib/` — it documents the MVVM architecture that every screen/feature must follow, not just the
`Team` example that proves it out.

## Stack

Flutter (managed via `fvm` — use `fvm flutter ...` for every command, not a bare `flutter` on PATH),
Dart SDK `^3.12.2`. Targets mobile (Android/iOS) first, but must also run well on macOS and Windows
desktop — all 6 platform folders are scaffolded.

In this local environment, prefer the absolute FVM binary: `/Users/ronan/fvm/bin/fvm flutter ...`.
The package name is `for_tech_lead`; tests must import app code as `package:for_tech_lead/...`, never
the old `package:frontend/...` path.

Packages: `go_router` (routing), `provider` (ViewModel exposure + granular rebuilds via
`Consumer`/`Selector`), `get_it` (DI container for Services/Repositories only), `dio` (HTTP),
`logger` (debug interceptor console output), `equatable` (value equality on Models), `intl`
(date/number formatting), `google_fonts` (Inter, see "Design system" below), `audioplayers` +
`wakelock_plus` (Daily's live-session gamification feedback + keep-awake, see "Navigation" below),
`mocktail` (dev, test mocking, no codegen), `fake_async` (dev, deterministic `Timer` tests — see
`DailySessionViewModel`'s tests).

Deliberately **not** used: Riverpod (extra paradigm, not needed yet — see rationale in the plan
history if revisited), `freezed`/`json_serializable`/`build_runner` (manual `fromJson`/`toJson` is
easier to debug while the backend API shape is still moving — revisit only if models genuinely
multiply into repetitive boilerplate).

## Flow: Screen → ViewModel → Repository → Service → Model

- **Screen**: a `StatelessWidget`. Creates its ViewModel via `ChangeNotifierProvider` at the route's
  mount point, consumes it via `Consumer`/`Selector` (never a bare `Consumer` around the whole
  screen — scope it to the smallest subtree that needs to rebuild). **Never imports a Service.**
  The only place a Screen touches a Repository type is the single `ChangeNotifierProvider(create: ...)`
  line that constructs its ViewModel — see `TeamsListScreen`.
- **ViewModel**: extends `BaseViewModel` (`lib/core/viewmodels/base_view_model.dart`). Constructor-
  injects its Repository (never calls `getIt` on a Service). Wraps async work in `runCatching(...)`
  so `ViewState` transitions (`idle → loading → loaded/error`) and `ApiException` → `errorMessage`
  mapping don't need to be hand-rolled per method.
- **Repository**: plain class, constructor-injects its Service, maps raw JSON (`Map<String, dynamic>`)
  into typed Models. **Only ever instantiated inside a Service or a ViewModel** (registered in
  `bootstrap.dart` via `getIt`), never inside a Screen.
- **Service**: constructor-injects `DioClient`, makes the raw `dio` calls, catches `DioException` and
  rethrows via `mapDioException()` (`lib/core/network/api_exception.dart`). Returns decoded JSON —
  mapping to Models is the Repository's job, not the Service's.
- **Model**: immutable, `Equatable`, manual `fromJson`/`toJson`. One model per file.

There is no Dart equivalent to Pest's `arch()` tests. The screen/service boundary is enforced by (1)
this document, (2) constructor-injection discipline — a Screen has no reason to type `XService`
because it only ever receives `XRepository`/`XViewModel` types. Adding a `custom_lint` rule to hard-
enforce "files under `screens/` must not import `services/`" is a reasonable future upgrade once the
pattern is stable across more than one feature; not present yet.

## Folder structure

Layer-first at the top (`core/`), feature-first inside `features/<name>/` (each feature owns its full
vertical: `models/`, `repositories/`, `services/`, `viewmodels/`, `screens/`). `test/` mirrors `lib/`.

```
lib/
├── main.dart              # configureDependencies() + runApp(App())
├── app.dart                # MaterialApp.router: AppTheme + appRouter
├── bootstrap.dart           # getIt registrations (Services/Repositories only, not ViewModels)
├── core/
│   ├── config/env.dart              # Env.apiBaseUrl (String.fromEnvironment / --dart-define)
│   ├── network/                     # DioClient, AppLoggingInterceptor, ApiException + mapDioException
│   ├── routing/                     # appRouter (go_router), RoutePaths
│   ├── theme/                       # AppColors, AppTypography, AppRadius, AppSpacing, AppThemeExtension, AppTheme
│   ├── responsive/                  # Breakpoints, AdaptiveScaffold
│   ├── viewmodels/base_view_model.dart
│   ├── feedback/daily_cue_player.dart  # sound + haptics for Daily's live session, see "Navigation" below
│   └── widgets/                     # AppPrimaryButton, AppTextField, AppDateField, AppDropdownField, AppDataTable, AppSummaryCard, AppKeyValueRow, Loading/Error/EmptyView
└── features/
    ├── teams/                       # reference implementation — copy this shape for new features
    │   ├── models/team.dart
    │   ├── repositories/team_repository.dart
    │   ├── services/team_service.dart
    │   ├── viewmodels/{teams_list,team_detail}_view_model.dart
    │   └── screens/{teams_list,team_detail}_screen.dart + {teams_list,team_detail}_body.dart
    ├── home/                        # dashboard — viewmodels/home_view_model.dart, screens/{home_screen,home_body}.dart
    ├── notifications/               # empty-state placeholder only, see "Navigation" below
    ├── profile/                     # viewmodels/profile_view_model.dart, screens/profile_screen.dart
    ├── auth/                        # login/register — see "Authentication" below
    ├── people/                      # nested under a team, not a top-level nav item — see "Navigation" below
    │   ├── models/{person,contract_type,seniority_level}.dart
    │   ├── repositories/person_repository.dart
    │   ├── services/person_service.dart
    │   ├── viewmodels/{people_list,person_form,person_detail}_view_model.dart
    │   ├── screens/{person_form,person_detail}_screen.dart + person_form.dart + person_detail_body.dart
    │   └── utils/birthday_util.dart     # daysUntilNextBirthday() — pure function, used by the Home birthday card
    ├── daily/                       # live session is top-level "focus mode", history nested under Team — see "Navigation"
    │   ├── models/{daily_meeting,daily_meeting_entry,daily_note_category,daily_session_phase,daily_cue,daily_turn_draft}.dart
    │   ├── repositories/daily_meeting_repository.dart
    │   ├── services/daily_meeting_service.dart
    │   ├── viewmodels/{daily_session,daily_history,daily_meeting_detail,person_daily_stats}_view_model.dart
    │   ├── screens/daily_session_screen.dart + {daily_config,daily_running,daily_review}_body.dart + daily_timer_ring.dart + daily_note_sheet.dart
    │   ├── screens/daily_history_screen.dart + daily_history_body.dart, daily_meeting_detail_screen.dart + daily_meeting_detail_body.dart
    │   ├── screens/person_daily_section.dart   # appended to PersonDetailBody
    │   └── utils/{daily_time_limit,daily_stats}.dart   # pure functions — validation/formatting, client-side stats aggregation
    └── integrations/                # external systems + people mappings + delivery metrics
        ├── models/integration_models.dart
        ├── repositories/integration_repository.dart
        ├── services/integration_service.dart
        ├── viewmodels/integrations_view_model.dart
        └── screens/integrations_screen.dart
```

## One class per file

Every file has exactly one primary public class. Where a Screen's loaded-state body is non-trivial
enough to need its own `Selector`, split it into a sibling `_body.dart` file/class (see
`teams_list_screen.dart` + `teams_list_body.dart`) instead of nesting a second class in the Screen's
file — this also means only that body subtree rebuilds when its slice of ViewModel state changes,
not the whole Screen.

## Granular rebuilds

Never wrap a whole Screen's `body` in one `Consumer` reacting to the entire ViewModel. Use
`Selector<ViewModel, T>` to project exactly the slice of state a subtree cares about (e.g. `ViewState`
for the loading/error/loaded switch, then a separate nested `Selector` on the actual data list) — see
`TeamsListScreen`/`TeamsListBody`. Use `context.read<T>()` for one-off calls (button `onPressed`)
that shouldn't subscribe the calling widget to rebuilds.

## Design system

Built for the target user (technical leads: short, frequent sessions between meetings, on both
mobile and desktop, often at night) — a sober "dev tool" look (dense-data-friendly, low visual
noise) rather than a bright consumer-app one. Never hardcode a `Color(0xFF...)`, font size, spacing,
or radius value inline in a widget — add/use tokens in `core/theme/` and read everything through
`Theme.of(context)` inside widgets. This is what makes `ThemeMode.system` (light/dark, wired in
`app.dart`) work for free.

- **Color** (`app_colors.dart`): near-monochrome zinc (grafite) neutral scale for
  background/surface/text/border, plus a single orange accent (`AppColors.accent`/`accentDark`)
  reserved for primary actions/selection — kept meaningful by never using it decoratively elsewhere.
  Status colors (`success`/`warning`/`error`) are separate from the accent and used sparingly
  (badges, alerts), never as a button color.
- **Typography** (`app_typography.dart`): Inter (via `google_fonts`) — chosen for legibility on
  dense data screens. Regular (400) for body copy, Medium (500) for labels/card titles, SemiBold
  (600) reserved for screen headers (`titleLarge`/`titleMedium`) — never a heavier weight in body
  text. Full scale: `displaySmall`, `titleLarge/Medium/Small`, `bodyLarge/Medium/Small`,
  `labelLarge/Medium/Small`.
- **Shape** (`app_radius.dart`): `sm` (8px, inputs/buttons), `md` (12px, cards), `lg` (20px,
  dialogs/bottom sheets) — soft-but-not-round; sharp corners read as legacy, heavy rounding as
  consumer/playful.
- **`AppTheme`** (`app_theme.dart`) wires all of the above into `ThemeData`: a hand-built
  `ColorScheme` (not `ColorScheme.fromSeed`, for exact control over the accent/neutral split),
  `inputDecorationTheme`/`elevatedButtonTheme`/`outlinedButtonTheme`/`cardTheme`/`dialogTheme`/
  `navigationBarTheme`/`navigationRailTheme` all reading the same tokens — a component never sets
  its own shape/color, so changing a token updates every screen. `AppPrimaryButton`/`AppTextField`
  in particular rely entirely on these theme defaults (no inline `style:`/`decoration:` overrides).
- **`AppSummaryCard`** (`core/widgets/cards/`): the reusable dashboard KPI card (icon + big value +
  label) — see `HomeScreen`. This is the one place a `Card` is intentional; lists never use one (see
  below).
- **Lists** (`AppDataTable`, `core/widgets/tables/`): never a `Card`-per-row list. On mobile widths
  it's a plain `ListView.separated` with a `Divider` between rows (no elevation, no per-row
  container); on desktop widths it's a `DataTable`, unchanged. Every `AppDataTable` **always**
  renders a search field above its content — via `AppSearchField` (`core/widgets/inputs/`) — from
  the start, not behind a toggle; there is no non-searchable list variant. `AppDataTable` owns its
  own empty state too (`emptyMessage`), so the search field stays visible even when a search yields
  no results (only `items.isEmpty` swaps in `EmptyView`, and the search bar sits outside that swap).
  `AppDataTable` itself just reports the (300ms-debounced) query text via `onSearchChanged`; the
  actual filtering is the ViewModel's job — see `TeamsListViewModel.search()`, which filters the
  already-loaded in-memory list by a case-insensitive `name` match rather than round-tripping to the
  API per keystroke (fine at the list sizes these screens deal with; revisit if a list needs
  server-side pagination + search together). Keep an unfiltered getter (`hasTeams`) alongside the
  filtered one so the empty-state message can distinguish "no results for this search" from
  "genuinely no data yet".
- **`AppDateField`**/**`AppDropdownField<T>`** (`core/widgets/inputs/`): the date/select counterparts
  to `AppTextField`, same decoration-driven theming. `AppDateField` wraps `showDatePicker` behind a
  read-only `InputDecorator` (tap anywhere to open the picker, no keyboard ever shows).
  `AppDropdownField<T>` is a themed generic `DropdownButtonFormField<T>` (`items` +
  `labelBuilder`) — see `PersonForm`'s contract-type/seniority selects for the reference usage.

## Navigation

Bottom `NavigationBar` (mobile) / `NavigationRail` (desktop) with 4 top-level destinations, in this
order: **Início** (dashboard), **Times**, **Notificações**, **Perfil** — see `_navDestinations` in
`core/routing/app_router.dart`. `RoutePaths.home` is the post-login `initialLocation`. Home
prioritizes summary cards above the fold (quick 3-second read) over a chart — a trend chart, once
historical data exists to back it, goes below the cards, not above (see `features/home/`'s
`HomeBody`: cards first, then a trends section). `NotificationsScreen` is an intentional empty-state
placeholder (no notifications backend/feature exists yet) rather than a stub with fake data — replace
it with a full Model → Service → Repository → ViewModel → Screen feature once that API exists.
`ProfileScreen` shows the signed-in user (via `AuthRepository.me()`) and is where sign-out now lives
(moved off `TeamsListScreen`'s app bar).

Not every feature gets a nav destination — `features/people/` is deliberately **nested under Team**,
not a 5th bottom-nav tab: `TeamDetailScreen` gets a "Membros" section (`team_members_section.dart`,
same team feature, reusing `AppDataTable`) listing that team's people via
`PeopleListViewModel(personRepository, teamId)`, with a FAB pushing `PersonFormScreen` at
`RoutePaths.personCreatePath(teamId)` and rows pushing `PersonDetailScreen` at
`RoutePaths.personDetailPath(teamId, personId)` — both are plain `GoRoute`s inside the same
`ShellRoute` as `teamDetail` (so the shell chrome persists), not top-level routes. Use this pattern —
not a new nav tab — for any future feature that's naturally scoped to a parent resource rather than
being its own global list.

`HomeBody` also has a "Próximos aniversários" card between the summary cards and the trends
placeholder: `HomeViewModel` injects `PersonRepository` alongside `TeamRepository`, fetches people
across *all* teams (`perPage: 100` — the API's validated ceiling), and sorts them by
`daysUntilNextBirthday()` (`features/people/utils/birthday_util.dart`, a pure/testable function) to
show the soonest 5. It's one `Card` with a `ListTile` per person, not a `Card` per person — the
"lists aren't cards" rule is about `AppDataTable`-style lists, not this kind of small fixed summary
widget, but per-item elevation is still avoided here for the same visual-noise reason.

### Daily — the one top-level route outside the shell

`features/daily/`'s live session (`DailySessionScreen`, `RoutePaths.dailySession`) is the **only**
route in the app that's a top-level `GoRoute` sibling of the `ShellRoute` while still requiring
authentication (same tier as `/login`/`/register`, but auth-gated like everything inside the shell) —
a live Daily is "focus mode": the nav bar/rail must not stay reachable mid-session, since `context.go`
from a stray nav tap isn't intercepted by `PopScope` and would silently destroy an unsaved, running
meeting. `DailySessionScreen` guards exit itself instead (a leading close button + `PopScope`, with a
confirmation dialog while `phase` is `running`/`reviewing`). History screens (`DailyHistoryScreen`,
`DailyMeetingDetailScreen`) are the opposite — nested under Team exactly like `features/people/`,
reached by push, inside the shell.

`DailySessionViewModel`'s countdown timer doesn't use `runCatching` for its final save
(`DailySessionViewModel.save()`): a network failure there must never swap the whole screen for an
`ErrorView` (`runCatching`'s normal behavior), since that would erase the meeting the tech lead just
ran turn-by-turn with nothing persisted server-side yet. It stays on the `reviewing` phase with an
inline error + retry button instead, via its own `isSaving`/`saveErrorMessage` fields — this is the one
ViewModel in the app that deliberately does NOT use the shared `runCatching` helper for a write
operation; don't "fix" this to match the convention elsewhere.

Live-session feedback (color/countdown ring is the primary channel; sound + haptics are reinforcement)
goes through `core/feedback/daily_cue_player.dart` (`DailyCuePlayer`, `audioplayers` +
`HapticFeedback`), a cross-cutting singleton registered in `bootstrap.dart` like `AuthSession`/
`DioClient` — **consumed by `DailySessionScreen`, never injected into `DailySessionViewModel`**, so the
ViewModel's timer logic stays testable (see `daily_session_view_model_test.dart`'s `fakeAsync` tests)
without an audio plugin in the test environment. The 3 short WAV cues under `assets/sounds/` are
generated by `tool/generate_daily_sounds.dart` (plain sine tones with a fade envelope) rather than
sourced externally — rerun that script (`dart run tool/generate_daily_sounds.dart`) if the cues ever
need to change; don't hand-edit the `.wav` files. `wakelock_plus` keeps the screen on only while
`phase == running`.

Both team-level (`DailyHistoryViewModel`) and person-level (`PersonDailyStatsViewModel`) stats are
computed client-side from `GET /daily-meeting-entries` listings (mirrors the birthday card's
approach) — but unlike birthdays (bounded by headcount), daily entries accumulate indefinitely, so
`DailyMeetingRepository.getAllEntries()` follows the response's `meta.last_page` across multiple pages
(capped at 10 pages / ~1000 entries) instead of assuming a single `per_page: 100` page is the whole
history. If stats ever look truncated for a long-lived team, this cap — not the aggregation math — is
the first thing to check.

### Page header

Every top-level (shell) screen uses `core/widgets/navigation/app_page_header.dart`
(`AppPageHeader`) instead of a raw `AppBar` — never build a bespoke one per screen. Layout:
description/subtitle line on top, page title below it, both left-aligned (`centerTitle: false`); the
notifications bell is right-aligned via `actions` and navigates to `/notifications` with
`context.go` (switches shell tab, doesn't stack a route). Pass `showNotifications: false` for
sub-pages reached by push (e.g. `TeamDetailScreen`) and for the Notifications screen itself, so the
bell doesn't point at the page you're already on. `HomeScreen` is the one place the title is the app
name itself (`4TechLead`, subtitle `'Painel'`) rather than the page name — see `HomeScreen`.

## Language

The app's name (`4TechLead`, set in `app.dart`'s `MaterialApp.title` and used as `HomeScreen`'s
header title) stays English/branded, but every other piece of user-facing text in the Flutter layer
— screen titles/subtitles, buttons, labels, empty/error/loading messages, nav destination labels —
is Portuguese (pt-BR). This includes the default messages baked into shared widgets/classes
(`ApiException` subclasses in `core/network/api_exception.dart`, `BaseViewModel`'s generic catch-all,
`ErrorView`'s retry button), not just per-screen strings — a new shared default must also be written
in Portuguese. Backend (Laravel) validation messages are not yet localized (still English) since
they come from `ValidationException.userMessage` verbatim from the API response — full pt-BR
coverage would need Laravel's own localization (`lang/pt_BR`), not just Flutter-side changes; flagged
as a known gap, not yet addressed.

This extends to native widgets, not just app text: `app.dart`'s `MaterialApp.router` sets
`locale: Locale('pt', 'BR')` + `supportedLocales`/`localizationsDelegates` (via the
`flutter_localizations` SDK package) so built-in Material/Cupertino/Widgets chrome (e.g.
`AppDateField`'s `showDatePicker` dialog) renders in Portuguese too, not just this app's own screens.
`main.dart` calls `initializeDateFormatting('pt_BR')` (from `intl`) before `runApp()` — required
before any `DateFormat.yMMMd('pt_BR')`-style call (skeleton formats with an explicit locale throw a
`LocaleDataException` otherwise). Always pass `'pt_BR'` explicitly to `DateFormat` constructors in
this codebase (see `AppDateField`, `team_detail_body.dart`, `person_detail_body.dart`,
`home_body.dart`) rather than relying on an ambient default locale.

## Reusable components

Buttons, inputs, and tables/lists live in `core/widgets/` and are used by every screen that needs
them — never recreate a bespoke button/text field/table per screen. `AppDataTable<T>` in particular
is itself responsive (`ListView` cards on mobile widths, `DataTable` on desktop widths, via
`Breakpoints`), so a Screen never has to make that layout decision itself. `AppKeyValueRow`
(`core/widgets/data/`) is the label/value stacked row used for read-only detail fields — extracted
from `PersonDetailBody`'s original private `_field` helper once Daily's history/stats sections needed
the same shape; reach for it instead of a bespoke `Column`+`Text` pair whenever a screen just needs to
show "label → value".

## Responsive / desktop

`Breakpoints.isDesktop(context)` (`>= 1024px`) drives `AdaptiveScaffold` (bottom `NavigationBar` on
mobile, `NavigationRail` on desktop) and `AppDataTable`'s layout switch. `AdaptiveScaffold` is wired
as the `builder` of a go_router `ShellRoute` in `core/routing/app_router.dart`, so the nav chrome
persists across route changes. Any new top-level navigable feature adds an `AppNavDestination` there.

## Networking

All HTTP goes through `DioClient` (`core/network/dio_client.dart`) — never instantiate a bare `Dio()`
in a Service. `AppLoggingInterceptor` is attached only in debug builds (`kDebugMode`) and logs
method/URL/headers (Authorization/Cookie redacted)/body for requests, status/body for responses, and
status/body for errors. Services catch `DioException` and rethrow via `mapDioException()` so callers
only ever deal with typed `ApiException` subclasses (`NetworkException`, `ValidationException` —
mirrors Laravel's `{message, errors: {field: [msgs]}}` 422 shape — `NotFoundException`,
`UnauthenticatedException`, `ForbiddenException`, `ServerException`).

## Integrations

`features/integrations/` configures external systems that send data to the Laravel webhook API. The
Flutter app does not ingest webhooks directly: it creates integration systems, shows the one-time token
returned by the backend, maps `person-external-identities`, and lists read-only delivery metrics.
Keep this feature API-first and typed like the rest of the app: Service returns raw JSON, Repository maps
to `IntegrationSystem`, `PersonExternalIdentity`, and `PersonDeliveryMetric`, ViewModel owns UI state.
Tests live under `test/features/integrations/` and should cover repository mapping plus screen rendering
for the three sections.

Mutation errors in already-loaded screens must not replace the whole body with `ErrorView`. Preserve
the loaded content and show an inline/snackbar error with retry or dismissal. If a local state flow
looks like a route (for example a focused 1:1/PDI/OKR document inside a detail screen), add `PopScope`
and a widget test so Android/system back closes that flow before leaving the page.

## Adding a new feature — recipe (mirror `features/teams/`)

1. `features/<name>/models/<name>.dart` — `fromJson`/`toJson`, `extends Equatable`.
2. `features/<name>/services/<name>_service.dart` — raw `dio` calls via injected `DioClient`, catch
   `DioException` → `mapDioException`.
3. `features/<name>/repositories/<name>_repository.dart` — injects the Service, maps JSON → Model.
4. `features/<name>/viewmodels/*.dart` — extend `BaseViewModel`, inject the Repository.
5. `features/<name>/screens/*.dart` (+ `*_body.dart` if the loaded state needs its own `Selector`) —
   `ChangeNotifierProvider` wiring `getIt<XRepository>()` into the ViewModel; never import the Service.
6. Register the Service/Repository in `bootstrap.dart` (`getIt.registerLazySingleton`).
7. Add routes in `core/routing/app_router.dart` (+ `RoutePaths` constants), and an
   `AppNavDestination` if it's a top-level nav item.
8. Tests mirroring `test/features/teams/` (`repositories/*_test.dart` mocking the Service,
   `viewmodels/*_test.dart` mocking the Repository, both via `mocktail` — no codegen).

## Commands

Run from `frontend/`, via `/Users/ronan/fvm/bin/fvm` in this environment (currently resolving to
Flutter 3.44.8 / Dart 3.12.2 — no `.fvmrc` pin file exists yet in this project; add one if the team
standardizes on `fvm` long-term):

```bash
/Users/ronan/fvm/bin/fvm flutter pub get
/Users/ronan/fvm/bin/fvm flutter analyze              # must be clean (strict-casts/strict-inference/strict-raw-types + tightened lints — see analysis_options.yaml)
/Users/ronan/fvm/bin/fvm flutter test                 # unit + widget tests
/Users/ronan/fvm/bin/fvm flutter run -d macos          # or -d chrome / a connected mobile device/emulator
```

The backend must be running (`docker compose up -d` from `backend/`) for the `Team`/`auth` features to
have real data to hit at `Env.apiBaseUrl` (defaults to `http://localhost:8090/api/v1` — matches
`backend/.env`'s `NGINX_PORT`, **not** Laravel's own `APP_URL` port 8000, which is only used by
`php artisan serve` outside Docker; override via `--dart-define=API_BASE_URL=...`).

## Authentication

Auth is bearer-token based (backend: Laravel Sanctum personal access tokens, not cookie/session) —
see `backend/CLAUDE.md`'s "Authentication" section for the API contract.

- `core/auth/auth_session.dart` (`AuthSession`) is cross-cutting session state, not a ViewModel — same
  tier as `DioClient`. It holds the in-memory token, persists it via `core/storage/token_storage.dart`
  (`flutter_secure_storage` — Keychain/Credential Manager/Keystore), and is the single source of truth
  `go_router`'s `redirect` (in `core/routing/app_router.dart`) uses as its `refreshListenable` to guard
  routes: unauthenticated → forced to `/login`; authenticated and on `/login`/`/register` → forced to
  `/home`.
- `core/network/auth_interceptor.dart` (`AuthInterceptor`) attaches `Authorization: Bearer <token>` to
  every request when `AuthSession.isAuthenticated`, and calls `AuthSession.signOut()` on any 401 response
  — the redirect above then takes over. `core/network/api_exception.dart` distinguishes
  `UnauthenticatedException` (401 — triggers the sign-out above) from `ForbiddenException` (403 —
  authenticated but not permitted, just an in-place error, no sign-out).
- `features/auth/` follows the exact same Model → Service → Repository → ViewModel → Screen shape as
  `features/teams/`, with one addition: `AuthRepository` is the only feature-level class allowed to touch
  `AuthSession` directly (besides `AuthInterceptor`) — on a successful `register`/`login` it calls
  `authSession.signIn(token)`. Registering auto-authenticates (the backend's register endpoint returns a
  token just like login), so `RegisterViewModel` never needs a follow-up login call.
- `/login` and `/register` (`features/auth/screens/`) are top-level `GoRoute`s, siblings of the
  `ShellRoute`, not nested inside it — no nav shell/`AppNavDestination` for either.
- `bootstrap.dart`'s `configureDependencies()` is `async`: it must `await authSession.restore()` (load any
  persisted token) *before* `runApp()`, otherwise the router's very first redirect decision runs before
  the token is known and can incorrectly bounce a signed-in user to `/login`. `main()` is `async` to match.
- Sign-out from the UI (`ProfileScreen`, via `ProfileViewModel.signOut()` → `AuthRepository.logout()`)
  goes through the normal Screen → ViewModel → Repository chain like any other action — `AuthSession`
  itself is only touched directly by `AuthRepository`/`AuthInterceptor` (see above), never by a Screen.
