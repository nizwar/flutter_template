import 'package:flutter/material.dart';

import '../../core/resources/themes.dart';

class CustomCard extends StatelessWidget {
  final double? borderRadius;
  final Color? backgroundColor;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final BoxShadow? boxShadow;
  final Widget? child;

  const CustomCard({
    super.key,
    this.borderRadius,
    this.child,
    this.boxShadow,
    this.backgroundColor,
    this.margin,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin ?? EdgeInsets.zero,
      padding: padding ?? EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        boxShadow: [boxShadow ?? BoxShadow(blurRadius: 5, color: theme(context).shadowColor)],
        borderRadius: BorderRadius.circular(borderRadius ?? 10),
        color: backgroundColor ?? Theme.of(context).cardColor,
      ),
      child: child ?? const SizedBox.shrink(),
    );
  }
}
