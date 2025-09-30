import 'dart:developer';

import 'package:gov_statistics_investigation_economic/common/utils/app_pref.dart';
import 'package:gov_statistics_investigation_economic/resource/database/database_helper.dart';
import 'package:gov_statistics_investigation_economic/resource/database/provider/base_db_provider.dart';
import 'package:gov_statistics_investigation_economic/resource/database/table/filed_common.dart';
import 'package:gov_statistics_investigation_economic/resource/database/table/table_p07mau.dart';
import 'package:gov_statistics_investigation_economic/resource/database/table/table_phieu_mautb.dart';
import 'package:sqflite/sqflite.dart';

class PhieuMauTBProvider extends BaseDBProvider<TablePhieuMauTB> {
  static final PhieuMauTBProvider _singleton = PhieuMauTBProvider._internal();

  factory PhieuMauTBProvider() {
    return _singleton;
  }

  Database? db;

  PhieuMauTBProvider._internal();

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
      List<TablePhieuMauTB> value, String createdAt) async {
    List<int> ids = [];
    for (var element in value) {
      element.createdAt = createdAt;
      //   element.updatedAt = createdAt;
     element.maDTV = AppPref.uid;
      ids.add(await db!.insert(tablePhieuMauTB, element.toJson()));
    }
    return ids;
  }

  @override
  Future onCreateTable(Database database) {
    return database.execute('''
    CREATE TABLE IF NOT EXISTS $tablePhieuMauTB
      (
        $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
        $colPhieuMauTBIDCoSo  TEXT,
        $colPhieuMauTBLoaiPhieu  INTEGER,
        $colPhieuMauTBMaTinh  TEXT,
        $colPhieuMauTBMaTKCS  TEXT,
        $colPhieuMauTBMaXa  TEXT,
        $colPhieuMauTBMaThon  TEXT,
        $colPhieuMauTBIDDB  TEXT,
        $colPhieuMauTBMaDiaBan  TEXT,
        $colPhieuMauTBA1_1  INTEGER,
        $colPhieuMauTBA1_1_GhiRo  TEXT,
        $colPhieuMauTBA1_2  INTEGER,
        $colPhieuMauTBA1_3_1  INTEGER,
        $colPhieuMauTBA1_3_2  INTEGER,
        $colPhieuMauTBA1_3_3  TEXT,
        $colPhieuMauTBA1_3_4  INTEGER,
        $colPhieuMauTBA1_3_5  INTEGER,
        $colPhieuMauTBA1_4  INTEGER,
        $colPhieuMauTBA1_5  INTEGER,
        $colPhieuMauTBA1_5_1  TEXT,
        $colPhieuMauTBA2_1  INTEGER,
        $colPhieuMauTBA2_1_1  INTEGER,
        $colPhieuMauTBA3_1_1_1  REAL,
        $colPhieuMauTBA3_1_1_2  REAL,
        $colPhieuMauTBA3_1_2_1  REAL,
        $colPhieuMauTBA3_1_2_2  REAL,
        $colPhieuMauTBA3_1_3_1  REAL,
        $colPhieuMauTBA3_1_3_2  REAL,
        $colPhieuMauTBA3_1_4_1  REAL,
        $colPhieuMauTBA3_1_4_2  REAL,
        $colPhieuMauTBA3_1_5_1  REAL,
        $colPhieuMauTBA3_1_5_2  REAL,
        $colPhieuMauTBA3_1T  REAL,
        $colPhieuMauTBA3_2  REAL,
        $colPhieuMauTBA3T  REAL,
        $colPhieuMauTBA3_2_1  REAL,
        $colPhieuMauTBA4_1  INTEGER,
        $colPhieuMauTBA4_2  REAL,
        $colPhieuMauTBA4T  REAL,
        $colPhieuMauTBA4_3  REAL,
        $colPhieuMauTBA5T  REAL,
        $colPhieuMauTBA6_1_1_1  INTEGER,
        $colPhieuMauTBA6_1_1_2  REAL,
        $colPhieuMauTBA6_1_1_3  REAL,
        $colPhieuMauTBA6_1_1_1_1  INTEGER,
        $colPhieuMauTBA6_1_1_1_2  REAL,
        $colPhieuMauTBA6_1_1_1_3  REAL,
        $colPhieuMauTBA6_1_1_2_1  INTEGER,
        $colPhieuMauTBA6_1_1_2_2  REAL,
        $colPhieuMauTBA6_1_1_2_3  REAL,
        $colPhieuMauTBA6_1_2_1  INTEGER,
        $colPhieuMauTBA6_1_2_2  REAL,
        $colPhieuMauTBA6_1_2_3  REAL,
        $colPhieuMauTBA6_1_3_1  INTEGER,
        $colPhieuMauTBA6_1_3_2  REAL,
        $colPhieuMauTBA6_1_3_3  REAL,
        $colPhieuMauTBA6_1_4_1  INTEGER,
        $colPhieuMauTBA6_1_4_2  REAL,
        $colPhieuMauTBA6_1_4_3  REAL,
        $colPhieuMauTBA6_1_5_1  INTEGER,
        $colPhieuMauTBA6_1_5_2  REAL,
        $colPhieuMauTBA6_1_5_3  REAL,
        $colPhieuMauTBA6_1_6_1  INTEGER,
        $colPhieuMauTBA6_1_6_2  REAL,
        $colPhieuMauTBA6_1_6_3  REAL,
        $colPhieuMauTBA6_1_6_1_1  INTEGER,
        $colPhieuMauTBA6_1_6_1_2  REAL,
        $colPhieuMauTBA6_1_6_1_3  REAL,
        $colPhieuMauTBA6_1_7_1  INTEGER,
        $colPhieuMauTBA6_1_7_2  REAL,
        $colPhieuMauTBA6_1_7_3  REAL,
        $colPhieuMauTBA6_1_7_1_1  INTEGER,
        $colPhieuMauTBA6_1_7_1_2  REAL,
        $colPhieuMauTBA6_1_7_1_3  REAL,
        $colPhieuMauTBA6_1_8_1  INTEGER,
        $colPhieuMauTBA6_1_8_2  REAL,
        $colPhieuMauTBA6_1_8_3  REAL,
        $colPhieuMauTBA6_1_9_1  INTEGER,
        $colPhieuMauTBA6_1_9_2  REAL,
        $colPhieuMauTBA6_1_9_3  REAL,
        $colPhieuMauTBA6_1_10_1  INTEGER,
        $colPhieuMauTBA6_1_10_2  REAL,
        $colPhieuMauTBA6_1_10_3  REAL,
        $colPhieuMauTBA6_1_10_1_1  INTEGER,
        $colPhieuMauTBA6_1_10_1_2  REAL,
        $colPhieuMauTBA6_1_10_1_3  REAL,
        $colPhieuMauTBA6_1_11_1  INTEGER,
        $colPhieuMauTBA6_1_11_2  REAL,
        $colPhieuMauTBA6_1_11_3  REAL,
        $colPhieuMauTBA7_1  INTEGER,
        $colPhieuMauTBA7_2  INTEGER,
        $colPhieuMauTBA7_3  REAL,
        $colPhieuMauTBA7_4_1_1  INTEGER,
        $colPhieuMauTBA7_4_1_2  REAL,
        $colPhieuMauTBA7_4_2_1  INTEGER,
        $colPhieuMauTBA7_4_2_2  REAL,
        $colPhieuMauTBA7_4_3_1  INTEGER,
        $colPhieuMauTBA7_4_3_2  REAL,
        $colPhieuMauTBA7_4_4_1  INTEGER,
        $colPhieuMauTBA7_4_4_2  REAL,
        $colPhieuMauTBA7_3_M  INTEGER,
        $colPhieuMauTBA7_4_M  REAL,
        $colPhieuMauTBA7_5_M  INTEGER,
        $colPhieuMauTBA7_6_M  REAL,
        $colPhieuMauTBA7_7_M  INTEGER,
        $colPhieuMauTBA7_8_M  REAL,
        $colPhieuMauTBA9_M  INTEGER,
        $colPhieuMauTBA10_M  TEXT,
        $colPhieuMauTBA10_1_M  REAL,
        $colPhieuMauTBA10_2_M  REAL,
        $columnMaDTV  TEXT,
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
  Future update(TablePhieuMauTB value, String id) async {
    String createAt = AppPref.dateTimeSaveDB!;
    String updatedAt = DateTime.now().toIso8601String();
    value.updatedAt = updatedAt;
    await db!.update(tablePhieuMauTB, value.toJson(), where: '''
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
        .update(tablePhieuMauTB, values, where: '$columnId = ?', whereArgs: [id]);

    log('UPDATE PHIEU 04: $i');
  }

  Future updateValue(String fieldName, value, idCoSo) async {
    String createAt = AppPref.dateTimeSaveDB!;
    Map<String, Object?> values = {
      fieldName: value,
      columnUpdatedAt: DateTime.now().toIso8601String(),
    };
    var i = await db!.update(tablePhieuMauTB, values,
        where:
            '''$columnIDCoSo = '$idCoSo' AND $columnMaDTV = '${AppPref.uid}' AND  $columnCreatedAt = '$createAt'
            ''');

    log('UPDATE PHIEU 04: $i');
  }
  Future updateValueByIdCoSo(String fieldName, value, idCoSo) async {
    String createAt = AppPref.dateTimeSaveDB!;
    Map<String, Object?> values = {
      fieldName: value,
      columnUpdatedAt: DateTime.now().toIso8601String(),
    };
    var i = await db!.update(tablePhieuMauTB, values,
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
      await db!.update(tablePhieuMauTB, multiValue,
          where: '$columnIDCoSo= ? AND $columnCreatedAt = ? ',
          whereArgs: [idCoSo, createdAt]);
    } else {
      Map<String, Object?> values = {
        fieldName: value,
        "UpdatedAt": DateTime.now().toIso8601String()
      };
      await db!.update(tablePhieuMauTB, values,
          where: '$columnIDCoSo= ? AND $columnCreatedAt = ? ',
          whereArgs: [idCoSo, createdAt]);
    }
  }

 
  Future updateMultiValues(String idCoSo,
      {Map<String, Object?>? multiValue}) async {
    String createdAt = AppPref.dateTimeSaveDB ?? "";
    if (multiValue != null) {
      multiValue['UpdatedAt'] = DateTime.now().toIso8601String();
      await db!.update(tablePhieuMauTB, multiValue,
          where: '$columnIDCoSo= ? AND $columnCreatedAt = ? ',
          whereArgs: [idCoSo, createdAt]);
    }
  }

  Future<Map> selectByIdCoSo(String idCoso) async {
    String createdAt = AppPref.dateTimeSaveDB!;

    List<Map> map = await db!.rawQuery('''
          SELECT * FROM $tablePhieuMauTB 
          WHERE $columnIDCoSo = '$idCoso' 
          AND $columnCreatedAt = '$createdAt'
        ''');
    return map.isNotEmpty ? map[0] : {};
  }

  Future<bool> isExistQuestion(String idCoso) async {
    String createdAt = AppPref.dateTimeSaveDB!;
    List<Map> map = await db!.query(tablePhieuMauTB, where: '''
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
        "SELECT ${fields.join('+')} as total FROM $tablePhieuMauTB  WHERE $columnIDCoSo = '$idCoso'   AND $columnCreatedAt = '$createdAt' AND $columnMaDTV='${AppPref.uid}'";
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
        "SELECT ${fields.join('+')} as total FROM $tablePhieuMauTB  WHERE $columnIDCoSo = '$idCoso'   AND $columnCreatedAt = '$createdAt' AND $columnMaDTV='${AppPref.uid}'";
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
        "SELECT ${fields.join('*')} as total FROM $tablePhieuMauTB  WHERE $columnIDCoSo = '$idCoso'   AND $columnCreatedAt = '$createdAt' AND $columnMaDTV='${AppPref.uid}'";
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
        "SELECT ${fields.join('*')} as total FROM $tablePhieuMauTB  WHERE $columnIDCoSo = '$idCoso'   AND $columnCreatedAt = '$createdAt' AND $columnMaDTV='${AppPref.uid}'";
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
 
  // Future<bool> kiemTraPhanVIVIIValues(
  //     String idCoso, List<String> fieldNames) async {
  //   List<int> result = [];

  //   String createdAt = AppPref.dateTimeSaveDB!;
  //   List<String> fields = [];
  //   for (var item in fieldNames) {
  //     fields.add(" $item ");
  //   }
  //   String sql =
  //       "SELECT ${fields.join(',')}  FROM $tablePhieuMauTB WHERE $columnIDCoSo = '$idCoso'   AND $columnCreatedAt = '$createdAt' AND $columnMaDTV='${AppPref.uid}'";
  //   List<Map> map = await db!.rawQuery(sql);
  //   for (var item in map) {
  //     item.forEach((key, value) {
  //       if (value != null) {
  //         result.add(1);
  //       }
  //     });
  //   }
  //   return result.isNotEmpty;
  // }

  Future<int> updateNullValues(String idCoso, List<String> fieldNames) async {
    int result = 0;

    String createdAt = AppPref.dateTimeSaveDB!;
    List<String> fields = [];
    for (var item in fieldNames) {
      fields.add(" $item = null ");
    }
    String sql =
        "UPDATE $tablePhieuMauTB SET ${fields.join(',')} WHERE $columnIDCoSo = '$idCoso'   AND $columnCreatedAt = '$createdAt' AND $columnMaDTV='${AppPref.uid}'";
    result = await db!.rawUpdate(sql);

    return result;
  }

  Future<int> deleteByCoSoId(String coSoId) {
    var res =
        db!.delete(tablePhieuMauTB, where: '''  $columnIDCoSo = '$coSoId'  ''');
    return res;
  }

  @override
  Future deletedTable(Database database) async {
    return await database.rawQuery('DROP TABLE IF EXISTS $tablePhieuMauTB');
  }
}
