# HTTP Connections

All API calls are managed through the HTTP clients defined in this folder. They centralize communication between the app and the backend so requests, headers, and errors are handled consistently.

## AI Instructions (HTTP)

1. All API files must use the `*_http.dart` suffix and extend `HttpConnection`.
2. Never perform UI actions (dialogs, navigation, snackbars) inside an `HttpConnection`.
3. Keep endpoint paths relative to the base URL; only override the base URL when you truly need a different host.
4. Handle `HttpErrorConnection` at the widget layer with clear user feedback.
5. Keep request/response models in `lib/core/models` and extend `Model`.

## Implementation notes (from code)

- `HttpConnection` exposes `get`, `post`, `put`, and `delete`, each accepting optional `params`, `headers`, and (where applicable) `body`.
- Query parameters are passed as `params` (`Map<String, dynamic>?`) and encoded automatically by Dio — do not hand-build query strings.
- The base URL is read from `AppConfig.read(context).endpoint` and can be changed at runtime with `updateBaseUrl(url)`.
- `_preRequestHeaders` injects the `Authorization: Bearer <token>` header automatically from `UserProvider` — you usually don't need to add it manually.
- Every Dio error is wrapped into `HttpErrorConnection` and logged to Crashlytics.
- `ApiResponse` has `status` (int), `message` (String?), and `result` (the payload). Use `resp.success` (true for 2xx) and read the payload from `resp.result`.

Because the base URL lives in the active `AppConfig`, you only pass the path relative to it. For a base URL of `https://api.example.com`, a login request is simply `post("/auth/login", ...)`.

## API requests

### Simple request

Name the file with the `_http` suffix; the class drops the suffix and uses PascalCase. A file handling user requests is `user_http.dart` with the class `UserHttp`.

```dart
class UserHttp extends HttpConnection {
  // The context is forwarded to HttpConnection so it can read providers/config.
  UserHttp(BuildContext context) : super(context);

  // Example: login.
  Future<User> login({required String username, required String password}) async {
    // `post` is inherited from HttpConnection.
    final resp = await post<ApiResponse>("/login", body: {
      "username": username,
      "password": password,
    });

    // Example API response wrapped by ApiResponse:
    // { "status": 200, "message": "Success", "result": {"name": "nizwar", ...} }

    // The payload lives in `result` (NOT `data`).
    if (resp.success) return User.fromJson(resp.result);

    // Surface failures as a typed exception for the widget layer to handle.
    throw HttpErrorConnection(status: resp.status, title: "Login", message: resp.message ?? "Login failed");
  }
}
```

#### Typed `result` deserialization (optional)

`ApiResponse.fromJson` accepts an optional `fromJsonT` callback to deserialize the `result` payload directly:

```dart
final resp = ApiResponse<User>.fromJson(json, (data) => User.fromJson(data));
final User? user = resp.result; // already typed
```

### Query parameters

```dart
final resp = await get<ApiResponse>("/search", params: {"q": "hello world", "page": 1});
// Dio encodes this to /search?q=hello%20world&page=1
```

### Multipart form (file upload)

Use `FormData` as the request body:

```dart
final resp = await post<ApiResponse>(
  "/upload",
  body: FormData.fromMap({
    "file": await MultipartFile.fromFile(file.path),
    "other_field": "Dummy data",
  }),
);
```

### Custom base URL

For a one-off request to a different host, change the base URL before calling:

```dart
updateBaseUrl("https://another-base-url.com");
```

For a client that always targets a different host, override it in the constructor body:

```dart
class ExternalApi extends HttpConnection {
  ExternalApi(BuildContext context) : super(context) {
    updateBaseUrl("https://another-base-url.com");
  }
}
```

### Authorization (automatic)

Authorization is already wired: `_preRequestHeaders` reads the token from `UserProvider` and appends `Authorization: Bearer <token>` to every request when a token is present. To enable it, set the token after login:

```dart
await UserProvider.read(context).setToken(resp.result["access_token"]);
// later: UserProvider.logout(context); // clears it from memory + storage
```

If your token lives elsewhere or has a different shape, adjust `_preRequestHeaders` in `lib/core/https/http_connection.dart`.

### Error handling

Network errors are thrown as `HttpErrorConnection`, which exposes:

1. `status` — the HTTP status code (or `-1` when there was no response).
2. `message` — a human-readable description.
3. `title` — a short label/category for the error.
4. `data` — the raw response body from the server (if any).
5. `body` — the request body that was sent.

Catch it at the widget layer — never inside the HTTP client:

```dart
Future<void> loginUser() async {
  try {
    await userHttp.login(username: "user", password: "pass");
  } on HttpErrorConnection catch (e) {
    showErrorDialog(context, e.message); // present a friendly message
  }
}
```

#### Best practices

- **Never show UI inside `HttpConnection`.** Keep dialogs/navigation at the widget level.
- **Catch centrally per screen** with `try/catch` on `HttpErrorConnection`.
- **Customize feedback** by reading `e.status`/`e.data` to map specific server error codes to user messages.

## Checklist for new endpoints

- [ ] Create a model in `lib/core/models` (extend `Model`, override `props`).
- [ ] Create a `*_http.dart` client extending `HttpConnection`.
- [ ] Add a provider if the data is shared globally.
- [ ] Handle `HttpErrorConnection` in the screen/widget.
