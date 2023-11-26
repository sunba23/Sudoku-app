import 'package:flutter/material.dart';

class SudokuView extends StatefulWidget {
  const SudokuView({Key? key}) : super(key: key);

  @override
  State<SudokuView> createState() => _SudokuViewState();
}

class _SudokuViewState extends State<SudokuView> {
  @override
  Widget build(BuildContext context) {
    return const Text('Sudoku View');
  }
}