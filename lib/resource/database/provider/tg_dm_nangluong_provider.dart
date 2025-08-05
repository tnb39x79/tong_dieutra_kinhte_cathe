import 'dart:developer' as developer;
 
import 'package:gov_statistics_investigation_economic/resource/database/table/filed_common.dart';
import 'package:gov_statistics_investigation_economic/resource/database/table/table_tg_dm_nangluong.dart'; 
 
import 'package:sqflite/sqflite.dart';
import 'package:gov_statistics_investigation_economic/common/common.dart';

import 'package:gov_statistics_investigation_economic/common/utils/utils.dart';
import 'package:gov_statistics_investigation_economic/resource/database/database_helper.dart';
import 'package:gov_statistics_investigation_economic/resource/database/provider/provider.dart';

class TGDmNangLuongProvider extends BaseDBProvider<TableTGDmNangLuong> {
  static final TGDmNangLuongProvider _singleton =
      TGDmNangLuongProvider._internal();

  factory TGDmNangLuongProvider() {
    return _singleton;
  }

  Database? db;

  TGDmNangLuongProvider._internal();

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
  Future<List<int>> insert(List<TableTGDmNangLuong> value, String createdAt) async {
    try {
      await db!.delete(tableTGDmNangLuong);
    } catch (e) {
      developer.log(e.toString());
    }
    List<int> ids = [];
    for (var element in value) { 
      ids.add(await db!.insert(tableTGDmNangLuong, element.toJson()));
    }
    return ids;
  }

  @override
  Future onCreateTable(Database database) async {
    return database.execute('''
      CREATE TABLE IF NOT EXISTS $tableTGDmNangLuong
      (
        $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
        $columnMa TEXT,
        $columnTen TEXT ,
         $columnTGDmNangLuongGhiRo INTEGER
      )
      ''');
  }

  @override
  Future<List<Map>> selectAll() async { 
    return await db!.query(tableTGDmNangLuong);
  }

  @override
  Future<Map> selectOne(int id) {
    // TODO: implement selectOne
    throw UnimplementedError();
  }

  @override
  Future update(TableTGDmNangLuong value, String id) {
    // TODO: implement update
    throw UnimplementedError();
  }

  @override
  Future deletedTable(Database database) async {
    try {
      return await database.rawQuery('DROP TABLE IF EXISTS $tableTGDmNangLuong');
    } catch (e) {
      return null;
    }
  }
}
