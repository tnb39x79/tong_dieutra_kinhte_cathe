import 'dart:developer';

import 'package:gov_statistics_investigation_economic/common/utils/app_pref.dart';
import 'package:gov_statistics_investigation_economic/resource/database/database_helper.dart';
import 'package:gov_statistics_investigation_economic/resource/database/provider/base_db_provider.dart';
import 'package:gov_statistics_investigation_economic/resource/database/table/filed_common.dart';
import 'package:gov_statistics_investigation_economic/resource/database/table/table_phieu_mautb_sanpham.dart';
import 'package:gov_statistics_investigation_economic/resource/database/table/table_phieu_nganh_tm_sanpham.dart';
import 'package:gov_statistics_investigation_economic/resource/database/table/table_phieu_nganh_vt.dart';

import 'package:sqflite/sqflite.dart';

class PhieuNganhVTProvider extends BaseDBProvider<TablePhieuNganhVT> {
  static final PhieuNganhVTProvider _singleton =
      PhieuNganhVTProvider._internal();

  factory PhieuNganhVTProvider() {
    return _singleton;
  }

  Database? db;

  PhieuNganhVTProvider._internal();

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
      List<TablePhieuNganhVT> value, String createdAt) async {
    List<int> ids = [];
    for (var element in value) {
      element.createdAt = createdAt;
      //  element.updatedAt = createdAt;
      element.maDTV = AppPref.uid;
      ids.add(await db!.insert(tablePhieuNganhVT, element.toJson()));
    }
    return ids;
  }

  @override
  Future onCreateTable(Database database) {
    return database.execute('''
    CREATE TABLE IF NOT EXISTS $tablePhieuNganhVT
      (
      $columnId INTEGER PRIMARY KEY AUTOINCREMENT, 
      $colPhieuNganhVTIDCoSo  TEXT,
      $colPhieuNganhVTA1_1_1  INTEGER,
      $colPhieuNganhVTA1_1_2  INTEGER,
      $colPhieuNganhVTA1_1_3  INTEGER,
      $colPhieuNganhVTA1_1_4  INTEGER,
      $colPhieuNganhVTA1_2_1  INTEGER,
      $colPhieuNganhVTA1_2_2  INTEGER,
      $colPhieuNganhVTA1_2_3  INTEGER,
      $colPhieuNganhVTA1_2_4  INTEGER,
      $colPhieuNganhVTA1_3_1  INTEGER,
      $colPhieuNganhVTA1_3_2  INTEGER,
      $colPhieuNganhVTA1_3_3  INTEGER,
      $colPhieuNganhVTA1_3_4  INTEGER,
      $colPhieuNganhVTA1_4_1  INTEGER,
      $colPhieuNganhVTA1_4_2  INTEGER,
      $colPhieuNganhVTA1_4_3  INTEGER,
      $colPhieuNganhVTA1_4_4  INTEGER,
      $colPhieuNganhVTA1_5_1  INTEGER,
      $colPhieuNganhVTA1_5_2  INTEGER,
      $colPhieuNganhVTA1_5_3  INTEGER,
      $colPhieuNganhVTA1_5_4  INTEGER,
      $colPhieuNganhVTA1_6_1  INTEGER,
      $colPhieuNganhVTA1_6_2  INTEGER,
      $colPhieuNganhVTA1_6_3  INTEGER,
      $colPhieuNganhVTA1_6_4  INTEGER,
      $colPhieuNganhVTA1_7_1  INTEGER,
      $colPhieuNganhVTA1_7_2  INTEGER,
      $colPhieuNganhVTA1_7_3  INTEGER,
      $colPhieuNganhVTA1_7_4  INTEGER,
      $colPhieuNganhVTA1_8_1  INTEGER,
      $colPhieuNganhVTA1_8_2  INTEGER,
      $colPhieuNganhVTA1_8_3  INTEGER,
      $colPhieuNganhVTA1_8_4  INTEGER,
      $colPhieuNganhVTA1_9_1  INTEGER,
      $colPhieuNganhVTA1_9_2  INTEGER,
      $colPhieuNganhVTA1_9_3  INTEGER,
      $colPhieuNganhVTA1_9_4  INTEGER,
      $colPhieuNganhVTA1_10_1  INTEGER,
      $colPhieuNganhVTA1_10_2  INTEGER,
      $colPhieuNganhVTA1_10_3  INTEGER,
      $colPhieuNganhVTA1_10_4  INTEGER,
      $colPhieuNganhVTA1_11_1  INTEGER,
      $colPhieuNganhVTA1_11_2  INTEGER,
      $colPhieuNganhVTA1_11_3  INTEGER,
      $colPhieuNganhVTA1_11_4  INTEGER,
      $colPhieuNganhVTA1_12_1  INTEGER,
      $colPhieuNganhVTA1_12_2  INTEGER,
      $colPhieuNganhVTA1_12_3  INTEGER,
      $colPhieuNganhVTA1_12_4  INTEGER,
      $colPhieuNganhVTA1_14_1  INTEGER,
      $colPhieuNganhVTA1_14_2  INTEGER,
      $colPhieuNganhVTA1_14_3  INTEGER,
      $colPhieuNganhVTA1_14_4  INTEGER,
      $colPhieuNganhVTA5  INTEGER,
      $colPhieuNganhVTA6  INTEGER,
      $colPhieuNganhVTA7_1_1  INTEGER,
      $colPhieuNganhVTA7_1_2  INTEGER,
      $colPhieuNganhVTA7_1_3  REAL,
      $colPhieuNganhVTA7_1_4  REAL,
      $colPhieuNganhVTA7_2_1  INTEGER,
      $colPhieuNganhVTA7_2_2  INTEGER,
      $colPhieuNganhVTA7_2_3  REAL,
      $colPhieuNganhVTA7_2_4  REAL,
      $colPhieuNganhVTA7_3_1  INTEGER,
      $colPhieuNganhVTA7_3_2  INTEGER,
      $colPhieuNganhVTA7_3_3  REAL,
      $colPhieuNganhVTA7_3_4  REAL,
      $colPhieuNganhVTA7_4_1  INTEGER,
      $colPhieuNganhVTA7_4_2  INTEGER,
      $colPhieuNganhVTA7_4_3  REAL,
      $colPhieuNganhVTA7_4_4  REAL,
      $colPhieuNganhVTA7_5_1  INTEGER,
      $colPhieuNganhVTA7_5_2  INTEGER,
      $colPhieuNganhVTA7_5_3  REAL,
      $colPhieuNganhVTA7_5_4  REAL,
      $colPhieuNganhVTA7_6_1  INTEGER,
      $colPhieuNganhVTA7_6_2  INTEGER,
      $colPhieuNganhVTA7_6_3  REAL,
      $colPhieuNganhVTA7_6_4  REAL,
      $colPhieuNganhVTA7_7_1  INTEGER,
      $colPhieuNganhVTA7_7_2  INTEGER,
      $colPhieuNganhVTA7_7_3  REAL,
      $colPhieuNganhVTA7_7_4  REAL,
      $colPhieuNganhVTA7_8_1  INTEGER,
      $colPhieuNganhVTA7_8_2  INTEGER,
      $colPhieuNganhVTA7_8_3  REAL,
      $colPhieuNganhVTA7_8_4  REAL,
      $colPhieuNganhVTA7_9_1  INTEGER,
      $colPhieuNganhVTA7_9_2  INTEGER,
      $colPhieuNganhVTA7_9_3  REAL,
      $colPhieuNganhVTA7_9_4  REAL,
      $colPhieuNganhVTA7_10_1  INTEGER,
      $colPhieuNganhVTA7_10_2  INTEGER,
      $colPhieuNganhVTA7_10_3  REAL,
      $colPhieuNganhVTA7_10_4  REAL,
      $colPhieuNganhVTA7_11_1  INTEGER,
      $colPhieuNganhVTA7_11_2  INTEGER,
      $colPhieuNganhVTA7_11_3  REAL,
      $colPhieuNganhVTA7_11_4  REAL,
      $colPhieuNganhVTA7_12_1  INTEGER,
      $colPhieuNganhVTA7_12_2  INTEGER,
      $colPhieuNganhVTA7_12_3  REAL,
      $colPhieuNganhVTA7_12_4  REAL,
      $colPhieuNganhVTA7_13_1  INTEGER,
      $colPhieuNganhVTA7_13_2  INTEGER,
      $colPhieuNganhVTA7_13_3  REAL,
      $colPhieuNganhVTA7_13_4  REAL,
      $colPhieuNganhVTA7_14_1  INTEGER,
      $colPhieuNganhVTA7_14_2  INTEGER,
      $colPhieuNganhVTA7_14_3  REAL,
      $colPhieuNganhVTA7_14_4  REAL,
      $colPhieuNganhVTA7_15_1  INTEGER,
      $colPhieuNganhVTA7_15_2  INTEGER,
      $colPhieuNganhVTA7_15_3  REAL,
      $colPhieuNganhVTA7_15_4  REAL,
      $colPhieuNganhVTA7_16_1  INTEGER,
      $colPhieuNganhVTA7_16_2  INTEGER,
      $colPhieuNganhVTA7_16_3  REAL,
      $colPhieuNganhVTA7_16_4  REAL,
      $colPhieuNganhVTA11  INTEGER,
      $colPhieuNganhVTA12  REAL,
      $colPhieuNganhVTA1_M  INTEGER,
      $colPhieuNganhVTA2_M  INTEGER,
      $colPhieuNganhVTA3_M  REAL,
      $colPhieuNganhVTA4_M  INTEGER,
      $colPhieuNganhVTA5_M  REAL,
      $colPhieuNganhVTA6_M  INTEGER,
      $colPhieuNganhVTA7_M  REAL,
      $colPhieuNganhVTA8_M  REAL,
      $colPhieuNganhVTA9_M  REAL,
      $colPhieuNganhVTA10_M  REAL,
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
  Future update(TablePhieuNganhVT value, String idCoSo) async {
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
    var i = await db!.update(tablePhieuNganhVT, values,
        where: '$columnId = ?', whereArgs: [columnId]);

    log('UPDATE PHIEU 04_C32: $i');
  }

  Future updateValueByIdCoSo(String fieldName, value, iDCoSo) async {
    Map<String, Object?> values = {
      fieldName: value,
      columnUpdatedAt: DateTime.now().toIso8601String(),
    };
    var i = await db!.update(tablePhieuNganhVT, values,
        where: '$columnIDCoSo = ?', whereArgs: [iDCoSo]);

    log('UPDATE PHIEU 04_C32: ${i.toString()}');
  }

  Future<int> updateNullValues(String idCoso, List<String> fieldNames) async {
    int result = 0;

    String createdAt = AppPref.dateTimeSaveDB!;
    List<String> fields = [];
    for (var item in fieldNames) {
      fields.add(" $item = null ");
    }
    String sql =
        "UPDATE $tablePhieuNganhVT SET ${fields.join(',')} WHERE $columnIDCoSo = '$idCoso'   AND $columnCreatedAt = '$createdAt' AND $columnMaDTV='${AppPref.uid}'";
    result = await db!.rawUpdate(sql);

    return result;
  }

  Future updateMultiValues(String idCoSo,
      {Map<String, Object?>? multiValue}) async {
    String createdAt = AppPref.dateTimeSaveDB ?? "";
    if (multiValue != null) {
      multiValue['UpdatedAt'] = DateTime.now().toIso8601String();
      await db!.update(tablePhieuNganhVT, multiValue,
          where: '$columnIDCoSo= ? AND $columnCreatedAt = ? ',
          whereArgs: [idCoSo, createdAt]);
    }
  }

  Future<List<Map>> selectListByIdCoSo(String idCoso) async {
    String createdAt = AppPref.dateTimeSaveDB!;

    List<Map> maps = await db!.rawQuery('''
          SELECT * FROM $tablePhieuNganhVT
          WHERE $columnIDCoSo = '$idCoso'
          AND $columnCreatedAt = '$createdAt'
        ''');
    return maps;
  }

  Future<Map> selectByIdCoSo(String idCoso) async {
    String createdAt = AppPref.dateTimeSaveDB!;

    List<Map> map = await db!.rawQuery('''
          SELECT * FROM $tablePhieuNganhVT 
          WHERE $columnIDCoSo = '$idCoso' 
          AND $columnCreatedAt = '$createdAt'
        ''');
    return map.isNotEmpty ? map[0] : {};
  }

  Future<Map> selectByIdCoSoSync(String idCoso) async {
    String createdAt = AppPref.dateTimeSaveDB!;

    List<Map> map = await db!.rawQuery('''
          SELECT * FROM $tablePhieuNganhVT 
          WHERE $columnIDCoSo = '$idCoso' 
          AND $colPhieuNganhVTA1_1_1 is not null
          AND $colPhieuNganhVTA1_1_2 is not null 
          AND $columnCreatedAt = '$createdAt' 
        ''');
    return map.isNotEmpty ? map[0] : {};
  }

  Future<bool> isExistQuestion(String idCoso) async {
    String createdAt = AppPref.dateTimeSaveDB!;
    List<Map> map = await db!.query(tablePhieuNganhVT, where: '''
      $columnCreatedAt = '$createdAt'
      AND $columnIDCoSo = '$idCoso'
    ''');
    return map.isNotEmpty;
  }

  Future<bool> isExistProduct(String idCoso) async {
    String createdAt = AppPref.dateTimeSaveDB!;
    List<Map> map = await db!.query(tablePhieuNganhVT, where: '''
      $columnCreatedAt = '$createdAt'
      AND $columnIDCoSo = '$idCoso' AND $columnMaDTV='${AppPref.uid}'
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
        "SELECT ${fields.join('+')} as total FROM $tablePhieuNganhVT  WHERE $columnIDCoSo = '$idCoso'  AND $columnCreatedAt = '$createdAt' AND $columnMaDTV='${AppPref.uid}'";
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
      String idCoso, List<String> fieldNames, String tongVsTich) async {
    double result = 0.0;

    String createdAt = AppPref.dateTimeSaveDB!;
    List<String> fields = [];
    for (var item in fieldNames) {
      fields.add("IFNULL($item,0.0)");
    }
    String sql =
        "SELECT ${fields.join(tongVsTich)} as total FROM $tablePhieuNganhVT  WHERE $columnIDCoSo = '$idCoso'    AND $columnCreatedAt = '$createdAt' AND $columnMaDTV='${AppPref.uid}'";
        log('totalDoubleByMaCauHoi sql $sql');
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

  Future<int> totalSubtractIntByMaCauHoi(
      String idCoso, List<String> fieldNames) async {
    int result = 0;

    String createdAt = AppPref.dateTimeSaveDB!;
    List<String> fields = [];
    for (var item in fieldNames) {
      fields.add("IFNULL($item,0)");
    }
    String sql =
        "SELECT ${fields.join('*')} as total FROM $tablePhieuNganhVT  WHERE $columnIDCoSo = '$idCoso'   AND $columnCreatedAt = '$createdAt' AND $columnMaDTV='${AppPref.uid}'";
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

  Future<bool> kiemTraPhanVIVIIValues(
      String idCoso, List<String> fieldNames) async {
    List<int> result = [];

    String createdAt = AppPref.dateTimeSaveDB!;
    List<String> fields = [];
    for (var item in fieldNames) {
      fields.add(" $item ");
    }
    String sql =
        "SELECT ${fields.join(',')}  FROM $tablePhieuNganhVT WHERE $columnIDCoSo = '$idCoso'   AND $columnCreatedAt = '$createdAt' AND $columnMaDTV='${AppPref.uid}'";
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

 
  Future<int> deleteById(int id) {
    var res = db!.delete(tablePhieuNganhVT, where: '''  $columnId = '$id'  ''');
    return res;
  }

  Future<int> deleteByCoSoId(String coSoId) {
    var res = db!
        .delete(tablePhieuNganhVT, where: '''  $columnIDCoSo = '$coSoId'  ''');
    return res;
  }

  @override
  Future deletedTable(Database database) async {
    return await database.rawQuery('DROP TABLE IF EXISTS $tablePhieuNganhVT');
  }
}
