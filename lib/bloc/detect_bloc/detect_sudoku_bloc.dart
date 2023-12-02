import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:image_picker/image_picker.dart';

part 'detect_sudoku_event.dart';
part 'detect_sudoku_state.dart';

class DetectSudokuBloc extends Bloc<DetectSudokuEvent, DetectSudokuState> {

  DetectSudokuBloc() : super(InitialState()) {
    on<PreviewEvent>((event, emit) async {
      if (event.file != null) {
        emit(PreviewState(event.file, null));
      } else if (event.assetPath != null) {
        emit(PreviewState(null, event.assetPath));
      }
    });
    // on<PickingEvent>((event, emit) async {
    //   final imagePicker = ImagePicker();
    //   final image = await imagePicker.pickImage(source: ImageSource.gallery);
    //   emit(PickedState(File(image!.path)));
    // });
    on<DetectingEvent>((event, emit) async {
      emit(LoadingState());
      String? detectedNumbers = await getNumbersFromImage(event.sudokuImage, event.assetPath);
      emit(LoadedState(detectedNumbers ?? 'No numbers detected'));
    });
    on<ClearStateEvent>((event, emit) {
      emit(InitialState());
    });
  }

  Future<String> getImageBase64(File? image, String? assetPath) async {
    if (image != null){
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
    String url = dotenv.env['AWS_LAMBDA_ENDPOINT_URL']!;

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
        String bodyString = responseBody['body'];
        Map<String, dynamic> bodyContent = jsonDecode(bodyString);

        String? detectedNumbers = bodyContent['sudoku'];
        return detectedNumbers;
      } else {
        throw 'Error number: ${response.statusCode} ${response.reasonPhrase}';
      }
    } catch (error) {
      safePrint('Exception occurred: $error');
    }
    return null;
  }
}
