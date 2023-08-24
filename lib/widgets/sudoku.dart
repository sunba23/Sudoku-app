import 'package:flutter/material.dart';

class SudokuWidget extends StatefulWidget {
  final String? sudokuString; // Declare the instance variable

  const SudokuWidget(this.sudokuString, {Key? key}) : super(key: key);

  @override
  State<SudokuWidget> createState() => _SudokuWidgetState();
}

class _SudokuWidgetState extends State<SudokuWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("received from lambda 1:"),
          Text(widget.sudokuString ?? "no data"), // Access the instance variable
        ],
      ),
    );
  }
}
