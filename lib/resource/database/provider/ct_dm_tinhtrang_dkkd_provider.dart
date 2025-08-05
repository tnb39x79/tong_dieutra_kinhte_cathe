import 'dart:developer' as developer;
 
import 'package:gov_statistics_investigation_economic/resource/database/table/filed_common.dart';
import 'package:gov_statistics_investigation_economic/resource/database/table/table_ct_dm_tinhtrang_dkkd.dart'; 
import 'package:sqflite/sqflite.dart'; 
import 'package:gov_statistics_investigation_economic/resource/database/database_helper.dart';
import 'package:gov_statistics_investigation_economic/resource/database/provider/provider.dart';

class CTDmTinhTrangDKKDProvider extends BaseDBProvider<TableCTDmTinhTrangDKKD> {
  static final CTDmTinhTrangDKKDProvider _singleton =
      CTDmTinhTrangDKKDProvider._internal();

  factory CTDmTinhTrangDKKDProvider() {
    return _singleton;
  }

  Database? db;

  CTDmTinhTrangDKKDProvider._internal();

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
  Future<List<int>> insert(List<TableCTDmTinhTrangDKKD> value, String createdAt) async {
    try {
      await db!.delete(tableCTDmTinhTrangDKKD);
    } catch (e) {
      developer.log(e.toString());
    }
    List<int> ids = [];
    for (var element in value) { 
      ids.add(await db!.insert(tableCTDmTinhTrangDKKD, element.toJson()));
    }
    return ids;
  }

  @override
  Future onCreateTable(Database database) async {
    return database.execute('''
      CREATE TABLE IF NOT EXISTS $tableCTDmTinhTrangDKKD
      (
        $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
        $columnMa INTEGER,
        $columnTen TEXT 
      )
      ''');
  }

  @override
  Future<List<Map>> selectAll() async { 
    return await db!.query(tableCTDmTinhTrangDKKD);
  }

  @override
  Future<Map> selectOne(int id) {
    // TODO: implement selectOne
    throw UnimplementedError();
  }

  @override
  Future update(TableCTDmTinhTrangDKKD value, String id) {
    // TODO: implement update
    throw UnimplementedError();
  }

  @override
  Future deletedTable(Database database) async {
    try {
      return await database.rawQuery('DROP TABLE IF EXISTS $tableCTDmTinhTrangDKKD');
    } catch (e) {
      return null;
    }
  }
}
