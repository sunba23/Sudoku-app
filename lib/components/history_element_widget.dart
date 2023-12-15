import 'package:app/components/history_grid_widget.dart';
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

  List<HistoryGridWidget> previewGrids = [];
  List<HistoryGridWidget> dialogGrids = [];
  Future<void>? loadGridsFuture;

  Future<void> loadGrids() async {
    previewGrids
      ..add(HistoryGridWidget(height: 140, width: 140, puzzleString: widget.historyElement.inputSudokuString,))
      ..add(HistoryGridWidget(height: 140, width: 140, puzzleString: widget.historyElement.outputSudokuString,));

    dialogGrids
      ..add(HistoryGridWidget(height: 260, width: 260, puzzleString: widget.historyElement.inputSudokuString,))
      ..add(HistoryGridWidget(height: 260, width: 260, puzzleString: widget.historyElement.outputSudokuString,));
  }

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
    loadGridsFuture = loadGrids();
  }

  Widget buildWidget(BuildContext context) {
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
        onTap: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Center(child: Text('Sudoku')),
                titleTextStyle: GoogleFonts.nunito(
                  fontWeight: FontWeight.w600,
                  fontSize: 25,
                  color: Theme.of(context).colorScheme.primary,
                ),
                content: SizedBox(
                  height: MediaQuery
                      .of(context)
                      .size
                      .height * 0.65,
                  width: MediaQuery
                      .of(context)
                      .size
                      .width * 0.85,
                  child: Column(
                    children: [
                      dialogGrids[0],
                      SizedBox(height: MediaQuery
                          .of(context)
                          .size
                          .height * 0.05,),
                      dialogGrids[1],
                    ],
                  ),
                ),
              );
            },
          );
        },
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryContainer,
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
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 10,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    previewGrids[0],
                    Icon(
                      Icons.arrow_forward_rounded,
                      color: Theme.of(context).colorScheme.onPrimary,
                      size: 20,
                    ),
                    previewGrids[1],
                  ]
                ),
                const SizedBox(height: 10,),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: loadGridsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return buildWidget(context);
        } else {
          return Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(15),
            ),
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }
}
