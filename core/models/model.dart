abstract class Model {
  Map<String, dynamic> toJson();

  @override
  String toString() => toJson().toString();
}
