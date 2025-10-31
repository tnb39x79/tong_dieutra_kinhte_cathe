import 'dart:developer';

import 'package:gov_statistics_investigation_economic/common/utils/app_pref.dart';
import 'package:gov_statistics_investigation_economic/resource/database/database_helper.dart';
import 'package:gov_statistics_investigation_economic/resource/database/provider/base_db_provider.dart';
import 'package:gov_statistics_investigation_economic/resource/database/table/filed_common.dart';
import 'package:gov_statistics_investigation_economic/resource/database/table/table_phieu_nganh_tm.dart';
import 'package:gov_statistics_investigation_economic/resource/database/table/table_phieu_nganh_tm_sanpham.dart';

import 'package:sqflite/sqflite.dart';

class PhieuNganhTMProvider extends BaseDBProvider<TablePhieuNganhTM> {
  static final PhieuNganhTMProvider _singleton =
      PhieuNganhTMProvider._internal();

  factory PhieuNganhTMProvider() {
    return _singleton;
  }

  Database? db;

  PhieuNganhTMProvider._internal();

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
      List<TablePhieuNganhTM> value, String createdAt) async {
    List<int> ids = [];
    for (var element in value) {
      element.createdAt = createdAt;
      //  element.updatedAt = createdAt;
      element.maDTV = AppPref.uid;
      ids.add(await db!.insert(tablePhieuNganhTM, element.toJson()));
    }
    return ids;
  }

  Future updateGetDuLieuPV(
      List<TablePhieuNganhTM> value, String createdAt) async {
    List<int> ids = [];
    for (var element in value) {
      element.createdAt = createdAt;
      element.maDTV = AppPref.uid;
      await db!.update(tablePhieuNganhTM, element.toJsonGetDLPV(), where: '''
      $columnCreatedAt = '$createdAt' AND $colPhieuNganhTMSanPhamIDCoSo = '${element.iDCoSo}' 
      AND $columnMaDTV= '${AppPref.uid}'
    ''');
    }
  }

  @override
  Future onCreateTable(Database database) {
    return database.execute('''
    CREATE TABLE IF NOT EXISTS $tablePhieuNganhTM
      (
      $columnId INTEGER PRIMARY KEY AUTOINCREMENT, 
      $colPhieuNganhTMIDCoSo  TEXT,
      $colPhieuNganhTMA1T  REAL,
      $colPhieuNganhTMA2  INTEGER,
      $colPhieuNganhTMA3  REAL,
      $colPhieuNganhTMA3T  REAL,
      $columnMaDTV  TEXT,
      $columnCreatedAt TEXT,
      $columnUpdatedAt TEXT

      )
      ''');
  }

  @override
  Future<List<Map>> selectAll() async {
    String createdAt = AppPref.dateTimeSaveDB!;
    return await db!.query(tablePhieuNganhTM, where: '''
      $columnCreatedAt = '$createdAt'  AND $columnMaDTV = '${AppPref.uid}'
    ''');
  }

  @override
  Future<Map> selectOne(int id) {
    // TODO: implement selectOne
    throw UnimplementedError();
  }

  @override
  Future update(TablePhieuNganhTM value, String idCoSo) async {
    // String createAt = AppPref.dateTimeSaveDB!;
    // String updatedAt = DateTime.now().toIso8601String();
    // value.updatedAt = updatedAt;
    // await db!.update(tablePhieu04C32, value.toJson(), where: '''
    //   $column04C32CreatedAt = '$createAt' AND $column04C32IDCoSo = '$idCoSo'
    //   }'
    // ''');
  }

  Future updateValue(String fieldName, value, columnId) async {
    Map<String, Object?> values = {
      fieldName: value,
      columnUpdatedAt: DateTime.now().toIso8601String(),
    };
    var i = await db!.update(tablePhieuNganhTM, values,
        where: '$columnId = ?', whereArgs: [columnId]);

    log('UPDATE PHIEU 04_C32: $i');
  }

  Future updateValueByIdCoSo(String fieldName, value, iDCoSo) async {
    Map<String, Object?> values = {
      fieldName: value,
      columnUpdatedAt: DateTime.now().toIso8601String(),
    };
    var i = await db!.update(tablePhieuNganhTM, values,
        where: '$columnIDCoSo = ?', whereArgs: [iDCoSo]);

    log('UPDATE PHIEU 04_C32: ${i.toString()}');
  }

  Future<int> updateNullValues(String idCoso, List<String> fieldNames) async {
    int result = 0;

    String createdAt = AppPref.dateTimeSaveDB!;
    var updatedAt = DateTime.now().toIso8601String();
    List<String> fields = [];
    for (var item in fieldNames) {
      fields.add(" $item = null ");
    }
    String sql =
        "UPDATE $tablePhieuNganhTM SET ${fields.join(',')},$columnUpdatedAt= '$updatedAt' WHERE $columnIDCoSo = '$idCoso'   AND $columnCreatedAt = '$createdAt' AND $columnMaDTV='${AppPref.uid}'";
    result = await db!.rawUpdate(sql);

    return result;
  }

  Future<List<Map>> selectListByIdCoSo(String idCoso) async {
    String createdAt = AppPref.dateTimeSaveDB!;

    List<Map> maps = await db!.rawQuery('''
          SELECT * FROM $tablePhieuNganhTM
          WHERE $columnIDCoSo = '$idCoso'
          AND $columnCreatedAt = '$createdAt'
        ''');
    return maps;
  }

  Future<Map> selectByIdCoSo(String idCoso) async {
    String createdAt = AppPref.dateTimeSaveDB!;

    List<Map> map = await db!.rawQuery('''
          SELECT * FROM $tablePhieuNganhTM 
          WHERE $columnIDCoSo = '$idCoso' 
          AND $columnCreatedAt = '$createdAt'
        ''');
    return map.isNotEmpty ? map[0] : {};
  }

  Future<Map> selectByIdCoSoSync(String idCoso) async {
    String createdAt = AppPref.dateTimeSaveDB!;

    List<Map> map = await db!.rawQuery('''
          SELECT * FROM $tablePhieuNganhTM 
          WHERE $columnIDCoSo = '$idCoso' 
          AND $colPhieuNganhTMA1T is not null
          AND $colPhieuNganhTMA2 is not null
          AND $colPhieuNganhTMA3 is not null
          AND $colPhieuNganhTMA3T is not null 
          AND $columnCreatedAt = '$createdAt' 
        ''');
    return map.isNotEmpty ? map[0] : {};
  }

  Future<bool> isExistQuestion(String idCoso) async {
    String createdAt = AppPref.dateTimeSaveDB!;
    List<Map> map = await db!.query(tablePhieuNganhTM, where: '''
      $columnCreatedAt = '$createdAt'
      AND $columnIDCoSo = '$idCoso'
    ''');
    return map.isNotEmpty;
  }

  Future<int> totalIntByMaCauHoi(
      String idCoso, int id, List<String> fieldNames) async {
    int result = 0;

    String createdAt = AppPref.dateTimeSaveDB!;
    List<String> fields = [];
    for (var item in fieldNames) {
      fields.add("IFNULL($item,0)");
    }
    String sql =
        "SELECT ${fields.join('+')} as total FROM $tablePhieuNganhTM  WHERE $columnIDCoSo = '$idCoso' AND $columnId=$id  AND $columnCreatedAt = '$createdAt' AND $columnMaDTV='${AppPref.uid}'";
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
      String idCoso, int id, List<String> fieldNames, String tongVsTich) async {
    double result = 0.0;

    String createdAt = AppPref.dateTimeSaveDB!;
    List<String> fields = [];
    for (var item in fieldNames) {
      fields.add("IFNULL($item,0.0)");
    }
    String sql =
        "SELECT ${fields.join(tongVsTich)} as total FROM $tablePhieuNganhTM  WHERE $columnIDCoSo = '$idCoso' AND $columnId=$id  AND $columnCreatedAt = '$createdAt' AND $columnMaDTV='${AppPref.uid}'";
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

  Future<int> deleteById(int id) {
    var res = db!.delete(tablePhieuNganhTM, where: '''  $columnId = '$id'  ''');
    return res;
  }

  Future<int> deleteByCoSoId(String coSoId) {
    var res = db!
        .delete(tablePhieuNganhTM, where: '''  $columnIDCoSo = '$coSoId'  ''');
    return res;
  }

  @override
  Future deletedTable(Database database) async {
    return await database.rawQuery('DROP TABLE IF EXISTS $tablePhieuNganhTM');
  }
}
