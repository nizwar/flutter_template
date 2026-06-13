# Models

Models represent the data structures exchanged with your backend and used across the app. You can hand-write them or generate a starting point from JSON with [Quicktype](https://app.quicktype.io), then adapt it to this template.

Every model **must extend `Model`** to inherit value equality (via Equatable), JSON serialization, and debug helpers.

## AI Instructions (Models)

1. Each model must extend `Model`.
2. File names are the entity name in snake_case (e.g., `user.dart`); no prefixes or suffixes.
3. Keep models immutable (`final` fields) when possible.
4. Never import UI (`material.dart`, widgets) inside a model.
5. Mark optional fields nullable and handle them safely in `fromJson`.
6. **Always override `props`** with the real fields (see performance note below).

## Base model (what you get)

`Model` extends `Equatable`, so `==`/`hashCode` come from the `props` list. It also provides:

- `toJson()` — required; you implement it.
- `toString()` — defaults to `toJson().toString()`.
- `print()` — logs the model via `clog()` (debug-only, pretty JSON).
- `stringify` — enabled for readable debug output.

### ⚠️ Performance: always override `props`

The base `Model.props` defaults to `[toString()]`, which serializes the entire object to JSON on **every** equality check. That is wasteful (it runs on rebuilds and in large lists) and fragile. For every model, override `props` with the actual fields:

```dart
@override
List<Object?> get props => [id, name, email];
```

## Example

A file containing the `User` model is named `user.dart`. Given this JSON:

```json
{
  "id": 1,
  "name": "John Doe",
  "email": "john.doe@example.com"
}
```

Write the model like this:

```dart
class User extends Model {
  final int id;
  final String name;
  final String email;

  User({
    required this.id,
    required this.name,
    required this.email,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        name: json["name"],
        email: json["email"],
      );

  @override
  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
      };

  // Override props with real fields for fast, correct equality.
  @override
  List<Object?> get props => [id, name, email];
}
```

### Tips

- Add a `copyWith` when you need to update a few fields immutably.
- For nullable JSON, default safely: `count: json["count"] ?? 0`.
- Nest models by calling their `fromJson` in the parent: `address: Address.fromJson(json["address"])`.
