import 'package:flutter/material.dart';

class GoTableColumn<T> {
  final String? headerLabel;
  final Widget? Function(BuildContext context)? header;
  final int? flex;
  final double? width;
  final Widget Function(int rowIndex, T data) cellBuilder;

  GoTableColumn({
    this.headerLabel,
    this.header,
    this.flex,
    this.width,
    required this.cellBuilder,
  }) : assert(
         flex == null || width == null,
         'Cannot provide both flex and width.',
       ),
       assert(
         flex != null || width != null,
         'Must provide either flex or width.',
       );
}
