import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:app/components/title_area.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:path_provider/path_provider.dart';
import '../utils/platform_utils.dart';
import 'package:http/http.dart' as http;
import '../widgets/sudoku.dart';
import 'dart:developer';

class CameraPage extends StatefulWidget {
  const CameraPage({super.key});

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  File? _image;
  // bool _isImageLoaded = false;
  // bool _isPickingImage = true; // stage 1
  // bool _areNumbersBeingDetected = false; // stage 2
  bool _isDetected = false; // stage 3
  final imagePicker = ImagePicker();
  // String? _detectedNumbers;

  Future getImageFromCamera() async {
    final image = await imagePicker.pickImage(source: ImageSource.camera);

    setState(() {
      _image = File(image!.path);
      // _isImageLoaded = true;
    });
  }

  Future getImageFromGallery() async {
    final image = await imagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = File(image!.path);
      // _isImageLoaded = true;
    });
  }

  Future<String> getImageBase64(File image) async {
    Uint8List imageBytes = await image.readAsBytes();
    String encodedData = base64Encode(imageBytes);
    return encodedData;
  }


  Future<String?> getNumbersFromImage(File image) async {
    String url = dotenv.env['AWS_LAMBDA_ENDPOINT_URL']!;

    // try {
      Map<String, dynamic> requestBody = {
        'body': {'image': await getImageBase64(_image!)},
      };

      //request body length
      int length = jsonEncode(requestBody).length;
      debugPrint('length: $length');
      debugPrint('requestBody: $requestBody', wrapWidth: 1000);

      debugPrint("LAST 200:\n");
      debugPrint(requestBody['body']['image'].toString().substring(length - 200, length - 1), wrapWidth: 1000);


      log(requestBody.toString());
      // Send the POST request
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestBody),
      );

    //   if (response.statusCode == 200) {
    //     Map<String, dynamic> responseData = jsonDecode(response.body);
    //     Map<String, dynamic> responseBody = jsonDecode(responseData['body']);
    //     String detectedNumbers = responseBody['sudoku'];
    //     _isDetected = true;
    //     return detectedNumbers;
    //   } else {
    //     safePrint(
    //       'Error number: ${response.statusCode} ${response.reasonPhrase}');
    //   }
    // } catch (error) {
    //   safePrint('Exception occurred: $error');
    // }
    // return null;
  }

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
      body: Column(
        children: [
          const TitleArea(title: "Solve"),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton(
            onPressed: getImageFromGallery,
            child: const Text('pick image'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _isDetected = true;
              });
            },
            child: const Text('detect'),
          ),
          _isDetected
            ? FutureBuilder(
                future: getNumbersFromImage(_image!),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    return Text(snapshot.data);
                  } else {
                    return const Text('Loading...');
                  }
                },
              )
            : const Text('not detected'),
        ],
      ),
    );
  }
}

