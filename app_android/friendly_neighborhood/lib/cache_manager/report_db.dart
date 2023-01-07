// ignore_for_file: depend_on_referenced_packages, avoid_init_to_null
import 'package:friendly_neighborhood/model/report.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

//Documentazione: https://docs.flutter.dev/cookbook/persistence/sqlite

/*
* Classe ReportDataManager:
* La seguente classe gestisce il database locale di Report
*/
//Singlenton class
class ReportDataManager {
  static final ReportDataManager _instance = ReportDataManager._internal();
  static const String dbName = "reportData.db";
  static const String tableName = "report";
  Database? _db = null;
  bool _isOpen = false;

  //factory constructor
  factory ReportDataManager() {
    return _instance;
  }

  ReportDataManager._internal() {
    open();
  }

/*
* funzione close
* La funzione serve per chiudere il database
*/
  Future close() async {
    if (_db != null) {
      _db!.close();
    }
    _isOpen = false;
  }

/*
* funzione open
* La funzione serve per aprire il database
*/
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

/*
* funzione insertListOfReports
* La funzione serve per aggiungere una lista di report nel db
*/
  Future insertListOfReports(List<Report> list) async {
    for (Report r in list) {
      await insertReport(r);
    }
  }

/*
* funzione insertReport
* La funzione serve per aggiungere un report al db
*/
  Future<void> insertReport(Report rep) async {
    if (!_isOpen) {
      await open();
    }

    await _db!.insert(
      tableName,
      rep.toDb(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

/*
* funzione updateReport
* La funzione serve per aggiornare un report nel db
*/
  Future<void> updateReport(Report rep) async {
    if (!_isOpen) {
      await open();
    }

    await _db!.update(
      tableName,
      rep.toDb(),
      where: 'id = ?',
      whereArgs: [rep.id],
    );
  }

/*
* funzione deleteReport
* La funzione serve per eliminare un report nel db
*/
  Future<void> deleteReport(Report rep) async {
    if (!_isOpen) {
      await open();
    }

    await _db!.delete(
      tableName,
      where: 'id = ?',
      whereArgs: [rep.id],
    );
  }

/*
* funzione cleanDB
* La funzione svuota il db
*/
  Future<void> cleanDB() async {
    if (!_isOpen) {
      await open();
    }

    await _db!.delete(tableName);
  }

/*
* funzione getReport
* La funzione restituisce una lista di report salvati nel db
*/
  Future<List<Report>> getReport() async {
    if (!_isOpen) {
      await open();
    }

    final List<Map<String, dynamic>> res = await _db!.query(tableName);
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
