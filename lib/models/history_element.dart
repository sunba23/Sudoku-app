import 'dart:convert';

class HistoryElement {
  final String title;
  final String subtitle;
  final String inputSudokuString;
  final String outputSudokuString;
  final DateTime timestamp;

  HistoryElement({
    required this.title,
    required this.subtitle,
    required this.inputSudokuString,
    required this.outputSudokuString,
    required this.timestamp,
  });

  factory HistoryElement.fromJsonString(String jsonString) {
    Map<String, dynamic> map = json.decode(jsonString);
    return HistoryElement(
      title: map['title'],
      subtitle: map['subtitle'],
      inputSudokuString: map['inputSudokuString'],
      outputSudokuString: map['outputSudokuString'],
      timestamp: DateTime.parse(map['timestamp']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'subtitle': subtitle,
      'inputSudokuString': inputSudokuString,
      'outputSudokuString': outputSudokuString,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  String toJsonString() {
    return jsonEncode(toJson());
  }
}
