import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../models/model.dart';

abstract class HttpConnection {
  final BuildContext context;

  HttpConnection(this.context) {
    //You can init providers here, so it can be access from subclass
  }

  //if pure == true, it will return data without parse it to ApiResponse
  Future post(String url, {Map<String, String>? params, dynamic body, dynamic headers, bool pure = false}) async {
    try {
      var resp = await Dio().post(url + paramsToString(params), data: body, options: Options(headers: headers));
      if (pure) return resp.data;
      if (resp.data != null) {
        return ApiResponse.fromJson(resp.data);
      }
    } catch (e) {
      return null;
    }
  }

  //if pure == true, it will return data without parse it to ApiResponse
  Future get(String url, {Map<String, String>? params, dynamic headers, bool pure = false}) async {
    try {
      var resp = await Dio().get(url + paramsToString(params), options: Options(headers: headers));
      if (pure) return resp.data;
      if (resp.data != null) {
        return ApiResponse.fromJson(resp.data);
      }
    } catch (e) {
      return null;
    }
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
