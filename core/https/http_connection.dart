import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hayal/core/providers/globals/user_provider.dart';
import '../models/model.dart';
import '../resources/environment.dart';

abstract class HttpConnection {
  final BuildContext context;

  Dio get _dio => Dio(
        BaseOptions(
          baseUrl: endpoint,
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $apiToken}',
          },
        ),
      );

  HttpConnection(this.context);

  ///if pure == true, it will return data without parse it to ApiResponse
  Future get(String url, {Map<String, String>? params, dynamic headers, bool pure = true, bool showDebug = false}) async {
    try {
      headers = _preRequest(headers);
      _printRequest("get", "${_dio.options.baseUrl}$url${paramsToString(params)}", showDebug: showDebug);
      var resp = await _dio.get(url + paramsToString(params), options: Options(headers: headers));
      _printResponse(resp.data, showDebug);
      if (pure) return resp.data;
      if (resp.data != null) {
        return ApiResponse.fromJson(resp.data);
      }
    } catch (e) {
      return null;
    }
  }

  ///if pure == true, it will return data without parse it to ApiResponse
  Future post(String url, {Map<String, String>? params, dynamic body, dynamic headers, bool pure = true, bool showDebug = false}) async {
    try {
      headers = _preRequest(headers);
      _printRequest("post", "${_dio.options.baseUrl}$url${paramsToString(params)}", body: body, showDebug: showDebug);
      var resp = await _dio.post(url + paramsToString(params), data: body, options: Options(headers: headers));
      _printResponse(resp.data, showDebug);
      if (pure) return resp.data;
      if (resp.data != null) {
        return ApiResponse.fromJson(resp.data);
      }
    } catch (e) {
      return null;
    }
  }

  ///if pure == true, it will return data without parse it to ApiResponse
  Future put(String url, {Map<String, String>? params, dynamic body, dynamic headers, bool pure = true, bool showDebug = false}) async {
    try {
      headers = _preRequest(headers);
      _printRequest("put", "${_dio.options.baseUrl}$url${paramsToString(params)}", body: body, showDebug: showDebug);
      var resp = await _dio.put(url + paramsToString(params), data: body, options: Options(headers: headers));
      _printResponse(resp.data, showDebug);
      if (pure) return resp.data;
      if (resp.data != null) {
        return ApiResponse.fromJson(resp.data);
      }
    } catch (e) {
      return null;
    }
  }

  ///if pure == true, it will return data without parse it to ApiResponse
  Future delete(String url, {Map<String, String>? params, dynamic body, dynamic headers, bool pure = true, bool showDebug = false}) async {
    try {
      headers = _preRequest(headers);
      _printRequest("delete", "${_dio.options.baseUrl}$url${paramsToString(params)}", body: body, showDebug: showDebug);
      var resp = await _dio.delete(url + paramsToString(params), data: body, options: Options(headers: headers));
      _printResponse(resp.data, showDebug);
      if (pure) return resp.data;
      if (resp.data != null) {
        return ApiResponse.fromJson(resp.data);
      }
    } catch (e) {
      return null;
    }
  }

  ///Add something before request, you can simply manipulate headers or anyting in here
  ///And got called before request called
  ///
  ///for an Example :
  Map<String, String>? _preRequest(Map<String, String>? headers) {
    var userProvider = UserProvider.of(context);
    if (userProvider.token != null) {
      if (headers != null) {
        headers.addEntries([MapEntry("Access-Token", "Bearer ${userProvider.token!.accessToken}")]);
      } else {
        headers = {"Access-Token": "Bearer ${userProvider.token!.accessToken}"};
      }
    }
    return headers;
  }

  static String paramsToString(Map<String, String>? params) {
    if (params == null) return "";
    String output = "?";
    params.forEach((key, value) {
      output += "$key=$value&";
    });
    return output.substring(0, output.length - 1);
  }

  ///Print request to console for debug purpose
  void _printRequest(String type, String url, {Map<String, dynamic>? body, bool showDebug = false}) {
    if (kDebugMode && showDebug) {
      log("${type.toUpperCase()} REQUEST : $url \n");
      if (body != null) {
        try {
          JsonEncoder encoder = const JsonEncoder.withIndent('  ');
          String prettyprint = encoder.convert(body);
          log("BODY : $prettyprint");
        } catch (e) {
          log("CAN'T FETCH BODY");
        }
      }
      log("==================== WAIT FOR RESPONSE =========================\n\n");
    }
  }

  ///Print response to console for debug purpose
  void _printResponse(dynamic response, [bool showDebug = false]) {
    String? prettyprint;
    log(response.toString());
    if (response is Map) {
      try {
        JsonEncoder encoder = const JsonEncoder.withIndent('  ');
        prettyprint = encoder.convert(response);
        // ignore: empty_catches
      } catch (e) {}
    }
    if (kDebugMode && showDebug) {
      log(prettyprint ?? response.toString());
      log("=======================================================\n\n");
    }
  }
}

class ApiResponse<T> extends Model {
  ApiResponse({
    this.success = false,
    this.message,
    this.data,
  });

  bool? success;
  String? message;
  T? data;

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
