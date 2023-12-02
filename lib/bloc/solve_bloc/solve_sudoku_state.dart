part of 'solve_sudoku_bloc.dart';

abstract class SolveSudokuState extends Equatable {
  const SolveSudokuState();
}

class SolveSudokuInitial extends SolveSudokuState {
  @override
  List<Object> get props => [];
}
