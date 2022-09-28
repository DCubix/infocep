import 'package:infocep/storage/storage.dart';
import 'package:sembast/sembast.dart';

class DAO {

  late StoreRef<String, Map<String, dynamic>> _store;

  DAO(String storeName) {
    _store = stringMapStoreFactory.store(storeName);
  }

  Future<Database> get db async => await Storage.instance.db;

  insert(Map<String, dynamic> map) async {
    await _store.add(await db, map);
  }

  update(Map<String, dynamic> map, Filter filter) async {
    await _store.update(await db, map, finder: Finder(filter: filter));
  }

  insertOrUpdate(Map<String, dynamic> map, Filter filter) async {
    final val = await get(filter);
    if (val == null) {
      await insert(map);
    } else {
      await update(map, filter);
    }
  }

  delete(Filter filter) async {
    await _store.delete(await db, finder: Finder(filter: filter));
  }

  clear() async {
    await _store.delete(await db);
  }

  Future<List<Map<String, dynamic>>> query({ Finder? finder }) async {
    final records = await _store.find(await db, finder: finder);
    return records.map((snapshot) => snapshot.value).toList();
  }

  Future<Map<String, dynamic>?> get(Filter filter) async {
    final record = await _store.findFirst(await db, finder: Finder(filter: filter));
    if (record == null) return Future.value(null);
    return record.value;
  }

  StoreRef<String, Map<String, dynamic>> get store => _store;

}