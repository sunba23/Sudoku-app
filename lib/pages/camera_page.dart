import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/detect_sudoku_bloc.dart';

import 'dart:io';

class CameraPage extends StatefulWidget {
  CameraPage({super.key});

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<DetectSudokuBloc, DetectSudokuState>(
        listener: (context, state) {
          // Handle any other state changes that might require additional actions
        },
        builder: (context, state) {
          if (state is LoadingState) {
            return _buildLoadingUI();
          }
          if (state is InitialState) {
            return _buildInitialUI();
          } else if (state is PickedState) {
            return _buildPickedUI(state.sudokuImage);
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
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Choose an image to begin'),
          ElevatedButton(
            onPressed: () {
              BlocProvider.of<DetectSudokuBloc>(context).add(PickingEvent());
            },
            child: const Text('Pick Image'),
          ),
        ],
      ),
    );
  }

  Widget _buildPickedUI(File sudokuImage) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.file(sudokuImage),
        ElevatedButton(
          onPressed: () {
            BlocProvider.of<DetectSudokuBloc>(context).add(DetectingEvent(sudokuImage));
          },
          child: const Text('Analyze Image'),
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
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Sudoku Detected:'),
          Text(detectedSudoku),
        ],
      ),
    );
  }
}