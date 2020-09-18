import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerObject extends StatelessWidget {
  final double width, height;
  final BorderRadius radius;
  final EdgeInsets margin, padding;

  const ShimmerObject(
      {Key key,
      this.width,
      this.height,
      this.radius,
      this.margin,
      this.padding})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? double.infinity,
      height: height ?? double.infinity,
      decoration: BoxDecoration(
          borderRadius: radius ?? BorderRadius.circular(5),
          color: Colors.grey.shade100),
      margin: margin ?? EdgeInsets.only(),
      padding: padding ?? EdgeInsets.only(),
    );
  }
}

class ShimmeringObject extends StatelessWidget {
  final double width, height;
  final BorderRadius radius;
  final EdgeInsets margin, padding;

  const ShimmeringObject(
      {Key key,
      this.width,
      this.height,
      this.radius,
      this.margin,
      this.padding})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ShimmerContainer(
      child: ShimmerObject(
        width: width ?? double.infinity,
        height: height ?? double.infinity,
        margin: margin ?? EdgeInsets.only(),
        padding: padding ?? EdgeInsets.only(),
        radius: radius ?? BorderRadius.circular(10),
      ),
    );
  }
}

class ShimmerContainer extends StatelessWidget {
  final Widget child;
  const ShimmerContainer({Key key, this.child})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade200,
      child: child,
      highlightColor: Colors.grey.shade100,
    );
  }
}
