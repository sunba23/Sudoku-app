import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'solve_page.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({Key? key}) : super(key: key);

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  File? _image;
  bool _isImageLoaded = false;
  final imagePicker = ImagePicker();

  Future getImageFromCamera() async {
    final image = await imagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      _image = File(image!.path);
      _isImageLoaded = true;
    });
  }

  Future getImageFromGallery() async {
    final image = await imagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = File(image!.path);
      _isImageLoaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Camera Page')),
      body: Center(
        child: _isImageLoaded == false
            ? const Text('No image selected.')
            : kIsWeb
                ? Image.network(_image!.path) //web specific
                : defaultTargetPlatform == TargetPlatform.android || defaultTargetPlatform == TargetPlatform.iOS
                    ? Image.file(_image!) //mobile specific
                    : defaultTargetPlatform == TargetPlatform.windows || defaultTargetPlatform == TargetPlatform.linux || defaultTargetPlatform == TargetPlatform.macOS || defaultTargetPlatform == TargetPlatform.fuchsia
                        ? Image.file(_image!) //desktop specific
                        : const Text('Unsupported platform'),

      ),
      floatingActionButton: Container(
        alignment: Alignment.bottomCenter,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Choose an option'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ListTile(
                          leading:
                              const Icon(Icons.add_photo_alternate_rounded),
                          title: const Text('Upload from file'),
                          onTap: () {
                            Navigator.pop(context); // Close the dialog
                            getImageFromGallery();
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.camera_alt_rounded),
                          title: const Text('Take a picture'),
                          onTap: () {
                            Navigator.pop(context); // Close the dialog
                            getImageFromCamera();
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.add),
              label: _image == null
                  ? const Text('Add image')
                  : const Text('Change image'),
            ),
            ElevatedButton.icon(
              onPressed: _isImageLoaded
                  ? () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SolvePage(sudokuImage: _image!)),
                      );
                    }
                  : () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please add an image first.'),
                          duration: Duration(seconds: 1),
                        ),
                      );
                    },
              style: ButtonStyle(
              backgroundColor: _isImageLoaded 
                ? MaterialStateProperty.all<Color>(Colors.green)
                : MaterialStateProperty.all<Color>(Colors.grey),
              ),
              icon: const Icon(Icons.arrow_forward_ios_rounded),
              label: const Text("Run"),
            ),

          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
