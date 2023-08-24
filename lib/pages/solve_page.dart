import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:http/http.dart' as http;

class SolvePage extends StatefulWidget {
  final File sudokuImage;
  const SolvePage({super.key, required this.sudokuImage});

  @override
  State<SolvePage> createState() => _SolvePageState();
}

class _SolvePageState extends State<SolvePage> {
  bool _isDetected = false;
  Array? _detectedNumbers;

  Future<void> solveSudoku() async {
    setState(() {
      _isDetected = false;
      _detectedNumbers = null;
    });

    //? q: resize the image?

    String url = dotenv.env['AWS_LAMBDA_ENDPOINT_URL']!;

    // Read the Sudoku image as bytes and encode it to base64
    List<int> imageBytes = await widget.sudokuImage.readAsBytes();
    String base64Image = base64Encode(imageBytes);
    safePrint('Base64 image: $base64Image');

    try {
      // Send the POST request to the AWS Lambda endpoint
      final response = await http.post(
        Uri.parse(url),
        body: {'image': base64Image},
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = jsonDecode(response.body);
        Array detectedNumbers = responseData['sudoku'];

        setState(() {
          _isDetected = true;
          _detectedNumbers = detectedNumbers;
        });
      } else {
        // error response
        safePrint('Error: ${response.statusCode}');
      }
    } catch (error) {
      safePrint('Exception occurred: $error');
    }
  }

  @override
  void initState() {
    super.initState();
    solveSudoku();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _isDetected
              ? const Text('Sudoku detected!')
              : LoadingAnimationWidget.threeRotatingDots(
            color: Colors.white,
            size: 50,
          ),
        ],
      )),
    );
  }
}
