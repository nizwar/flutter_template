import 'package:flutter/material.dart';
import 'package:mobile_551/core/https/authHttp.dart';
import 'package:mobile_551/ui/components/customDivider.dart';
import 'package:ndialog/ndialog.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController _etUsername = TextEditingController();
  final TextEditingController _etPassword = TextEditingController();

  final FocusNode _fcUsername = FocusNode();
  final FocusNode _fcPassword = FocusNode();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ListView(
            physics: BouncingScrollPhysics(),
            shrinkWrap: true,
            padding: EdgeInsets.all(20),
            children: [
              Image.asset(
                "assets/logo-new.png",
                height: 200,
              ),
              ColumnDivider(
                space: 20,
              ),
              TextField(
                controller: _etUsername,
                focusNode: _fcUsername,
                textInputAction: TextInputAction.next,
                onSubmitted: (value) {
                  FocusScope.of(context).unfocus();
                  _fcPassword.requestFocus();
                },
                decoration: defaultDecoration("Username"),
              ),
              ColumnDivider(),
              TextField(
                controller: _etPassword,
                focusNode: _fcPassword,
                obscureText: true,
                decoration: defaultDecoration("Password"),
              ),
              ColumnDivider(space: 30),
              SizedBox(
                height: 40,
                child: FlatButton(
                  color: Colors.deepOrange.shade400,
                  child: Text(
                    "Log In",
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () => loginClick(context),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void loginClick(BuildContext context) async {
    await CustomProgressDialog.future(context,
        future: AuthHttp(context).login(_etUsername.text, _etPassword.text));
  }

  InputDecoration defaultDecoration(String hint) => InputDecoration(
        hintText: hint,
        contentPadding: EdgeInsets.symmetric(horizontal: 15),
        border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade300)),
        focusedBorder:
            OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade300)),
        fillColor: Colors.grey.shade200,
        filled: true,
      );
}
