import 'dart:convert';
import 'dart:io';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../utils/platform_utils.dart';
import 'package:http/http.dart' as http;
import '../widgets/sudoku.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({super.key});

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  // File? _image;
  // bool _isImageLoaded = false;
  // bool _isPickingImage = true; // stage 1
  // bool _areNumbersBeingDetected = false; // stage 2
  // bool _isDetected = false; // stage 3
  // final imagePicker = ImagePicker();
  // String? _detectedNumbers;
  //
  // Future getImageFromCamera() async {
  //   final image = await imagePicker.pickImage(source: ImageSource.camera);
  //   setState(() {
  //     _image = File(image!.path);
  //     _isImageLoaded = true;
  //   });
  // }
  //
  // Future getImageFromGallery() async {
  //   final image = await imagePicker.pickImage(source: ImageSource.gallery);
  //   setState(() {
  //     _image = File(image!.path);
  //     _isImageLoaded = true;
  //   });
  // }
  //
  // Future<String?> getNumbersFromImage(File image) async {
  //   String url = dotenv.env['AWS_LAMBDA_ENDPOINT_URL']!;
  //
  //   // Read the Sudoku image as bytes and encode it to base64
  //   List<int> imageBytes = await image.readAsBytes();
  //   String base64Image = base64Encode(imageBytes);
  //   safePrint('Base64 image: $base64Image');
  //
  //   try {
  //     Map<String, dynamic> requestBody = {
  //       'body': {'image': base64Image}
  //     };
  //
  //     // Send the POST request
  //     final response = await http.post(
  //       Uri.parse(url),
  //       headers: {'Content-Type': 'application/json'},
  //       body: jsonEncode(requestBody),
  //     );
  //
  //     if (response.statusCode == 200) {
  //       Map<String, dynamic> responseData = jsonDecode(response.body);
  //       Map<String, dynamic> responseBody = jsonDecode(responseData['body']);
  //       String detectedNumbers = responseBody['sudoku'];
  //       return detectedNumbers;
  //     } else {
  //       safePrint(
  //         'Error number: ${response.statusCode} ${response.reasonPhrase}');
  //     }
  //   } catch (error) {
  //     safePrint('Exception occurred HERE: $error');
  //   }
  //   return null;
  // }
  //
  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     body: Center(
  //         child: _isImageLoaded == false
  //             ? const Text('No image selected.') // 1. picking/showing image
  //             : _areNumbersBeingDetected
  //                 ? LoadingAnimationWidget.threeRotatingDots(
  //                     // 2. sending image to cloud, loading animation
  //                     color: Colors.white,
  //                     size: 50,
  //                   )
  //                 : _isDetected
  //                     ? SudokuWidget( // 3. showing detected numbers
  //                         _detectedNumbers,
  //                       )
  //                     : platformShowImage(_image!)), // 1. picking/showing image
  //     floatingActionButton: _isPickingImage
  //         ? Container(
  //             //TODO: make them look less clunky
  //             alignment: Alignment.bottomCenter,
  //             child: Row(
  //               mainAxisAlignment: MainAxisAlignment.center,
  //               children: [
  //                 ElevatedButton.icon(
  //                   onPressed: () {
  //                     showDialog(
  //                       context: context,
  //                       builder: (context) => AlertDialog(
  //                         title: const Text('Choose an option'),
  //                         content: Column(
  //                           mainAxisSize: MainAxisSize.min,
  //                           children: [
  //                             ListTile(
  //                               leading: const Icon(
  //                                   Icons.add_photo_alternate_rounded),
  //                               title: const Text('Upload from file'),
  //                               onTap: () {
  //                                 Navigator.pop(context); // Close the dialog
  //                                 getImageFromGallery();
  //                               },
  //                             ),
  //                             ListTile(
  //                               leading: const Icon(Icons.camera_alt_rounded),
  //                               title: const Text('Take a picture'),
  //                               onTap: () {
  //                                 Navigator.pop(context); // Close the dialog
  //                                 getImageFromCamera();
  //                               },
  //                             ),
  //                           ],
  //                         ),
  //                       ),
  //                     );
  //                   },
  //                   icon: const Icon(Icons.add),
  //                   label: _image == null
  //                       ? const Text('Add image')
  //                       : const Text('Change image'),
  //                 ),
  //                 ElevatedButton.icon(
  //                   onPressed: _isImageLoaded
  //                       ? () async {
  //                           // here the image is sent to the cloud, so we need to wait for the response
  //                           setState(() {
  //                             _areNumbersBeingDetected = true;
  //                             _isPickingImage = false;
  //                           });
  //                           _detectedNumbers =
  //                               await getNumbersFromImage(_image!);
  //                           setState(() {
  //                             _areNumbersBeingDetected = false;
  //                             _isDetected = true;
  //                           });
  //                         }
  //                       : () {
  //                           ScaffoldMessenger.of(context).showSnackBar(
  //                             const SnackBar(
  //                               content: Text('Please add an image first.'),
  //                               duration: Duration(seconds: 1),
  //                             ),
  //                           );
  //                         },
  //                   style: ButtonStyle(
  //                     backgroundColor: _isImageLoaded
  //                         ? MaterialStateProperty.all<Color>(Colors.green)
  //                         : MaterialStateProperty.all<Color>(Colors.grey),
  //                   ),
  //                   icon: const Icon(Icons.arrow_forward_ios_rounded),
  //                   label: const Text("Run"),
  //                 ),
  //               ],
  //             ),
  //           )
  //         : null,
  //     floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
  //   );
  // }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Photo upload page',
                style: GoogleFonts.poppins(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          )
      ),
    );
  }
}

