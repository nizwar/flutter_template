import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:mobile_551/core/providers/userProvider.dart';
import 'package:mobile_551/core/utils/preferences.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class BrowserScreen extends StatefulWidget {
  @override
  _BrowserScreenState createState() => _BrowserScreenState();
}

class _BrowserScreenState extends State<BrowserScreen> {
  bool loading = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<UserProvider>(
        builder: (context, value, child) => SafeArea(
          child: Stack(
            children: [
              InAppWebView(
                onLoadStop: (controller, url) {
                  setState(() {
                    loading = false;
                  });
                  if ((url.split("/").last == "logout" ||
                          url.contains("logout")) ||
                      (url.split("/").last == "login" ||
                          url.contains("login"))) {
                    Preferences.logout(context);
                  }
                },
                onLoadStart: (controller, url) {
                  setState(() {
                    loading = true;
                  });
                  if (!url.contains("551.co.id")) return launch(url);
                },
                initialUrl: "https://dashboard.551.co.id/auto-login/api/" +
                        value?.token ??
                    "",
              ),
              !loading
                  ? SizedBox.shrink()
                  : Container(
                      color: Colors.white.withOpacity(.5),
                      alignment: Alignment.center,
                      child: Container(
                        padding: EdgeInsets.all(30),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.white),
                        child: CircularProgressIndicator(),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
