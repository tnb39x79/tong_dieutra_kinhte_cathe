 
import 'dart:developer' as developer;

import 'package:gov_statistics_investigation_economic/resource/database/table/filed_common.dart';
import 'package:gov_statistics_investigation_economic/resource/database/table/table_dm_tinhtranghd.dart';
import 'package:sqflite/sqflite.dart';
import 'package:gov_statistics_investigation_economic/common/common.dart';

import 'package:gov_statistics_investigation_economic/common/utils/utils.dart';
import 'package:gov_statistics_investigation_economic/resource/database/database_helper.dart';
import 'package:gov_statistics_investigation_economic/resource/database/provider/provider.dart';

class DmTinhTrangHDProvider extends BaseDBProvider<TableDmTinhTrangHD> {
  static final DmTinhTrangHDProvider _singleton =
      DmTinhTrangHDProvider._internal();

  factory DmTinhTrangHDProvider() {
    return _singleton;
  }

  Database? db;

  DmTinhTrangHDProvider._internal();

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
      List<TableDmTinhTrangHD> value, String createdAt) async {
    try {
      await db!.delete(tableDmTinhTrangHD);
    } catch (e) {
      developer.log(e.toString());
    }
    List<int> ids = [];
    for (var element in value) { 
      ids.add(await db!.insert(tableDmTinhTrangHD, element.toJson()));
    }
    return ids;
  }

  @override
  Future onCreateTable(Database database) async {
    return database.execute('''
      CREATE TABLE IF NOT EXISTS $tableDmTinhTrangHD
      (
        $columnDmTinhTrangHDId INTEGER PRIMARY KEY AUTOINCREMENT,
        $columnDmTinhTrangHDMaTinhTrang INTEGER,
        $columnDmTinhTrangHDTenTinhTrang TEXT, 
        $columnDmTinhTrangHDMaDoiTuongDT INTEGER 
      )
      ''');
  }

  @override
  Future<List<Map>> selectAll() async {
    String createdAt = AppPref.dateTimeSaveDB!;
    return await db!.query(tableDmTinhTrangHD);
  }

  @override
  Future<Map> selectOne(int id) {
    // TODO: implement selectOne
    throw UnimplementedError();
  }

  Future<List<Map>> selectByMaDoiTuongDT() async {
    String sql =
        ' SELECT * FROM $tableDmTinhTrangHD ';
    List<Map> maps = await db!.rawQuery(sql);
    return maps;
  }
 

  @override
  Future update(TableDmTinhTrangHD value, String id) {
    // TODO: implement update
    throw UnimplementedError();
  }

  @override
  Future deletedTable(Database database) async {
    try {
      return await database.rawQuery('DROP TABLE IF EXISTS $tableDmTinhTrangHD');
    } catch (e) {
      return null;
    }
  }
}
