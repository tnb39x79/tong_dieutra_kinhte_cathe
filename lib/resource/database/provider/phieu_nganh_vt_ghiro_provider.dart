import 'dart:developer';

import 'package:gov_statistics_investigation_economic/common/utils/app_pref.dart';
import 'package:gov_statistics_investigation_economic/resource/database/database_helper.dart';
import 'package:gov_statistics_investigation_economic/resource/database/provider/base_db_provider.dart';
import 'package:gov_statistics_investigation_economic/resource/database/table/filed_common.dart';
import 'package:gov_statistics_investigation_economic/resource/database/table/table_phieu_nganh_vt_ghiro.dart'; 

import 'package:sqflite/sqflite.dart';

class PhieuNganhVTGhiRoProvider extends BaseDBProvider<TablePhieuNganhVTGhiRo> {
  static final PhieuNganhVTGhiRoProvider _singleton = PhieuNganhVTGhiRoProvider._internal();

  factory PhieuNganhVTGhiRoProvider() {
    return _singleton;
  }

  Database? db;

  PhieuNganhVTGhiRoProvider._internal();

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
      List<TablePhieuNganhVTGhiRo> value, String createdAt) async {
    List<int> ids = [];
    for (var element in value) {
      element.createdAt = createdAt;
      //  element.updatedAt = createdAt;
      element.maDTV = AppPref.uid;
      ids.add(await db!.insert(tablePhieuNganhVTGhiRo, element.toJson()));
    }
    return ids;
  }

  @override
  Future onCreateTable(Database database) {
    return database.execute('''
    CREATE TABLE IF NOT EXISTS $tablePhieuNganhVTGhiRo
      (
      $columnId INTEGER PRIMARY KEY AUTOINCREMENT, 
      $colPhieuNganhVTGhiRoIDCoSo  TEXT,
      $colPhieuNganhVTGhiRoMaCauHoi  TEXT,
      $colPhieuNganhVTGhiRoSTT  INTEGER,
      $colPhieuNganhVTGhiRoCGhiRo  TEXT,
      $colPhieuNganhVTGhiRoC1  INTEGER,
      $colPhieuNganhVTGhiRoC2  INTEGER,
      $colPhieuNganhVTGhiRoC3  INTEGER,
      $colPhieuNganhVTGhiRoC4  INTEGER,
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
  Future update(TablePhieuNganhVTGhiRo value, String idCoSo) async {
    // String createAt = AppPref.dateTimeSaveDB!;
    // String updatedAt = DateTime.now().toIso8601String();
    // value.updatedAt = updatedAt;
    // await db!.update(tablePhieu04C32, value.toJson(), where: '''
    //   $column04C32CreatedAt = '$createAt' AND $column04C32IDCoSo = '$idCoSo'
    //   }'
    // ''');
  }

  Future updateValue(String fieldName, value, columId) async {
    Map<String, Object?> values = {
      fieldName: value,
      columnUpdatedAt: DateTime.now().toIso8601String(),
    };
    var i = await db!.update(tablePhieuNganhVTGhiRo, values,
        where: '$columnId = ?', whereArgs: [columId]);

    log('UPDATE PHIEU 04_C32: $i');
  }

  Future updateValueByIdCoso(String fieldName, value, iDCoSo, id) async {
    Map<String, Object?> values = {
      fieldName: value,
      columnUpdatedAt: DateTime.now().toIso8601String(),
    };
    var i = await db!.update(tablePhieuNganhVTGhiRo, values,
        where: '$columnId = ? AND $columnIDCoSo = ?', whereArgs: [id, iDCoSo]);

    log('UPDATE PHIEU 04_C32: ${i.toString()}');
  }

  Future<List<Map>> selectByIdCoso(String idCoso) async {
    String createdAt = AppPref.dateTimeSaveDB!;

    List<Map> maps = await db!.rawQuery('''
          SELECT * FROM $tablePhieuNganhVTGhiRo 
          WHERE $columnIDCoSo = '$idCoso' 
          AND $columnCreatedAt = '$createdAt'
        ''');
    return maps;
  }

  Future<List<Map>> selectByIdCosoSync(String idCoso) async {
    String createdAt = AppPref.dateTimeSaveDB!;

    List<Map> maps = await db!.rawQuery('''
          SELECT * FROM $tablePhieuNganhVTGhiRo 
          WHERE $columnIDCoSo = '$idCoso' 
          AND $colPhieuNganhVTGhiRoMaCauHoi  TEXT, is not null
          AND $colPhieuNganhVTGhiRoSTT  TEXT, is not null
          AND $colPhieuNganhVTGhiRoC1  TEXT, is not null
          AND $colPhieuNganhVTGhiRoC2  TEXT, is not null 
          AND $colPhieuNganhVTGhiRoC3  TEXT, is not null 
          AND $colPhieuNganhVTGhiRoC4  TEXT, is not null 
          AND $columnCreatedAt = '$createdAt' ORDER BY STT
        ''');
    return maps;
  }

  Future<int> getMaxSTTByIdCoso(String idCoso) async {
    String createdAt = AppPref.dateTimeSaveDB!;

    List<Map> map = await db!.rawQuery('''
          SELECT MAX($colPhieuNganhVTGhiRoSTT) as MaxSTT FROM $tablePhieuNganhVTGhiRo 
          WHERE $columnIDCoSo = '$idCoso' 
          AND $columnCreatedAt = '$createdAt'
        ''');
    if (map.isNotEmpty) {
      if (map[0] != null) {
        return map[0]['MaxSTT'] ?? 0;
      }
    }
    return 0;
    // return map.isNotEmpty ? map[0]['STT'] : 0;
  }

  Future<bool> isExistQuestion(String idCoso) async {
    String createdAt = AppPref.dateTimeSaveDB!;
    List<Map> map = await db!.query(tablePhieuNganhVTGhiRo, where: '''
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
        "SELECT ${fields.join('+')} as total FROM $tablePhieuNganhVTGhiRo  WHERE $columnIDCoSo = '$idCoso' AND $columnId=$id  AND $columnCreatedAt = '$createdAt' AND $columnMaDTV='${AppPref.uid}'";
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
      String idCoso, int id, List<String> fieldNames,String tongVsTich) async {
    double result = 0.0;

    String createdAt = AppPref.dateTimeSaveDB!;
    List<String> fields = [];
    for (var item in fieldNames) {
      fields.add("IFNULL($item,0)");
    }
    String sql =
        "SELECT ${fields.join(tongVsTich)} as total FROM $tablePhieuNganhVTGhiRo  WHERE $columnIDCoSo = '$idCoso' AND $columnId=$id  AND $columnCreatedAt = '$createdAt' AND $columnMaDTV='${AppPref.uid}'";
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
    var res = db!.delete(tablePhieuNganhVTGhiRo, where: '''  $columnId = '$id'  ''');
    return res;
  }
 Future<int> deleteByCoSoId(String coSoId) {
    var res = db!.delete(tablePhieuNganhVTGhiRo, where: '''  $columnIDCoSo = '$coSoId'  ''');
    return res;
  }


  @override
  Future deletedTable(Database database) async {
    return await database.rawQuery('DROP TABLE IF EXISTS $tablePhieuNganhVTGhiRo');
  }
}
