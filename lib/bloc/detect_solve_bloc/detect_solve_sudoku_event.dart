part of 'detect_solve_sudoku_bloc.dart';

abstract class DetectSolveSudokuEvent extends Equatable {
  const DetectSolveSudokuEvent();

  @override
  List<Object> get props => [];
}

class PreviewEvent extends DetectSolveSudokuEvent {
  final File? file;
  final String? assetPath;

  const PreviewEvent(this.file, this.assetPath);

  @override
  List<Object> get props => [file ?? Object(), assetPath ?? Object()];
}


class DetectingEvent extends DetectSolveSudokuEvent {
  final File? sudokuImage;
  final String? assetPath;

  const DetectingEvent(this.sudokuImage, this.assetPath);

  @override
  List<Object> get props => [sudokuImage ?? Object(), assetPath ?? Object()];
}

class ClearStateEvent extends DetectSolveSudokuEvent {}

class SolvingEvent extends DetectSolveSudokuEvent {
  final String sudoku;

  const SolvingEvent(this.sudoku);

  @override
  List<Object> get props => [sudoku];
}

class ErrorEvent extends DetectSolveSudokuEvent{
  final String message;

  const ErrorEvent(this.message);

  @override
  List<Object> get props => [message];
}