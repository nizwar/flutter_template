import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:ndialog/ndialog.dart';
import 'customShimmer.dart';

class CustomImage extends StatelessWidget {
  final String url;
  final double width, height;
  final BorderRadius borderRadius;
  final BoxFit fit;
  final bool showBlackGradient;
  final bool zoomOnTap;

  const CustomImage(
      {Key key,
      @required this.url,
      this.width,
      this.height,
      this.borderRadius,
      this.fit,
      this.zoomOnTap,
      this.showBlackGradient = false})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (zoomOnTap ?? false)
          ? () {
              if (zoomOnTap ?? false)
                ZoomDialog(
                  child: CustomImage(
                    fit: BoxFit.contain,
                    url: url,
                  ),
                ).show(context);
            }
          : null,
      child: Container(
        height: height ?? double.infinity,
        width: width ?? double.infinity,
        decoration: BoxDecoration(
            borderRadius: borderRadius ?? BorderRadius.circular(0.0)),
        child: ClipRRect(
          borderRadius: borderRadius ?? BorderRadius.circular(0.0),
          child: Stack(
            fit: StackFit.expand,
            alignment: Alignment.center,
            children: <Widget>[
              CachedNetworkImage(
                fit: fit ?? BoxFit.cover,
                imageUrl: url ?? "",
                placeholder: (context, string) => Container(
                  alignment: Alignment.center,
                  child: ShimmeringObject(
                    radius: borderRadius ?? BorderRadius.circular(0.0),
                  ),
                ),
                errorWidget: (context, string, obj) => Image.asset(
                  "assets/images/nothumb.webp",
                  fit: BoxFit.cover,
                ),
              ),
              showBlackGradient
                  ? Container(
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                              colors: [
                            Colors.black.withOpacity(.5),
                            Colors.transparent,
                            Colors.black.withOpacity(.5)
                          ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter)),
                    )
                  : SizedBox.shrink(),
            ],
          ),
        ),
      ),
    );
  }
}
