import 'dart:convert';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import '../models/model.dart';
import '../providers/user_provider.dart';
import '../utils/app_config.dart';

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
    this.dio = dio ?? Dio(BaseOptions(baseUrl: AppConfig.read(context).endpoint, headers: {'Content-Type': 'application/json', 'Accept': 'application/json'}));
  }

  Future<T> get<T>(String url, {Map<String, String>? params, dynamic headers}) async {
    try {
      headers = await _preRequestHeaders(headers);
      var resp = await dio.get(url + paramsToString(params), options: Options(headers: headers));
      if (resp.data != null) {
        if (T.toString().startsWith('ApiResponse')) {
          return ApiResponse.fromJson(resp.statusCode ?? -1, resp.data) as T;
        }
        return resp.data as T;
      }
    } on DioException catch (e) {
      throw _handleError(e);
    } on SocketException catch (_) {
      throw HttpErrorConnection(status: -3, title: "Socket Exception", message: "Kesalahan saat memuat", requestOptions: RequestOptions(path: url));
    } on FormatException catch (_) {
      throw HttpErrorConnection(status: -3, title: "Format Exception", message: "Format respon tidak valid", requestOptions: RequestOptions(path: url));
    }
    throw Exception("No data returned from the server");
  }

  Future<T> post<T>(String url, {Map<String, String>? params, dynamic body, dynamic headers}) async {
    try {
      headers = await _preRequestHeaders(headers);
      var resp = await dio.post(
        url + paramsToString(params),
        data: body,
        options: Options(headers: headers),
      );
      if (resp.data != null) {
        if (T.toString().startsWith('ApiResponse')) {
          return ApiResponse.fromJson(resp.statusCode ?? -1, resp.data) as T;
        }
        return resp.data as T;
      }
    } on DioException catch (e) {
      throw _handleError(e);
    } on SocketException catch (_) {
      throw HttpErrorConnection(status: -2, title: "Socket Exception", message: "Kesalahan saat memuat", requestOptions: RequestOptions(path: url));
    } on FormatException catch (_) {
      throw HttpErrorConnection(status: -3, title: "Format Exception", message: "Format respon tidak valid", requestOptions: RequestOptions(path: url));
    }
    throw Exception("No data returned from the server");
  }

  Future<T> put<T>(String url, {Map<String, String>? params, dynamic body, dynamic headers}) async {
    try {
      headers = await _preRequestHeaders(headers);
      var resp = await dio.put(
        url + paramsToString(params),
        data: body,
        options: Options(headers: headers),
      );
      if (resp.data != null) {
        if (T.toString().startsWith('ApiResponse')) {
          return ApiResponse.fromJson(resp.statusCode ?? -1, resp.data) as T;
        }
        return resp.data as T;
      }
    } on DioException catch (e) {
      throw _handleError(e);
    } on SocketException catch (_) {
      throw HttpErrorConnection(status: -2, title: "Socket Exception", message: "Kesalahan saat memuat", requestOptions: RequestOptions(path: url));
    } on FormatException catch (_) {
      throw HttpErrorConnection(status: -3, title: "Format Exception", message: "Format respon tidak valid", requestOptions: RequestOptions(path: url));
    }
    throw Exception("No data returned from the server");
  }

  Future<T> delete<T>(String url, {Map<String, String>? params, dynamic body, dynamic headers}) async {
    try {
      headers = await _preRequestHeaders(headers);
      var resp = await dio.delete(
        url + paramsToString(params),
        data: body,
        options: Options(headers: headers),
      );
      if (resp.data != null) {
        if (T.toString().startsWith('ApiResponse')) {
          return ApiResponse.fromJson(resp.statusCode ?? -1, resp.data) as T;
        }
        return resp.data as T;
      }
    } on DioException catch (e) {
      throw _handleError(e);
    } on SocketException catch (_) {
      throw HttpErrorConnection(status: -2, title: "Socket Exception", message: "Kesalahan saat memuat", requestOptions: RequestOptions(path: url));
    } on FormatException catch (_) {
      throw HttpErrorConnection(status: -3, title: "Format Exception", message: "Format respon tidak valid", requestOptions: RequestOptions(path: url));
    }
    throw Exception("No data returned from the server");
  }

  Future<Map<String, String>>? _preRequestHeaders(Map<String, String>? headers) async {
    try {
      AndroidDeviceInfo deviceInfo = await DeviceInfoPlugin().androidInfo;
      var deviceData = deviceInfo.data;
      var keys = deviceData.keys.toList();
      for (int i = 0; i < keys.length; i++) {
        var key = keys[i];
        var value = deviceData[key];
        if (value != null) {
          if (headers != null) {
            headers.addEntries([MapEntry("X-Device-$key", value.toString())]);
          } else {
            headers = {"X-Device-$key": value.toString()};
          }
        }
      }
    } catch (_) {
      FirebaseCrashlytics.instance.log("Failed to get device info while preparing request headers");
    }

    var token = UserProvider.read(context).auth?.token;
    if (token != null) {
      if (headers != null) {
        headers.addEntries([MapEntry("Authorization", "Bearer $token")]);
      } else {
        headers = {"Authorization": "Bearer $token"};
      }
    }
    return Future.value(headers);
  }

  HttpErrorConnection _handleError(DioException e) {
    FirebaseCrashlytics.instance.setCustomKey("has_api_response", e.response != null);
    FirebaseCrashlytics.instance.log("Request: ${e.requestOptions.path} ${e.requestOptions.method}");
    FirebaseCrashlytics.instance.log("Request Headers: ${jsonEncode(e.requestOptions.headers)}");
    if (e.requestOptions.data is FormData) {
      FirebaseCrashlytics.instance.log({for (var e in (e.requestOptions.data as FormData).fields) MapEntry(e.key, e.value)}.toString());
    } else {
      FirebaseCrashlytics.instance.log("Request Body: ${e.requestOptions.data}");
    }
    if (e.response != null) {
      final data = e.response?.data;
      if (data != null) {
        if (data is String) {
          FirebaseCrashlytics.instance.log(data);
          return HttpErrorConnection(status: e.response?.statusCode ?? -1, title: e.type.name, message: data, requestOptions: e.requestOptions);
        } else {
          try {
            ApiResponse respData = ApiResponse.fromJson(e.response?.statusCode ?? -1, data);
            FirebaseCrashlytics.instance.log(jsonEncode(respData.toJson()));
            return HttpErrorConnection(status: e.response?.statusCode ?? -1, title: "API Return Error", message: respData.message ?? "Not Available", requestOptions: e.requestOptions);
          } catch (_) {
            FirebaseCrashlytics.instance.log(jsonEncode(data));
            return HttpErrorConnection(status: e.response?.statusCode ?? -1, title: e.type.name, message: e.message ?? "Application internal error", requestOptions: e.requestOptions);
          }
        }
      }
      FirebaseCrashlytics.instance.log(data.toString());
      return HttpErrorConnection(status: e.response?.statusCode ?? -1, title: e.type.name, message: e.message ?? "Application internal error", requestOptions: e.requestOptions);
    }
    FirebaseCrashlytics.instance.log("${e.type.name} ${e.message} - THERE IS NO RESPONSE");
    return HttpErrorConnection(status: -1, title: e.type.name, message: e.message ?? "Application internal error", requestOptions: e.requestOptions);
  }

  static String paramsToString(Map<String, String>? params) {
    if (params == null) return "";
    String output = "?";
    params.forEach((key, value) {
      output += "$key=$value&";
    });
    return output.substring(0, output.length - 1);
  }
}

class ApiResponse<T> extends Model {
  ApiResponse({required this.status, this.message, this.result});

  final int status;
  final String? message;
  final T? result;

  bool get success => (status >= 200 && status < 300);
  factory ApiResponse.fromJson(int status, Map<String, dynamic> json) => ApiResponse(status: status, message: json["message"], result: json["data"]);

  @override
  Map<String, dynamic> toJson() => {"status": status, "message": message, "result": result};
}

class HttpErrorConnection implements Exception {
  final int status;
  final String message;
  final String title;

  final dynamic data;
  final dynamic body;

  HttpErrorConnection({required this.status, required this.message, required this.title, RequestOptions? requestOptions})
      : data = requestOptions?.data,
        body = requestOptions?.data;

  @override
  String toString() {
    return message;
  }
}
