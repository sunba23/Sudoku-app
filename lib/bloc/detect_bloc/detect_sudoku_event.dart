part of 'detect_sudoku_bloc.dart';

abstract class DetectSudokuEvent extends Equatable {
  const DetectSudokuEvent();

  @override
  List<Object> get props => [];
}

// class PickingEvent extends DetectSudokuEvent {}

class PreviewEvent extends DetectSudokuEvent {
  final File? file;
  final String? assetPath;

  const PreviewEvent(this.file, this.assetPath);

  @override
  List<Object> get props => [file ?? Object(), assetPath ?? Object()];
}


class DetectingEvent extends DetectSudokuEvent {
  final File? sudokuImage;
  final String? assetPath;

  const DetectingEvent(this.sudokuImage, this.assetPath);

  @override
  List<Object> get props => [sudokuImage ?? Object(), assetPath ?? Object()];
}

class ClearStateEvent extends DetectSudokuEvent {}
