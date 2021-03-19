import 'package:flutter/material.dart';
import 'package:mobile_551/core/https/httpConnection.dart';
import 'package:mobile_551/core/providers/userProvider.dart';
import 'package:mobile_551/core/resources/environment.dart';
import 'package:mobile_551/core/utils/preferences.dart';
import 'package:mobile_551/core/utils/utils.dart';
import 'package:ndialog/ndialog.dart';

class AuthHttp extends HttpConnection {
  AuthHttp(BuildContext context) : super(context);

  Future<bool> login(String username, String password) async {
    var resp = await post(
      endpoint + "login-auth-member",
      body: {
        "username": username,
        "password": password,
      },
      pure: true,
    ).timeout(Duration(seconds: 15));

    if (resp != null) {
      if (resp["status"]) {
        Preferences.instance().then((value) {
          value.saveToken(resp["token"]);
          UserProvider.instance(context).token = resp["token"];
        });
        return true;
      } else {
        await NAlertDialog(
          title: Text("Perhatian"),
          content: Text(resp["message"]),
          actions: [
            FlatButton(
              onPressed: () {
                closeScreen(context);
              },
              child: Text("Mengerti"),
            ),
          ],
        ).show(context);
        return false;
      }
    }
    await NAlertDialog(
      title: Text("Perhatian"),
      content: Text("Gagal terhubung, mohon periksa koneksi internet anda"),
      actions: [
        FlatButton(
          onPressed: () {
            closeScreen(context);
          },
          child: Text("Mengerti"),
        ),
      ],
    ).show(context);
    return false;
  }
}
