import 'dart:developer';

import 'package:doctor/model/notes.dart';
import 'package:doctor/model/visits_model.dart';

import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
  static late DatabaseHelper _databaseHelper; // Singleton DatabaseHelper
  static late Database _database; // Singleton Database

  String noteTable = 'note_table';
  String notePrimaryKey = 'id';

  String name = 'name';
  String date = 'date';
  String visitsnumber = 'visitsNumber';
  String noteVisit = 'visit_table';

  String visitId = 'id';
  String visiterName = 'visitName';
  String visitsPrimaryKey = 'visitId';

  String visitsDates = 'date';

  DatabaseHelper._createInstance(); // Named constructor to create instance of DatabaseHelper

  factory DatabaseHelper() {
    _databaseHelper = DatabaseHelper
        ._createInstance(); // This is executed only once, singleton object

    return _databaseHelper;
  }

  Future<Database> get database async {
    _database = await initializeDatabase();

    return _database;
  }

  Future<Database> initializeDatabase() async {
    // Get the directory path for both Android and iOS to store database.
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'notes.db';

    // Open/create the database at a given path
    var notesDatabase =
        await openDatabase(path, version: 1, onCreate: _createDb);
    return notesDatabase;
  }

  void _createDb(Database db, int newVersion) async {
    await db.execute('''
      create table $noteTable (
        $notePrimaryKey integer primary key autoincrement,
        $name text not null,
        $visitsnumber integer not null,
        $date DATETIME not null
       )''');
    await db.execute('''
      create table $noteVisit (
        $visitsPrimaryKey integer primary key autoincrement,
        $visitId integer not null,
        $visitsDates DATETIME not null,
        $visiterName text not null,
        FOREIGN KEY($visitId) REFERENCES $noteTable($notePrimaryKey)
       )''');
  }

  // Fetch Operation: Get all note objects from database
  Future<List<Map<String, dynamic>>> getNoteMapList() async {
    Database db = await database;

//		var result = await db.rawQuery('SELECT * FROM $noteTable order by $colPriority ASC');
    var result = await db.query(noteTable, orderBy: '$name ASC');
    return result;
  }

  // Insert Operation: Insert a Note object to database
  Future<int> insertNote(Note note) async {
    Database db = await database;
    var result = await db.insert(noteTable, note.toMap());

    return result;
  }

  Future<List<Map<String, dynamic>>> checkIfExist(Note note) async {
    String namee = note.name;
    Database db = await database;
    var result =
        await db.rawQuery('SELECT * from $noteTable where name = "$namee" ');

    return result;
  }

  // Update Operation: Update a Note object and save it to database
  Future<int> updateNote(Note note) async {
    var db = await database;
    var result = await db.update(noteTable, note.toMap(),
        where: '$notePrimaryKey = ?', whereArgs: [note.id]);
    return result;
  }

  // Delete Operation: Delete a Note object from database
  Future<int> deleteNote(int id) async {
    var db = await database;
    int result = await db
        .rawDelete('DELETE FROM $noteTable WHERE $notePrimaryKey = $id');
    return result;
  }

  // Get number of Note objects in database
  Future<int> getCount() async {
    Database db = await database;
    List<Map<String, dynamic>> x =
        await db.rawQuery('SELECT COUNT (*) from $noteTable');
    int? result = Sqflite.firstIntValue(x);
    return result ?? 0;
  }

  // Get the 'Map List' [ List<Map> ] and convert it to 'Note List' [ List<Note> ]
  Future<List<Note>> getNoteList() async {
    var noteMapList = await getNoteMapList(); // Get 'Map List' from database
    int count =
        noteMapList.length; // Count the number of map entries in db table

    List<Note> noteList = [];
    // For loop to create a 'Note List' from a 'Map List'
    for (int i = 0; i < count; i++) {
      noteList.add(Note.fromMapObject(noteMapList[i]));
    }

    return noteList;
  }

  Future<List<Map<String, dynamic>>> getVisitsMapList(int id) async {
    Database db = await database;

//		var result = await db.rawQuery('SELECT * FROM $noteTable order by $colPriority ASC');
    var result = await db.rawQuery('SELECT * from $noteVisit where id=$id');
    return result;
  }

  Future<int> getCountForVisits() async {
    Database db = await database;
    List<Map<String, dynamic>> x =
        await db.rawQuery('SELECT COUNT (*) from $noteVisit');
    int? result = Sqflite.firstIntValue(x);
    return result ?? 0;
  }

  Future<List<Visits>> getVisitsList(int id) async {
    var visitsMapList =
        await getVisitsMapList(id); // Get 'Map List' from database
    int count =
        visitsMapList.length; // Count the number of map entries in db table

    List<Visits> visits = [];
    // For loop to create a 'Note List' from a 'Map List'
    for (int i = 0; i < count; i++) {
      visits.add(Visits.fromMapObject(visitsMapList[i]));
    }

    return visits;
  }

  Future<int> deleteVisit(int id) async {
    var db = await database;
    int result =
        await db.rawDelete('DELETE FROM $noteVisit WHERE $visitId = $id');
    return result;
  }

  Future<int> deleteOneVisit(int id) async {
    var db = await database;
    int result = await db
        .rawDelete('DELETE FROM $noteVisit WHERE $visitsPrimaryKey = $id');
    return result;
  }

  Future<int> updateVisit(Visits visit) async {
    var db = await database;
    var result = await db.update(noteVisit, visit.toMap(),
        where: '$notePrimaryKey = ?', whereArgs: [visit.id]);
    return result;
  }

  Future<int> insertVisit(Visits visit) async {
    Database db = await database;
    var result = await db.insert(noteVisit, visit.toMap());
    return result;
  }

  Future<int> repairDataBase() async {
    Database db = await database;
    var result = await db.rawDelete(
        'DELETE FROM $noteVisit WHERE visitId NOT IN (SELECT $notePrimaryKey FROM $noteTable);');

    return result;
  }

  Future<List<Map<String, dynamic>>> searchedVisitsMapList(
      String name, String date1, String date2) async {
    Database db = await database;

//
//	var result = await db.rawQuery('SELECT * FROM $noteTable order by $colPriority ASC');
    if (name == "empty" && date1 != date2) {
      log("empty name and dates diffrent");

      var result = await db.rawQuery(
          "SELECT * FROM $noteVisit where date >= '$date1' and  date <= '$date2' ");
      return result;
    } else if (date1 == date2 && name != "empty") {
      log("not empty name and dates equal");
      var result = await db.rawQuery(
          "SELECT * from $noteVisit   WHERE date = '$date1'  and $visiterName='$name' ");
      return result;
    } else if (date1 == date2 && name == "empty") {
      log("empty name and dates equal");
      var result =
          await db.rawQuery("SELECT * from $noteVisit   WHERE date = '$date1'");
      return result;
    } else {
      var result = await db.rawQuery(
          "SELECT * from $noteVisit   WHERE (date < '$date1' AND  date > '$date2' ) or $visiterName='$name' ");
      return result;
    }
  }

  Future<List<Visits>> search(String name, String date1, String date2) async {
    var searchedvisitsmaptolist =
        await searchedVisitsMapList(name, date1, date2);

    List<Visits> visits = [];
    int count = searchedvisitsmaptolist.length;

    for (int i = 0; i < count; i++) {
      visits.add(Visits.fromMapObject(searchedvisitsmaptolist[i]));
    }

    return visits;
  }
}
