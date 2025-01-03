import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/model.dart';
import '../providers/user_provider.dart';
import '../resources/environment.dart' as env;
import '../utils/logger.dart';
 

abstract class HttpConnection {
  final BuildContext context;
  late Dio dio;

  late String _baseUrl;
  String get baseUrl => _baseUrl;

  void updateBaseUrl(String url) {
    _baseUrl = url;
    dio.options.baseUrl = url;
  }

  HttpConnection(this.context, {String baseUrl = env.endpoint}) {
    _baseUrl = baseUrl;
    dio = Dio(BaseOptions(baseUrl: baseUrl, headers: {"Content-Type": "application/json"}));
  }

  ///if pure == true, it will return data without parse it to ApiResponse
  Future get(String url, {Map<String, String>? params, dynamic headers, bool pure = false}) async {
    try {
      headers = _preRequestHeaders(headers);
      var resp = await dio.get(url + paramsToString(params), options: Options(headers: headers));
      if (!_postRequestHeaders(resp)) return;
      if (pure) return resp.data;
      if (resp.data != null) {
        return ApiResponse.fromJson(resp.data);
      }
    } on DioException catch (e) {
      elog("DIO Error - Code ${e.response?.statusCode ?? -1}, ${e.type}, ${e.error}");
      throw HttpErrorConnection(status: e.response?.statusCode ?? -1, title: e.type.name, message: e.message ?? "Application internal error");
    }
  }

  ///if pure == true, it will return data without parse it to ApiResponse
  Future post(String url, {Map<String, String>? params, dynamic body, dynamic headers, bool pure = false}) async {
    try {
      headers = _preRequestHeaders(headers);
      var resp = await dio.post(url + paramsToString(params), data: body, options: Options(headers: headers));
      if (!_postRequestHeaders(resp)) return;
      if (pure) return resp.data;
      if (resp.data != null) {
        return ApiResponse.fromJson(resp.data);
      }
    } on DioException catch (e) {
      elog("DIO Error - Code ${e.response?.statusCode ?? -1}, ${e.type}, ${e.error}");
      throw HttpErrorConnection(status: e.response?.statusCode ?? -1, title: e.type.name, message: e.message ?? "Application internal error");
    }
  }

  ///if pure == true, it will return data without parse it to ApiResponse
  Future put(String url, {Map<String, String>? params, dynamic body, dynamic headers, bool pure = false}) async {
    try {
      headers = _preRequestHeaders(headers);
      var resp = await dio.put(url + paramsToString(params), data: body, options: Options(headers: headers));
      if (!_postRequestHeaders(resp)) return;
      if (pure) return resp.data;
      if (resp.data != null) {
        return ApiResponse.fromJson(resp.data);
      }
    } on DioException catch (e) {
      elog("DIO Error - Code ${e.response?.statusCode ?? -1}, ${e.type}, ${e.error}");
      throw HttpErrorConnection(status: e.response?.statusCode ?? -1, title: e.type.name, message: e.message ?? "Application internal error");
    }
  }

  ///if pure == true, it will return data without parse it to ApiResponse
  Future delete(String url, {Map<String, String>? params, dynamic body, dynamic headers, bool pure = false}) async {
    try {
      headers = _preRequestHeaders(headers);
      var resp = await dio.delete(url + paramsToString(params), data: body, options: Options(headers: headers));
      if (!_postRequestHeaders(resp)) return;
      if (pure) return resp.data;
      if (resp.data != null) {
        return ApiResponse.fromJson(resp.data);
      }
    } on DioException catch (e) {
      elog("DIO Error - Code ${e.response?.statusCode ?? -1}, ${e.type}, ${e.error}");
      throw HttpErrorConnection(status: e.response?.statusCode ?? -1, title: e.type.name, message: e.message ?? "Application internal error");
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

  bool _postRequestHeaders(Response response) {
    if (response.statusCode == null) throw Exception("Application error on requests");
    if (response.statusCode == 401) {
      ///TODO : Implement refresh token ketimbang suruh user login lagi
      UserProvider.logout(context);
      throw HttpErrorConnection(status: 401, message: "Session expired", title: "Authentication Error");
    }
    if (response.statusCode! > 300) {
      if (response.data is Map<String, dynamic>) {
        try {
          ApiResponse respData = ApiResponse.fromJson(response.data);
          elog("API - ${respData.message.toString()}");
          throw HttpErrorConnection(status: response.statusCode ?? -1, title: "API Return Error", message: respData.message ?? "Not Available");
        } catch (_) {}
      }
      elog("Response Error - Code ${response.statusCode}, ${response.statusMessage!}, ${response.data}");
      throw HttpErrorConnection(status: response.statusCode!, title: response.statusMessage!, message: response.data!);
    }
    return true;
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

///This is quick solution for make dummies request
///
///Just put your dummy json on assets folder and rename like after endpoint route
///and replace "/" to "."
///
///"assets/dummies/${url.replaceAll("/", ".")}.json"
class HttpDummies extends HttpConnection {
  HttpDummies(super.context);

  @override
  Future get(String url, {Map<String, String>? params, headers, bool pure = false}) async {
    return request(url, headers: headers, params: params, pure: pure);
  }

  @override
  Future post(String url, {Map<String, String>? params, body, headers, bool pure = false}) {
    return request(url, headers: headers, params: params, pure: pure);
  }

  @override
  Future put(String url, {Map<String, String>? params, body, headers, bool pure = false}) {
    return request(url, headers: headers, params: params, pure: pure);
  }

  @override
  Future delete(String url, {Map<String, String>? params, body, headers, bool pure = false}) {
    return request(url, headers: headers, params: params, pure: pure);
  }

  Future request(String url, {Map<String, String>? params, headers, bool pure = false}) async {
    try {
      await Future.delayed(const Duration(milliseconds: 300));
      elog("Loading assets/dummies/${url.replaceAll("/", ".")}.json");
      var raw = await rootBundle.loadString("assets/dummies/${url.replaceAll("/", ".")}.json");
      var data = jsonDecode(raw);
      elog(data);
      if (pure) return data;
      return ApiResponse.fromJson(data);
    } catch (e) {
      throw HttpErrorConnection(status: -500, message: "Error while parsing the dummies\n$e", title: "Parsing error");
    }
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

  HttpErrorConnection({required this.status, required this.message, required this.title});

  @override
  String toString() {
    return "Error $status, $title, $message";
  }
}
