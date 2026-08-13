import 'package:flutter/material.dart';

class GoTableDecoration {
  final Color? headerBackgroundColor;
  final Color Function(int rowIndex) rowBackgroundColor;
  final Color? dividerColor;
  final IconData filterIcon;
  final IconData filterEnabledIcon;
  final IconData sortIcon;
  final IconData refreshIcon;
  final IconData previousPageIcon;
  final IconData nextPageIcon;
  final Widget emptyWidget;

  static Color defaultRowBackgroundColor(int index) {
    return index % 2 == 0
        ? Colors.transparent
        : Colors.grey.withValues(alpha: 0.1);
  }

  const GoTableDecoration({
    this.headerBackgroundColor,
    this.rowBackgroundColor = defaultRowBackgroundColor,
    this.dividerColor,
    this.filterIcon = Icons.filter_list_off,
    this.filterEnabledIcon = Icons.filter_list,
    this.sortIcon = Icons.arrow_downward,
    this.refreshIcon = Icons.refresh,
    this.previousPageIcon = Icons.chevron_left,
    this.nextPageIcon = Icons.chevron_right,
    this.emptyWidget = const Center(child: Text('No data available')),
  });
}
