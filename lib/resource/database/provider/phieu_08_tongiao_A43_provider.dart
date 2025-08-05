import 'dart:developer';

import 'package:gov_statistics_investigation_economic/common/utils/app_pref.dart';
import 'package:gov_statistics_investigation_economic/resource/database/database_helper.dart';
import 'package:gov_statistics_investigation_economic/resource/database/provider/base_db_provider.dart';
import 'package:gov_statistics_investigation_economic/resource/database/table/filed_common.dart';
import 'package:gov_statistics_investigation_economic/resource/database/table/table_phieu_08_tongiao.dart';
import 'package:gov_statistics_investigation_economic/resource/database/table/table_phieu_08_tongiao_A4_3.dart';
import 'package:sqflite/sqflite.dart';

class PhieuTonGiaoA43Provider extends BaseDBProvider<TablePhieuTonGiaoA43> {
  static final PhieuTonGiaoA43Provider _singleton = PhieuTonGiaoA43Provider._internal();

  factory PhieuTonGiaoA43Provider() {
    return _singleton;
  }

  Database? db;

  PhieuTonGiaoA43Provider._internal();

  set createdAt(String createdAt) {}

  @override
  Future delete(int id) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future init() async {
    db = await DatabaseHelper.instance.database;
  }

  @override
  Future<List<int>> insert(
      List<TablePhieuTonGiaoA43> value, String createdAt) async {
    List<int> ids = [];
    for (var element in value) {
      element.createdAt = createdAt;
      //  element.updatedAt = createdAt;
      element.maDTV = AppPref.uid;
      ids.add(await db!.insert(tablePhieuTonGiaoA43, element.toJson()));
    }
    return ids;
  }

  @override
  Future onCreateTable(Database database) {
    return database.execute('''
    CREATE TABLE IF NOT EXISTS $tablePhieuTonGiaoA43
      ( 
      $columnId INTEGER PRIMARY KEY AUTOINCREMENT, 
      $columnIDCoSo TEXT,
      $columnPhieuTonGiaoA43STT INTEGER,
      $columnPhieuTonGiaoA43A4_3_1  TEXT,
      $columnPhieuTonGiaoA43A4_3_2 TEXT,
      $columnPhieuTonGiaoA43A4_3_3 INTEGER,
      $columnPhieuTonGiaoA43A4_3_4 REAL,
      $columnPhieuTonGiaoA43A4_3_5 REAL,
      $columnMaDTV  TEXT,
      $columnCreatedAt TEXT,
      $columnUpdatedAt TEXT 
      )
      ''');
  }

  @override
  Future<List<Map>> selectAll() {
    // TODO: implement selectAll
    throw UnimplementedError();
  }

  @override
  Future<Map> selectOne(int id) {
    // TODO: implement selectOne
    throw UnimplementedError();
  }

  @override
  Future update(TablePhieuTonGiaoA43 value, String idCoSo) async {
    // String createAt = AppPref.dateTimeSaveDB!;
    // String updatedAt = DateTime.now().toIso8601String();
    // value.updatedAt = updatedAt;
    // await db!.update(tablePhieu04C8, value.toJson(), where: '''
    //   $column04C8CreatedAt = '$createAt' AND $column04C8IDCoSo = '$idCoSo'
    //   }'
    // ''');
  }

  Future updateValue(String fieldName, value, int id) async {
    Map<String, Object?> values = {
      fieldName: value,
      columnUpdatedAt: DateTime.now().toIso8601String(),
    };
    var i = await db!.update(tablePhieuTonGiaoA43, values,
        where: '$columnId = ?  ', whereArgs: [id]);

    log('UPDATE PHIEU MAU A61: $i');
  }

  Future updateValueByIdCoso(String fieldName, value, iDCoSo, int id) async {
    Map<String, Object?> values = {
      fieldName: value,
      columnUpdatedAt: DateTime.now().toIso8601String(),
    };
    var i = await db!.update(tablePhieuTonGiaoA43, values,
        where: '$columnIDCoSo = ? AND $columnId = ?  ',
        whereArgs: [iDCoSo, id]);

    log('UPDATE PHIEU MAU A61: $i');
  }

  Future<List<Map>> selectByIdCoso(String idCoso) async {
    String createdAt = AppPref.dateTimeSaveDB!;

    List<Map> maps = await db!.rawQuery('''
          SELECT * FROM $tablePhieuTonGiaoA43 
          WHERE $columnIDCoSo = '$idCoso' 
          AND $columnCreatedAt = '$createdAt' ORDER BY STT
        ''');
    return maps;
  }

  Future<List<Map>> selectByIdCoSoSync(String idCoso) async {
    String createdAt = AppPref.dateTimeSaveDB!;

    List<Map> maps = await db!.rawQuery('''
          SELECT * FROM $tablePhieuTonGiaoA43 
          WHERE $columnIDCoSo = '$idCoso' 
          AND $columnPhieuTonGiaoA43A4_3_1 is not null
          AND $columnPhieuTonGiaoA43A4_3_2 is not null
           AND $columnPhieuTonGiaoA43A4_3_3 is not null
            AND $columnPhieuTonGiaoA43A4_3_4 is not null
          AND $columnCreatedAt = '$createdAt' ORDER BY STT
        ''');
    return maps;
  }

  Future<bool> isExistQuestion(String idCoso) async {
    String createdAt = AppPref.dateTimeSaveDB!;
    List<Map> map = await db!.query(tablePhieuTonGiaoA43, where: '''
      $columnCreatedAt = '$createdAt'
      AND $columnIDCoSo = '$idCoso'
    ''');
    return map.isNotEmpty;
  }

  Future<int> getMaxSTTByIdCoso(String idCoso) async {
    String createdAt = AppPref.dateTimeSaveDB!;
    List<Map> map = await db!.rawQuery('''
          SELECT IFNULL(MAX(STT), 0) as MaxSTT FROM $tablePhieuTonGiaoA43 
          WHERE $columnIDCoSo = '$idCoso' 
        
          AND $columnCreatedAt = '$createdAt'
        ''');
    if (map.isNotEmpty) {
      if (map[0] != null) {
        return map[0]['MaxSTT'] ?? 0;
      }
    }
    return 0;
    // return map.isNotEmpty ? map[0]['MaxSTT'] : 0;
  }

  Future<int> deleteById(int id) {
    var res = db!.delete(tablePhieuTonGiaoA43, where: '''  $columnId = '$id'  ''');
    return res;
  }
 Future<int> deleteAllByIdCoSo(String idCoSo) {
    var res = db!.delete(tablePhieuTonGiaoA43, where: '''  $columnIDCoSo = '$idCoSo'  ''');
    return res;
  }
  @override
  Future deletedTable(Database database) async {
    return await database.rawQuery('DROP TABLE IF EXISTS $tablePhieuTonGiaoA43');
  }
}
