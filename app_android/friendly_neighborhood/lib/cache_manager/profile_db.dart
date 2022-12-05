// ignore_for_file: depend_on_referenced_packages

import 'package:friendly_neighborhood/model/localuser.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

//Documentazione: https://docs.flutter.dev/cookbook/persistence/sqlite

//Singlenton class
class LocalUserManager {
  static final LocalUserManager _instance = LocalUserManager._internal();
  static const String dbName = "localUser.db";
  late final Database _db;
  bool _isOpen = false;

  // using a factory is important
  // because it promises to return _an_ object of this type
  // but it doesn't promise to make a new one.
  factory LocalUserManager() {
    return _instance;
  }

  // This named constructor is the "real" constructor
  // It'll be called exactly once, by the static property assignment above
  // it's also private, so it can only be called in this class
  LocalUserManager._internal() {}

  //La funzione serve per chiudere il database
  Future close() async {
    _db.close();
    _isOpen = false;
  }

  //La funzione serve per aprire il database
  Future open() async {
    _db = await openDatabase(
      join(await getDatabasesPath(), dbName),
      //Funzione creazione database
      onCreate: (db, version) {
        return db.execute(
            'CREATE TABLE user(email TEXT PRIMARY KEY,username TEXT,name TEXT, lastname TEXT, birthdate TEXT,address TEXT, family INTEGER,houseType TEXT,neighborhood TEXT,token TEXT)');
      },
      version: 1,
    );
    _isOpen = true;
  }

  Future<void> insertUser(LocalUser user) async {
    if (!_isOpen) {
      open();
    }

    await _db.insert(
      'user',
      user.mapForDb(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updateUser(LocalUser user) async {
    if (!_isOpen) {
      open();
    }

    //Si può aggiornare anche la chiave primaria, perciò devo rimuovere l'utente esistente
    LocalUser l = await getUser();
    await deleteUser(l);
    insertUser(user);
  }

  Future<void> deleteUser(LocalUser user) async {
    if (!_isOpen) {
      open();
    }

    await _db.delete(
      'user',
      where: 'email = ?',
      whereArgs: [user.email],
    );
  }

  Future<LocalUser> getUser() async {
    // Get a reference to the database.
    if (!_isOpen) {
      open();
    }

    final List<Map<String, dynamic>> res = await _db.query('user');

    // E' possibile avere solo 1 utente nel database, non di più
    return LocalUser.fromDB(res[0]);
  }

  //La funzione ritorna true se il db è stato aperto, false in caso contrario
  bool get isOpen => _isOpen;
}
/*
TIPI GESTITI DA SQLFLITE
INTEGER
REAL
TEXT
BLOB

Le date saranno gestite attraverso il tipo text
*/
