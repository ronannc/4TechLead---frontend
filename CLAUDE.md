# CLAUDE.md

Guidance for Claude Code (and other AI agents) working in `frontend/`. Read this before touching
`lib/` — it documents the MVVM architecture that every screen/feature must follow, not just the
`Team` example that proves it out.

## Stack

Flutter (managed via `fvm` — use `fvm flutter ...` for every command, not a bare `flutter` on PATH),
Dart SDK `^3.12.2`. Targets mobile (Android/iOS) first, but must also run well on macOS and Windows
desktop — all 6 platform folders are scaffolded.

Packages: `go_router` (routing), `provider` (ViewModel exposure + granular rebuilds via
`Consumer`/`Selector`), `get_it` (DI container for Services/Repositories only), `dio` (HTTP),
`logger` (debug interceptor console output), `equatable` (value equality on Models), `intl`
(date/number formatting), `google_fonts` (Inter, see "Design system" below), `mocktail` (dev, test
mocking, no codegen).

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
│   └── widgets/                     # AppPrimaryButton, AppTextField, AppDataTable, AppSummaryCard, Loading/Error/EmptyView
└── features/
    ├── teams/                       # reference implementation — copy this shape for new features
    │   ├── models/team.dart
    │   ├── repositories/team_repository.dart
    │   ├── services/team_service.dart
    │   ├── viewmodels/{teams_list,team_detail}_view_model.dart
    │   └── screens/{teams_list,team_detail}_screen.dart + {teams_list,team_detail}_body.dart
    ├── home/                        # dashboard — viewmodels/home_view_model.dart, screens/{home_screen,home_body}.dart
    ├── notifications/               # empty-state placeholder only, see "Navigation" below
    └── profile/                     # viewmodels/profile_view_model.dart, screens/profile_screen.dart
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

## Reusable components

Buttons, inputs, and tables/lists live in `core/widgets/` and are used by every screen that needs
them — never recreate a bespoke button/text field/table per screen. `AppDataTable<T>` in particular
is itself responsive (`ListView` cards on mobile widths, `DataTable` on desktop widths, via
`Breakpoints`), so a Screen never has to make that layout decision itself.

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
`UnauthorizedException`, `ServerException`).

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

Run from `frontend/`, via `fvm` if a bare `flutter` isn't on `PATH` (this environment manages Flutter
through `fvm`, currently resolving to Flutter 3.44.8 / Dart 3.12.2 — no `.fvmrc` pin file exists yet
in this project; add one if the team standardizes on `fvm` long-term):

```bash
fvm flutter pub get
fvm flutter analyze              # must be clean (strict-casts/strict-inference/strict-raw-types + tightened lints — see analysis_options.yaml)
fvm flutter test                 # unit + widget tests
fvm flutter run -d macos          # or -d chrome / a connected mobile device/emulator
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
  `/teams`.
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
- Sign-out from the UI (`TeamsListScreen`'s app bar) calls `getIt<AuthSession>().signOut()` directly —
  `AuthSession` is core infrastructure, not a feature Repository, so this doesn't violate the
  screens-never-touch-repositories rule (comparable to a Screen reading `Theme.of(context)`).
