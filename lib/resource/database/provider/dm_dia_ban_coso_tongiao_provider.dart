import 'dart:developer' as developer;
import 'package:gov_statistics_investigation_economic/resource/database/table/filed_common.dart';
import 'package:gov_statistics_investigation_economic/resource/database/table/table_dm_dia_ban_coso_tongiao.dart'; 
import 'package:sqflite/sqflite.dart';
import 'package:gov_statistics_investigation_economic/common/common.dart';

import 'package:gov_statistics_investigation_economic/common/utils/utils.dart';
import 'package:gov_statistics_investigation_economic/resource/database/database_helper.dart';
import 'package:gov_statistics_investigation_economic/resource/database/provider/provider.dart';

class DiaBanCoSoTonGiaoProvider extends BaseDBProvider<TableDmDiaBanTonGiao> {
  static final DiaBanCoSoTonGiaoProvider _singleton = DiaBanCoSoTonGiaoProvider._internal();

  factory DiaBanCoSoTonGiaoProvider() {
    return _singleton;
  }

  Database? db;

  DiaBanCoSoTonGiaoProvider._internal();

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
      List<TableDmDiaBanTonGiao> value, String createdAt) async {
    try {
      await db!.delete(tableDiaBanTonGiao,
          where: '''$columnMaDTV='${AppPref.uid}' ''');
    } catch (e) {
      developer.log(e.toString());
    }
    List<int> ids = [];
    for (var element in value) {
      element.createdAt = createdAt;
   //   element.updatedAt = createdAt;
      ids.add(await db!.insert(tableDiaBanTonGiao, element.toJson()));
    }
    return ids;
  }

  @override
  Future onCreateTable(Database database) async {
    return database.execute('''
      CREATE TABLE IF NOT EXISTS $tableDiaBanTonGiao
      (
        $columnDmDiaBanTonGiaoId INTEGER PRIMARY KEY AUTOINCREMENT,  
        $columnDmDiaBanTonGiaoMaTinh TEXT,
        $columnDmDiaBanTonGiaoMaHuyen TEXT,
        $columnDmDiaBanTonGiaoMaXa TEXT,
        $columnDmDiaBanTonGiaoTenXa TEXT, 
        $columnMaDTV TEXT, 
        $columnCreatedAt TEXT,
        $columnUpdatedAt TEXT
      )
      ''');
  }

  @override
  Future<List<Map>> selectAll() async {
    String createdAt = AppPref.dateTimeSaveDB!;
    return await db!.query(tableDiaBanTonGiao, where: '''
      $columnCreatedAt = '$createdAt'
    ''');
  }

  @override
  Future<Map> selectOne(int id) {
    // TODO: implement selectOne
    throw UnimplementedError();
  }

  @override
  Future update(TableDmDiaBanTonGiao value, String id) {
    // TODO: implement update
    throw UnimplementedError();
  }

  @override
  Future deletedTable(Database database) async {
    try {
      return await database.rawQuery('DROP TABLE IF EXISTS $tableDiaBanTonGiao');
    } catch (e) {
      return null;
    }
  }
}
