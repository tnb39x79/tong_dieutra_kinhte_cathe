import 'dart:developer';

import 'package:gov_statistics_investigation_economic/common/utils/app_pref.dart';
import 'package:gov_statistics_investigation_economic/resource/database/database_helper.dart';
import 'package:gov_statistics_investigation_economic/resource/database/provider/base_db_provider.dart';
import 'package:gov_statistics_investigation_economic/resource/database/table/filed_common.dart';
import 'package:gov_statistics_investigation_economic/resource/database/table/table_phieu_nganh_lt.dart'; 
import 'package:sqflite/sqflite.dart';

class PhieuNganhLTProvider extends BaseDBProvider<TablePhieuNganhLT> {
  static final PhieuNganhLTProvider _singleton = PhieuNganhLTProvider._internal();

  factory PhieuNganhLTProvider() {
    return _singleton;
  }

  Database? db;

  PhieuNganhLTProvider._internal();

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
      List<TablePhieuNganhLT> value, String createdAt) async {
    List<int> ids = [];
    for (var element in value) {
      element.createdAt = createdAt;
      //  element.updatedAt = createdAt;
      element.maDTV = AppPref.uid;
      ids.add(await db!.insert(tablePhieuNganhLT, element.toJson()));
    }
    return ids;
  }

  @override
  Future onCreateTable(Database database) {
    return database.execute('''
    CREATE TABLE IF NOT EXISTS $tablePhieuNganhLT
      ( 
      $colPhieuNganhLTId INTEGER PRIMARY KEY AUTOINCREMENT, 
      $columnIDCoSo TEXT, 
      $colPhieuNganhLTA1_1_1  INTEGER,
      $colPhieuNganhLTA1_1_2  INTEGER,
      $colPhieuNganhLTA1_1_3  INTEGER,
      $colPhieuNganhLTA1_1_4  INTEGER,
      $colPhieuNganhLTA1_1_5  INTEGER,
      $colPhieuNganhLTA1_1_6  INTEGER,
      $colPhieuNganhLTA1_2_1  INTEGER,
      $colPhieuNganhLTA1_2_2  INTEGER,
      $colPhieuNganhLTA1_2_3  INTEGER,
      $colPhieuNganhLTA1_2_4  INTEGER,
      $colPhieuNganhLTA1_2_5  INTEGER,
      $colPhieuNganhLTA1_2_6  INTEGER,
      $colPhieuNganhLTA1_3_1  INTEGER,
      $colPhieuNganhLTA1_3_2  INTEGER,
      $colPhieuNganhLTA1_3_3  INTEGER,
      $colPhieuNganhLTA1_3_4  INTEGER,
      $colPhieuNganhLTA1_3_5  INTEGER,
      $colPhieuNganhLTA1_3_6  INTEGER,
      $colPhieuNganhLTA1_4_1  INTEGER,
      $colPhieuNganhLTA1_4_2  INTEGER,
      $colPhieuNganhLTA1_4_3  INTEGER,
      $colPhieuNganhLTA1_4_4  INTEGER,
      $colPhieuNganhLTA1_4_5  INTEGER,
      $colPhieuNganhLTA1_4_6  INTEGER,
      $colPhieuNganhLTA1_5_1  INTEGER,
      $colPhieuNganhLTA1_5_2  INTEGER,
      $colPhieuNganhLTA1_5_3  INTEGER,
      $colPhieuNganhLTA1_5_4  INTEGER,
      $colPhieuNganhLTA1_5_5  INTEGER,
      $colPhieuNganhLTA1_5_6  INTEGER,
      $colPhieuNganhLTA1_5_GhiRo  TEXT,
      $colPhieuNganhLTA5  INTEGER,
      $colPhieuNganhLTA5_1  INTEGER,
      $colPhieuNganhLTA6  INTEGER,
      $colPhieuNganhLTA6_1  INTEGER,
      $colPhieuNganhLTA1_M  INTEGER,
      $colPhieuNganhLTA1_1_M  INTEGER,
      $colPhieuNganhLTA2_M  INTEGER,
      $colPhieuNganhLTA2_1_M  INTEGER,
      $colPhieuNganhLTA3_M  REAL,
      $colPhieuNganhLTA4_M  REAL,
      $colPhieuNganhLTA5_M  REAL,
      $colPhieuNganhLTA6_M  REAL,
      $colPhieuNganhLTA7_M  REAL,
      $colPhieuNganhLTA7_1_M  REAL,
      $colPhieuNganhLTA8_M  REAL,
      $colPhieuNganhLTA9_M  REAL,
      $colPhieuNganhLTA10_M  REAL,
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
  Future update(TablePhieuNganhLT value, String idCoSo) async {
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
    var i = await db!.update(tablePhieuNganhLT, values,
        where: '$colPhieuNganhLTId = ?  ', whereArgs: [id]);

    log('UPDATE PHIEU MAU A61: $i');
  }

    Future updateValueByIdCoSo(String fieldName, value, columId) async {
    Map<String, Object?> values = {
      fieldName: value,
      columnUpdatedAt: DateTime.now().toIso8601String(),
    };
    var i = await db!.update(tablePhieuNganhLT, values,
        where: '$columnId = ?', whereArgs: [columId]);

    log('UPDATE PHIEU 04_C32: $i');
  }

  Future updateValueByIdCoso(String fieldName, value, iDCoSo, int id) async {
    Map<String, Object?> values = {
      fieldName: value,
      columnUpdatedAt: DateTime.now().toIso8601String(),
    };
    var i = await db!.update(tablePhieuNganhLT, values,
        where: '$columnIDCoSo = ? AND $colPhieuNganhLTId = ?  ',
        whereArgs: [iDCoSo, id]);

    log('UPDATE PHIEU MAU A61: $i');
  }

  Future<int> updateNullValues(String idCoso, List<String> fieldNames) async {
    int result = 0;

    String createdAt = AppPref.dateTimeSaveDB!;
    List<String> fields = [];
    for (var item in fieldNames) {
      fields.add(" $item = null ");
    }
    String sql =
        "UPDATE $tablePhieuNganhLT SET ${fields.join(',')} WHERE $columnIDCoSo = '$idCoso'   AND $columnCreatedAt = '$createdAt' AND $columnMaDTV='${AppPref.uid}'";
    result = await db!.rawUpdate(sql);

    return result;
  }

  Future<List<Map>> selectByIdCoso(String idCoso) async {
    String createdAt = AppPref.dateTimeSaveDB!;

    List<Map> maps = await db!.rawQuery('''
          SELECT * FROM $tablePhieuNganhLT 
          WHERE $columnIDCoSo = '$idCoso' 
          AND $columnCreatedAt = '$createdAt' ORDER BY STT
        ''');
    return maps;
  }

  Future<List<Map>> selectByIdCosoSync(String idCoso) async {
    String createdAt = AppPref.dateTimeSaveDB!;

    List<Map> maps = await db!.rawQuery('''
          SELECT * FROM $tablePhieuNganhLT 
          WHERE $columnIDCoSo = '$idCoso' 
          AND $colPhieuNganhLTA1_1_1 is not null
          AND $colPhieuNganhLTA1_1_2 is not null 
          AND $columnCreatedAt = '$createdAt' ORDER BY STT
        ''');
    return maps;
  }

  Future<bool> isExistQuestion(String idCoso) async {
    String createdAt = AppPref.dateTimeSaveDB!;
    List<Map> map = await db!.query(tablePhieuNganhLT, where: '''
      $columnCreatedAt = '$createdAt'
      AND $columnIDCoSo = '$idCoso'
    ''');
    return map.isNotEmpty;
  }

  Future<int> getMaxSTTByIdCoso(String idCoso) async {
    String createdAt = AppPref.dateTimeSaveDB!;
    List<Map> map = await db!.rawQuery('''
          SELECT IFNULL(MAX(STT), 0) as MaxSTT FROM $tablePhieuNganhLT 
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
 Future<int> totalIntByMaCauHoi(
      String idCoso ,int id, List<String> fieldNames,String tongVsTich) async {
    int result = 0;

    String createdAt = AppPref.dateTimeSaveDB!;
    List<String> fields = [];
    for (var item in fieldNames) {
      fields.add("IFNULL($item,0)");
    }
    String sql =
        "SELECT ${fields.join(tongVsTich)} as total FROM $tablePhieuNganhLT  WHERE $columnIDCoSo = '$idCoso' AND $columnId=$id  AND $columnCreatedAt = '$createdAt' AND $columnMaDTV='${AppPref.uid}'";
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
      String idCoso ,int id, List<String> fieldNames) async {
    double result = 0.0;

    String createdAt = AppPref.dateTimeSaveDB!;
    List<String> fields = [];
    for (var item in fieldNames) {
      fields.add("IFNULL($item,0)");
    }
    String sql =
        "SELECT ${fields.join('+')} as total FROM $tablePhieuNganhLT  WHERE $columnIDCoSo = '$idCoso' AND $columnId=$id  AND $columnCreatedAt = '$createdAt' AND $columnMaDTV='${AppPref.uid}'";
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
    var res = db!.delete(tablePhieuNganhLT, where: '''  $columnId = '$id'  ''');
    return res;
  }
 Future<int> deleteByCoSoId(String coSoId) {
    var res = db!.delete(tablePhieuNganhLT, where: '''  $columnIDCoSo = '$coSoId'  ''');
    return res;
  }

  @override
  Future deletedTable(Database database) async {
    return await database.rawQuery('DROP TABLE IF EXISTS $tablePhieuNganhLT');
  }
}
