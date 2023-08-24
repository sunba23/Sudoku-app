import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';

class SudokuWidget extends StatefulWidget {
  final String? sudokuString;

  const SudokuWidget(this.sudokuString, {Key? key}) : super(key: key);

  @override
  State<SudokuWidget> createState() => _SudokuWidgetState();
}

class _SudokuWidgetState extends State<SudokuWidget> {
  late List<List<TextEditingController>> controllers;

  @override
  void initState() {
    super.initState();

    controllers = List.generate(
        9, (_) => List.generate(9, (_) => TextEditingController()));

    if (widget.sudokuString != null) {
      for (int row = 0; row < 9; row++) {
        for (int col = 0; col < 9; col++) {
          final index = row * 9 + col;
          if (index < widget.sudokuString!.length &&
              widget.sudokuString![index] != '.') {
            controllers[row][col].text = widget.sudokuString![index];
          }
        }
      }
    }
  }

  @override
  void dispose() {
    for (var rowControllers in controllers) {
      for (var controller in rowControllers) {
        controller.dispose();
      }
    }
    super.dispose();
  }

  String collectData() {
    String result = '';
    for (int row = 0; row < 9; row++) {
      for (int col = 0; col < 9; col++) {
        final text = controllers[row][col].text;
        result += (text.isNotEmpty) ? text : '.';
      }
    }
    return result;
  }

  BorderSide customBorderSideThick() {
    return const BorderSide(
      color: Colors.white70,
      width: 3.0,
    );
  }

  BorderSide customBorderSideThin() {
    return const BorderSide(
      color: Colors.white70,
      width: 1.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: List.generate(9, (row) {
                return Row(
                  children: List.generate(9, (col) {
                    return Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: row == 2 || row == 5
                              ? customBorderSideThick()
                              : customBorderSideThin(),
                          right: col == 2 || col == 5
                              ? customBorderSideThick()
                              : customBorderSideThin(),
                          left: col == 0
                              ? customBorderSideThin()
                              : BorderSide.none,
                          top: row == 0
                              ? customBorderSideThin()
                              : BorderSide.none,
                        ),
                      ),
                      child: TextField(
                        controller: controllers[row][col],
                        maxLength: 1,
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          counterText: '',
                          contentPadding: EdgeInsets.zero,
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.zero,
                          ),
                        ),
                      ),
                    );
                  }),
                );
              }),
            ),
          ),
          const Text("Please correct the numbers if needed and press 'Solve'"),
          ElevatedButton(
            onPressed: () {
              final data = collectData();
              safePrint(data);
            },
            child: const Text('Solve'),
          ),
        ],
      ),
    );
  }
}
