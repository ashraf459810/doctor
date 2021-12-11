class Note {
  int? _id;
  late String _name;
  late int _visitNumbers;
  late String _date;

  Note(
    this._name,
    this._date,
    this._visitNumbers,
  );

  Note.withId(
    this._id,
    this._name,
    this._date,
    this._visitNumbers,
  );

  int? get id => _id;

  String get name => _name;

  int get visitNumber => _visitNumbers;

  String get date => _date;

  set name(String name) {
    if (name.length <= 255) {
      _name = name;
    }
  }

  set visitNumbers(int visits) {
    _visitNumbers = visits;
  }

  set date(String newDate) {
    if (newDate.isNotEmpty) {
      _date = newDate;
    }
  }

  // Convert a Note object into a Map object
  Map<String, dynamic> toMap() {
    // ignore: prefer_collection_literals
    var map = Map<String, dynamic>();

    if (id != null) {
      map['id'] = _id;
    }

    map['id'] = _id;

    map['name'] = _name;
    map['visitsNumber'] = _visitNumbers;

    map['date'] = _date;

    return map;
  }

  // Extract a Note object from a Map object
  Note.fromMapObject(Map<String, dynamic> map) {
    _id = map['id'];
    _name = map['name'];
    _visitNumbers = map['visitsNumber'];

    _date = map['date'];
  }
}
