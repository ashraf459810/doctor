part of 'home_bloc.dart';

@immutable
abstract class HomeEvent {}

class GetDataBaseEvent extends HomeEvent {}

class InserNoteEvent extends HomeEvent {
  final Note note;

  InserNoteEvent(this.note);
}

class AddVisitEvent extends HomeEvent {
  final String date;
  final int id;
  final String name;
  final int visitNumber;
  AddVisitEvent(this.date, this.id, this.name, this.visitNumber);
}

class GetVisitsForUserEvent extends HomeEvent {
  final int id;

  GetVisitsForUserEvent(this.id);
}
