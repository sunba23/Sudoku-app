part of 'detect_sudoku_bloc.dart';

abstract class DetectSudokuEvent extends Equatable {
  const DetectSudokuEvent();

  @override
  List<Object> get props => [];
}

class PickingEvent extends DetectSudokuEvent {}

class DetectingEvent extends DetectSudokuEvent {
  final File sudokuImage;

  const DetectingEvent(this.sudokuImage);

  @override
  List<Object> get props => [sudokuImage];
}

