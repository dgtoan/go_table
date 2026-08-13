import 'package:flutter/material.dart';

class GoTableActions<T> {
  final void Function(T data)? onRowTap;
  final VoidCallback? onRefresh;
  final ValueChanged<int>? onRowsPerPageChanged;
  final ValueChanged<int>? onPageChanged;

  GoTableActions({
    this.onRowTap,
    this.onRefresh,
    this.onRowsPerPageChanged,
    this.onPageChanged,
  });
}
