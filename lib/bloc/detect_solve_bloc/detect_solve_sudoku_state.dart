part of 'detect_solve_sudoku_bloc.dart';

abstract class DetectSolveSudokuState extends Equatable {
  const DetectSolveSudokuState();

  @override
  List<Object> get props => [];

  get sudokuImage => null;
  get assetPath => null;
}

class InitialState extends DetectSolveSudokuState {}

class PreviewState extends DetectSolveSudokuState {
  @override
  final File? sudokuImage;
  @override
  final String? assetPath;

  const PreviewState(this.sudokuImage, this.assetPath);

  @override
  List<Object> get props => [sudokuImage ?? Object(), assetPath ?? Object()];
}

class LoadingState extends DetectSolveSudokuState {}

class LoadedState extends DetectSolveSudokuState {
  final String detectedSudoku;

  const LoadedState(this.detectedSudoku);

  @override
  List<Object> get props => [detectedSudoku];
}

class ErrorState extends DetectSolveSudokuState {
  final String message;

  const ErrorState(this.message);

  @override
  List<Object> get props => [message];
}

class LoadingSolvingState extends DetectSolveSudokuState {}

class SolvedState extends DetectSolveSudokuState {
  final String solvedSudoku;

  const SolvedState(this.solvedSudoku);

  @override
  List<Object> get props => [solvedSudoku];
}

class ErrorSolvingState extends DetectSolveSudokuState {
  final String message;

  const ErrorSolvingState(this.message);

  @override
  List<Object> get props => [message];
}