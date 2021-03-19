import 'package:flutter/material.dart';
import 'package:mobile_551/core/utils/utils.dart';
import 'package:ndialog/ndialog.dart';
import 'package:zoom_widget/zoom_widget.dart';

class InfoDetailScreen extends StatelessWidget {
  final List<String> listAssets;
  final String title;

  const InfoDetailScreen(
      {Key key, @required this.listAssets, @required this.title})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          title,
          style: TextStyle(color: Colors.black),
        ),
        elevation: 10,
      ),
      body: Center(
        child: ListView(
          shrinkWrap: true,
          children: listAssets
              .map((e) => Container(
                    child: InkWell(
                      child: Image.asset(e),
                      onTap: () {
                        DialogBackground(
                          dialog: Zoom(
                            canvasColor: Colors.transparent,
                            backgroundColor: Colors.transparent,
                            initZoom: 0,
                            maxZoomWidth: MediaQuery.of(context).size.width * 3,
                            maxZoomHeight:
                                MediaQuery.of(context).size.height * 3,
                            child: Image.asset(
                              e,
                            ),
                            onTap: () {
                              closeScreen(context);
                            },
                          ),
                        ).show(context);
                      },
                    ),
                    margin: EdgeInsets.only(bottom: 10),
                  ))
              .toList(),
        ),
      ),
    );
  }
}
