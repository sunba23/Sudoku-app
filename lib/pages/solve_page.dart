import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class SolvePage extends StatefulWidget {
  final File sudokuImage;
  const SolvePage({Key? key, required this.sudokuImage}) : super(key: key);

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

      if (response.statusCode == 200) {
        // Decode the response
        Map<String, dynamic> responseData = jsonDecode(response.body);

        // Extract and decode the solution image
        String solutionImageData = responseData['solution'];
        List<int> solutionBytes = base64Decode(solutionImageData);

        // Temporary file to store the solution image
        File solutionImageFile =
            File('${widget.sudokuImage.path}_solution.jpg');
        await solutionImageFile.writeAsBytes(solutionBytes);

        setState(() {
          _isSolved = true;
          _solutionImage = solutionImageFile;
        });
      } else { // error response
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
      appBar: AppBar(title: const Text('Solve Page')),
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
