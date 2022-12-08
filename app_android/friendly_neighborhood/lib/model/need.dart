// ignore_for_file: unnecessary_getters_setters

class Need {
  late int _id;
  late DateTime _postDate;
  late String _title;
  late String _address;
  late String _description;
  late String _assistant;
  late int _idAssistant;
  late String _creator;

  Need(
      {int id = -1,
      required DateTime postDate,
      required String title,
      required String address,
      required String description,
      required String assistant,
      required int idAssistant,
      required String creator}) {
    _id = id;
    _postDate = postDate;
    _title = title;
    _address = address;
    _description = description;
    _assistant = assistant;
    _idAssistant = idAssistant;
    _creator = creator;
  }

  //JSON CONSTRUCTOR
  Need.fromJSON(Map<String, dynamic> json) {
    _id = json["id"];
    _postDate = json["postDate"];
    _title = json["title"];
    _address = json["address"];
    _description = json["description"];
    _assistant = json["assistant"];
    _idAssistant = json["idAssistant"];
    _creator = json["creator"];
  }

  //GETTER
  int get id => _id;
  DateTime get postDate => _postDate;
  String get title => _title;
  String get address => _address;
  String get description => _description;
  String get assistant => _assistant;
  String get creator => _creator;

  //SETTER
  set title(String title) => _title = title;
  set address(String address) => _address = address;
  set description(String description) => _description = description;
  set idAssistant(int idAssistant) => _idAssistant = idAssistant;

  //CONVERSION TO JSON
  Map<String, dynamic> toJson() => {
        'id': _id,
        'postDate': _postDate,
        'title': _title,
        'address': _address,
        'description': _description,
        'assistant': _assistant,
        'idAssistant': _idAssistant,
        'creator': _creator
      };
}
