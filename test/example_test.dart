// Example unit tests for the flutter_template boilerplate.
//
// These files live in `test/` at your Flutter project root. Adjust the import
// package name below (`boilerplate`) to match the `name:` in your pubspec.yaml,
// then run `flutter test`.

import 'package:flutter_test/flutter_test.dart';

import 'package:boilerplate/core/https/http_connection.dart';
import 'package:boilerplate/core/utils/extensions.dart';

void main() {
  group('StringExtensions.capitalize', () {
    test('capitalizes a single word', () {
      expect('hello'.capitalize, 'Hello');
    });

    test('capitalizes each word in a sentence', () {
      expect('hello world'.capitalize, 'Hello World');
    });

    test('returns empty string unchanged', () {
      expect(''.capitalize, '');
    });
  });

  group('ApiResponse', () {
    test('success is true for 2xx status', () {
      expect(ApiResponse(status: 200).success, isTrue);
      expect(ApiResponse(status: 204).success, isTrue);
    });

    test('success is false for non-2xx status', () {
      expect(ApiResponse(status: 404).success, isFalse);
      expect(ApiResponse(status: 500).success, isFalse);
    });

    test('fromJson parses fields and uses `result` (not `data`)', () {
      final r = ApiResponse.fromJson({
        'status': 200,
        'message': 'OK',
        'result': {'id': '1'},
      });
      expect(r.status, 200);
      expect(r.message, 'OK');
      expect(r.result, {'id': '1'});
    });

    test('fromJson applies fromJsonT to deserialise result', () {
      final r = ApiResponse<String>.fromJson(
        {'status': 200, 'result': 42},
        (d) => 'value:$d',
      );
      expect(r.result, 'value:42');
    });
  });
}
