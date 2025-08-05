import 'dart:developer';

import 'package:gov_statistics_investigation_economic/common/utils/app_pref.dart';
import 'package:gov_statistics_investigation_economic/resource/database/database_helper.dart';
import 'package:gov_statistics_investigation_economic/resource/database/provider/base_db_provider.dart';
import 'package:gov_statistics_investigation_economic/resource/database/table/filed_common.dart';
import 'package:gov_statistics_investigation_economic/resource/database/table/table_p07mau.dart';
import 'package:sqflite/sqflite.dart';

class PhieuMauProvider extends BaseDBProvider<TablePhieuMau> {
  static final PhieuMauProvider _singleton = PhieuMauProvider._internal();

  factory PhieuMauProvider() {
    return _singleton;
  }

  Database? db;

  PhieuMauProvider._internal();

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
  Future<List<int>> insert(List<TablePhieuMau> value, String createdAt) async {
    List<int> ids = [];
    for (var element in value) {
      element.createdAt = createdAt;
      //   element.updatedAt = createdAt;
      element.maDTV = AppPref.uid;
      ids.add(await db!.insert(tablePhieuMau, element.toJson()));
    }
    return ids;
  }

  @override
  Future onCreateTable(Database database) {
    return database.execute('''
    CREATE TABLE IF NOT EXISTS $tablePhieuMau
      (
        $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
        $columnMaPhieu  INTEGER,
        $columnIDCoSo  TEXT,
        $columnMaTinh  TEXT,
        $columnMaHuyen  TEXT,
        $columnMaXa  TEXT,
        $columnMaDiaBan  TEXT,
        $columnPhieuMauA1_1 TEXT,
        $columnPhieuMauA1_2 TEXT,
        $columnPhieuMauA1_3 INTEGER,
        $columnPhieuMauA1_3GhiRo TEXT,
        $columnPhieuMauA1_4 INTEGER,
        $columnPhieuMauA1_5_1 TEXT,
        $columnPhieuMauA1_5_2 INTEGER,
        $columnPhieuMauA1_5_3 INTEGER,
        $columnPhieuMauA1_5_4 TEXT,
        $columnPhieuMauA1_5_5 INTEGER,
        $columnPhieuMauA1_5_6 INTEGER,
        $columnPhieuMauA1_6 INTEGER,
        $columnPhieuMauA1_7 INTEGER,
        $columnPhieuMauA1_7_1 TEXT,
        $columnPhieuMauA2_1 INTEGER,
        $columnPhieuMauA2_1_1 INTEGER,
        $columnPhieuMauA2_1_2 INTEGER,
        $columnPhieuMauA2_1_3 INTEGER,
        $columnPhieuMauA2_2_1_1 INTEGER,
        $columnPhieuMauA2_2_1_2 INTEGER,
        $columnPhieuMauA2_2_2_1 INTEGER,
        $columnPhieuMauA2_2_2_2 INTEGER,
        $columnPhieuMauA2_2_3_1 INTEGER,
        $columnPhieuMauA2_2_3_2 INTEGER,
        $columnPhieuMauA2_2_4_1 INTEGER,
        $columnPhieuMauA2_2_4_2 INTEGER,
        $columnPhieuMauA2_2_5_1 INTEGER,
        $columnPhieuMauA2_2_5_2 INTEGER,
        $columnPhieuMauA2_2_6_1 INTEGER,
        $columnPhieuMauA2_2_6_2 INTEGER,
        $columnPhieuMauA2_2_7_1 INTEGER,
        $columnPhieuMauA2_2_7_2 INTEGER,
        $columnPhieuMauA2_2_8_1 INTEGER,
        $columnPhieuMauA2_2_8_2 INTEGER,
        $columnPhieuMauA2_2_9_1 INTEGER,
        $columnPhieuMauA2_2_9_2 INTEGER,
        $columnPhieuMauA2_2_10_1 INTEGER,
        $columnPhieuMauA2_2_10_2 INTEGER,
        $columnPhieuMauA2_3_1_1 INTEGER,
        $columnPhieuMauA2_3_1_2 INTEGER,
        $columnPhieuMauA2_3_2_1 INTEGER,
        $columnPhieuMauA2_3_2_2 INTEGER,
        $columnPhieuMauA2_3_3_1 INTEGER,
        $columnPhieuMauA2_3_3_2 INTEGER,
        $columnPhieuMauA2_3_4_1 INTEGER,
        $columnPhieuMauA2_3_4_2 INTEGER,
        $columnPhieuMauA2_3_5_1 INTEGER,
        $columnPhieuMauA2_3_5_2 INTEGER,
        $columnPhieuMauA2_3_6_1 INTEGER,
        $columnPhieuMauA2_3_6_2 INTEGER,
        $columnPhieuMauA3_1_1 REAL,
        $columnPhieuMauA3_1_2 REAL,
        $columnPhieuMauA3_2_1_1 REAL,
        $columnPhieuMauA3_2_1_2 REAL,
        $columnPhieuMauA3_2_2_1 REAL,
        $columnPhieuMauA3_2_2_2 REAL,
        $columnPhieuMauA3_2_3_1 REAL,
        $columnPhieuMauA3_2_3_2 REAL,
        $columnPhieuMauA3_2_4_1 REAL,
        $columnPhieuMauA3_2_4_2 REAL,
        $columnPhieuMauA3_2_0 REAL,
        $columnPhieuMauA3_3 REAL,
        $columnPhieuMauA3_0 REAL,
        $columnPhieuMauA3_3_1 REAL,
        $columnPhieuMauA4_1 INTEGER,
        $columnPhieuMauA4_2 REAL,
        $columnPhieuMauA4_0 REAL,
        $columnPhieuMauA4_3 INTEGER,
        $columnPhieuMauA4_4 TEXT,
        $columnPhieuMauA4_4_1 REAL,
        $columnPhieuMauA4_4_2 REAL,
        $columnPhieuMauA4_5_1_1 INTEGER,
        $columnPhieuMauA4_5_1_2 REAL,
        $columnPhieuMauA4_5_2_1 INTEGER,
        $columnPhieuMauA4_5_2_2 REAL,
        $columnPhieuMauA4_5_3_1 INTEGER,
        $columnPhieuMauA4_5_3_2 REAL,
        $columnPhieuMauA4_5_4_1 INTEGER,
        $columnPhieuMauA4_5_4_2 REAL,
        $columnPhieuMauA4_6 REAL,
        $columnPhieuMauA4_7_0 REAL,
        $columnPhieuMauA4_7_1_1 INTEGER,
        $columnPhieuMauA4_7_1_2 REAL,
        $columnPhieuMauA4_7_2_1 INTEGER,
        $columnPhieuMauA4_7_2_2 REAL,
        $columnPhieuMauA4_7_3_1 INTEGER,
        $columnPhieuMauA4_7_3_2 REAL,
        $columnPhieuMauA4_7_4_1 INTEGER,
        $columnPhieuMauA4_7_4_2 REAL,
        $columnPhieuMauA4_7_5_1 INTEGER,
        $columnPhieuMauA4_7_5_2 REAL,
        $columnPhieuMauA4_7_6_1 INTEGER,
        $columnPhieuMauA4_7_6_2 REAL,
        $columnPhieuMauA4_7_7_1 INTEGER,
        $columnPhieuMauA4_7_7_2 REAL,
        $columnPhieuMauA4_7_8_1 INTEGER,
        $columnPhieuMauA4_7_8_2 REAL,
        $columnPhieuMauA5_7 REAL,
        $columnPhieuMauA6_2_1 REAL,
        $columnPhieuMauA6_2_2 REAL,
        $columnPhieuMauA6_3 INTEGER,
        $columnPhieuMauA6_4 INTEGER,
        $columnPhieuMauA6_5 REAL,
        $columnPhieuMauA6_6 INTEGER,
        $columnPhieuMauA6_7 REAL,
        $columnPhieuMauA6_9_1 INTEGER,
        $columnPhieuMauA6_9_2 INTEGER,
        $columnPhieuMauA6_10 INTEGER,
        $columnPhieuMauA6_11 REAL,
        $columnPhieuMauA6_12 REAL,
        $columnPhieuMauA6_13 REAL,
        $columnPhieuMauA6_14 REAL,
        $columnPhieuMauA7_1_1_0 INTEGER,
        $columnPhieuMauA7_1_1_1 INTEGER,
        $columnPhieuMauA7_1_1_2 INTEGER,
        $columnPhieuMauA7_1_1_3 INTEGER,
        $columnPhieuMauA7_1_1_4 INTEGER,
        $columnPhieuMauA7_1_1_5 INTEGER,
        $columnPhieuMauA7_1_2_0 INTEGER,
        $columnPhieuMauA7_1_2_1 INTEGER,
        $columnPhieuMauA7_1_2_2 INTEGER,
        $columnPhieuMauA7_1_2_3 INTEGER,
        $columnPhieuMauA7_1_2_4 INTEGER,
        $columnPhieuMauA7_1_2_5 INTEGER,
        $columnPhieuMauA7_1_3_0 INTEGER,
        $columnPhieuMauA7_1_3_1 INTEGER,
        $columnPhieuMauA7_1_3_2 INTEGER,
        $columnPhieuMauA7_1_3_3 INTEGER,
        $columnPhieuMauA7_1_3_4 INTEGER,
        $columnPhieuMauA7_1_3_5 INTEGER,
        $columnPhieuMauA7_1_4_0 INTEGER,
        $columnPhieuMauA7_1_4_1 INTEGER,
        $columnPhieuMauA7_1_4_2 INTEGER,
        $columnPhieuMauA7_1_4_3 INTEGER,
        $columnPhieuMauA7_1_4_4 INTEGER,
        $columnPhieuMauA7_1_4_5 INTEGER,
        $columnPhieuMauA7_1_5_0 INTEGER,
        $columnPhieuMauA7_1_5_1 INTEGER,
        $columnPhieuMauA7_1_5_2 INTEGER,
        $columnPhieuMauA7_1_5_3 INTEGER,
        $columnPhieuMauA7_1_5_4 INTEGER,
        $columnPhieuMauA7_1_5_5 INTEGER,
        $columnPhieuMauA7_1_5GhiRo TEXT,
        $columnPhieuMauA7_2 INTEGER,
        $columnPhieuMauA7_2_1 INTEGER,
        $columnPhieuMauA7_3 REAL,
        $columnPhieuMauA7_4 INTEGER,
        $columnPhieuMauA7_4_1 INTEGER,
        $columnPhieuMauA7_5 REAL,
        $columnPhieuMauA7_6 INTEGER,
        $columnPhieuMauA7_6_1 INTEGER,
        $columnPhieuMauA7_7 INTEGER,
        $columnPhieuMauA7_7_1 INTEGER,
        $columnPhieuMauA7_8 INTEGER,
        $columnPhieuMauA7_8_1 INTEGER,
        $columnPhieuMauA7_9 REAL,
        $columnPhieuMauA7_10 REAL,
        $columnPhieuMauA7_11 REAL,
        $columnPhieuMauA7_12 REAL,
        $columnPhieuMauA7_13 REAL,
        $columnPhieuMauA8_1_1_1 INTEGER,
        $columnPhieuMauA8_1_1_2 REAL,
        $columnPhieuMauA8_1_1_3 REAL,
        $columnPhieuMauA8_1_1_1_1 INTEGER,
        $columnPhieuMauA8_1_1_1_2 REAL,
        $columnPhieuMauA8_1_1_1_3 REAL,
        $columnPhieuMauA8_1_1_2_1 INTEGER,
        $columnPhieuMauA8_1_1_2_2 REAL,
        $columnPhieuMauA8_1_1_2_3 REAL,
        $columnPhieuMauA8_1_1_3_1 INTEGER,
        $columnPhieuMauA8_1_1_3_2 REAL,
        $columnPhieuMauA8_1_1_3_3 REAL,
        $columnPhieuMauA8_1_1_4_1 INTEGER,
        $columnPhieuMauA8_1_1_4_2 REAL,
        $columnPhieuMauA8_1_1_4_3 REAL,
        $columnPhieuMauA8_1_2_1 INTEGER,
        $columnPhieuMauA8_1_2_2 REAL,
        $columnPhieuMauA8_1_2_3 REAL,
        $columnPhieuMauA8_1_3_1 INTEGER,
        $columnPhieuMauA8_1_3_2 REAL,
        $columnPhieuMauA8_1_3_3 REAL,
        $columnPhieuMauA8_1_3_1_1 INTEGER,
        $columnPhieuMauA8_1_3_1_2 REAL,
        $columnPhieuMauA8_1_3_1_3 REAL,
        $columnPhieuMauA8_1_4_1 INTEGER,
        $columnPhieuMauA8_1_4_2 REAL,
        $columnPhieuMauA8_1_4_3 REAL,
        $columnPhieuMauA8_1_5_1 INTEGER,
        $columnPhieuMauA8_1_5_2 REAL,
        $columnPhieuMauA8_1_5_3 REAL,
        $columnPhieuMauA8_1_5_1_1 INTEGER,
        $columnPhieuMauA8_1_5_1_2 REAL,
        $columnPhieuMauA8_1_5_1_3 REAL,
        $columnPhieuMauA8_1_6_1 INTEGER,
        $columnPhieuMauA8_1_6_2 REAL,
        $columnPhieuMauA8_1_6_3 REAL,
        $columnPhieuMauA8_1_7_1 INTEGER,
        $columnPhieuMauA8_1_7_2 REAL,
        $columnPhieuMauA8_1_7_3 REAL,
        $columnPhieuMauA8_1_8_1 INTEGER,
        $columnPhieuMauA8_1_8_2 REAL,
        $columnPhieuMauA8_1_8_3 REAL,
        $columnPhieuMauA8_1_9_1 INTEGER,
        $columnPhieuMauA8_1_9_2 REAL,
        $columnPhieuMauA8_1_9_3 REAL,
        $columnPhieuMauA8_1_10_1 INTEGER,
        $columnPhieuMauA8_1_10_2 REAL,
        $columnPhieuMauA8_1_10_3 REAL,
        $columnPhieuMauA8_1_11_1 INTEGER,
        $columnPhieuMauA8_1_11_2 REAL,
        $columnPhieuMauA8_1_11_3 REAL,
        $columnPhieuMauA9_1 INTEGER,
        $columnPhieuMauA9_2 INTEGER,
        $columnPhieuMauA9_3 INTEGER,
        $columnPhieuMauA9_4_1 INTEGER,
        $columnPhieuMauA9_4_2 INTEGER,
        $columnPhieuMauA9_4_3 INTEGER,
        $columnPhieuMauA9_4_4 INTEGER,
        $columnPhieuMauA9_4_5 INTEGER,
        $columnPhieuMauA9_5 REAL,
        $columnPhieuMauA9_6 REAL,
        $columnPhieuMauA9_7 INTEGER,
        $columnPhieuMauA9_7_1 REAL,
        $columnPhieuMauA9_8 REAL,
        $columnPhieuMauA9_9 INTEGER,
        $columnPhieuMauA9_10 REAL,
                
        $columnMaDTV  TEXT,
        $columnKinhDo  REAL,
        $columnViDo  REAL,
        $columnNguoiTraLoi  TEXT,
        $columnSoDienThoai  TEXT,
        $columnHoTenDTV  TEXT,
        $columnSoDienThoaiDTV  TEXT,
        $columnThoiGianBD  TEXT,
        $columnThoiGianKT  TEXT,
        $columnCreatedAt  TEXT,
        $columnUpdatedAt  TEXT

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
  Future update(TablePhieuMau value, String id) async {
    String createAt = AppPref.dateTimeSaveDB!;
    String updatedAt = DateTime.now().toIso8601String();
    value.updatedAt = updatedAt;
    await db!.update(tablePhieuMau, value.toJson(), where: '''
      $columnCreatedAt = '$createAt' AND $columnId = '$id' 
      AND $columnMaDTV= '${AppPref.uid}'
    ''');
  }

  Future updateById(String fieldName, value, int id) async {
    Map<String, Object?> values = {
      fieldName: value,
      columnUpdatedAt: DateTime.now().toIso8601String(),
    };
    var i = await db!
        .update(tablePhieuMau, values, where: '$columnId = ?', whereArgs: [id]);

    log('UPDATE PHIEU 04: $i');
  }

  Future updateValue(String fieldName, value, idCoSo) async {
    String createAt = AppPref.dateTimeSaveDB!;
    Map<String, Object?> values = {
      fieldName: value,
      columnUpdatedAt: DateTime.now().toIso8601String(),
    };
    var i = await db!.update(tablePhieuMau, values,
        where:
            '''$columnIDCoSo = '$idCoSo' AND $columnMaDTV = '${AppPref.uid}' AND  $columnCreatedAt = '$createAt'
            ''');

    log('UPDATE PHIEU 04: $i');
  }

  ///update multi field
  Future updateValuesMultiFields(fieldName, value, String idCoSo,
      {Map<String, Object?>? multiValue}) async {
    String createdAt = AppPref.dateTimeSaveDB ?? "";
    if (multiValue != null) {
      multiValue['UpdatedAt'] = DateTime.now().toIso8601String();
      await db!.update(tablePhieuMau, multiValue,
          where: '$columnIDCoSo= ? AND $columnCreatedAt = ? ',
          whereArgs: [idCoSo, createdAt]);
    } else {
      Map<String, Object?> values = {
        fieldName: value,
        "UpdatedAt": DateTime.now().toIso8601String()
      };
      await db!.update(tablePhieuMau, values,
          where: '$columnIDCoSo= ? AND $columnCreatedAt = ? ',
          whereArgs: [idCoSo, createdAt]);
    }
  }

  Future<Map> selectByIdCoSo(String idCoso) async {
    String createdAt = AppPref.dateTimeSaveDB!;

    List<Map> map = await db!.rawQuery('''
          SELECT * FROM $tablePhieuMau 
          WHERE $columnIDCoSo = '$idCoso' 
          AND $columnCreatedAt = '$createdAt'
        ''');
    return map.isNotEmpty ? map[0] : {};
  }

  Future<bool> isExistQuestion(String idCoso) async {
    String createdAt = AppPref.dateTimeSaveDB!;
    List<Map> map = await db!.query(tablePhieuMau, where: '''
      $columnCreatedAt = '$createdAt'
      AND $columnIDCoSo = '$idCoso'
    ''');
    return map.isNotEmpty;
  }

  Future<int> totalIntByMaCauHoi(String idCoso, List<String> fieldNames) async {
    int result = 0;

    String createdAt = AppPref.dateTimeSaveDB!;
    List<String> fields = [];
    for (var item in fieldNames) {
      fields.add("IFNULL($item,0)");
    }
    String sql =
        "SELECT ${fields.join('+')} as total FROM $tablePhieuMau  WHERE $columnIDCoSo = '$idCoso'   AND $columnCreatedAt = '$createdAt' AND $columnMaDTV='${AppPref.uid}'";
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
        "SELECT ${fields.join('+')} as total FROM $tablePhieuMau  WHERE $columnIDCoSo = '$idCoso'   AND $columnCreatedAt = '$createdAt' AND $columnMaDTV='${AppPref.uid}'";
    List<Map> map = await db!.rawQuery(sql);

    for (var item in map) {
      item.forEach((key, value) {
        if (value != null) {
          if (value == 0) {
            result = 0.0;
          } else {
            result = value;
          }
        }
      });
    }
    return result;
  }

  Future<double> totalSubtractDoubleByMaCauHoi(
      String idCoso, List<String> fieldNames) async {
    double result = 0.0;

    String createdAt = AppPref.dateTimeSaveDB!;
    List<String> fields = [];
    for (var item in fieldNames) {
      fields.add("IFNULL($item,0)");
    }
    String sql =
        "SELECT ${fields.join('*')} as total FROM $tablePhieuMau  WHERE $columnIDCoSo = '$idCoso'   AND $columnCreatedAt = '$createdAt' AND $columnMaDTV='${AppPref.uid}'";
    List<Map> map = await db!.rawQuery(sql);

    for (var item in map) {
      item.forEach((key, value) {
        if (value != null) {
          if (value == 0) {
            result = 0.0;
          } else {
            result = value;
          }
        }
      });
    }
    return result;
  }

  Future<int> totalSubtractIntByMaCauHoi(
      String idCoso, List<String> fieldNames) async {
    int result = 0;

    String createdAt = AppPref.dateTimeSaveDB!;
    List<String> fields = [];
    for (var item in fieldNames) {
      fields.add("IFNULL($item,0)");
    }
    String sql =
        "SELECT ${fields.join('*')} as total FROM $tablePhieuMau  WHERE $columnIDCoSo = '$idCoso'   AND $columnCreatedAt = '$createdAt' AND $columnMaDTV='${AppPref.uid}'";
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

  Future<bool> getLocation(String idCoso) async {
    String createdAt = AppPref.dateTimeSaveDB!;
    double result = 0;
    String sql =
        "SELECT $columnKinhDo,$columnViDo FROM $tablePhieuMau  WHERE $columnIDCoSo = '$idCoso'   AND $columnCreatedAt = '$createdAt' AND $columnMaDTV='${AppPref.uid}'";
    List<Map> map = await db!.rawQuery(sql);
    for (var item in map) {
      item.forEach((key, value) {
        if (value != null) {
          result = value;
        }
      });
    }
    return result > 0;
  }

  Future<bool> kiemTraPhanVIVIIValues(
      String idCoso, List<String> fieldNames) async {
    List<int> result = [];

    String createdAt = AppPref.dateTimeSaveDB!;
    List<String> fields = [];
    for (var item in fieldNames) {
      fields.add(" $item ");
    }
    String sql =
        "SELECT ${fields.join(',')}  FROM $tablePhieuMau WHERE $columnIDCoSo = '$idCoso'   AND $columnCreatedAt = '$createdAt' AND $columnMaDTV='${AppPref.uid}'";
    List<Map> map = await db!.rawQuery(sql);
    for (var item in map) {
      item.forEach((key, value) {
        if (value != null) {
          result.add(1);
        }
      });
    }
    return result.isNotEmpty;
  }

  Future<int> updateNullValues(String idCoso, List<String> fieldNames) async {
    int result = 0;

    String createdAt = AppPref.dateTimeSaveDB!;
    List<String> fields = [];
    for (var item in fieldNames) {
      fields.add(" $item = null ");
    }
    String sql =
        "UPDATE $tablePhieuMau SET ${fields.join(',')} WHERE $columnIDCoSo = '$idCoso'   AND $columnCreatedAt = '$createdAt' AND $columnMaDTV='${AppPref.uid}'";
    result = await db!.rawUpdate(sql);

    return result;
  }

  Future<int> deleteByCoSoId(String coSoId) {
    var res =
        db!.delete(tablePhieuMau, where: '''  $columnIDCoSo = '$coSoId'  ''');
    return res;
  }

  @override
  Future deletedTable(Database database) async {
    return await database.rawQuery('DROP TABLE IF EXISTS $tablePhieuMau');
  }
}
