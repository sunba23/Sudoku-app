import 'package:app/components/title_area.dart';
import 'package:app/models/history_element.dart';
import 'package:flutter/material.dart';

class HistoryElementPage extends StatefulWidget {
  const HistoryElementPage({super.key, required this.historyElement});
  final HistoryElement historyElement;

  @override
  State<HistoryElementPage> createState() => _HistoryElementPageState();
}

class _HistoryElementPageState extends State<HistoryElementPage> {
  void goBackToHistory() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      TitleArea(
        title: 'History',
        icon: Icons.arrow_back_rounded,
        onTap: goBackToHistory,
      ),
      // TODO here goes the picture of the input sudoku and the output sudoku
      // TODO as well as other details
      Text(widget.historyElement.timestamp.toString()),
    ]);
  }
}
