---
name: flutter-template-pattern
description: >-
  Apply the nizwar/flutter_template conventions when adding or editing code in
  this Flutter boilerplate. Use whenever creating models, API clients, providers,
  routes, screens, or reusable widgets; when wiring Provider/go_router/Dio/Firebase;
  or when the user mentions this template, its `core`/`ui` structure, HttpConnection,
  AppConfig, or PaginatorPage. Triggers: add feature, create model, create API,
  add provider, new screen, follow the project structure, flutter template pattern.
---

# Flutter Template Pattern

Encodes the architecture and conventions of the `nizwar/flutter_template` boilerplate so generated code stays consistent. Read `CLAUDE.md` and `DEEP_CHECK_REPORT.md` at the repo root for full context before large changes.

## Core principles

1. **Strict `core/` vs `ui/` split.** Data/logic/networking → `lib/core/`. Widgets/screens → `lib/ui/`. Never mix.
2. **No hardcoded colors.** Use `theme(context)`, `textTheme(context)`, `colorScheme(context)` (from `core/resources/themes.dart`); custom colors via the `CustomColors` extension in `core/resources/colors.dart`.
3. **Zero warnings.** No deprecated/unused imports. End every task with `flutter analyze` + `dart fix --apply`.
4. **Reuse before creating.** Check `ui/components/` and `core/utils/` first.
5. **Minimal diffs, keep naming + folder structure.**
6. Prefer `const` constructors to limit rebuilds.

## Decision guide — where does new code go?

| You are adding... | Location | Pattern |
|---|---|---|
| Data model | `lib/core/models/` | extend `Model`; `toJson`/`fromJson`; `props` from real fields |
| API calls | `lib/core/https/<feature>_http.dart` | extend `HttpConnection(context)`; use `get/post/put/delete<T>()` |
| Global state | `lib/core/providers/` | `ChangeNotifier` + static `read`/`watch`; register in `main.dart` MultiProvider |
| Local state | beside the widget | same provider pattern, single-file or local `providers/` folder |
| Route | `lib/core/utils/route.dart` | add `GoRoute` in `getRouter()`; navigate with `context.goNamed/pushNamed` |
| Screen | `lib/ui/screens/` | `Scaffold`, small `const` widgets |
| Reusable widget | `lib/ui/components/` | stateless when possible; theme-driven styling |
| Env config | `lib/core/resources/environment.dart` | subclass `AppConfig`; read via `AppConfig.read(context)` |

## Snippets

### Model
```dart
class User extends Model {
  final String id, name;
  User({required this.id, required this.name});
  factory User.fromJson(Map<String, dynamic> json) =>
      User(id: json["id"], name: json["name"]);
  @override Map<String, dynamic> toJson() => {"id": id, "name": name};
  @override List<Object?> get props => [id, name]; // override (base uses toString — slow)
}
```

### API client
```dart
class UserHttp extends HttpConnection {
  UserHttp(BuildContext context) : super(context);
  Future<User> login(String u, String p) async {
    final r = await post<ApiResponse>("/login", body: {"username": u, "password": p});
    if (r.success) return User.fromJson(r.result); // field is `result`, not `data`
    throw HttpErrorConnection(status: r.status, title: "Login", message: r.message ?? "");
  }
}
```

### Provider
```dart
class FooProvider extends ChangeNotifier {
  static FooProvider read(BuildContext c) => c.read();
  static FooProvider watch(BuildContext c) => c.watch();
}
```

### Logging
`clog(obj)` debug pretty-JSON · `elog(obj)` debug→console / release→Crashlytics · `cprint(obj)` debugPrint. Never use raw `print()`.

## Known traps (don't reproduce; fix if touched)

- `AppConfig.switchConfig` is currently a no-op (shadowed param + self-assignment).
- `Preferences.token` setter force-unwraps (`value!`) → crash on null; `saveToken` doesn't exist yet.
- `AdaptiveProgressIndicator` uses `dart:io Platform.isIOS` → crashes on Flutter Web; guard with `kIsWeb`/`defaultTargetPlatform`.
- `Model.props => [toString()]` is slow — always override `props` per field in new models.
- `ApiResponse.fromJson` doesn't truly deserialize the generic `result`; add a `fromJsonT` callback if needed.
- `HttpConnection.paramsToString` doesn't URL-encode — prefer Dio `queryParameters`.
- `PaginatorPage` builds all items eagerly via `ListView(children:)`; use `ListView.builder` for long lists.

## Before finishing

Run through the CLAUDE.md §5 checklist: structure intact, no hardcoded colors, model/API/provider/route patterns followed, `flutter analyze` clean, no new force-unwraps, no secrets committed.
