
import 'package:flutter/cupertino.dart';

class ColumnRows<T> extends StatefulWidget {
  final List<T> data;
  final int columnCount;

  const ColumnRows({super.key, required this.data, required this.columnCount});

  @override
  State<StatefulWidget> createState() {
    return _ColumnRows();
  }
}

class _ColumnRows extends State<ColumnRows> {

  @override
  Widget build(BuildContext context) {

    int size = widget.data.length;

    var rows = size == 0 ? 0 : (1 + (size - 1) / widget.columnCount).toInt();

    List<Widget> widgetRows = [];

    for (int rowIndex = 0; rowIndex <= rows; rowIndex++) {
      widgetRows.add(
        Row(
          children: [
            for (int columnIndex = 0; columnIndex < widget.columnCount; columnIndex++)
              if (rowIndex * widget.columnCount + columnIndex < size)...{
                widget.data[rowIndex * widget.columnCount + columnIndex]
              } else...{
                Spacer()
              }
          ],
        )
      );
    }

    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: SingleChildScrollView(
        reverse: false,
        child: Column(
          children: widgetRows,
        ),
      ),
    );
  }
}