import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_table/src/models/go_table_actions.dart';
import 'package:go_table/src/models/go_table_column.dart';
import 'package:go_table/src/models/go_table_decoration.dart';
import 'package:go_table/src/extensions/widget_list_separator.dart';

class GoTableContent<T> extends StatefulWidget {
  const GoTableContent({
    super.key,
    required this.data,
    required this.minWidth,
    required this.columns,
    this.actions,
    required this.baseRowIndex,
    required this.decoration,
  });

  final List<T> data;
  final double minWidth;
  final List<GoTableColumn<T>> columns;
  final GoTableActions<T>? actions;
  final int baseRowIndex;
  final GoTableDecoration decoration;

  @override
  State<GoTableContent<T>> createState() => _GoTableContentState<T>();
}

class _GoTableContentState<T> extends State<GoTableContent<T>> {
  final ScrollController _verticalScrollController = ScrollController();
  final ScrollController _horizontalScrollController = ScrollController();

  @override
  void dispose() {
    _verticalScrollController.dispose();
    _horizontalScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final showScrollbar = kIsWeb ? true : false;
    return Scrollbar(
      key: ValueKey('vertical_scrollbar_${widget.data.length}'),
      controller: _verticalScrollController,
      thumbVisibility: showScrollbar,
      trackVisibility: showScrollbar,
      notificationPredicate: (notification) =>
          notification.metrics.axis == Axis.vertical,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final double tableWidth = constraints.maxWidth > widget.minWidth
              ? constraints.maxWidth
              : widget.minWidth;
          return Scrollbar(
            key: ValueKey(
              'horizontal_scrollbar_${widget.data.length}_${constraints.maxWidth}',
            ),
            controller: _horizontalScrollController,
            thumbVisibility: showScrollbar,
            trackVisibility: showScrollbar,
            notificationPredicate: (notification) =>
                notification.metrics.axis == Axis.horizontal,
            child: ScrollConfiguration(
              behavior: ScrollConfiguration.of(
                context,
              ).copyWith(scrollbars: false),
              child: SingleChildScrollView(
                controller: _horizontalScrollController,
                scrollDirection: Axis.horizontal,
                child: SizedBox(
                  width: tableWidth,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8.0, bottom: 8.0),
                    child: Column(
                      children: [
                        ColoredBox(
                          color:
                              widget.decoration.headerBackgroundColor ??
                              Theme.of(
                                context,
                              ).primaryColor.withValues(alpha: 0.1),
                          child: IntrinsicHeight(
                            child: Row(
                              children: widget.columns
                                  .map((column) {
                                    final child =
                                        column.header?.call(context) ??
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            column.headerLabel ?? '',
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        );
                                    if (column.width != null) {
                                      return SizedBox(
                                        width: column.width,
                                        child: child,
                                      );
                                    }
                                    return Expanded(
                                      flex: column.flex ?? 1,
                                      child: child,
                                    );
                                  })
                                  .toList()
                                  .separatedBy(const VerticalDivider(width: 1)),
                            ),
                          ),
                        ),
                        const Divider(height: 2),
                        if (widget.data.isEmpty)
                          Expanded(child: widget.decoration.emptyWidget)
                        else
                          Expanded(
                            child: ListView.builder(
                              controller: _verticalScrollController,
                              itemCount: widget.data.length,
                              itemBuilder: (context, index) {
                                final rowIndex = widget.baseRowIndex + index;
                                return Column(
                                  children: [
                                    InkWell(
                                      onTap: widget.actions?.onRowTap != null
                                          ? () => widget.actions?.onRowTap
                                                ?.call(widget.data[index])
                                          : null,
                                      child: ColoredBox(
                                        color: widget.decoration
                                            .rowBackgroundColor(index),
                                        child: IntrinsicHeight(
                                          child: Row(
                                            children: widget.columns
                                                .map((column) {
                                                  final cellContent = Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                          4.0,
                                                        ),
                                                    child: column.cellBuilder(
                                                      rowIndex,
                                                      widget.data[index],
                                                    ),
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
                                      color: widget.decoration.dividerColor,
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
