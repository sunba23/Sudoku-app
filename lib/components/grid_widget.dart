import 'package:flutter/material.dart';

class SudokuGrid extends StatefulWidget {
  final double height;
  final double width;
  final String puzzleString;
  final bool isEditable;
  final ValueChanged<String> onChanged;

  SudokuGrid({
    required this.height,
    required this.width,
    required this.puzzleString,
    required this.isEditable,
    required this.onChanged,
  });

  @override
  _SudokuGridState createState() => _SudokuGridState();
}

class _SudokuGridState extends State<SudokuGrid> {
  late List<String> gridState;
  String correctedText = '';

  @override
  void initState() {
    super.initState();
    gridState = widget.puzzleString.split('');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      width: widget.width,
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 9,
        ),
        itemCount: 81,
        itemBuilder: (context, index) {
          String value = index < widget.puzzleString.length
              ? widget.puzzleString[index]
              : '.';
          return Container(
            width: widget.width / 9,
            height: widget.height / 9,
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: Colors.black,
                  width: index < 9
                      ? 0.5
                      : 0.0, // Add a thin border to the first row
                ),
                left: BorderSide(
                  color: Colors.black,
                  width: index % 9 == 0
                      ? 0.5
                      : 0.0, // Add a thin border to the first column
                ),
                right: BorderSide(
                  color: Colors.black,
                  width:
                      (index + 1) % 3 == 0 && (index + 1) % 9 != 0 ? 2.0 : 0.5,
                ),
                bottom: BorderSide(
                  color: Colors.black,
                  width: ((index ~/ 9) + 1) % 3 == 0 && index < 72 ? 2.0 : 0.5,
                ),
              ),
            ),
            child: TextFormField(
              initialValue: value != '.' ? value : '',
              enabled: widget.isEditable,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black, // Set the text color to black
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                disabledBorder: InputBorder.none,
              ),
              onChanged: (newValue) {
                setState(() {
                  //print(gridState);
                  gridState[index] = newValue;
                  widget.onChanged(gridState.join());
                  print("Grid state: $gridState");
                });
              },
            ),
          );
        },
      ),
    );
  }
}
