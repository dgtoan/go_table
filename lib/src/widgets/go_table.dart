import 'package:flutter/material.dart';
import 'package:go_table/src/widgets/go_table_content.dart';
import 'package:go_table/src/widgets/go_table_footer.dart';
import 'package:go_table/src/models/go_table_actions.dart';
import 'package:go_table/src/models/go_table_column.dart';
import 'package:go_table/src/models/go_table_decoration.dart';

class GoTable<T> extends StatelessWidget {
  const GoTable({
    super.key,
    required this.data,
    this.minWidth = 800,
    required this.columns,
    this.showFooter = true,
    this.availableRowsPerPage = const [10, 20, 50],
    this.rowsPerPage = 20,
    this.currentPage = 1,
    this.totalPages = 1,
    this.actions,
    this.decoration = const GoTableDecoration(),
  });

  final List<T> data;
  final double minWidth;
  final List<GoTableColumn<T>> columns;
  final bool showFooter;
  final List<int> availableRowsPerPage;
  final int rowsPerPage;
  final int currentPage;
  final int totalPages;
  final GoTableActions<T>? actions;
  final GoTableDecoration decoration;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: GoTableContent(
            data: data,
            minWidth: minWidth,
            columns: columns,
            actions: actions,
            baseRowIndex: (currentPage - 1) * rowsPerPage,
            decoration: decoration,
          ),
        ),
        if (showFooter) ...[
          const Divider(height: 1),
          GoTableFooter(
            rowsPerPage: rowsPerPage,
            availableRowsPerPage: availableRowsPerPage,
            actions: actions,
            currentPage: currentPage,
            totalPages: totalPages,
            decoration: decoration,
          ),
        ],
      ],
    );
  }
}
