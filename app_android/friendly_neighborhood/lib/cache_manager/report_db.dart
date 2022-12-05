// ignore_for_file: depend_on_referenced_packages
import 'package:friendly_neighborhood/model/report.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

//Documentazione: https://docs.flutter.dev/cookbook/persistence/sqlite

//Singlenton class
class NeedDataManager {
  static final NeedDataManager _instance = NeedDataManager._internal();
  static const String dbName = "needData.db";
  static const String tableName = "need";
  late final Database _db;
  bool _isOpen = false;

  // using a factory is important
  // because it promises to return _an_ object of this type
  // but it doesn't promise to make a new one.
  factory NeedDataManager() {
    return _instance;
  }

  // This named constructor is the "real" constructor
  // It'll be called exactly once, by the static property assignment above
  // it's also private, so it can only be called in this class
  NeedDataManager._internal() {}

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
            'CREATE TABLE $tableName(id INTEGER PRIMARY KEY,postDate TEXT,title TEXT, priority INTEGER, category TEXT,address TEXT,creator TEXT)');
      },
      version: 1,
    );
    _isOpen = true;
  }

  Future<void> insertReport(Report rep) async {
    if (!_isOpen) {
      open();
    }

    await _db.insert(
      tableName,
      rep.toDb(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updateReport(Report rep) async {
    if (!_isOpen) {
      open();
    }

    await _db.update(
      tableName,
      rep.toDb(),
      where: 'id = ?',
      whereArgs: [rep.id],
    );
  }

  Future<void> deleteReport(Report rep) async {
    if (!_isOpen) {
      open();
    }

    await _db.delete(
      tableName,
      where: 'id = ?',
      whereArgs: [rep.id],
    );
  }

  Future<List<Report>> getReport() async {
    // Get a reference to the database.
    if (!_isOpen) {
      open();
    }

    final List<Map<String, dynamic>> res = await _db.query(tableName);
    return List.generate(res.length, (i) {
      return Report.fromDB(res[i]);
    });
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
