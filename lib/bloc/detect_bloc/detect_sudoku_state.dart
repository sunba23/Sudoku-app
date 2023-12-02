part of 'detect_sudoku_bloc.dart';

abstract class DetectSudokuState extends Equatable {
  const DetectSudokuState();

  @override
  List<Object> get props => [];
}

class InitialState extends DetectSudokuState {}

class PreviewState extends DetectSudokuState {
  final File? sudokuImage;
  final String? assetPath;

  const PreviewState(this.sudokuImage, this.assetPath);

  @override
  List<Object> get props => [sudokuImage ?? Object(), assetPath ?? Object()];
}

// class PickedState extends DetectSudokuState {
//   final File sudokuImage;
//
//   const PickedState(this.sudokuImage);
//
//   @override
//   List<Object> get props => [sudokuImage];
// }

class LoadingState extends DetectSudokuState {}

class LoadedState extends DetectSudokuState {
  final String detectedSudoku;

  const LoadedState(this.detectedSudoku);

  @override
  List<Object> get props => [detectedSudoku];
}