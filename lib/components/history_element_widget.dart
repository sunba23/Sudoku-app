import 'package:app/components/history_grid_widget.dart';
import 'package:app/models/history_element.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:ui' as ui;
import 'dart:io';
import 'package:path_provider/path_provider.dart';

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
  double opacityLevel = 0.0;
  final GlobalKey boundaryKey = GlobalKey();

  List<HistoryGridWidget> previewGrids = [];
  List<HistoryGridWidget> dialogGrids = [];

  void setUpGrids() {
    previewGrids
      ..add(HistoryGridWidget(height: 140, width: 140, puzzleString: widget.historyElement.inputSudokuString,))
      ..add(HistoryGridWidget(height: 140, width: 140, puzzleString: widget.historyElement.outputSudokuString,));

    dialogGrids
      ..add(HistoryGridWidget(height: 280, width: 280, puzzleString: widget.historyElement.inputSudokuString,))
      ..add(HistoryGridWidget(height: 280, width: 280, puzzleString: widget.historyElement.outputSudokuString,));
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
    setUpGrids();

    Future.delayed(const Duration(milliseconds: 0), () {
      setState(() {
        opacityLevel = 1.0;
      });
    });
  }

  Future<void> shareSolvedSudoku() async {
    final repaintBoundary = RepaintBoundary(
      key: boundaryKey,
      child: SizedBox(
        height: 140,
        width: 140,
        child: HistoryGridWidget(
          height: 140,
          width: 140,
          puzzleString: widget.historyElement.outputSudokuString,
        ),
      ),
    );

    final renderObject = boundaryKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
    final image = await renderObject.toImage(pixelRatio: 2.0);
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);

    final directory = await getTemporaryDirectory();
    final file = File('${directory.path}/sudoku.png');

    await file.writeAsBytes(byteData?.buffer.asUint8List() ?? <int>[]);

    await Share.shareXFiles([XFile(file.path)]);
  }

  Widget buildWidget(BuildContext context) {
    return Dismissible(
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
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      dialogGrids[0],
                      SizedBox(height: MediaQuery
                          .of(context)
                          .size
                          .height * 0.02,),
                      dialogGrids[1],
                      SizedBox(height: MediaQuery
                          .of(context)
                          .size
                          .height * 0.02,),
                      ElevatedButton(
                        onPressed: () {
                          shareSolvedSudoku();
                        },
                        child: const Text('Share'),
                      ),
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
          child: AnimatedOpacity(
            opacity: opacityLevel,
            duration: const Duration(seconds: 3),
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
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      key: boundaryKey,
      child: buildWidget(context),
    );
  }
}
