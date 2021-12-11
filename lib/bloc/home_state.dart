part of 'home_bloc.dart';

@immutable
abstract class HomeState {}

class HomeInitial extends HomeState {}

class GetDataBaseState extends HomeState {
  final List<Note> notes;

  GetDataBaseState(this.notes);
}

class Loading extends HomeState {}

class GetUserVisitsState extends HomeState {
  final List<Visits> visits;

  GetUserVisitsState(this.visits);
}
