import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:doctor/data_base/note_data_base.dart';

import 'package:doctor/model/notes.dart';
import 'package:doctor/model/visits_model.dart';
import 'package:meta/meta.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeInitial()) {
    DatabaseHelper databaseHelper = DatabaseHelper();

    on<HomeEvent>((event, emit) async {
      databaseHelper.initializeDatabase();

      emit(Loading());
      if (event is GetDataBaseEvent) {
        var result = await databaseHelper.repairDataBase();
        log(result.toString());

        List<Note> notes = await databaseHelper.getNoteList();

        emit(GetDataBaseState(notes));
      }

      if (event is InserNoteEvent) {
        // emit(Loading());
        final result = await databaseHelper.checkIfExist(event.note);
        if (result.isEmpty) {
          int returnedId = await databaseHelper.insertNote(event.note);

          databaseHelper.insertVisit(
              Visits(returnedId, event.note.date, event.note.name));

          add(GetDataBaseEvent());
        } else {
          emit(Error("Name Already Exist"));
        }
      }
      if (event is AddVisitEvent) {
        // emit(Loading());
        await databaseHelper
            .updateNote(Note.withId(
                event.id, event.name, event.date, event.visitNumber))
            .then((value) => databaseHelper
                .insertVisit(Visits(event.id, event.date, event.name))
                .then((value) => add(GetDataBaseEvent())));
      }

      if (event is GetVisitsForUserEvent) {
        // emit(Loading());
        List<Visits> visits = await databaseHelper.getVisitsList(event.id);
        log(visits.length.toString());
        emit(GetUserVisitsState(visits));
      }

      if (event is DeleteUser) {
        emit(Loading());
        await databaseHelper
            .deleteNote(event.userid)
            .then((value) => databaseHelper.deleteVisit(event.userid));
        add(GetDataBaseEvent());
      }
      if (event is DeleteVisit) {
        // emit(Loading());
        await databaseHelper.deleteOneVisit(event.visitid).then((value) =>
            databaseHelper.updateNote(Note.withId(event.note.id,
                event.note.name, event.note.date, event.visitsNumber - 1)));

        add(GetVisitsForUserEvent(event.noteid));
        // add(GetDataBaseEvent());
      }
      if (event is SearchEvent) {
        // emit(Loading());
        List<Visits> visits =
            await databaseHelper.search(event.name, event.date1, event.date2);
        log(visits.length.toString());

        emit(SearchState(visits));
      }
    });
  }
}
