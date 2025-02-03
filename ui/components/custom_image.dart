import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:ndialog/ndialog.dart';

import 'custom_shimmer.dart';

class CustomImage extends StatelessWidget {
  final String? url;
  final double? width, height;
  final BorderRadius? borderRadius;
  final BoxFit? fit;
  final bool showBlackGradient;
  final bool zoomOnTap;
  final String? errorAssets;
  final BoxShape? boxShape;

  const CustomImage({
    super.key,
    @required this.url,
    this.width,
    this.height,
    this.borderRadius,
    this.errorAssets,
    this.fit = BoxFit.cover,
    this.zoomOnTap = false,
    this.showBlackGradient = false,
    this.boxShape,
  });

  @override
  Widget build(BuildContext context) {
    VoidCallback? zoomOnTapFunction;
    if (zoomOnTap) {
      zoomOnTapFunction = () {
        ZoomDialog(
          child: CustomImage(url: url, boxShape: boxShape, borderRadius: borderRadius, errorAssets: errorAssets, fit: fit, height: height, width: width, showBlackGradient: false, zoomOnTap: false),
        ).show(context);
      };
    }
    return GestureDetector(
      onTap: zoomOnTapFunction,
      child: Container(
        height: height ?? double.infinity,
        width: width ?? double.infinity,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(borderRadius: boxShape != null ? null : (borderRadius ?? BorderRadius.circular(0.0)), shape: boxShape ?? BoxShape.rectangle),
        child: Stack(
          fit: StackFit.expand,
          alignment: Alignment.center,
          children: <Widget>[
            CachedNetworkImage(
              fit: fit!,
              imageUrl: url!,
              placeholder: (context, string) => Container(alignment: Alignment.center, child: ShimmeringObject(radius: borderRadius ?? BorderRadius.circular(0.0))),
              errorWidget: (context, string, obj) {
                if (errorAssets == null) return Center(child: Icon(Icons.error_outline));
                return Image.asset(
                  errorAssets!,
                  fit: BoxFit.cover,
                );
              },
            ),
            if (showBlackGradient)
              Container(
                decoration: BoxDecoration(
                    gradient:
                        LinearGradient(colors: [Colors.black.withValues(alpha: .5), Colors.transparent, Colors.black.withValues(alpha: .5)], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
              )
          ],
        ),
      ),
    );
  }
}
