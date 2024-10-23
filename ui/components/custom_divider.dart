import 'package:flutter/material.dart';

class ColumnDivider extends StatelessWidget {
  final double? space;
  final Color? color;
  const ColumnDivider({super.key, this.space, this.color});
  @override
  Widget build(BuildContext context) {
    return Container(height: space ?? 10, color: color);
  }
}

class RowDivider extends StatelessWidget {
  final double? space;
  final Color? color;
  const RowDivider({super.key, this.space, this.color});
  @override
  Widget build(BuildContext context) {
    return Container(width: space ?? 10, color: color);
  }
}
