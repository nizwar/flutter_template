# Deep Check Report — flutter_template

Source: https://github.com/nizwar/flutter_template
Review date: 2026-06-13 · Reviewer: AI agent (static review, no `flutter analyze` — the SDK was unavailable in the sandbox)
Scope: 21 Dart files (~1,300 lines), `core/` + `ui/` architecture.

> Note: Most of the issues below have since been **fixed**. See `IMPROVEMENTS.md` for what changed. This report documents the original findings.

---

## 1. Summary

The template is compact, well structured (clean `core`/`ui` separation), and already ships AI instructions in `readme.md`. The foundation is solid: an abstract `HttpConnection`, a multi-environment `AppConfig`, an Equatable-based `Model`, reusable UI components, and a ready-to-use paginator.

That said, there were **several real correctness bugs** (some in APIs that were documented for users to call), **doc/code mismatches**, and meaningful **performance opportunities**. There was no `analysis_options.yaml`, no tests, and a handful of crash-prone force-unwraps (`!`).

Fix priority: **High** → `switchConfig`, `Preferences`, the `Platform.isIOS` web crash, `Model.props`. **Medium** → generic `ApiResponse`, URL-encoding params, UI force-unwraps. **Low** → linting, tests, theme persistence.

---

## 2. Bugs & correctness (high priority)

### 2.1 `AppConfig.switchConfig()` completely broken — `core/utils/app_config.dart`
```dart
static void switchConfig(BuildContext context, AppConfig config) {
  var config = context.read<AppConfig>();   // ❌ shadows the `config` parameter
  config.endpoint = config.endpoint;        // ❌ self-assignment (no-op)
  config.appName = config.appName;          // ❌ no-op
  config.color = config.color;              // ❌ no-op
  config.notifyListeners();
}
```
The `config` parameter passed by the caller is **ignored**. This function is documented in the README (`AppConfig.switchConfig(context, YOUR_CONFIG)`) but does nothing. **Fix:**
```dart
static void switchConfig(BuildContext context, AppConfig newConfig) {
  final current = context.read<AppConfig>();
  current.endpoint = newConfig.endpoint;
  current.appName  = newConfig.appName;
  current.color    = newConfig.color;
  current.notifyListeners();
}
```

### 2.2 `Preferences` — force-unwrap + a method the README promises but doesn't exist
```dart
set token(String? value) => shared.setString("token", value!);  // ❌ crashes when null
```
The README also shows `pref.saveToken("XXXX")` and a non-null `String` from `pref.token` — **neither API exists** on the class. **Fix:**
```dart
set token(String? value) =>
    value == null ? shared.remove("token") : shared.setString("token", value);
String? get token => shared.getString("token");
Future<void> saveToken(String token) => shared.setString("token", token);
Future<void> clear() => shared.clear();
```

### 2.3 `AdaptiveProgressIndicator` crashes on Flutter Web — `ui/components/adaptive_progress_indicator.dart`
```dart
import 'dart:io';
...
if (Platform.isIOS) { ... }   // ❌ dart:io Platform does not exist on Web → crash
```
**Fix:** use `kIsWeb` + `defaultTargetPlatform` from `flutter/foundation.dart`:
```dart
final isCupertino = !kIsWeb && defaultTargetPlatform == TargetPlatform.iOS;
return isCupertino ? CupertinoActivityIndicator(...) : CircularProgressIndicator(...);
```

### 2.4 `Model.props` uses `toString()` — `core/models/model.dart`
```dart
List<Object?> get props => [toString()];   // ⚠️ full JSON serialization per comparison
```
Equatable calls `props` for `==`/`hashCode`. Using `toString()` (which calls `toJson().toString()`) means **serializing the whole object on every comparison/rebuild** — wasteful and fragile (key order, non-serializable types). Each subclass should define `props` from its real fields. At minimum document the trade-off; see §4.

### 2.5 `ApiResponse` — fake generic deserialization + string-based type check
`core/https/http_connection.dart`:
```dart
if (T.toString().startsWith('ApiResponse')) { return ApiResponse.fromJson(resp.data) as T; }
...
factory ApiResponse.fromJson(Map json) => ApiResponse(... result: json["result"]);  // ❌ T? never parsed
```
- `T.toString().startsWith(...)` is a fragile string-based type check.
- `result` is returned as raw `dynamic` then cast via `as T` — can throw `TypeError` at runtime if the shape differs.
- **README mismatch:** the example uses `resp.success` & `resp.data`, but the field is `result` (not `data`). `success` exists, but `data` does not.

**Fix (common pattern):** accept a `fromJsonT`:
```dart
factory ApiResponse.fromJson(Map<String, dynamic> json, [T Function(dynamic)? fromJsonT]) =>
  ApiResponse(
    status: json["status"],
    message: json["message"],
    result: fromJsonT != null && json["result"] != null ? fromJsonT(json["result"]) : json["result"],
  );
```

### 2.6 `paramsToString` doesn't URL-encode — `core/https/http_connection.dart`
```dart
output += "$key=$value&";   // ❌ spaces / & / = in the value break the query
```
**Fix:** `Uri.encodeQueryComponent(value)`, or better, use Dio's `queryParameters` (Dio encodes automatically) instead of manual strings.

### 2.7 `HttpErrorConnection` — duplicate `data` & `body`
```dart
: data = requestOptions?.data, body = requestOptions?.data;  // ❌ both identical
```
`body` was likely meant to be `requestOptions?.data` and `data` the `response.data`. One of them loses the response information.

### 2.8 `extensions.dart` — `DateFormat` receives a `Locale`, not a `String`
Every formatter calls `DateFormat.x(locale)` with a `Locale?` parameter, but `DateFormat` expects a **`String?` locale** (e.g. `"id_ID"`). This is a type mismatch the compiler will reject / produce wrong results. `jms` even passes `[locale]` (a `List`). On top of that, **every method takes a `BuildContext context` that is never used**. **Verify with `flutter analyze`**, then change the type to `String? locale` and either drop `context` or use it to resolve the locale.

---

## 3. Force-unwrap & null safety (medium priority)

| File | Location | Issue |
|---|---|---|
| `ui/components/custom_image.dart` | `imageUrl: url!` | `url` is nullable but force-unwrapped → crash when null. Guard first / show a placeholder. |
| `ui/components/custom_shimmer.dart` | `child: child!` | `ShimmerContainer.child` nullable, force-unwrapped. |
| `core/utils/preferences.dart` | `value!` | see §2.2 |

Safe pattern: validate at the top of `build`, or make the field `required`/non-null if it's truly mandatory.

---

## 4. Performance

1. **`Model.props => [toString()]`** (§2.4) — the most impactful. JSON serialization on every `==`. Noticeable for large lists in `PaginatorPage<T>`. Define `props` per field.
2. **`PaginatorPage` uses `ListView(children: [...List.generate(...)])`** — `ui/components/page_paginator.dart`. This builds **all** items at once, removing the benefit of lazy building. For long lists switch to `ListView.builder` (or `CustomScrollView` + `SliverList`) so only visible items are built.
3. **`getMaterialColor` recomputed on every access** — `ThemeProvider.colorSwatch` getter calls `getMaterialColor()` on every theme build. Cache it in the constructor (`late final MaterialColor _swatch = getMaterialColor(_colorSwatch);`).
4. **`themeData()` calls `themeProvider(context)` multiple times** and rebuilds the full `ThemeData` on every rebuild. Minor, but combine into a single local variable.
5. **`paramsToString` builds a String via concatenation** in a loop — small, but moving to Dio `queryParameters` removes it and fixes §2.6 at once.

---

## 5. Development potential

- **`analysis_options.yaml` + `flutter_lints`** are missing. The README demands "zero warnings" but there's no linter config. Add `package:flutter_lints/flutter.yaml` + extra rules (`prefer_const_constructors`, `require_trailing_commas`).
- **No `test/` folder.** Add minimal unit tests for `StringExtensions.capitalize`, `getMaterialColor`, `ApiResponse.fromJson`, and widget tests for the components.
- **`styles.dart` is empty** even though the README documents "Styles". Fill it or remove the reference.
- **The auth header in `HttpConnection._preRequestHeaders` is still commented out.** Enable it (via a Dio `Interceptor` or in the hook) so the token is injected automatically and the logic stays centralized (also handles refresh/401).
- **Endpoints are hardcoded** in `environment.dart`. Consider `--dart-define` (`String.fromEnvironment`) so URLs/secrets aren't committed.
- **Theme persistence**: `ThemeProvider.setThemeMode` doesn't save the choice to `SharedPreferences`; the choice is lost on restart. Wire it to `Preferences`.
- **`generated_plugin_registrant.dart` is committed** — it's a generated file and should be `.gitignore`d.
- **Blank splash**: `SplashScreen`/`MainScreen` are just empty `Scaffold()`s (white screen). Add at least a logo/indicator.
- **Localization**: `intl` is already present; add `flutter_localizations` + `l10n.yaml` scaffolding if multi-language is needed.
- **CI**: add a GitHub Actions workflow (`flutter analyze` + `flutter test`) to keep "zero warnings" enforced.

---

## 6. Priority table

| # | Item | Type | Priority | Effort |
|---|---|---|---|---|
| 2.1 | `switchConfig` no-op | Bug | 🔴 High | XS |
| 2.2 | `Preferences` null + missing API | Bug/Doc | 🔴 High | XS |
| 2.3 | `Platform.isIOS` web crash | Bug | 🔴 High | XS |
| 2.4 | `Model.props` toString | Perf | 🔴 High | S |
| 2.5 | `ApiResponse` generic | Bug/Doc | 🟠 Medium | S |
| 2.6 | URL-encode params | Bug/Sec | 🟠 Medium | XS |
| 2.8 | `DateFormat` locale type | Bug | 🟠 Medium | S |
| 3 | UI force-unwraps | Robustness | 🟠 Medium | XS |
| 4.2 | Paginator `ListView.builder` | Perf | 🟠 Medium | S |
| 5 | Lints + tests + CI | DX | 🟡 Low | M |

---

## 7. Notes

This review is **static** — `flutter analyze`/`dart fix` were not run (the SDK was unavailable). Before merging fixes, run locally:
```sh
flutter analyze
dart fix --apply
flutter test
```
Items marked "verify" (§2.8) should be confirmed with the analyzer first.
