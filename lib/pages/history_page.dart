import 'package:app/components/history_element_widget.dart';
import 'package:app/models/history_element.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:google_fonts/google_fonts.dart';
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
        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          child: HistoryElementWidget(historyElement: historyElementValue, onDeleteElement: deleteHistoryElement),
        );
      }).toList(),
    );
  }

  Future<void> deleteHistoryElement(HistoryElement historyElement) async {
    // setState(() {
    //   historyElements.remove(historyElement);
    // });
    historyElements.remove(historyElement);
    SharedPreferences.getInstance().then((prefs) {
      List<String> historyValue = prefs.getStringList('history') ?? [];
      historyValue.remove(historyElement.toJsonString());
      prefs.setStringList('history', historyValue);
    });
    print('deleted a history element! history now is:');
    print(historyElements);
  }

  @override
  void initState() {
    super.initState();
    //TODO do the things below when adding to history (camera_page) instead of here
    _historyFuture = SharedPreferences.getInstance().then((prefs) {
      return prefs.getStringList('history');
    }).then((historyValue) {
      //converting history string to list of HistoryElement and storing it in historyElements
      if (historyValue != null) {
        List<HistoryElement> historyElementsValue =
            historyValue.map((e) => HistoryElement.fromJsonString(e)).toList();
        //sorting the list of HistoryElement by date
        historyElementsValue.sort((a, b) => a.timestamp.compareTo(b.timestamp));
        //if history length is greater that 10, then remove the first element
        if (historyElementsValue.length > 10) {
          historyElementsValue = historyElementsValue.sublist(
              historyElementsValue.length - 10, historyElementsValue.length);
        }
        // reverse the list so that the latest history is at the top
        historyElementsValue = historyElementsValue.reversed.toList();

        historyElements = historyElementsValue;
      }
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
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Stack(
        children: [
          FutureBuilder<List<String>?>(
            future: _historyFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else {
                if (snapshot.hasData && (snapshot.data != null && snapshot.data!.isNotEmpty)) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height,
                      child: ListView(
                        children: [const SizedBox(height: 120), ...getHistoryElementWidgets(), const SizedBox(height: 100),],
                      ),
                    ),
                  );
                } else {
                  return Center(
                    child: Text(
                      'No history available.',
                      style: GoogleFonts.nunito(
                        fontSize: 30,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  );
                }
              }
            },
          ),
          Positioned(
            bottom: 0,
            child: Container(
              height: 140,
              width: MediaQuery.of(context).size.width,
              alignment: Alignment.bottomCenter,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Theme.of(context).colorScheme.background.withOpacity(0), Theme.of(context).colorScheme.background, Theme.of(context).colorScheme.background, Theme.of(context).colorScheme.background, Theme.of(context).colorScheme.background],
                ),
              ),
            ),
          ),
          Positioned(
            top: 0,
            child: Container(
              height: 140,
              width: MediaQuery.of(context).size.width,
              alignment: Alignment.bottomCenter,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Theme.of(context).colorScheme.background, Theme.of(context).colorScheme.background, Theme.of(context).colorScheme.background, Theme.of(context).colorScheme.background, Theme.of(context).colorScheme.background, Theme.of(context).colorScheme.background.withOpacity(0)],
                ),
              ),
            ),
          ),
          const TitleArea(title: "History"),
        ],
      ),
    );
  }
}
