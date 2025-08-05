import 'dart:developer';

import 'package:gov_statistics_investigation_economic/common/utils/app_pref.dart';
import 'package:gov_statistics_investigation_economic/resource/database/database_helper.dart';
import 'package:gov_statistics_investigation_economic/resource/database/provider/base_db_provider.dart';
import 'package:gov_statistics_investigation_economic/resource/database/table/filed_common.dart';
import 'package:gov_statistics_investigation_economic/resource/database/table/table_phieu_08_tongiao.dart';
import 'package:sqflite/sqflite.dart';

class PhieuTonGiaoProvider extends BaseDBProvider<TablePhieuTonGiao> {
  static final PhieuTonGiaoProvider _singleton =
      PhieuTonGiaoProvider._internal();

  factory PhieuTonGiaoProvider() {
    return _singleton;
  }

  Database? db;

  PhieuTonGiaoProvider._internal();

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
      List<TablePhieuTonGiao> value, String createdAt) async {
    List<int> ids = [];
    for (var element in value) {
      element.createdAt = createdAt;
      //    element.updatedAt = createdAt;
      element.maDTV = AppPref.uid;
      ids.add(await db!.insert(tablePhieuTonGiao, element.toJson()));
    }
    return ids;
  }

  @override
  Future onCreateTable(Database database) {
    return database.execute('''
    CREATE TABLE IF NOT EXISTS $tablePhieuTonGiao
      (
      $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
      $columnPhieuTonGiaoIdCoSo TEXT,
      $columnMaTinh TEXT,
      $columnMaHuyen TEXT,
      $columnMaXa TEXT,
      $columnPhieuTonGiaoMaThon TEXT,
      $columnPhieuTonGiaoA1_1 TEXT,
      $columnPhieuTonGiaoA1_2 TEXT,
      $columnPhieuTonGiaoA1_3 TEXT,
      $columnPhieuTonGiaoA1_4 TEXT,
      $columnPhieuTonGiaoA1_5_1 TEXT,
      $columnPhieuTonGiaoA1_5_2 TEXT,
      $columnPhieuTonGiaoA1_5_3 INTEGER,
      $columnPhieuTonGiaoA1_5_4 INTEGER,
      $columnPhieuTonGiaoA1_5_5 TEXT,
      $columnPhieuTonGiaoA1_5_6 INTEGER,
      $columnPhieuTonGiaoA1_5_6GhiRo TEXT,
      $columnPhieuTonGiaoA1_6 INTEGER,
      $columnPhieuTonGiaoA1_6GhiRo INTEGER,
      $columnPhieuTonGiaoA1_7 INTEGER,
      $columnPhieuTonGiaoA1_7GhiRo TEXT,
      $columnPhieuTonGiaoA1_8_1 INTEGER,
      $columnPhieuTonGiaoA1_8_2 INTEGER,
      $columnPhieuTonGiaoA1_9 INTEGER,
      $columnPhieuTonGiaoA2_1 INTEGER,
      $columnPhieuTonGiaoA2_1_1 INTEGER,
      $columnPhieuTonGiaoA2_2_01 INTEGER,
      $columnPhieuTonGiaoA2_2_02 INTEGER,
      $columnPhieuTonGiaoA2_2_03 INTEGER,
      $columnPhieuTonGiaoA2_2_04 INTEGER,
      $columnPhieuTonGiaoA2_2_05 INTEGER,
      $columnPhieuTonGiaoA2_2_06 INTEGER,
      $columnPhieuTonGiaoA2_2_07 INTEGER,
      $columnPhieuTonGiaoA2_2_08 INTEGER,
      $columnPhieuTonGiaoA2_2_09 INTEGER,
      $columnPhieuTonGiaoA2_2_10 INTEGER,
      $columnPhieuTonGiaoA2_2_11 INTEGER,
      $columnPhieuTonGiaoA2_2_12 INTEGER,
      $columnPhieuTonGiaoA2_2_13 INTEGER,
      $columnPhieuTonGiaoA2_2_14 INTEGER,
      $columnPhieuTonGiaoA2_2_15 INTEGER,
      $columnPhieuTonGiaoA2_2_16 INTEGER,
      $columnPhieuTonGiaoA2_2_17 INTEGER,
      $columnPhieuTonGiaoA2_2_18 INTEGER,
      $columnPhieuTonGiaoA2_2_19 INTEGER,
      $columnPhieuTonGiaoA2_2_20 INTEGER,
      $columnPhieuTonGiaoA2_2_21 INTEGER,
      $columnPhieuTonGiaoA3_1 REAL,
      $columnPhieuTonGiaoA3_2 REAL,
      $columnPhieuTonGiaoA3_2_1 REAL,
      $columnPhieuTonGiaoA4_1_01 REAL,
      $columnPhieuTonGiaoA4_1_02 REAL,
      $columnPhieuTonGiaoA4_1_03 REAL,
      $columnPhieuTonGiaoA4_1_04 REAL,
      $columnPhieuTonGiaoA4_1_05 REAL,
      $columnPhieuTonGiaoA4_1_06 REAL,
      $columnPhieuTonGiaoA4_1_07 REAL,
      $columnPhieuTonGiaoA4_1_07_1 REAL,
      $columnPhieuTonGiaoA4_1_07_1GhiRo TEXT,
      $columnPhieuTonGiaoA4_1_08 REAL,
      $columnPhieuTonGiaoA4_1_08_1 REAL,
      $columnPhieuTonGiaoA4_1_09 REAL,
      $columnPhieuTonGiaoA4_1_10 REAL,
      $columnPhieuTonGiaoA4_1_10GhiRo TEXT,
      $columnPhieuTonGiaoA4_2 INTEGER,
      $columnPhieuTonGiaoA5_1 INTEGER,
      $columnPhieuTonGiaoA5_2 INTEGER,
      $columnPhieuTonGiaoA5_2GhiRo TEXT,
      $columnPhieuTonGiaoA5_3_1_1 INTEGER,
      $columnPhieuTonGiaoA5_3_1_2 REAL,
      $columnPhieuTonGiaoA5_3_2_1 INTEGER,
      $columnPhieuTonGiaoA5_3_2_2 REAL,
      $columnPhieuTonGiaoA5_3_3_1 INTEGER,
      $columnPhieuTonGiaoA5_3_3_2 REAL,
      $columnPhieuTonGiaoA5_3_4_1 INTEGER,
      $columnPhieuTonGiaoA5_3_4_2 REAL,
      $columnPhieuTonGiaoA5_4 INTEGER,
      $columnPhieuTonGiaoA6_1_1_1 INTEGER,
      $columnPhieuTonGiaoA6_1_1_2 REAL,
      $columnPhieuTonGiaoA6_1_1_3 REAL,
      $columnPhieuTonGiaoA6_1_2_1 INTEGER,
      $columnPhieuTonGiaoA6_1_2_2 REAL,
      $columnPhieuTonGiaoA6_1_2_3 REAL,
      $columnPhieuTonGiaoA6_1_3_1 INTEGER,
      $columnPhieuTonGiaoA6_1_3_2 REAL,
      $columnPhieuTonGiaoA6_1_3_3 REAL,
      $columnPhieuTonGiaoA6_1_4_1 INTEGER,
      $columnPhieuTonGiaoA6_1_4_2 REAL,
      $columnPhieuTonGiaoA6_1_4_3 REAL,
      $columnPhieuTonGiaoA6_1_5_1 INTEGER,
      $columnPhieuTonGiaoA6_1_5_2 REAL,
      $columnPhieuTonGiaoA6_1_5_3 REAL,
      $columnPhieuTonGiaoA6_1_6_1 INTEGER,
      $columnPhieuTonGiaoA6_1_6_2 REAL,
      $columnPhieuTonGiaoA6_1_6_3 REAL,
      $columnPhieuTonGiaoA6_1_7_1 INTEGER,
      $columnPhieuTonGiaoA6_1_7_2 REAL,
      $columnPhieuTonGiaoA6_1_7_3 REAL,
      $columnPhieuTonGiaoA6_1_8_1 INTEGER,
      $columnPhieuTonGiaoA6_1_8_2 REAL,
      $columnPhieuTonGiaoA6_1_8_3 REAL,
      $columnPhieuTonGiaoA6_1_9_1 INTEGER,
      $columnPhieuTonGiaoA6_1_9_2 REAL,
      $columnPhieuTonGiaoA6_1_9_3 REAL,
      $columnPhieuTonGiaoA6_1_10_1 INTEGER,
      $columnPhieuTonGiaoA6_1_10_2 REAL,
      $columnPhieuTonGiaoA6_1_10_3 REAL,
      $columnPhieuTonGiaoA6_1_11_1 INTEGER,
      $columnPhieuTonGiaoA6_1_11_2 REAL,
      $columnPhieuTonGiaoA6_1_11_3 REAL,
      $columnPhieuTonGiaoA7_1 INTEGER,
      $columnPhieuTonGiaoA7_2 TEXT,
      $columnPhieuTonGiaoA7_2_1 REAL,
      $columnPhieuTonGiaoA7_2_2 REAL,

      $columnPhieuTonGiaoMaDTV TEXT,
      $columnPhieuTonGiaoKinhDo REAL,
      $columnPhieuTonGiaoViDo REAL,
      $columnPhieuTonGiaoNguoiTraLoi TEXT,
      $columnPhieuTonGiaoSoDienThoai TEXT,
      $columnPhieuTonGiaoHoTenDTV TEXT,
      $columnPhieuTonGiaoSoDienThoaiDTV TEXT,
      $columnPhieuTonGiaoThoiGianBD TEXT,
      $columnPhieuTonGiaoThoiGianKT TEXT,
      $columnPhieuTonGiaoCreatedAt TEXT,
      $columnPhieuTonGiaoUpdatedAt TEXT

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
  Future update(TablePhieuTonGiao value, String id) async {
    String createAt = AppPref.dateTimeSaveDB!;
    String updatedAt = DateTime.now().toIso8601String();
    value.updatedAt = updatedAt;
    await db!.update(tablePhieuTonGiao, value.toJson(), where: '''
      $columnCreatedAt = '$createAt' AND $columnId = '$id' 
      AND $columnMaDTV= '${AppPref.uid}'
    ''');
  }

  Future updateById(String fieldName, value, int id) async {
    Map<String, Object?> values = {
      fieldName: value,
      columnUpdatedAt: DateTime.now().toIso8601String(),
    };
    var i = await db!.update(tablePhieuTonGiao, values,
        where: '$columnId = ?', whereArgs: [id]);

    log('UPDATE PHIEU TG: $i');
  }

  Future updateValue(String fieldName, value, idCoSo) async {
    String createAt = AppPref.dateTimeSaveDB!;
    Map<String, Object?> values = {
      fieldName: value,
      columnUpdatedAt: DateTime.now().toIso8601String(),
    };
    var i = await db!.update(tablePhieuTonGiao, values,
        where:
            '''$columnIDCoSo = '$idCoSo' AND $columnMaDTV = '${AppPref.uid}'  AND  $columnCreatedAt = '$createAt'
          ''');

    log('UPDATE PHIEU TG: $i');
  }

  ///update multi field
  Future updateValuesMultiFields(fieldName, value, String idCoSo,
      {Map<String, Object?>? multiValue}) async {
    String createdAt = AppPref.dateTimeSaveDB ?? "";
    if (multiValue != null) {
      multiValue['UpdatedAt'] = DateTime.now().toIso8601String();
      await db!.update(tablePhieuTonGiao, multiValue,
          where: '$columnIDCoSo= ? AND $columnCreatedAt = ? ',
          whereArgs: [idCoSo, createdAt]);
    } else {
      Map<String, Object?> values = {
        fieldName: value,
        "UpdatedAt": DateTime.now().toIso8601String()
      };
      await db!.update(tablePhieuTonGiao, values,
          where: '$columnIDCoSo= ? AND $columnCreatedAt = ? ',
          whereArgs: [idCoSo, createdAt]);
    }
  }

  Future<int> totalIntByMaCauHoi(String idCoso, List<String> fieldNames) async {
    int result = 0;

    String createdAt = AppPref.dateTimeSaveDB!;
    List<String> fields = [];
    for (var item in fieldNames) {
      fields.add("IFNULL($item,0)");
    }
    String sql =
        "SELECT ${fields.join('+')} as total FROM $tablePhieuTonGiao  WHERE $columnIDCoSo = '$idCoso'   AND $columnCreatedAt = '$createdAt' AND $columnMaDTV='${AppPref.uid}'";
    List<Map> map = await db!.rawQuery(sql);

    for (var item in map) {
      item.forEach((key, value) {
        if (value != null) {
          result = value;
        }
      });
    }
    return result;
  }

  Future<double> totalDoubleByMaCauHoi(
      String idCoso, List<String> fieldNames) async {
    double result = 0.0;

    String createdAt = AppPref.dateTimeSaveDB!;
    List<String> fields = [];
    for (var item in fieldNames) {
      fields.add("IFNULL($item,0)");
    }
    String sql =
        "SELECT ${fields.join('+')} as total FROM $tablePhieuTonGiao  WHERE $columnIDCoSo = '$idCoso'   AND $columnCreatedAt = '$createdAt' AND $columnMaDTV='${AppPref.uid}'";
    List<Map> map = await db!.rawQuery(sql);

    for (var item in map) {
      item.forEach((key, value) {
        if (value != null) {
          result = value;
        }
      });
    }
    return result;
  }

  Future<Map> selectByIdCoSo(String idCoSo) async {
    String createdAt = AppPref.dateTimeSaveDB!;

    List<Map> map = await db!.rawQuery('''
          SELECT * FROM $tablePhieuTonGiao 
          WHERE $columnIDCoSo = '$idCoSo' 
          AND $columnCreatedAt = '$createdAt'
        ''');
    return map.isNotEmpty ? map[0] : {};
  }

  Future<bool> isExistQuestion(String idCoSo) async {
    String createdAt = AppPref.dateTimeSaveDB!;
    List<Map> map = await db!.query(tablePhieuTonGiao, where: '''
      $columnCreatedAt = '$createdAt'
      AND $columnIDCoSo = '$idCoSo'
    ''');
    return map.isNotEmpty;
  }

  Future<int> deleteByCoSoId(String coSoId) {
    var res = db!
        .delete(tablePhieuTonGiao, where: '''  $columnIDCoSo = '$coSoId'  ''');
    return res;
  }

  @override
  Future deletedTable(Database database) async {
    return await database.rawQuery('DROP TABLE IF EXISTS $tablePhieuTonGiao');
  }
}
