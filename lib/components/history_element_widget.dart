import 'package:app/models/history_element.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HistoryElementWidget extends StatefulWidget {
  const HistoryElementWidget({super.key, required this.historyElement, required this.onDeleteElement});
  final HistoryElement historyElement;
  final Function(HistoryElement) onDeleteElement;
  @override
  State<HistoryElementWidget> createState() => _HistoryElementWidgetState();
}

class _HistoryElementWidgetState extends State<HistoryElementWidget> {
  DateTime now = DateTime.now();
  String differenceString = '';

  @override
  void initState() {
    super.initState();
    final Duration diff =
        DateTime.now().difference(widget.historyElement.timestamp);
    if (diff.inDays > 1) {
      differenceString = '${diff.inDays} days ago';
    } else if (diff.inMinutes > 60) {
      differenceString = '${diff.inHours} hours ago';
    } else if (diff.inSeconds > 60) {
      differenceString = '${diff.inMinutes} minutes ago';
    } else {
      differenceString = '${diff.inSeconds} seconds ago';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      // key: Key(widget.historyElement.hashCode.toString()),
      key: UniqueKey(),
      background: Container(
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(15),
        ),
        child: const Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: Icon(
              Icons.delete,
              color: Colors.white,
            ),
          ),
        ),
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        widget.onDeleteElement(widget.historyElement);
      },
      child: InkWell(
        onLongPress: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return const AlertDialog(
                title: Text('2 grid widgets go here'),
              );
            },
          );
        },
        child: Container(
          decoration: BoxDecoration(
            color: const Color (0xffebebf5),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                Text(
                  differenceString,
                  style: GoogleFonts.nunito(
                    fontWeight: FontWeight.w600,
                    color: const Color.fromARGB(255, 57, 64, 83),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'input sudoku: ${widget.historyElement.inputSudokuString}',
                  style: GoogleFonts.nunito(
                    fontWeight: FontWeight.w600,
                    color: const Color.fromARGB(255, 57, 64, 83),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'solved sudoku: ${widget.historyElement.outputSudokuString}',
                  style: GoogleFonts.nunito(
                    fontWeight: FontWeight.w600,
                    color: const Color.fromARGB(255, 57, 64, 83),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
