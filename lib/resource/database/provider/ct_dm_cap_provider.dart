import 'package:gov_statistics_investigation_economic/resource/database/database_helper.dart';
import 'package:gov_statistics_investigation_economic/resource/database/provider/base_db_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../table/table_ct_dm_cap.dart';

class DmCapProvider extends BaseDBProvider<TableDmCap> {
  static final DmCapProvider _singleton = DmCapProvider._internal();

  factory DmCapProvider() {
    return _singleton;
  }

  Database? db;

  DmCapProvider._internal();

  @override
  Future init() async {
    db = await DatabaseHelper.instance.database;
  }

  @override
  Future delete(int id) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future<List<int>> insert(List<TableDmCap> value, String createdAt) async {
    try {
      await db!.delete(tableDmCap);
    } catch (e) {
      //   developer.log(e.toString());
    }
    List<int> ids = [];
    for (var element in value) {
      ids.add(await db!.insert(tableDmCap, element.toJson()));
    }
    return ids;
  }

  @override
  Future onCreateTable(Database database) async {
    return database.execute('''
      CREATE TABLE IF NOT EXISTS $tableDmCap
      (
        $columnDmCapId INTEGER PRIMARY KEY AUTOINCREMENT,
        $columnDmCapMa INTEGER,
        $columnDDmCapTen TEXT 
      )
      ''');
  }

  @override
  Future<List<Map>> selectAll() async {
    return await db!.query(tableDmCap);
  }

  @override
  Future<Map> selectOne(int id) {
    // TODO: implement selectOne
    throw UnimplementedError();
  }

  @override
  Future update(TableDmCap value, String id) {
    // TODO: implement update
    throw UnimplementedError();
  }

  @override
  Future deletedTable(Database database) async {
    try {
      return await database.rawQuery('DROP TABLE IF EXISTS $tableDmCap');
    } catch (e) {
      return null;
    }
  }
}
