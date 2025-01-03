# MODELS
To create models in your project, you can use [Quicktype](https://app.quicktype.io), a tool that generates classes from JSON data. This tool helps to quickly create models that are ready to use in your application.

After generating your model, ensure to `extend the Model class` to inherit all the features and benefits provided by it, such as serialization, validation, and other utility functions.

### Example:
For consistency and clarity, all file names should follow a strict naming convention without any prefixes or suffixes. Simply use the name of the entity represented in the file.

Example: A file containing the User model should be named `user.dart`.

This convention ensures uniformity across the project and makes it easier to locate and identify files.

Suppose you have the following JSON response:
```json
{
  "id": 1,
  "name": "John Doe",
  "email": "john.doe@example.com"
}
```
You can use Quicktype to generate the following model:
```dart
class User extends Model{
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
}
```