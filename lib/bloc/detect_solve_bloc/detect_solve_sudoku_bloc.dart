import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:app/models/history_element.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:image_picker/image_picker.dart';

part 'detect_solve_sudoku_event.dart';
part 'detect_solve_sudoku_state.dart';

class DetectSolveSudokuBloc
    extends Bloc<DetectSolveSudokuEvent, DetectSolveSudokuState> {
  DetectSolveSudokuBloc() : super(InitialState()) {
    on<PreviewEvent>((event, emit) async {
      if (event.file != null) {
        emit(PreviewState(event.file, null));
      } else if (event.assetPath != null) {
        emit(PreviewState(null, event.assetPath));
      }
    });
    on<DetectingEvent>((event, emit) async {
      emit(LoadingState());
      String? detectedNumbers =
          await getNumbersFromImage(event.sudokuImage, event.assetPath);
      detectedNumbers != null
          ? emit(LoadedState(detectedNumbers))
          : emit(const ErrorState(
              "An error has occurred. Please try again later."));
    });
    on<ClearStateEvent>((event, emit) {
      emit(InitialState());
    });
    on<SolvingEvent>((event, emit) async {
      emit(LoadingSolvingState());
      await Future.delayed(
          const Duration(seconds: 3)); //TODO !!!! DELETE THIS LATER !!!!!
      String? solvedSudoku = await getSolvedSudoku(event.sudoku);
      if (solvedSudoku != null) {
        await addSudokuToHistory(event.sudoku, solvedSudoku);
      }
      emit(SolvedState(solvedSudoku ?? 'Unable to solve sudoku'));
    });
    on<ErrorEvent>((event, emit) {
      emit(ErrorState(event.message));
    });
  }

  Future<String> getImageBase64(File? image, String? assetPath) async {
    if (image != null) {
      Uint8List imageBytes = await image.readAsBytes();
      String encodedData = base64Encode(imageBytes);
      return encodedData;
    } else if (assetPath != null) {
      ByteData bytes = await rootBundle.load(assetPath);
      String encodedData = base64Encode(bytes.buffer.asUint8List());
      return encodedData;
    }
    print("oops");
    return '';
  }

  Future<String?> getNumbersFromImage(File? image, String? assetPath) async {
    String url =
        'http://10.0.2.2:5000/detect'; // access localhost from emulator

    try {
      Map<String, String> requestBody = {
        'image': await getImageBase64(image, assetPath),
      };

      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> responseBody = jsonDecode(response.body);
        String? detectedNumbers = responseBody['sudoku'];
        return detectedNumbers;
      } else {
        return null;
      }
    } catch (error) {
      print('Exception occurred: $error');
    }
    return null;
  }

  Future<String?> getSolvedSudoku(String sudoku) async {
    String url = 'http://10.0.2.2:5000/solve'; // access localhost from emulator

    try {
      Map<String, String> requestBody = {
        'sudoku': sudoku,
      };

      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> responseBody = jsonDecode(response.body);
        String? solvedSudoku = responseBody['sudoku'];
        return Future.value(solvedSudoku);
      } else {
        throw 'Error number: ${response.statusCode} ${response.reasonPhrase}';
      }
    } catch (error) {
      print('Exception occurred: $error');
    }
    return null;
  }

  Future<void> addSudokuToHistory(String sudoku, String solvedSudoku) async {
    print("Adding sudoku to history");
    try {
      final historyElement = HistoryElement(
        title: 'Sudoku',
        subtitle: 'Solved',
        inputSudokuString: sudoku,
        outputSudokuString: solvedSudoku,
        timestamp: DateTime.now(),
      );
      String jsonifiedHistoryElement = historyElement.toJsonString();

      await SharedPreferences.getInstance().then((prefs) {
        List<String>? history = prefs.getStringList('history');
        history ??= [];
        history.add(jsonifiedHistoryElement);
        prefs.setStringList('history', history);
      });
    } catch (error) {
      print('Exception occurred: $error');
    }
  }
}
