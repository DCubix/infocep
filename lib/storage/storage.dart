import 'dart:async';

import 'package:path/path.dart' as path;

import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';

class Storage {

  static final Storage _instance = Storage._();
  Storage._();
  static Storage get instance => _instance;

  Completer<Database>? _db;
  
  Future<Database> get db async {
    if (_db == null) {
      _db = Completer<Database>();
      _openDatabase();
    }
    return _db!.future;
  }

  _openDatabase() async {
    final appDocumentDir = await getApplicationDocumentsDirectory();
    final dbPath = path.join(appDocumentDir.path, 'data.db');
    final database = await databaseFactoryIo.openDatabase(dbPath, version: 20, onVersionChanged: (db, oldVersion, newVersion) {});
    _db!.complete(database);
  }

}