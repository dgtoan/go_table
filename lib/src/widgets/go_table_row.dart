import 'package:flutter/material.dart';
import 'package:go_table/src/extensions/widget_list_separator.dart';
import 'package:go_table/src/models/go_table_actions.dart';
import 'package:go_table/src/models/go_table_column.dart';
import 'package:go_table/src/models/go_table_decoration.dart';

class GoTableRow<T> extends StatelessWidget {
  const GoTableRow({
    super.key,
    required this.rowIndex,
    required this.index,
    required this.data,
    required this.columns,
    required this.decoration,
    this.actions,
  });

  final int rowIndex;
  final int index;
  final List<T> data;
  final List<GoTableColumn<T>> columns;
  final GoTableDecoration decoration;
  final GoTableActions<T>? actions;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: actions?.onRowTap != null
              ? () => actions?.onRowTap?.call(data[index])
              : null,
          child: ColoredBox(
            color: decoration.rowBackgroundColor(index),
            child: IntrinsicHeight(
              child: Row(
                children: columns
                    .asMap()
                    .entries
                    .map((entry) {
                      final columnIndex = entry.key;
                      final column = entry.value;
                      final rowData = data[index];

                      final cellContent = _GoTableCell(
                        rowData: rowData,
                        column: column,
                        rowIndex: index,
                        columnIndex: columnIndex,
                        actions: actions,
                        decoration: decoration,
                      );
                      if (column.width != null) {
                        return SizedBox(
                          width: column.width,
                          child: cellContent,
                        );
                      }
                      return Expanded(
                        flex: column.flex ?? 1,
                        child: cellContent,
                      );
                    })
                    .toList()
                    .separatedBy(
                      const VerticalDivider(
                        width: 1,
                      ),
                    ),
              ),
            ),
          ),
        ),
        Divider(
          height: 1,
          color: decoration.dividerColor,
        ),
      ],
    );
  }
}

class _GoTableCell<T> extends StatefulWidget {
  const _GoTableCell({
    super.key,
    required this.rowData,
    required this.column,
    required this.rowIndex,
    required this.columnIndex,
    required this.actions,
    required this.decoration,
  });

  final T rowData;
  final GoTableColumn<T> column;
  final int rowIndex;
  final int columnIndex;
  final GoTableActions<T>? actions;
  final GoTableDecoration decoration;

  @override
  State<_GoTableCell<T>> createState() => _GoTableCellState<T>();
}

class _GoTableCellState<T> extends State<_GoTableCell<T>> {
  bool _isFocused = false;

  @override
  Widget build(BuildContext context) {
    return Focus(
      canRequestFocus: false,
      onFocusChange: (isFocused) {
        setState(() => _isFocused = isFocused);
      },
      onKeyEvent: (node, event) {
        widget.actions?.onCellKeyEvent?.call(
          widget.rowIndex,
          widget.columnIndex,
          widget.rowData,
          event,
        );
        return KeyEventResult.ignored;
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        decoration: BoxDecoration(
          border: Border.all(
            color:
                _isFocused ? widget.decoration.focusColor : Colors.transparent,
            width: 2,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: widget.column.cellBuilder(widget.rowIndex, widget.rowData),
        ),
      ),
    );
  }
}
