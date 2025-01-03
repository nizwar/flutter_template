import 'package:equatable/equatable.dart';

import '../utils/logger.dart';

abstract class Model extends Equatable {
  Map<String, dynamic> toJson();

  @override
  String toString() => toJson().toString();

  @override
  List<Object?> get props => [toString()];

  @override
  bool? get stringify => true;

  void print() => clog(toJson());
}
