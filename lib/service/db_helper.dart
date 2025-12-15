import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';

class DbHelper {
  static Database? _db;

  static Future<Database> createDB() async {
    if (_db != null) {
      return _db!;
    }

    _db = await openDatabase(
      'Checkupdb.db',
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''CREATE TABLE user_table (
            id_user  INTEGER PRIMARY KEY AUTOINCREMENT,
            name     TEXT,
            password TEXT    UNIQUE
          );''');

        db.insert("user_table", {"name": "ahmed", "password": "123"});
        db.insert("user_table", {"name": "anas", "password": "147"});
        db.insert("user_table", {"name": "mousab", "password": "456"});

        await db.execute('''
          CREATE TABLE Sicks_table (
            id_sick INTEGER PRIMARY KEY AUTOINCREMENT,
            name    TEXT    UNIQUE,
            age     INTEGER
          );
        ''');
        await db.execute('''  
          CREATE TABLE simple_table (
              id_simple INTEGER PRIMARY KEY AUTOINCREMENT,
              name     TEXT   
          );
          ''');
        await db.insert("simple_table", {'id_simple': 1, 'name': 'دم'});
        await db.insert("simple_table", {'id_simple': 2, 'name': 'بول'});
        await db.insert("simple_table", {'id_simple': 3, 'name': 'براز'});
        await db.execute('''  
          CREATE TABLE checkup_table (
              id_check   INTEGER   PRIMARY KEY AUTOINCREMENT,
              check_type TEXT (70) NOT NULL,
              sick_id    INTEGER   REFERENCES Sicks_table (id_sick),
              simples    INTEGER   REFERENCES simple_table (id_simple),
              Date_check TEXT      NOT NULL,
              isReady    NUMERIC   DEFAULT (0)
            );
          ''');
      },
      onOpen: (db) {
        debugPrint("is open");
      },
    );
    return _db!;
  }

  static Future<List<Map>> getUseres() async {
    _db ??= await createDB();
    return _db!.query("user_table");
  }

  static Future<List<Map>> getSick() async {
    //find

    _db ??= await createDB();

    return await _db!.query("Sicks_table", orderBy: 'id_sick');
  }

  static Future<List<Map>> getSimple() async {
    //find

    _db ??= await createDB();

    return await _db!.query("simple_table", orderBy: 'id_simple');
  }

  static Future<List<Map<String, dynamic>>> getCheckup() async {
    //find

    _db ??= await createDB();

    return await _db!.rawQuery('''
      SELECT id_check, check_type, Date_check,
      sick_id, simples,
      isReady, simple_table.name as SimpleName,
      Sicks_table.name as sickest
      FROM checkup_table, simple_table, Sicks_table
      where simples = id_simple and sick_id = id_sick
      ''');

    // return await _db!.query("checkup_table");
  }

  static Future<int> updateSick({
    required int idSick,
    required String newName,
    required String newAge,
  }) async {
    _db ??= await createDB();
    return await _db!.update(
      'Sicks_table',
      {'name': newName, 'age': newAge},
      where: 'id_sick=?',
      whereArgs: [idSick],
    );
  }

  static Future<int> updateSimple({
    required int idSimple,
    required String newName,
  }) async {
    _db ??= await createDB();
    return await _db!.update(
      'simple_table',
      {'name': newName},
      where: 'id_simple=?',
      whereArgs: [idSimple],
    );
  }

  static Future<int> updateCheck({
    required int checkId,
    required String checkType,
    required int sickId,
    required int simples,
    required String dateCheck,
  }) async {
    _db ??= await createDB();

    return await _db!.update(
      'checkup_table',
      {
        'check_type': checkType,
        'sick_id': sickId,
        'simples': simples,
        'Date_check': dateCheck,
      },
      where: 'id_check=?',
      whereArgs: [checkId],
    );
  }

  static Future<int> insertSick({
    required String name,
    required String age,
  }) async {
    //create
    _db ??= await createDB();

    return await _db!.insert("Sicks_table", {'name': name, 'age': age});
  }

  static Future<int> insertSimple({required String name}) async {
    //create
    _db ??= await createDB();

    return await _db!.insert("simple_table", {'name': name});
  }

  static Future<int> insertCheck({
    required String checkType,
    required int sickId,
    required int simples,
    required int isReady,
  }) async {
    //create
    _db ??= await createDB();

    return await _db!.insert("checkup_table", {
      'check_type': checkType,
      'sick_id ': sickId,
      'simples': simples,
      'Date_check':
          "${DateTime.now().year}/${DateTime.now().month}/${DateTime.now().day}",
      'isReady': isReady,
    });
  }

  static Future<int> deleteSick(int idSick) async {
    //kill
    _db ??= await createDB();

    return await _db!.delete(
      'Sicks_table',
      where: 'id_sick=?',
      whereArgs: [idSick],
    );
  }

  static Future<int> deleteSimple(int idSimple) async {
    //kill
    _db ??= await createDB();

    return await _db!.delete(
      'simple_table',
      where: 'id_simple=?',
      whereArgs: [idSimple],
    );
  }

  static Future<int> deleteCkeck(int idCheck) async {
    //kill
    _db ??= await createDB();

    return await _db!.delete(
      'checkup_table',
      where: 'id_check=?',
      whereArgs: [idCheck],
    );
  }

  static Future<int> readyCheck({
    required int checkId,
    required int isReady,
  }) async {
    return await _db!.update(
      "checkup_table",
      {'isReady': isReady},
      where: 'id_check=?',
      whereArgs: [checkId],
    );
  }
}
