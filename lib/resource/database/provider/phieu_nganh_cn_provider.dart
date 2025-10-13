import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gov_statistics_investigation_economic/common/utils/app_pref.dart';
import 'package:gov_statistics_investigation_economic/resource/database/database_helper.dart';
import 'package:gov_statistics_investigation_economic/resource/database/provider/base_db_provider.dart';
import 'package:gov_statistics_investigation_economic/resource/database/table/filed_common.dart';
import 'package:gov_statistics_investigation_economic/resource/database/table/table_p07mau.dart';

import 'package:sqflite/sqflite.dart';

class PhieuNganhCNProvider extends BaseDBProvider<TablePhieuNganhCN> {
  static final PhieuNganhCNProvider _singleton =
      PhieuNganhCNProvider._internal();

  factory PhieuNganhCNProvider() {
    return _singleton;
  }

  Database? db;

  PhieuNganhCNProvider._internal();

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
      List<TablePhieuNganhCN> value, String createdAt) async {
    List<int> ids = [];
    for (var element in value) {
      element.createdAt = createdAt;
      //  element.updatedAt = createdAt;
      element.maDTV = AppPref.uid;
      ids.add(await db!.insert(tablePhieuNganhCN, element.toJson()));
    }
    return ids;
  }

  @override
  Future onCreateTable(Database database) {
    return database.execute('''
    CREATE TABLE IF NOT EXISTS $tablePhieuNganhCN
      (
      $columnId INTEGER PRIMARY KEY AUTOINCREMENT, 
      $colPhieuNganhCNIDCoSo  TEXT,
      $colPhieuNganhCNSTT_SanPham  INTEGER,
      $colPhieuNganhCNMaNganhC5  TEXT,
      $colPhieuNganhCNA1_1  TEXT,
      $colPhieuNganhCNA1_2  TEXT,
      $colPhieuNganhCNA2_1  TEXT,
      $colPhieuNganhCNA2_2  REAL, 
      $colPhieuNganhCNIsDefault INTEGER, 
      $colPhieuNganhCNIsSync INTEGER,
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
  Future update(TablePhieuNganhCN value, String idCoSo) async {
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
    var i = await db!.update(tablePhieuNganhCN, values,
        where: '$columnId = ?', whereArgs: [columId]);

    log('UPDATE PHIEU 04_C32: $i');
  }

  Future updateValueByIdCoso(String fieldName, value, iDCoSo, id) async {
    Map<String, Object?> values = {
      fieldName: value,
      columnUpdatedAt: DateTime.now().toIso8601String(),
    };
    var i = await db!.update(tablePhieuNganhCN, values,
        where: '$columnId = ? AND $columnIDCoSo = ?', whereArgs: [id, iDCoSo]);

    log('UPDATE PHIEU 04_C32: ${i.toString()}');
  }

  Future<List<Map>> selectByIdCoso(String idCoso) async {
    String createdAt = AppPref.dateTimeSaveDB!;

    List<Map> maps = await db!.rawQuery('''
          SELECT * FROM $tablePhieuNganhCN 
          WHERE $columnIDCoSo = '$idCoso' 
          AND $columnCreatedAt = '$createdAt'
        ''');
    return maps;
  }

  Future<List<Map>> selectDistinctCap5ByIdCoso(String idCoso) async {
    String createdAt = AppPref.dateTimeSaveDB!;

    List<Map> maps = await db!.rawQuery('''
          SELECT distinct $colPhieuNganhCNIDCoSo,$colPhieuNganhCNMaNganhC5,(select $tablePhieuMauTBSanPham.$colPhieuMauTBSanPhamA5_1_1 from $tablePhieuMauTBSanPham where $tablePhieuMauTBSanPham.$colPhieuMauTBSanPhamMaNganhC5=$tablePhieuNganhCN.$colPhieuNganhCNMaNganhC5) as MoTaSanPham  FROM $tablePhieuNganhCN 
          WHERE $columnIDCoSo = '$idCoso' 
          AND $columnCreatedAt = '$createdAt'
        ''');
    return maps;
  }

  Future<List<Map>> selectByIdCosoSync(String idCoso) async {
    String createdAt = AppPref.dateTimeSaveDB!;

    List<Map> maps = await db!.rawQuery('''
          SELECT * FROM $tablePhieuNganhCN 
          WHERE $columnIDCoSo = '$idCoso' 
          AND $colPhieuNganhCNSTT_SanPham is not null
          AND $colPhieuNganhCNMaNganhC5 is not null
          AND $colPhieuNganhCNA1_1 is not null
          AND $colPhieuNganhCNA1_2 is not null
          AND $colPhieuNganhCNA2_1 is not null
          AND $colPhieuNganhCNA2_2 is not null 
          AND $columnCreatedAt = '$createdAt' ORDER BY $colPhieuNganhCNSTT_SanPham
        ''');
    return maps;
  }

  Future<List<Map>> getByMaNganhC5(String idCoso, String maNganhC5) async {
    String createdAt = AppPref.dateTimeSaveDB!;
    List<Map> map = await db!.query(tablePhieuNganhCN, where: '''
      $columnCreatedAt = '$createdAt'
      AND  $colPhieuNganhCNMaNganhC5 = '$maNganhC5'
      AND $columnIDCoSo = '$idCoso' AND $columnMaDTV='${AppPref.uid}'
    ''');
    return map;
  }

  Future<List<Map>> selectCap1BCDEByIdCoSo(
      String idCoso, List<String> maSanPhamCap1BCDE) async {
    String createdAt = AppPref.dateTimeSaveDB!;

    String sql = "SELECT distinct $tablePhieuMauTBSanPham.$columnIDCoSo, ";
    sql +=
        " $tablePhieuMauTBSanPham.$colPhieuMauTBSanPhamSTTSanPham AS STT_SanPham, ";
    sql += "$tablePhieuMauTBSanPham.$colPhieuMauTBSanPhamA5_1_2 as MaNganhC5, ";
    sql += " $tablePhieuNganhCN.$colPhieuNganhCNA1_1, ";
    sql += " $tablePhieuNganhCN.$colPhieuNganhCNA1_2, ";
    sql += "$tablePhieuNganhCN.$colPhieuNganhCNA2_1, ";
    sql += " $tablePhieuNganhCN.$colPhieuNganhCNA2_2, "; 
    sql += " '${AppPref.uid}' as MADTV ";
    sql += " FROM $tablePhieuMauTBSanPham";
    sql +=
        " LEFT JOIN $tablePhieuNganhCN ON $tablePhieuMauTBSanPham.$colPhieuMauTBSanPhamA5_1_2=$tablePhieuNganhCN.$colPhieuNganhCNMaNganhC5";
    sql +=
        " AND $tablePhieuMauTBSanPham.$colPhieuMauTBSanPhamSTTSanPham=$tablePhieuNganhCN.$colPhieuNganhCNSTT_SanPham";
    sql += " WHERE $tablePhieuMauTBSanPham.$columnIDCoSo = '$idCoso' ";
    sql += " AND $tablePhieuMauTBSanPham.$columnCreatedAt = '$createdAt'";
    sql +=
        " AND $tablePhieuMauTBSanPham.$colPhieuMauTBSanPhamA5_1_2 in (${maSanPhamCap1BCDE.map((e) => "'$e'").join(', ')})";
    debugPrint(sql);
    List<Map> maps = await db!.rawQuery(sql);
    return maps;
  }

  Future<int> getMaxSTTByIdCoso(String idCoso) async {
    String createdAt = AppPref.dateTimeSaveDB!;

    List<Map> map = await db!.rawQuery('''
          SELECT MAX($colPhieuNganhCNSTT_SanPham) as MaxSTT FROM $tablePhieuNganhCN 
          WHERE $columnIDCoSo = '$idCoso' 
          AND $columnCreatedAt = '$createdAt'
        ''');
    if (map.isNotEmpty) {
      if (map[0] != null) {
        return map[0]['MaxSTT'] ?? 0;
      }
    }
    return 0;
    
  }

  Future<int> getIsDefaultByIdCoso(String idCoso) async {
    String createdAt = AppPref.dateTimeSaveDB!;

    List<Map> map = await db!.rawQuery('''
          SELECT IsDefault FROM $tablePhieuNganhCN 
          WHERE $columnIDCoSo = '$idCoso' 
          AND $columnCreatedAt = '$createdAt'
        ''');
    if (map.isNotEmpty) {
      if (map[0] != null) {
        return map[0]['IsDefault'] ?? 0;
      }
    }
    return 0;
  }

  Future<int> countNotIsDefaultByIdCoso(String idCoso) async {
    String createdAt = AppPref.dateTimeSaveDB!;

    List<Map> map = await db!.rawQuery('''
          SELECT _id FROM $tablePhieuNganhCN 
          WHERE $columnIDCoSo = '$idCoso' 
          AND $columnCreatedAt = '$createdAt'
          AND $colPhieuNganhCNIsDefault is null 
        ''');
    if (map.isNotEmpty) {
      if (map[0] != null) {
        return map[0]['_id'] ?? 0;
      }
    }
    return 0;
  }
    Future<int> countMaNganhCap5ByIdCoso(String idCoso,String maNganhCap5) async {
    String createdAt = AppPref.dateTimeSaveDB!;

    List<Map> map = await db!.rawQuery('''
          SELECT COUNT($colPhieuNganhCNMaNganhC5) AS COUNTCAP5 FROM $tablePhieuNganhCN 
          WHERE $columnIDCoSo = '$idCoso' 
          AND $columnCreatedAt = '$createdAt' 
          AND $colPhieuNganhCNMaNganhC5='$maNganhCap5'
          GROUP BY $colPhieuNganhCNMaNganhC5

        ''');
    if (map.isNotEmpty) {
      if (map[0] != null) {
        return map[0]['COUNTCAP5'] ?? 0;
      }
    }
    return 0;
  }

  Future<bool> isExistQuestion(String idCoso) async {
    String createdAt = AppPref.dateTimeSaveDB!;
    List<Map> map = await db!.query(tablePhieuNganhCN, where: '''
      $columnCreatedAt = '$createdAt'
      AND $columnIDCoSo = '$idCoso'
    ''');
    return map.isNotEmpty;
  }

  Future<bool> isExistProduct(String idCoso) async {
    String createdAt = AppPref.dateTimeSaveDB!;
    List<Map> map = await db!.query(tablePhieuNganhCN, where: '''
      $columnCreatedAt = '$createdAt'
      AND $columnIDCoSo = '$idCoso' AND $columnMaDTV='${AppPref.uid}'
    ''');
    return map.isNotEmpty;
  }

  Future<bool> isExistProductBySTT(String idCoso, int stt) async {
    String createdAt = AppPref.dateTimeSaveDB!;
    List<Map> map = await db!.query(tablePhieuNganhCN, where: '''
      $columnCreatedAt = '$createdAt'
      AND  $colPhieuNganhCNSTT_SanPham = '$stt'
      AND $columnIDCoSo = '$idCoso' AND $columnMaDTV='${AppPref.uid}'
    ''');
    return map.isNotEmpty;
  }

  Future<bool> isExistProductById(String idCoso, int id) async {
    String createdAt = AppPref.dateTimeSaveDB!;
    List<Map> map = await db!.query(tablePhieuNganhCN, where: '''
      $columnCreatedAt = '$createdAt'
      AND  $columnId = '$id'
      AND $columnIDCoSo = '$idCoso' AND $columnMaDTV='${AppPref.uid}'
    ''');
    return map.isNotEmpty;
  }

  Future<bool> isExistProductByMaNganhC5(
      String idCoso, String maNganhC5) async {
    String createdAt = AppPref.dateTimeSaveDB!;
    List<Map> map = await db!.query(tablePhieuNganhCN, where: '''
      $columnCreatedAt = '$createdAt'
      AND  $colPhieuNganhCNMaNganhC5 = '$maNganhC5'
      AND $columnIDCoSo = '$idCoso' AND $columnMaDTV='${AppPref.uid}'
    ''');
    return map.isNotEmpty;
  }

  Future<bool> isExistProductByMaNganhC8(
      String idCoso, String maNganhC8) async {
    String createdAt = AppPref.dateTimeSaveDB!;
    List<Map> map = await db!.query(tablePhieuNganhCN, where: '''
      $columnCreatedAt = '$createdAt'
      AND  $colPhieuNganhCNA1_2 = '$maNganhC8'
      AND $columnIDCoSo = '$idCoso' AND $columnMaDTV='${AppPref.uid}'
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
        "SELECT ${fields.join('+')} as total FROM $tablePhieuNganhCN  WHERE $columnIDCoSo = '$idCoso' AND $columnId=$id  AND $columnCreatedAt = '$createdAt' AND $columnMaDTV='${AppPref.uid}'";
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
      fields.add("IFNULL($item,0)");
    }
    String sql =
        "SELECT ${fields.join(tongVsTich)} as total FROM $tablePhieuNganhCN  WHERE $columnIDCoSo = '$idCoso' AND $columnId=$id  AND $columnCreatedAt = '$createdAt' AND $columnMaDTV='${AppPref.uid}'";
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

  ///Mã ngành cấp 2 là ngành công nghiệp (mã ngành >=10 và <=39) 
 Future<List<String>> getMaNganhCN10To39(String idCoso) async {
    String createdAt = AppPref.dateTimeSaveDB!;
    List<String> result = [];
    List<Map> maps = await db!.rawQuery('''
          SELECT $colPhieuNganhCNMaNganhC5 FROM $tablePhieuMauTBSanPham 
          WHERE $columnIDCoSo = '$idCoso' 
          AND $columnCreatedAt = '$createdAt'
          AND substr($colPhieuNganhCNMaNganhC5 ,1,2) BETWEEN '10' and '39'
        ''');

    for (var item in maps) {
      item.forEach((key, value) {
        if (value != null) {
          result.add(value);
        }
      });
    }
    return result;
  }
  Future<int> deleteById(int id) {
    var res = db!.delete(tablePhieuNganhCN, where: '''  $columnId = '$id'  ''');
    return res;
  }

  Future<int> deleteByCoSoId(String coSoId) {
    var res = db!
        .delete(tablePhieuNganhCN, where: '''  $columnIDCoSo = '$coSoId'  ''');
    return res;
  }

  @override
  Future deletedTable(Database database) async {
    return await database.rawQuery('DROP TABLE IF EXISTS $tablePhieuNganhCN');
  }
 
}
