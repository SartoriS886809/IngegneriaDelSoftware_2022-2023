// ignore_for_file: unnecessary_getters_setters
class Report {
  late int _id;
  late DateTime _postDate;
  late String _title;
  late int _priority;
  late String _category;
  late String _address;
  late String _creator;

  Report(int id, DateTime postDate, String title, int priority, String category,
      String address, String creator) {
    _id = id;
    _postDate = postDate;
    _title = title;
    _priority = priority;
    _category = category;
    _address = address;
    _creator = creator;
  }

  Report.fromJSON(Map<String, dynamic> json) {
    _id = json["id"];
    _postDate = json["postDate"];
    _title = json["title"];
    _priority = json["priority"];
    _category = json["category"];
    _address = json["address"];
    _creator = json["creator"];
  }

  //GETTER
  int get id => _id;
  DateTime get postDate => _postDate;
  String get title => _title;
  int get priority => _priority;
  String get category => _category;
  String get address => _address;
  String get creator => _creator;

  //CONVERSION TO JSON
  Map<String, dynamic> toJson() => {
        'id': _id,
        'postDate': _postDate,
        'title': _title,
        'priority': _priority,
        'category': _category,
        'address': _address,
        'creator': _creator,
      };
}
