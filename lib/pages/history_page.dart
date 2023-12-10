import 'package:app/components/history_element_widget.dart';
import 'package:app/models/history_element.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../components/title_area.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  Future<List<String>?>? _historyFuture;
  List<HistoryElement> historyElements = [];

  List<Widget> getHistoryElementWidgets() {
    return AnimationConfiguration.toStaggeredList(
      duration: const Duration(milliseconds: 500),
      childAnimationBuilder: (widget) => SlideAnimation(
        verticalOffset: 50.0,
        child: FadeInAnimation(
          child: widget,
        ),
      ),
      children: historyElements.map((historyElementValue) {
        return HistoryElementWidget(historyElement: historyElementValue);
      }).toList(),
    );
  }

  @override
  void initState() {
    super.initState();
    _historyFuture = SharedPreferences.getInstance().then((prefs) {
      return prefs.getStringList('history');
    }).then((historyValue) {
      print(historyValue);
      //converting history string to list of HistoryElement and storing it in historyElements
      if (historyValue != null) {
        List<HistoryElement> historyElementsValue =
            historyValue.map((e) => HistoryElement.fromJsonString(e)).toList();
        //sorting the list of HistoryElement by date
        //TODO do the things below when adding to history (camera_page) instead of here
        historyElementsValue.sort((a, b) => a.timestamp.compareTo(b.timestamp));

        //if history length is greater that 10, then remove the first element
        if (historyElementsValue.length > 10) {
          debugPrint(historyElementsValue.length.toString());
          historyElementsValue = historyElementsValue.sublist(
              historyElementsValue.length - 10, historyElementsValue.length);
          debugPrint(historyElementsValue.length.toString());
        }

        historyElements = historyElementsValue;
        print(historyElements);
      }
      print(historyValue);
      return historyValue;
    });
  }

  void deleteHistory() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete History'),
          content: const Text('Are you sure you want to delete the history?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Delete history and close the dialog
                SharedPreferences.getInstance().then((prefs) {
                  prefs.remove('history');
                });
                setState(() {
                  historyElements = [];
                });
                Navigator.of(context).pop();
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const TitleArea(title: "History"),
          FutureBuilder<List<String>?>(
            future: _historyFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else {
                if (snapshot.hasData && snapshot.data != null) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: Column(
                      children: getHistoryElementWidgets(),
                    ),
                  );
                } else {
                  return const Center(
                    child: Text(
                      'No history available.',
                      style: TextStyle(
                        fontSize: 30,
                      ),
                    ),
                  );
                }
              }
            },
          ),
        ],
      ),
    );
  }
}
