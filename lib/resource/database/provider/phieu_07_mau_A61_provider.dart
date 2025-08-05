import 'dart:developer';

import 'package:gov_statistics_investigation_economic/common/utils/app_pref.dart';
import 'package:gov_statistics_investigation_economic/resource/database/database_helper.dart';
import 'package:gov_statistics_investigation_economic/resource/database/provider/base_db_provider.dart';
import 'package:gov_statistics_investigation_economic/resource/database/table/filed_common.dart';
import 'package:gov_statistics_investigation_economic/resource/database/table/table_phieu_07_mau_A61.dart';
import 'package:sqflite/sqflite.dart';

class PhieuMauA61Provider extends BaseDBProvider<TablePhieuMauA61> {
  static final PhieuMauA61Provider _singleton = PhieuMauA61Provider._internal();

  factory PhieuMauA61Provider() {
    return _singleton;
  }

  Database? db;

  PhieuMauA61Provider._internal();

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
      List<TablePhieuMauA61> value, String createdAt) async {
    List<int> ids = [];
    for (var element in value) {
      element.createdAt = createdAt;
      //  element.updatedAt = createdAt;
      element.maDTV = AppPref.uid;
      ids.add(await db!.insert(tablePhieuMauA61, element.toJson()));
    }
    return ids;
  }

  @override
  Future onCreateTable(Database database) {
    return database.execute('''
    CREATE TABLE IF NOT EXISTS $tablePhieuMauA61
      ( 
      $columnPhieuMauA61Id INTEGER PRIMARY KEY AUTOINCREMENT, 
      $columnIDCoSo TEXT,
      $columnPhieuMauA61STT INTEGER,
      $columnPhieuMauA61A6_1_0  TEXT,
      $columnPhieuMauA61A6_1_1 INTEGER,
      $columnPhieuMauA61A6_1_2 INTEGER,
      $columnPhieuMauA61A6_1_3 INTEGER,
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
  Future update(TablePhieuMauA61 value, String idCoSo) async {
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
    var i = await db!.update(tablePhieuMauA61, values,
        where: '$columnPhieuMauA61Id = ?  ', whereArgs: [id]);

    log('UPDATE PHIEU MAU A61: $i');
  }

  Future updateValueByIdCoso(String fieldName, value, iDCoSo, int id) async {
    Map<String, Object?> values = {
      fieldName: value,
      columnUpdatedAt: DateTime.now().toIso8601String(),
    };
    var i = await db!.update(tablePhieuMauA61, values,
        where: '$columnIDCoSo = ? AND $columnPhieuMauA61Id = ?  ',
        whereArgs: [iDCoSo, id]);

    log('UPDATE PHIEU MAU A61: $i');
  }

  Future<List<Map>> selectByIdCoso(String idCoso) async {
    String createdAt = AppPref.dateTimeSaveDB!;

    List<Map> maps = await db!.rawQuery('''
          SELECT * FROM $tablePhieuMauA61 
          WHERE $columnIDCoSo = '$idCoso' 
          AND $columnCreatedAt = '$createdAt' ORDER BY STT
        ''');
    return maps;
  }

  Future<List<Map>> selectByIdCosoSync(String idCoso) async {
    String createdAt = AppPref.dateTimeSaveDB!;

    List<Map> maps = await db!.rawQuery('''
          SELECT * FROM $tablePhieuMauA61 
          WHERE $columnIDCoSo = '$idCoso' 
          AND $columnPhieuMauA61A6_1_0 is not null
          AND $columnPhieuMauA61A6_1_1 is not null
           AND $columnPhieuMauA61A6_1_2 is not null
            AND $columnPhieuMauA61A6_1_3 is not null
          AND $columnCreatedAt = '$createdAt' ORDER BY STT
        ''');
    return maps;
  }

  Future<bool> isExistQuestion(String idCoso) async {
    String createdAt = AppPref.dateTimeSaveDB!;
    List<Map> map = await db!.query(tablePhieuMauA61, where: '''
      $columnCreatedAt = '$createdAt'
      AND $columnIDCoSo = '$idCoso'
    ''');
    return map.isNotEmpty;
  }

  Future<int> getMaxSTTByIdCoso(String idCoso) async {
    String createdAt = AppPref.dateTimeSaveDB!;
    List<Map> map = await db!.rawQuery('''
          SELECT IFNULL(MAX(STT), 0) as MaxSTT FROM $tablePhieuMauA61 
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
        "SELECT ${fields.join(tongVsTich)} as total FROM $tablePhieuMauA61  WHERE $columnIDCoSo = '$idCoso' AND $columnId=$id  AND $columnCreatedAt = '$createdAt' AND $columnMaDTV='${AppPref.uid}'";
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
        "SELECT ${fields.join('+')} as total FROM $tablePhieuMauA61  WHERE $columnIDCoSo = '$idCoso' AND $columnId=$id  AND $columnCreatedAt = '$createdAt' AND $columnMaDTV='${AppPref.uid}'";
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
    var res = db!.delete(tablePhieuMauA61, where: '''  $columnId = '$id'  ''');
    return res;
  }
 Future<int> deleteByCoSoId(String coSoId) {
    var res = db!.delete(tablePhieuMauA61, where: '''  $columnIDCoSo = '$coSoId'  ''');
    return res;
  }

  @override
  Future deletedTable(Database database) async {
    return await database.rawQuery('DROP TABLE IF EXISTS $tablePhieuMauA61');
  }
}
