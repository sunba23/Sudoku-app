import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class SolvePage extends StatefulWidget {
  final File sudokuImage;
  const SolvePage({super.key, required this.sudokuImage});

  @override
  State<SolvePage> createState() => _SolvePageState();
}

class _SolvePageState extends State<SolvePage> {
  bool _isSolved = false;
  File? _solutionImage;

  Future<void> solveSudoku() async {
    setState(() {
      _isSolved = false;
      _solutionImage = null;
    });

    //? q: resize the image?

    String url = dotenv.env['AWS_LAMBDA_ENDPOINT_URL']!;

    // Read the Sudoku image as bytes and encode it to base64
    List<int> imageBytes = await widget.sudokuImage.readAsBytes();
    String base64Image = base64Encode(imageBytes);
    print('Base64 image: $base64Image');

    try {
      // Send the POST request to the AWS Lambda endpoint
      final response = await http.post(
        Uri.parse(url),
        body: {'image': base64Image},
      );
      print("step 1");

      if (response.statusCode == 200) {
        // Decode the response
        Map<String, dynamic> responseData = jsonDecode(response.body);
        print("step 2");
        // Extract and decode the solution image
        String solutionImageData = responseData['result'];
        List<int> solutionBytes = base64Decode(solutionImageData);
        print("step 3");
        // Temporary file to store the solution image
        File solutionImageFile =
            File('${widget.sudokuImage.path}_solution.jpg');
        await solutionImageFile.writeAsBytes(solutionBytes);
        print("step 4");

        setState(() {
          _isSolved = true;
          _solutionImage = solutionImageFile;
        });
      } else {
        // error response
        print('Error: ${response.statusCode}');
      }
    } catch (error) {
      print('Exception occurred: $error');
    }
  }

  @override
  void initState() {
    super.initState();
    solveSudoku(); // instantly solve the sudoku
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _isSolved
              ? const Text('Sudoku solved!')
              : const Text('Solving sudoku, please wait...'),
        ],
      )),
    );
  }
}
