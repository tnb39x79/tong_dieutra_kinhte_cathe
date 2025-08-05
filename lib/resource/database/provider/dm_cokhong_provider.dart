import 'dart:developer' as developer;

import 'package:gov_statistics_investigation_economic/resource/database/table/filed_common.dart';
import 'package:gov_statistics_investigation_economic/resource/database/table/table_dm_cokhong.dart'; 
import 'package:sqflite/sqflite.dart'; 
import 'package:gov_statistics_investigation_economic/resource/database/database_helper.dart';
import 'package:gov_statistics_investigation_economic/resource/database/provider/provider.dart';

class DmCoKhongProvider extends BaseDBProvider<TableDmCoKhong> {
  static final DmCoKhongProvider _singleton =
      DmCoKhongProvider._internal();

  factory DmCoKhongProvider() {
    return _singleton;
  }

  Database? db;

  DmCoKhongProvider._internal();

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
  Future<List<int>> insert(
      List<TableDmCoKhong> value, String createdAt) async {
    try {
      await db!.delete(tableDmCoKhong);
    } catch (e) {
      developer.log(e.toString());
    }
    List<int> ids = [];
    for (var element in value) { 
      ids.add(await db!.insert(tableDmCoKhong, element.toJson()));
    }
    return ids;
  }

  @override
  Future onCreateTable(Database database) async {
    return database.execute('''
      CREATE TABLE IF NOT EXISTS $tableDmCoKhong
      (
        $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
        $columnMa INTEGER,
        $columnTen TEXT 
      )
      ''');
  }

  @override
  Future<List<Map>> selectAll() async { 
    return await db!.query(tableDmCoKhong);
  }

  @override
  Future<Map> selectOne(int id) {
    // TODO: implement selectOne
    throw UnimplementedError();
  }

  @override
  Future update(TableDmCoKhong value, String id) {
    // TODO: implement update
    throw UnimplementedError();
  }

  @override
  Future deletedTable(Database database) async {
    try {
      return await database.rawQuery('DROP TABLE IF EXISTS $tableDmCoKhong');
    } catch (e) {
      return null;
    }
  }
}
