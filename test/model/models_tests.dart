import 'package:flutter_test/flutter_test.dart';
import 'package:app/models/history_element.dart';

void main() {
  group('HistoryElement', () {
    test('should correctly deserialize from JSON string', () {
      const jsonString = '''
      {
        "title": "Test Title",
        "subtitle": "Test Subtitle",
        "inputSudokuString": "123456789",
        "outputSudokuString": "987654321",
        "timestamp": "2024-01-01T00:00:00.000"
      }
      ''';

      final expectedElement = HistoryElement(
        title: "Test Title",
        subtitle: "Test Subtitle",
        inputSudokuString: "123456789",
        outputSudokuString: "987654321",
        timestamp: DateTime.parse("2024-01-01T00:00:00.000"),
      );

      final resultElement = HistoryElement.fromJsonString(jsonString);

      expect(resultElement.title, expectedElement.title);
      expect(resultElement.subtitle, expectedElement.subtitle);
      expect(
          resultElement.inputSudokuString, expectedElement.inputSudokuString);
      expect(
          resultElement.outputSudokuString, expectedElement.outputSudokuString);
      expect(resultElement.timestamp, expectedElement.timestamp);
    });

    test('should correctly serialize to JSON string', () {
      final element = HistoryElement(
        title: "Test Title",
        subtitle: "Test Subtitle",
        inputSudokuString: "123456789",
        outputSudokuString: "987654321",
        timestamp: DateTime.parse("2024-01-01T00:00:00.000"),
      );
      final resultJsonString = element.toJsonString();

      var expectedJsonString = '{"title":"Test Title","subtitle":"Test Subtitle","inputSudokuString":"123456789","outputSudokuString":"987654321","timestamp":"2024-01-01T00:00:00.000"}';

      expect(resultJsonString, expectedJsonString);
    });
  });
}
