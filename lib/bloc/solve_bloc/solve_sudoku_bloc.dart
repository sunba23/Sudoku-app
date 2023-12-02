import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'solve_sudoku_event.dart';
part 'solve_sudoku_state.dart';

class SolveSudokuBloc extends Bloc<SolveSudokuEvent, SolveSudokuState> {
  SolveSudokuBloc() : super(SolveSudokuInitial()) {
    on<SolveSudokuEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
