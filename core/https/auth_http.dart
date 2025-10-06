import 'package:mojang_nontr/core/https/http_connection.dart';
import 'package:mojang_nontr/core/models/auth.dart';

import '../models/user.dart';

class AuthHttp extends HttpConnection {
  AuthHttp(super.context);

  Future<Auth> login(String nik, String password) async {
    ApiResponse response = await post('/login', body: {
      'nik': nik,
      'password': password,
    });
    return Auth.fromJson(response.result);
  }

  Future<User> getProfile() async {
    ApiResponse response = await get('/profile');
    return User.fromJson(response.result);
  }
}
