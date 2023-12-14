import 'package:flutter/material.dart';
import 'cell_widget.dart';

class SudokuGrid extends StatefulWidget {
  final double height;
  final double width;
  final String puzzleString;
  final bool isEditable;
  final ValueChanged<String> onChanged;

  const SudokuGrid({
    super.key,
    required this.height,
    required this.width,
    required this.puzzleString,
    required this.isEditable,
    required this.onChanged,
  });

  @override
  State<SudokuGrid> createState() => _SudokuGridState();
}

class _SudokuGridState extends State<SudokuGrid> {
  late List<String> gridState;
  String correctedText = '';

  @override
  void initState() {
    super.initState();
    gridState =
        List<String>.filled(81, '.'); // Initialize gridState with 81 dots
    for (int i = 0; i < widget.puzzleString.length; i++) {
      gridState[i] = widget.puzzleString[
          i]; // Overwrite the initial dots with the characters from puzzleString
    }
  }

  final BorderSide _thinBorder = const BorderSide(color: Colors.black, width: 0.5);
  final BorderSide _thickBorder = const BorderSide(color: Colors.black, width: 2.0);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      width: widget.width,
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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
                      : 0.0,
                ),
                left: BorderSide(
                  color: Colors.black,
                  width: index % 9 == 0
                      ? 0.5
                      : 0.0,
                ),
                right: (index + 1) % 3 == 0 && (index + 1) % 9 != 0 ? _thickBorder : _thinBorder,
                bottom: ((index ~/ 9) + 1) % 3 == 0 && index < 72 ? _thickBorder : _thinBorder,
              ),
            ),
            child: SudokuCell(
              initialValue: value != '.' ? value : '',
              onChanged: (newValue) {
                setState(() {
                  gridState[index] = newValue;
                  widget.onChanged(gridState.join());
                });
              },
            ),
          );
        },
      ),
    );
  }
}
