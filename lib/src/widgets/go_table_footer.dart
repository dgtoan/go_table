import 'package:flutter/material.dart';
import 'package:go_table/src/models/go_table_actions.dart';
import 'package:go_table/src/models/go_table_decoration.dart';

class GoTableFooter<T> extends StatelessWidget {
  const GoTableFooter({
    super.key,
    required this.rowsPerPage,
    required this.availableRowsPerPage,
    required this.actions,
    required this.currentPage,
    required this.totalPages,
    required this.decoration,
  });

  final int rowsPerPage;
  final List<int> availableRowsPerPage;
  final GoTableActions<T>? actions;
  final int currentPage;
  final int totalPages;
  final GoTableDecoration decoration;

  @override
  Widget build(BuildContext context) {
    final isFirstPage = currentPage <= 1;
    final isLastPage = currentPage >= totalPages;
    return Row(
      spacing: 8,
      children: [
        TextButton.icon(
          onPressed: actions?.onRefresh,
          label: const Text('Làm mới', style: TextStyle(fontSize: 13)),
          icon: Icon(decoration.refreshIcon, size: 16),
        ),
        const Spacer(),
        const Text('Số hàng mỗi trang:', style: TextStyle(fontSize: 13)),
        DropdownButton<int>(
          value: rowsPerPage,
          elevation: 4,
          focusColor: Colors.transparent,
          items: availableRowsPerPage
              .map(
                (value) => DropdownMenuItem<int>(
                  value: value,
                  child: Text(
                    value.toString(),
                    style: const TextStyle(fontSize: 13),
                  ),
                ),
              )
              .toList(),
          onChanged: (value) {
            if (value != null) {
              actions?.onRowsPerPageChanged?.call(value);
            }
          },
        ),
        const SizedBox(height: 24, child: VerticalDivider(width: 1)),
        Text(
          'Trang $currentPage / $totalPages',
          style: const TextStyle(fontSize: 13),
        ),
        IconButton(
          onPressed: isFirstPage
              ? null
              : () => actions?.onPageChanged?.call(currentPage - 1),
          iconSize: 20,
          icon: Icon(decoration.previousPageIcon),
        ),
        IconButton(
          onPressed: isLastPage
              ? null
              : () => actions?.onPageChanged?.call(currentPage + 1),
          iconSize: 20,
          icon: Icon(decoration.nextPageIcon),
        ),
      ],
    );
  }
}
