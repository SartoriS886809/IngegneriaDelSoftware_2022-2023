// ignore_for_file: unnecessary_getters_setters

class LocalUser {
  late String _email;
  late String _username;
  late String _name;
  late String _lastname;
  late DateTime _birthdate;
  late String _address;
  late int _family;
  late String _houseType;
  late String _neighborhood;
  late String _token;

  LocalUser(
      String email,
      String username,
      String name,
      String lastname,
      DateTime birthdate,
      String address,
      int family,
      String houseType,
      String neighborhood,
      String token) {
    _email = email;
    _username = username;
    _name = name;
    _lastname = lastname;
    _birthdate = birthdate;
    _address = address;
    _family = family;
    _houseType = houseType;
    _neighborhood = neighborhood;
    _token = token;
  }
  LocalUser.fromJSON(Map<String, dynamic> json) {
    _email = json['email'];
    _username = json['username'];
    _name = json['name'];
    _lastname = json['lastname'];
    _birthdate = json['birthdate'];
    _address = json['address'];
    _family = json['family'];
    _houseType = json['houseType'];
    _neighborhood = json['neighborhood'];
    _token = json['token'];
  }

  LocalUser.fromDB(Map<String, dynamic> map) {
    _email = map['email'];
    _username = map['username'];
    _name = map['name'];
    _lastname = map['lastname'];
    _birthdate = DateTime.parse(map['birthdate']);
    _address = map['address'];
    _family = map['family'];
    _houseType = map['houseType'];
    _neighborhood = map['neighborhood'];
    _token = map['token'];
  }

  //GETTER
  String get email => _email;
  String get username => _username;
  String get name => _name;
  String get lastname => _lastname;
  DateTime get birthdate => _birthdate;
  String get address => _address;
  int get family => _family;
  String get houseType => _houseType;
  String get neighborhood => _neighborhood;
  String get token => _token;

  //SETTER
  set email(String email) => _email = email;
  set username(String username) => _username = username;
  set name(String name) => _name = name;
  set lastname(String lastname) => _lastname = lastname;
  set birthdate(DateTime birthdate) => _birthdate = birthdate;
  set address(String address) => _address = address;
  set family(int family) => _family = family;
  set houseType(String houseType) => _houseType = houseType;
  set neighborhood(String neighborhood) => _neighborhood = neighborhood;

  //CONVERSION TO JSON
  Map<String, dynamic> toJson() => {
        'email': _email,
        'username': _username,
        'name': _name,
        'lastname': _lastname,
        'birthdate': _birthdate,
        'address': _address,
        'family': _family,
        'houseType': _houseType,
        'neighborhood': _neighborhood,
        'token': _token
      };

  //Mappa per database
  Map<String, dynamic> mapForDb() => {
        'email': _email,
        'username': _username,
        'name': _name,
        'lastname': _lastname,
        'birthdate': _birthdate.toString(),
        'address': _address,
        'family': _family,
        'houseType': _houseType,
        'neighborhood': _neighborhood,
        'token': _token
      };
}
