abstract class Model {
  Map<String, dynamic> toJson();
  String toString() => toJson().toString();
}
