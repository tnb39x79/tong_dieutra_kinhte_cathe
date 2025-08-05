import 'dart:developer';

import 'package:gov_statistics_investigation_economic/common/utils/app_pref.dart';
import 'package:gov_statistics_investigation_economic/resource/database/database_helper.dart';
import 'package:gov_statistics_investigation_economic/resource/database/provider/base_db_provider.dart';
import 'package:gov_statistics_investigation_economic/resource/database/table/filed_common.dart';
import 'package:gov_statistics_investigation_economic/resource/database/table/table_p07mau.dart';

import 'package:sqflite/sqflite.dart';

class PhieuMauA68Provider extends BaseDBProvider<TablePhieuMauA68> {
  static final PhieuMauA68Provider _singleton = PhieuMauA68Provider._internal();

  factory PhieuMauA68Provider() {
    return _singleton;
  }

  Database? db;

  PhieuMauA68Provider._internal();

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
      List<TablePhieuMauA68> value, String createdAt) async {
    List<int> ids = [];
    for (var element in value) {
      element.createdAt = createdAt;
      //  element.updatedAt = createdAt;
      element.maDTV = AppPref.uid;
      ids.add(await db!.insert(tablePhieuMauA68, element.toJson()));
    }
    return ids;
  }

  @override
  Future onCreateTable(Database database) {
    return database.execute('''
    CREATE TABLE IF NOT EXISTS $tablePhieuMauA68
      (
      $columnId INTEGER PRIMARY KEY AUTOINCREMENT, 
      $columnIDCoSo TEXT,
      $columnPhieuMauA68STT INTEGER, 
      $columnPhieuMauA68A6_8_0  TEXT,
      $columnPhieuMauA68A6_8_1 INTEGER,
      $columnPhieuMauA68A6_8_2 REAL,
      $columnPhieuMauA68A6_8_3 REAL,
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
  Future update(TablePhieuMauA68 value, String idCoSo) async {
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
    var i = await db!.update(tablePhieuMauA68, values,
        where: '$columnId = ?', whereArgs: [columId]);

    log('UPDATE PHIEU 04_C32: $i');
  }

  Future updateValueByIdCoso(String fieldName, value, iDCoSo, id) async {
    Map<String, Object?> values = {
      fieldName: value,
      columnUpdatedAt: DateTime.now().toIso8601String(),
    };
    var i = await db!.update(tablePhieuMauA68, values,
        where: '$columnId = ? AND $columnIDCoSo = ?', whereArgs: [id, iDCoSo]);

    log('UPDATE PHIEU 04_C32: ${i.toString()}');
  }

  Future<List<Map>> selectByIdCoso(String idCoso) async {
    String createdAt = AppPref.dateTimeSaveDB!;

    List<Map> maps = await db!.rawQuery('''
          SELECT * FROM $tablePhieuMauA68 
          WHERE $columnIDCoSo = '$idCoso' 
          AND $columnCreatedAt = '$createdAt'
        ''');
    return maps;
  }

  Future<List<Map>> selectByIdCosoSync(String idCoso) async {
    String createdAt = AppPref.dateTimeSaveDB!;

    List<Map> maps = await db!.rawQuery('''
          SELECT * FROM $tablePhieuMauA68 
          WHERE $columnIDCoSo = '$idCoso' 
          AND $columnPhieuMauA68A6_8_0 is not null
          AND $columnPhieuMauA68A6_8_1 is not null
          AND $columnPhieuMauA68A6_8_2 is not null
          AND $columnPhieuMauA68A6_8_3 is not null 
          AND $columnCreatedAt = '$createdAt' ORDER BY STT
        ''');
    return maps;
  }

  Future<int> getMaxSTTByIdCoso(String idCoso) async {
    String createdAt = AppPref.dateTimeSaveDB!;

    List<Map> map = await db!.rawQuery('''
          SELECT MAX(STT) as MaxSTT FROM $tablePhieuMauA68 
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
    List<Map> map = await db!.query(tablePhieuMauA68, where: '''
      $columnCreatedAt = '$createdAt'
      AND $columnIDCoSo = '$idCoso'
    ''');
    return map.isNotEmpty;
  }

  Future<int> getMaxSTTByIDCoso(String idCoso) async {
    String createdAt = AppPref.dateTimeSaveDB!;
    List<Map> map = await db!.rawQuery('''
          SELECT MAX(STT) as STT FROM $tablePhieuMauA68 
          WHERE $columnIDCoSo = '$idCoso' 
         
          AND $columnCreatedAt = '$createdAt'
        ''');
    return map.isNotEmpty ? map[0]['STT'] : 0;
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
        "SELECT ${fields.join('+')} as total FROM $tablePhieuMauA68  WHERE $columnIDCoSo = '$idCoso' AND $columnId=$id  AND $columnCreatedAt = '$createdAt' AND $columnMaDTV='${AppPref.uid}'";
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
        "SELECT ${fields.join(tongVsTich)} as total FROM $tablePhieuMauA68  WHERE $columnIDCoSo = '$idCoso' AND $columnId=$id  AND $columnCreatedAt = '$createdAt' AND $columnMaDTV='${AppPref.uid}'";
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
    var res = db!.delete(tablePhieuMauA68, where: '''  $columnId = '$id'  ''');
    return res;
  }
 Future<int> deleteByCoSoId(String coSoId) {
    var res = db!.delete(tablePhieuMauA68, where: '''  $columnIDCoSo = '$coSoId'  ''');
    return res;
  }


  @override
  Future deletedTable(Database database) async {
    return await database.rawQuery('DROP TABLE IF EXISTS $tablePhieuMauA68');
  }
}
