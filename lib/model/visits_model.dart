class Visits {
  late int _id;
  late String _name;
  late String _date;
  int? visitid;

  Visits(this._id, this._date, this._name);

  int? get id => _id;

  String get date => _date;

  String get name => _name;

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
    map['visitName'] = _name;
    map['visitId'] = visitid;

    map['date'] = _date;

    return map;
  }

  // Extract a Note object from a Map object
  Visits.fromMapObject(Map<String, dynamic> map) {
    _id = map['id'];
    _name = map['visitName'];
    visitid = map["visitId"];
    _date = map['date'];
  }
}
