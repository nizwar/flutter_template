import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import '../models/model.dart';
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

  HttpConnection(this.context, {String? baseUrl}) {
    baseUrl ??= AppConfig.read(context).endpoint;
    _baseUrl = baseUrl;
    dio = Dio(BaseOptions(baseUrl: baseUrl, headers: {"Content-Type": "application/json"}));
  }

  Future get(String url, {Map<String, String>? params, dynamic headers, bool pure = false}) async {
    try {
      headers = _preRequestHeaders(headers);
      var resp = await dio.get(url + paramsToString(params), options: Options(headers: headers));
      if (pure) return resp.data;
      if (resp.data != null) {
        return ApiResponse.fromJson(resp.data);
      }
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future post(String url, {Map<String, String>? params, dynamic body, dynamic headers, bool pure = false}) async {
    try {
      headers = _preRequestHeaders(headers);
      var resp = await dio.post(url + paramsToString(params), data: body, options: Options(headers: headers));
      if (pure) return resp.data;
      if (resp.data != null) {
        return ApiResponse.fromJson(resp.data);
      }
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future put(String url, {Map<String, String>? params, dynamic body, dynamic headers, bool pure = false}) async {
    try {
      headers = _preRequestHeaders(headers);
      var resp = await dio.put(url + paramsToString(params), data: body, options: Options(headers: headers));
      if (pure) return resp.data;
      if (resp.data != null) {
        return ApiResponse.fromJson(resp.data);
      }
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future delete(String url, {Map<String, String>? params, dynamic body, dynamic headers, bool pure = false}) async {
    try {
      headers = _preRequestHeaders(headers);
      var resp = await dio.delete(url + paramsToString(params), data: body, options: Options(headers: headers));
      if (pure) return resp.data;
      if (resp.data != null) {
        return ApiResponse.fromJson(resp.data);
      }
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Map<String, String>? _preRequestHeaders(Map<String, String>? headers) {
    // var userProvider = UserProvider.read(context);
    // if (userProvider.auth?.token != null) {
    //   if (headers != null) {
    //     headers.addEntries([MapEntry("Authorization", "Bearer ${userProvider.auth?.token}")]);
    //   } else {
    //     headers = {"Authorization": "Bearer ${userProvider.auth?.token}"};
    //   }
    // }
    return headers;
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
          return HttpErrorConnection(
            status: e.response?.statusCode ?? -1,
            title: e.type.name,
            message: data,
            requestOptions: e.requestOptions,
          );
        } else {
          try {
            ApiResponse respData = ApiResponse.fromJson(data);
            FirebaseCrashlytics.instance.log(jsonEncode(respData.toJson()));
            return HttpErrorConnection(
              status: e.response?.statusCode ?? -1,
              title: "API Return Error",
              message: respData.message ?? "Not Available",
              requestOptions: e.requestOptions,
            );
          } catch (_) {
            FirebaseCrashlytics.instance.log(jsonEncode(data));
            return HttpErrorConnection(
              status: e.response?.statusCode ?? -1,
              title: e.type.name,
              message: e.message ?? "Application internal error",
              requestOptions: e.requestOptions,
            );
          }
        }
      }
      FirebaseCrashlytics.instance.log(data.toString());
      return HttpErrorConnection(
        status: e.response?.statusCode ?? -1,
        title: e.type.name,
        message: e.message ?? "Application internal error",
        requestOptions: e.requestOptions,
      );
    }
    FirebaseCrashlytics.instance.log("${e.type.name} ${e.message} - THERE IS NO RESPONSE");
    return HttpErrorConnection(
      status: -1,
      title: e.type.name,
      message: e.message ?? "Application internal error",
      requestOptions: e.requestOptions,
    );
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
  ApiResponse({
    this.success = false,
    this.message,
    this.data,
  });

  final bool? success;
  final String? message;
  final T? data;

  factory ApiResponse.fromJson(Map<String, dynamic> json) => ApiResponse(
        success: json["success"],
        message: json["message"],
        data: json["data"],
      );

  @override
  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": data,
      };
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
    return "Error $status, $message";
  }
}
