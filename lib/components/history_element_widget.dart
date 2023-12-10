import 'package:app/models/history_element.dart';
import 'package:flutter/material.dart';

class HistoryElementWidget extends StatefulWidget {
  const HistoryElementWidget({super.key, required this.historyElement});
  final HistoryElement historyElement;
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
    return Padding(
        padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
        child: InkWell(
          onTap: () {
            Navigator.pushNamed(
              context,
              '/history_element_page',
              arguments: {
                'historyElement': widget.historyElement,
              },
            );
          },
          child: Container(
            height: 100,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: const [
                BoxShadow(
                  color: Colors.grey,
                  blurRadius: 5,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        widget.historyElement.title,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.historyElement.subtitle,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          differenceString,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
