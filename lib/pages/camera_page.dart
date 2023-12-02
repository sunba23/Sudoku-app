import 'package:app/components/title_area.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import '../bloc/detect_bloc/detect_sudoku_bloc.dart';

import 'dart:io';

class CameraPage extends StatefulWidget {
  CameraPage({super.key});

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  final double cardRadius = 15.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 223, 225, 238),
      body: BlocConsumer<DetectSudokuBloc, DetectSudokuState>(
        listener: (context, state) {
        },
        builder: (context, state) {
          if (state is LoadingState) {
            return _buildLoadingUI();
          }
          if (state is InitialState) {
            return _buildInitialUI();
          } else if (state is PreviewState) { // we build the preview UI based on the image source
            if (state.sudokuImage == null) {
              return _buildPreviewUI(null, state.assetPath!);
            } else {
              return _buildPreviewUI(state.sudokuImage!, null);
            }
          } else if (state is LoadedState) {
            return _buildLoadedUI(state.detectedSudoku);
          } else {
            return const SizedBox.shrink();
          }
        },
      ),
    );
  }

  Widget _buildInitialUI() {
    return Column(
      children: [
        const TitleArea(title: "Solve"),
        const SizedBox(height: 60.0,),
        Container( // photo upload card
          width: MediaQuery.of(context).size.width * 0.9,
          height: MediaQuery.of(context).size.height * 0.27,
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 235, 235, 245),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 15.0, left: 25.0, bottom: 20.0),
                child: Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Try one of our pictures...',
                    style: GoogleFonts.nunito(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: const Color.fromARGB(255, 57, 64, 83),
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.35,
                    height: MediaQuery.of(context).size.height * 0.14,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 57, 64, 83),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: GestureDetector(
                      onTap: () {
                        String assetPath = 'lib/assets/recommended_sudokus/5.jpg';
                        BlocProvider.of<DetectSudokuBloc>(context).add(PreviewEvent(null, assetPath));
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                            color: const Color.fromARGB(250, 57, 64, 83),
                            width: 2,
                          ),
                          image: const DecorationImage(
                            image: AssetImage('lib/assets/recommended_sudokus/5.jpg'),
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.35,
                    height: MediaQuery.of(context).size.height * 0.14,
                    child: GestureDetector(
                      onTap: () {
                        String assetPath = 'lib/assets/recommended_sudokus/5.jpg';
                        BlocProvider.of<DetectSudokuBloc>(context).add(PreviewEvent(null, assetPath));
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                            color: const Color.fromARGB(250, 57, 64, 83),
                            width: 2,
                          ),
                          image: const DecorationImage(
                            image: AssetImage('lib/assets/recommended_sudokus/5.jpg'),
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 40.0,),
        Container( // photo upload card
          width: MediaQuery.of(context).size.width * 0.9,
          height: MediaQuery.of(context).size.height * 0.27,
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 235, 235, 245),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 12.0, right: 30.0,),
                child: Container(
                  alignment: Alignment.centerRight,
                  child: Text(
                    '...or upload your own',
                    style: GoogleFonts.nunito(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: const Color.fromARGB(255, 57, 64, 83),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 25.0, bottom: 30.0),
                child: DottedBorder(
                  color: const Color.fromARGB(255 ,57, 64, 83).withOpacity(0.85),
                  strokeWidth: 2.5,
                  strokeCap: StrokeCap.round,
                  dashPattern: const [25, 20],
                  radius: const Radius.circular(15),
                  customPath: (size) {
                    return Path()
                      ..moveTo(cardRadius, 0)
                      ..lineTo(size.width - cardRadius, 0)
                      ..arcToPoint(Offset(size.width, cardRadius), radius: Radius.circular(cardRadius))
                      ..lineTo(size.width, size.height - cardRadius)
                      ..arcToPoint(Offset(size.width - cardRadius, size.height), radius: Radius.circular(cardRadius))
                      ..lineTo(cardRadius, size.height)
                      ..arcToPoint(Offset(0, size.height - cardRadius), radius: Radius.circular(cardRadius))
                      ..lineTo(0, cardRadius)
                      ..arcToPoint(Offset(cardRadius, 0), radius: Radius.circular(cardRadius));
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.75,
                    height: MediaQuery.of(context).size.height * 0.15,
                    child: MaterialButton(
                      onPressed: () async {
                        final imagePicker = ImagePicker();
                        final image = await imagePicker.pickImage(source: ImageSource.gallery);
                        File file = File(image!.path);
                        if (mounted){
                          BlocProvider.of<DetectSudokuBloc>(context).add(PreviewEvent(file, null));
                        }
                      },
                      child: Icon(
                        Icons.add_rounded,
                        size: 50,
                        color: const Color.fromARGB(255, 57, 64, 83).withOpacity(0.85),
                      )
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPreviewUI(File? sudokuImage, String? assetPath) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        sudokuImage != null ? Image.file(sudokuImage) : Image.asset(assetPath!),
        ElevatedButton(
          onPressed: () {
            BlocProvider.of<DetectSudokuBloc>(context).add(
              DetectingEvent(sudokuImage, assetPath),
            );
          },
          child: const Text('Analyze Image'),
        ),
        ElevatedButton(
          onPressed: () {
            BlocProvider.of<DetectSudokuBloc>(context).add(
              ClearStateEvent(),
            );
          },
          child: const Text('Clear'),
        ),
      ],
    );
  }


  Widget _buildLoadingUI() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildLoadedUI(String detectedSudoku) {
    // create the sudoku grid. the grid is a 9x9 grid of text fields. the detectedSudoku string is used to populate the text fields - it consists of 81 characters, each representing a cell in the sudoku grid. the characters are in row-major order, and are either a digit (1-9) or a period (.) to represent an empty cell.
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Sudoku Detected:'),
          // GridView.count(
          //   shrinkWrap: true,
          //   crossAxisCount: 9,
          //   children: List.generate(81, (index) {
          //     return Center(
          //       child: SizedBox(
          //         width: 30,
          //         height: 30,
          //         child: TextFormField(
          //           initialValue: detectedSudoku[index] == '.'
          //               ? ''
          //               : detectedSudoku[index],
          //           textAlign: TextAlign.center,
          //           keyboardType: TextInputType.number,
          //           decoration: const InputDecoration(
          //             border: OutlineInputBorder(),
          //           ),
          //         ),
          //       ),
          //     );
          //   }),
          // ),
          Text(detectedSudoku),
        ],
      ),
    );
  }
}
