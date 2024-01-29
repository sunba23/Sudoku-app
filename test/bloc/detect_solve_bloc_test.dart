import 'dart:io';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:app/bloc/detect_solve_bloc/detect_solve_sudoku_bloc.dart';


void main() {
  group('DetectSolveBloc', () {
    blocTest<DetectSolveSudokuBloc, DetectSolveSudokuState>(
      'emits [] when nothing is added',
      build: () => DetectSolveSudokuBloc(),
      expect: () => [],
    );

    blocTest<DetectSolveSudokuBloc, DetectSolveSudokuState>(
      'emits [InitialState] when ClearStateEvent is added',
      build: () => DetectSolveSudokuBloc(),
      act: (bloc) => bloc.add(ClearStateEvent()),
      expect: () => [isA<InitialState>()],
    );

    blocTest<DetectSolveSudokuBloc, DetectSolveSudokuState>(
      'emits [LoadingState] when DetectingEvent is added',
      build: () => DetectSolveSudokuBloc(),
      act: (bloc) => bloc.add(const DetectingEvent(null, null)),
      expect: () => [isA<LoadingState>()],
    );
  });
}