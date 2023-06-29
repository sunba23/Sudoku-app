import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class SolvePage extends StatefulWidget {
  final File sudokuImage;
  const SolvePage({Key? key, required this.sudokuImage}) : super(key: key);

  @override
  State<SolvePage> createState() => _SolvePageState();
}

class _SolvePageState extends State<SolvePage> {

  Future solveSudoku() async {
    //TODO connect to cloud backend
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Solve Page')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('This sudoku is being solved:'),
            kIsWeb
                ? Image.network(widget.sudokuImage.path) //web specific
                : defaultTargetPlatform == TargetPlatform.android || defaultTargetPlatform == TargetPlatform.iOS
                    ? Image.file(widget.sudokuImage) //mobile specific
                    : defaultTargetPlatform == TargetPlatform.windows || defaultTargetPlatform == TargetPlatform.linux || defaultTargetPlatform == TargetPlatform.macOS || defaultTargetPlatform == TargetPlatform.fuchsia
                        ? Image.file(widget.sudokuImage) //desktop specific
                        : const Text('Unsupported platform'),
          ],
        )
      ),
    );
  }
}
