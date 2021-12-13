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

class DeleteUser extends HomeEvent {
  final int userid;

  DeleteUser(this.userid);
}

class DeleteVisit extends HomeEvent {
  final int visitid;
  final int noteid;
  final int visitsNumber;
  final Note note;

  DeleteVisit(this.visitid, this.noteid, this.visitsNumber, this.note);
}

class SearchEvent extends HomeEvent {
  final String date1;
  final String date2;
  final String name;

  SearchEvent(this.date1, this.name, this.date2);
}
