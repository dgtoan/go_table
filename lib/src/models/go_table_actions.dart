import 'package:flutter/material.dart';

typedef GoTableCellKeyEventCallback<T> = void Function(
  int rowIndex,
  int columnIndex,
  T data,
  KeyEvent event,
);

class GoTableActions<T> {
  final void Function(T data)? onRowTap;
  final GoTableCellKeyEventCallback<T>? onCellKeyEvent;
  final VoidCallback? onRefresh;
  final ValueChanged<int>? onRowsPerPageChanged;
  final ValueChanged<int>? onPageChanged;

  GoTableActions({
    this.onRowTap,
    this.onCellKeyEvent,
    this.onRefresh,
    this.onRowsPerPageChanged,
    this.onPageChanged,
  });
}
