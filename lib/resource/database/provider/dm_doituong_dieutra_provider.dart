 
import 'dart:developer' as developer;

import 'package:gov_statistics_investigation_economic/resource/database/table/filed_common.dart';
import 'package:gov_statistics_investigation_economic/resource/database/table/table_dm_doituong_dieutra.dart';
import 'package:sqflite/sqflite.dart';
import 'package:gov_statistics_investigation_economic/common/common.dart';

import 'package:gov_statistics_investigation_economic/common/utils/utils.dart';
import 'package:gov_statistics_investigation_economic/resource/database/database_helper.dart';
import 'package:gov_statistics_investigation_economic/resource/database/provider/provider.dart';

class DmDoiTuongDieuTraProvider extends BaseDBProvider<TableDoiTuongDieuTra> {
  static final DmDoiTuongDieuTraProvider _singleton =
      DmDoiTuongDieuTraProvider._internal();

  factory DmDoiTuongDieuTraProvider() {
    return _singleton;
  }

  Database? db;

  DmDoiTuongDieuTraProvider._internal();

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
      List<TableDoiTuongDieuTra> value, String createdAt) async {
    try {
      await db!.delete(tableDoiTuongDT);
    } catch (e) {
      developer.log(e.toString());
    }
    List<int> ids = [];
    for (var element in value) { 
      ids.add(await db!.insert(tableDoiTuongDT, element.toJson()));
    }
    return ids;
  }

  @override
  Future onCreateTable(Database database) async {
    return database.execute('''
      CREATE TABLE IF NOT EXISTS $tableDoiTuongDT
      (
        $columnDoiTuongDTId INTEGER PRIMARY KEY AUTOINCREMENT,
        $columnDoiTuongDTMaDoiTuongDT INTEGER,
        $columnDoiTuongDTTenDoiTuongDT TEXT, 
        $columnDoiTuongDTMoTaDoiTuongDT TEXT 
      )
      ''');
  }

  @override
  Future<List<Map>> selectAll() async {
    String createdAt = AppPref.dateTimeSaveDB!;
    return await db!.query(tableDoiTuongDT);
  }

  @override
  Future<Map> selectOne(int id) {
    // TODO: implement selectOne
    throw UnimplementedError();
  }

  @override
  Future update(TableDoiTuongDieuTra value, String id) {
    // TODO: implement update
    throw UnimplementedError();
  }

  Future<List<Map>> selectOneWithMaDT({required String maDT}) async {
    String createdAt = AppPref.dateTimeSaveDB!;
    List<Map> maps = await db!.rawQuery('''
        SELECT * FROM $tableDoiTuongDT
        WHERE $columnDoiTuongDTMaDoiTuongDT = '$maDT' 
      ''');

    return maps;
  }

  @override
  Future deletedTable(Database database) async {
    try {
      return await database.rawQuery('DROP TABLE IF EXISTS $tableDoiTuongDT');
    } catch (e) {
      return null;
    }
  }
}
