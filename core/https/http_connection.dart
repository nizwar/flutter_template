import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import '../models/model.dart';
import '../providers/user_provider.dart';
import '../utils/app_config.dart';

/// Base class for all API clients.
///
/// Extend this class (one `*_http.dart` file per feature), pass the
/// [BuildContext] to the constructor, and call [get]/[post]/[put]/[delete].
/// Errors are normalised into [HttpErrorConnection] and logged to Crashlytics;
/// handle them at the widget layer.
///
/// ```dart
/// class UserHttp extends HttpConnection {
///   UserHttp(BuildContext context) : super(context);
///   Future<User> login(String u, String p) async {
///     final r = await post<ApiResponse>("/login", body: {"username": u, "password": p});
///     if (r.success) return User.fromJson(r.result);
///     throw HttpErrorConnection(status: r.status, title: "Login", message: r.message ?? "");
///   }
/// }
/// ```
abstract class HttpConnection {
  final BuildContext context;
  late Dio dio;

  late String _baseUrl;
  String get baseUrl => _baseUrl;

  void updateBaseUrl(String url) {
    _baseUrl = url;
    dio.options.baseUrl = url;
  }

  HttpConnection(this.context, [Dio? dio]) {
    _baseUrl = AppConfig.read(context).endpoint;
    this.dio = dio ?? Dio(BaseOptions(baseUrl: _baseUrl, headers: {'Content-Type': 'application/json', 'Accept': 'application/json'}));
  }

  Future<T> get<T>(String url, {Map<String, dynamic>? params, dynamic headers}) async {
    try {
      headers = _preRequestHeaders(headers);
      var resp = await dio.get(url, queryParameters: params, options: Options(headers: headers));
      return _parse<T>(resp.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<T> post<T>(String url, {Map<String, dynamic>? params, dynamic body, dynamic headers}) async {
    try {
      headers = _preRequestHeaders(headers);
      var resp = await dio.post(url, data: body, queryParameters: params, options: Options(headers: headers));
      return _parse<T>(resp.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<T> put<T>(String url, {Map<String, dynamic>? params, dynamic body, dynamic headers}) async {
    try {
      headers = _preRequestHeaders(headers);
      var resp = await dio.put(url, data: body, queryParameters: params, options: Options(headers: headers));
      return _parse<T>(resp.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<T> delete<T>(String url, {Map<String, dynamic>? params, dynamic body, dynamic headers}) async {
    try {
      headers = _preRequestHeaders(headers);
      var resp = await dio.delete(url, data: body, queryParameters: params, options: Options(headers: headers));
      return _parse<T>(resp.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Shared response handling: wraps raw data into [ApiResponse] when [T] is an
  /// [ApiResponse], otherwise returns the raw payload cast to [T].
  T _parse<T>(dynamic data) {
    if (data == null) throw Exception("No data returned from the server");
    if (T.toString().startsWith('ApiResponse')) {
      return ApiResponse.fromJson(data) as T;
    }
    return data as T;
  }

  /// Hook to inject per-request headers. Adds a `Bearer` token from
  /// [UserProvider] when one is available, without clobbering caller headers.
  Map<String, dynamic>? _preRequestHeaders(dynamic headers) {
    final result = <String, dynamic>{};
    if (headers is Map) {
      headers.forEach((key, value) => result["$key"] = value);
    }
    final token = UserProvider.read(context).token;
    if (token != null && token.isNotEmpty) {
      result["Authorization"] = "Bearer $token";
    }
    return result.isEmpty ? null : result;
  }

  HttpErrorConnection _handleError(DioException e) {
    FirebaseCrashlytics.instance.setCustomKey("has_api_response", e.response != null);
    FirebaseCrashlytics.instance.log("Request: ${e.requestOptions.path} ${e.requestOptions.method}");
    FirebaseCrashlytics.instance.log("Request Headers: ${jsonEncode(e.requestOptions.headers)}");
    if (e.requestOptions.data is FormData) {
      FirebaseCrashlytics.instance.log({for (var f in (e.requestOptions.data as FormData).fields) MapEntry(f.key, f.value)}.toString());
    } else {
      FirebaseCrashlytics.instance.log("Request Body: ${e.requestOptions.data}");
    }
    if (e.response != null) {
      final data = e.response?.data;
      if (data != null) {
        if (data is String) {
          FirebaseCrashlytics.instance.log(data);
          return HttpErrorConnection(status: e.response?.statusCode ?? -1, title: e.type.name, message: data, requestOptions: e.requestOptions, responseData: data);
        } else {
          try {
            ApiResponse respData = ApiResponse.fromJson(data);
            FirebaseCrashlytics.instance.log(jsonEncode(respData.toJson()));
            return HttpErrorConnection(status: e.response?.statusCode ?? -1, title: "API Return Error", message: respData.message ?? "Not Available", requestOptions: e.requestOptions, responseData: data);
          } catch (_) {
            FirebaseCrashlytics.instance.log(jsonEncode(data));
            return HttpErrorConnection(status: e.response?.statusCode ?? -1, title: e.type.name, message: e.message ?? "Application internal error", requestOptions: e.requestOptions, responseData: data);
          }
        }
      }
      FirebaseCrashlytics.instance.log(data.toString());
      return HttpErrorConnection(status: e.response?.statusCode ?? -1, title: e.type.name, message: e.message ?? "Application internal error", requestOptions: e.requestOptions);
    }
    FirebaseCrashlytics.instance.log("${e.type.name} ${e.message} - THERE IS NO RESPONSE");
    return HttpErrorConnection(status: -1, title: e.type.name, message: e.message ?? "Application internal error", requestOptions: e.requestOptions);
  }

  /// Builds a URL-encoded query string (e.g. `?a=1&b=hello%20world`).
  ///
  /// Kept for backward compatibility; new code should pass `params` to
  /// [get]/[post]/etc. directly, letting Dio encode them.
  static String paramsToString(Map<String, dynamic>? params) {
    if (params == null || params.isEmpty) return "";
    final query = params.entries
        .map((e) => "${Uri.encodeQueryComponent(e.key)}=${Uri.encodeQueryComponent('${e.value}')}")
        .join("&");
    return "?$query";
  }
}

/// Generic API envelope. The result field is named `result` (not `data`).
class ApiResponse<T> extends Model {
  ApiResponse({required this.status, this.message, this.result});

  bool get success => (status >= 200 && status < 300);

  final int status;
  final String? message;
  final T? result;

  /// Deserialises an [ApiResponse]. Pass [fromJsonT] to also deserialise the
  /// `result` payload into a typed object; otherwise it is returned as-is.
  ///
  /// ```dart
  /// final r = ApiResponse<User>.fromJson(json, (d) => User.fromJson(d));
  /// ```
  factory ApiResponse.fromJson(Map<String, dynamic> json, [T Function(dynamic result)? fromJsonT]) {
    final raw = json["result"];
    return ApiResponse<T>(
      status: json["status"] is int ? json["status"] : int.tryParse("${json["status"]}") ?? -1,
      message: json["message"]?.toString(),
      result: (fromJsonT != null && raw != null) ? fromJsonT(raw) : raw as T?,
    );
  }

  @override
  Map<String, dynamic> toJson() => {"status": status, "message": message, "result": result};

  @override
  List<Object?> get props => [status, message, result];
}

/// Normalised network error thrown by [HttpConnection].
class HttpErrorConnection implements Exception {
  final int status;
  final String message;
  final String title;

  /// The response body returned by the server (if any).
  final dynamic data;

  /// The request body that was sent.
  final dynamic body;

  HttpErrorConnection({
    required this.status,
    required this.message,
    required this.title,
    RequestOptions? requestOptions,
    dynamic responseData,
  })  : data = responseData,
        body = requestOptions?.data;

  @override
  String toString() => "Error $status, $message";
}
