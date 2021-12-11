class Visits {
  late int _id;

  late String _date;

  Visits(
    this._id,
    this._date,
  );

  int? get id => _id;

  String get date => _date;

  set date(String newDate) {
    if (newDate.isNotEmpty) {
      _date = newDate;
    }
  }

  // Convert a Note object into a Map object
  Map<String, dynamic> toMap() {
    // ignore: prefer_collection_literals
    var map = Map<String, dynamic>();

    map['id'] = _id;

    map['date'] = _date;

    return map;
  }

  // Extract a Note object from a Map object
  Visits.fromMapObject(Map<String, dynamic> map) {
    _id = map['id'];

    _date = map['date'];
  }
}
