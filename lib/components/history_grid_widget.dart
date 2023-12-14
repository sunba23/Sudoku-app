import 'package:flutter/material.dart';

class HistoryGridWidget extends StatelessWidget {
  final String puzzleString;
  final double height;
  final double width;

  const HistoryGridWidget({super.key,
    required this.puzzleString,
    required this.height,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(width, height),
      painter: SudokuPainter(puzzleString),
    );
  }
}

class SudokuPainter extends CustomPainter {
  final String puzzleString;

  SudokuPainter(this.puzzleString);

  @override
  void paint(Canvas canvas, Size size) {
    final double cellSize = size.width / 9;
    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
    );

    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 1.0;

    for (int i = 0; i <= 9; i++) {
      final offset = cellSize * i;
      // Draw vertical lines
      canvas.drawLine(Offset(offset, 0), Offset(offset, size.height), paint);
      // Draw horizontal lines
      canvas.drawLine(Offset(0, offset), Offset(size.width, offset), paint);
    }

    for (int i = 0; i < 81; i++) {
      final String value = puzzleString[i];
      if (value != '.') {
        textPainter.text = TextSpan(
          text: value,
          style: TextStyle(
            color: Colors.black,
            fontSize: cellSize / 2,
          ),
        );
        textPainter.layout();
        final offset = Offset(
          (i % 9) * cellSize + cellSize / 2 - textPainter.width / 2,
          (i ~/ 9) * cellSize + cellSize / 2 - textPainter.height / 2,
        );
        textPainter.paint(canvas, offset);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}