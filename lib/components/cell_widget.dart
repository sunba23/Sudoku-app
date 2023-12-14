import 'package:flutter/material.dart';

class SudokuCell extends StatefulWidget {
  final String initialValue;
  final ValueChanged<String> onChanged;

  const SudokuCell({super.key,
    required this.initialValue,
    required this.onChanged,
  });

  @override
  State<SudokuCell> createState() => _SudokuCellState();
}

class _SudokuCellState extends State<SudokuCell> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _controller,
      keyboardType: TextInputType.number,
      textAlign: TextAlign.center,
      style: const TextStyle(
        color: Colors.black,
      ),
      decoration: const InputDecoration(
        border: InputBorder.none,
        disabledBorder: InputBorder.none,
      ),
      onChanged: widget.onChanged,
    );
  }
}