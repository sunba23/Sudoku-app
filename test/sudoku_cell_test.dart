import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:app/components/grid_widget.dart';
import 'package:app/components/cell_widget.dart';

void main() {
  testWidgets(
      'SudokuCell updates gridState and calls onChanged when value changes',
      (WidgetTester tester) async {
    // Define a variable to track the latest grid state
    String latestGridState = '';

    // Build a SudokuGrid with a single SudokuCell
    await tester.pumpWidget(
      MaterialApp(
        home: Material(
          child: SudokuGrid(
            height: 100,
            width: 100,
            puzzleString: '.' * 81, // Create a grid with 81 cells
            isEditable: true,
            onChanged: (newState) {
              latestGridState = newState;
            },
          ),
        ),
      ),
    );

    // Find the first SudokuCell
    final finder = find.byType(SudokuCell).first;

    // Verify that the SudokuCell is in the widget tree
    expect(finder, findsOneWidget);

    // Enter '1' into the SudokuCell
    await tester.enterText(finder, '1');

    // Verify that the gridState was updated and onChanged was called with the new grid state
    expect(latestGridState[0], '1'); // Check the first cell in the grid state
  });
}
