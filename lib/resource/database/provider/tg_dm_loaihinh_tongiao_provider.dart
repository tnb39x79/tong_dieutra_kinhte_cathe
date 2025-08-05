import 'dart:developer' as developer;
 
import 'package:gov_statistics_investigation_economic/resource/database/table/filed_common.dart';
import 'package:gov_statistics_investigation_economic/resource/database/table/table_tg_dm_loaihinh_tongiao.dart';
 
import 'package:sqflite/sqflite.dart';
import 'package:gov_statistics_investigation_economic/common/common.dart';

import 'package:gov_statistics_investigation_economic/common/utils/utils.dart';
import 'package:gov_statistics_investigation_economic/resource/database/database_helper.dart';
import 'package:gov_statistics_investigation_economic/resource/database/provider/provider.dart';

class TGDmLoaiHinhTonGiaoProvider extends BaseDBProvider<TableTGDmLoaiHinhTonGiao> {
  static final TGDmLoaiHinhTonGiaoProvider _singleton =
      TGDmLoaiHinhTonGiaoProvider._internal();

  factory TGDmLoaiHinhTonGiaoProvider() {
    return _singleton;
  }

  Database? db;

  TGDmLoaiHinhTonGiaoProvider._internal();

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
  Future<List<int>> insert(List<TableTGDmLoaiHinhTonGiao> value, String createdAt) async {
    try {
      await db!.delete(tableTGDmLoaiHinhTonGiao);
    } catch (e) {
      developer.log(e.toString());
    }
    List<int> ids = [];
    for (var element in value) { 
      ids.add(await db!.insert(tableTGDmLoaiHinhTonGiao, element.toJson()));
    }
    return ids;
  }

  @override
  Future onCreateTable(Database database) async {
    return database.execute('''
      CREATE TABLE IF NOT EXISTS $tableTGDmLoaiHinhTonGiao
      (
        $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
        $columnMa INTEGER,
        $columnTen TEXT ,
        $columnSTT INTEGER
      )
      ''');
  }

  @override
  Future<List<Map>> selectAll() async { 
    return await db!.query(tableTGDmLoaiHinhTonGiao);
  }

  @override
  Future<Map> selectOne(int id) {
    // TODO: implement selectOne
    throw UnimplementedError();
  }

  @override
  Future update(TableTGDmLoaiHinhTonGiao value, String id) {
    // TODO: implement update
    throw UnimplementedError();
  }

  @override
  Future deletedTable(Database database) async {
    try {
      return await database.rawQuery('DROP TABLE IF EXISTS $tableTGDmLoaiHinhTonGiao');
    } catch (e) {
      return null;
    }
  }
}
