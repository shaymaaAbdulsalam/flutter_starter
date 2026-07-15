---
name: flutter-bloc-clean-architecture
description: Use when building or modifying anything in this project — a Flutter app using BLoC + Clean Architecture. Applies to adding features, use cases, repositories, blocs, routes, theming, or DI wiring, and to reviewing code for consistency with this project's established patterns.
---

# This project — conventions

Every feature in this codebase follows the *same* shape. The `auth` and
`home` features are the reference implementation — when in doubt, open the
matching file in `features/auth/` and mirror it exactly rather than inventing
a new pattern.

**Before adding anything (a field, a feature, a screen, a bloc, a repository
method), find the closest existing example in this codebase first** and copy
its structure, naming, and layering. Do not introduce a new state-management
approach, error type, DI scoping rule, or folder layout that isn't already
used somewhere in `lib/`. If a genuinely new pattern seems necessary, say so
explicitly and explain why the existing one doesn't fit — don't silently
diverge.

## Layered structure

Every feature lives under `lib/features/<feature_name>/`:

```
lib/features/<feature_name>/
├── <feature_name>_injection.dart   # register<Feature>Feature(GetIt sl)
├── presentation/
│   ├── bloc/<name>/                # <name>_bloc.dart + part 'event'/'state' (+ 'validator')
│   └── pages/
├── domain/
│   ├── entities/                   # plain Equatable classes, no (de)serialization
│   ├── repositories/                # abstract interfaces, return FutureEither<T>
│   └── usecases/                    # one class per business action
└── data/
    ├── models/                      # DTOs: fromJson/toJson, toEntity()
    ├── datasources/                  # remote (Dio) / local (secure storage) — only place touching transport
    └── repositories/                  # implements the domain interface, uses RepositorySafeCall
```

Shared code lives in `lib/core/`: `di/`, `error/`, `network/`, `routing/`,
`session/`, `theme/`, `typedefs/`, `ui/`, `usecase/`, `extensions/`, `enums/`.

## Dependency rule

`presentation` → `domain` only. `domain` → nothing (no Flutter/Dio/data
imports). `data` → implements `domain`'s interfaces. Cross-feature reuse is
allowed **only** through another feature's domain layer — e.g. `home` reusing
auth's `GetCurrentUserUseCase` (see `home_injection.dart`), never its data
layer or bloc.

## Error handling pipeline (don't deviate from this chain)

1. Data sources throw `AppException` subtypes (`core/error/exceptions.dart`):
   `ServerException`, `NetworkException`, `UnauthorizedException`,
   `CacheException`, `ValidationException`.
2. Repository implementations mix in `RepositorySafeCall` and wrap the whole
   body in `safeCall(() async {...})` (`core/error/repository_safe_call.dart`),
   which maps each `AppException` to the matching `Failure`
   (`core/error/failure.dart`): `ServerFailure`, `NetworkFailure`,
   `UnauthorizedFailure`, `CacheFailure`, `ValidationFailure`, `UnknownFailure`.
3. Repository/use case methods return `FutureEither<T>` (=
   `Future<Either<Failure, T>>`, `core/typedefs/typedefs.dart`) — never throw
   across a layer boundary, never return a raw exception type.
4. In the bloc, feed a `FutureEither<T>` into `.linkWithState(emit, onSuccess:
   ..., onError: ...)` (`core/ui/state/result.dart`) to get automatic
   loading → success/failure emission into a `Result<T>` state slice.
5. In the widget, render a `Result<T>` slice with `ResultBuilder<Bloc, State,
   T>` (selector → the slice, builder → success UI); it wires
   loading/error views and retry automatically. For infinite lists use
   `PaginatedResult<T>` (`core/ui/state/paginated_result.dart`) +
   `PaginatedResultBuilder` instead of a plain `Result`.

Never let a `DioException`/`PostgrestException`/raw exception cross out of
`data/`. Never catch a raw exception inside a bloc — only match on `Failure`.

## Use cases

One class per business action, implementing `UseCase<T, Params>`
(`core/usecase/usecase.dart`) with a single `call()` method so it's invoked as
`await useCase(params)`. Use `NoParams` when there's no input. Params objects
are `Equatable`, not positional args (see `LoginParams`).

## Bloc conventions

- One bloc per screen/concern under `presentation/bloc/<name>/`, split into
  `<name>_bloc.dart` (with `part '<name>_event.dart'` and `part
  '<name>_state.dart'`), plus a `<name>_validator.dart` part for forms.
- Form fields in state are `FieldValue<T>` (value + error,
  `core/ui/forms/field_value.dart`); `setValue()` clears the error on typing.
- Validation lives in the bloc via `FormValidationMixin.checkValidation(...)`
  in a `<Feature>Validation on <Feature>Bloc` extension
  (`core/ui/forms/form_validation.dart`) — never in the widget.
- A bloc calls **use cases only**, never a repository or datasource directly.
- `AuthBloc` is the one app-wide session bloc; screen-scoped form blocs
  (`LoginBloc`, `RegisterBloc`, ...) take it as a constructor dependency to
  push session events (e.g. `AuthLoggedIn`) after a successful submission.

## Dependency injection (`get_it`)

Each feature owns `<feature>_injection.dart` exporting
`void register<Feature>Feature(GetIt sl)`. `core/di/setup.dart` just calls
each one plus `_registerCore()`/`_registerAppShell()` — never add a feature's
bindings directly into `setup.dart`.

Scoping rules (copy exactly):
- Datasources, repositories, use cases → `registerLazySingleton`.
- App-wide session state (`AuthBloc`) → `registerSingleton` — exactly one
  instance shared by the router and every screen.
- Screen-scoped blocs (forms, per-page state) → `registerFactory` — a fresh
  instance per screen; sharing these causes stale-state bugs across screens.

## Routing (`go_router`)

Single router built in `core/routing/app_router.dart` via `createAppRouter
(AuthBloc)`, with one centralized `redirect` guard reading `authBloc.state
.status` (`AuthStatus.unknown/unauthenticated/authenticated`) and
`refreshListenable: GoRouterRefreshStream(authBloc.stream)`. No screen ever
calls `context.go('/login')` on logout — the guard reacts to bloc state
changes instead. Add new paths to `AppRoutes` (`core/routing/app_routes.dart`)
and a `GoRoute` entry here; add new auth-gated route groups to the `switch` in
`redirect`, not as one-off checks in widgets.

## Theming

Everything a project rebrands lives in one `AppThemeConfig`
(`core/theme/app_theme_config.dart`) passed into `app.dart` — seed color,
font, radii (`core/theme/tokens/app_borders.dart`), input style, button sizing.
`AppTheme` derives everything from this config; don't hardcode colors/radii/
spacing in a widget — use `Theme.of(context)`, `AppColorsExtension`, or the
tokens in `core/theme/tokens/`.

## Adding a new feature — order of operations

1. Domain first: entity → repository interface (`FutureEither<T>` methods) →
   use case(s).
2. Data: model (`fromJson`/`toJson`/`toEntity()`) → datasource → repository
   impl (`with RepositorySafeCall`, wrap in `safeCall`).
3. Presentation: bloc + event/state (+ validator if it's a form) → page,
   using `ResultBuilder`/`PaginatedResultBuilder` and the shared
   `core/ui/inputs/` widgets.
4. Wire it: create `<feature>_injection.dart` with `register<Feature>Feature`,
   call it from `setupGetIt()` in `core/di/setup.dart`, add routes to
   `AppRoutes` + `app_router.dart`.

## Reviewing existing code — flag, don't silently fix

- Domain importing Flutter/Dio/data-layer files.
- A bloc calling a repository/datasource directly instead of a use case.
- A raw exception caught outside `data/repositories/`.
- A DTO/model used in `presentation/` instead of the domain entity.
- A `<feature>_injection.dart` binding added straight into `core/di/setup.dart`.
- New color/spacing/radius literals in a widget instead of `AppThemeConfig`/
  theme tokens.
- A use case with more than one public method or business action.
