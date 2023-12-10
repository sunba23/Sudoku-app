import 'package:app/components/title_area.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:rive/rive.dart';
import '../bloc/detect_solve_bloc/detect_solve_sudoku_bloc.dart';

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
      body: BlocConsumer<DetectSolveSudokuBloc, DetectSolveSudokuState>(
        listener: (context, state) {
        },
        builder: (context, state) {
          if (state is LoadingState) {
            return _buildLoadingUI();
          }
          if (state is InitialState) {
            return _buildInitialUI();
          } else if (state is PreviewState) { // we pass different arguments to preview UI based on the image source
            if (state.sudokuImage == null) {
              return _buildPreviewUI(null, state.assetPath!);
            } else {
              return _buildPreviewUI(state.sudokuImage!, null);
            }
          } else if (state is LoadedState) {
            return _buildLoadedUI(state.detectedSudoku);
          } else if (state is ErrorState) {
            return _buildErrorDetectingUI(state.message);
          } else if (state is LoadingSolvingState) {
            return _buildSolvingLoadingUI();
          } else if (state is SolvedState) {
            return _buildSolvedUI(state.solvedSudoku);
          } else if (state is ErrorSolvingState) {
            return _buildErrorSolvingUI(state.message);
          }
          else {
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
          height: MediaQuery.of(context).size.height * 0.26,
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
                    height: MediaQuery.of(context).size.height * 0.15,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 57, 64, 83),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: GestureDetector(
                      onTap: () {
                        String assetPath = 'lib/assets/recommended_sudokus/5.jpg';
                        BlocProvider.of<DetectSolveSudokuBloc>(context).add(PreviewEvent(null, assetPath));
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
                    height: MediaQuery.of(context).size.height * 0.15,
                    child: GestureDetector(
                      onTap: () {
                        String assetPath = 'lib/assets/recommended_sudokus/5.jpg';
                        BlocProvider.of<DetectSolveSudokuBloc>(context).add(PreviewEvent(null, assetPath));
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
                          BlocProvider.of<DetectSolveSudokuBloc>(context).add(PreviewEvent(file, null));
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
      children: [
        const TitleArea(title: "Solve"),
        const SizedBox(height: 60.0,),
        Container(
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 235, 235, 245),
            borderRadius: BorderRadius.circular(15),
          ),
          width: MediaQuery.of(context).size.width * 0.9,
          height: MediaQuery.of(context).size.height * 0.6,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Text(
                  'Image preview',
                  style: GoogleFonts.nunito(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: const Color.fromARGB(255, 57, 64, 83),
                  ),
                ),
                const SizedBox(height: 20.0,),
                Container(
                  width: MediaQuery.of(context).size.width * 0.75,
                  height: MediaQuery.of(context).size.height * 0.35,
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color.fromARGB(255, 57, 64, 83), width: 2),
                    borderRadius: BorderRadius.circular(15),
                    image: DecorationImage(
                      image: sudokuImage != null
                          ? Image.file(sudokuImage).image
                          : Image.asset(assetPath!).image,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 20.0,),
                ElevatedButton(
                  onPressed: () {
                    BlocProvider.of<DetectSolveSudokuBloc>(context).add(
                      DetectingEvent(sudokuImage, assetPath),
                    );
                  },
                  child: const Text('Detect numbers'),
                ),
                ElevatedButton(
                  onPressed: () {
                    BlocProvider.of<DetectSolveSudokuBloc>(context).add(
                      ClearStateEvent(),
                    );
                  },
                  child: const Text('Back'),
                ),
              ],
            ),
          )
        ),
      ],
    );
  }


  Widget _buildLoadingUI() {
    return Column(
      children: [
        const TitleArea(title: "Solve"),
        const SizedBox(height: 60.0,),
        Lottie.asset('lib/assets/lottie_assets/Animation1.json'),
        const SizedBox(height: 20.0,),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Align(
            alignment: Alignment.center,
            child: Text(
              'Detecting numbers usually takes up to 20 seconds. You may leave this page and keep using the app while we detect them.',
              style: GoogleFonts.nunito(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: const Color.fromARGB(255, 57, 64, 83),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoadedUI(String detectedSudoku) {
    final TextEditingController sudokuInputController = TextEditingController(text: detectedSudoku);
    String correctedText = detectedSudoku;
    return Column(
      children: [
        const TitleArea(title: "Solve"),
        TextFormField(
          // keyboardType: TextInputType.number,
          controller: sudokuInputController,
          onChanged: (input) {correctedText = input;},
        ),
        ElevatedButton(
          onPressed: () {
            BlocProvider.of<DetectSolveSudokuBloc>(context).add(
              ClearStateEvent(),
            );
          },
          child: const Text('Close'),
        ),
        ElevatedButton(
          onPressed: () {
            // Pass the corrected Sudoku grid to SolveSudokuBloc
            BlocProvider.of<DetectSolveSudokuBloc>(context).add(
              SolvingEvent(correctedText),
            );
          },
          child: const Text("Solve"),
        ),
      ],
    );
  }

Widget _buildErrorDetectingUI(String message) {
    return Column(
      children: [
        const TitleArea(title: "Solve"),
        const SizedBox(height: 60.0,),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Align(
            alignment: Alignment.center,
            child: Text(
              message,
              style: GoogleFonts.nunito(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: const Color.fromARGB(255, 57, 64, 83),
              ),
            ),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            BlocProvider.of<DetectSolveSudokuBloc>(context).add(
              ClearStateEvent(),
            );
          },
          child: const Text('Close'),
        ),
      ],
    );
  }

  Widget _buildSolvingLoadingUI() {
    return SingleChildScrollView( //avoids overflow due to the keyboard being visible for a moment
      child: Column(
        children: [
          const TitleArea(title: "Solve"),
          const SizedBox(height: 60.0,),
          // Lottie.asset('lib/assets/lottie_assets/solveAnimation.json'),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.4,
            width: MediaQuery.of(context).size.width * 0.8,
            child: Lottie.asset('lib/assets/lottie_assets/Animation2.json'),
          ),
          const SizedBox(height: 20.0,),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Align(
              alignment: Alignment.center,
              child: Text(
                'Solving sudoku usually takes up to 5 seconds. You may leave this page and keep using the app while we solve it.',
                style: GoogleFonts.nunito(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: const Color.fromARGB(255, 57, 64, 83),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSolvedUI(String solvedSudoku) {
    return Column(
      children: [
        const TitleArea(title: "Solve"),
        Text(solvedSudoku),
        ElevatedButton(
          onPressed: () {
            BlocProvider.of<DetectSolveSudokuBloc>(context).add(
              ClearStateEvent(),
            );
          },
          child: const Text('Close'),
        ),
      ],
    );
  }

  Widget _buildErrorSolvingUI(String message){
    return Column(
      children: [
        const TitleArea(title: "Solve"),
        Text("Error encountered: $message"),
      ],
    );
  }
}
