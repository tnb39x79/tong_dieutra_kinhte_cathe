import 'dart:developer';

import 'package:gov_statistics_investigation_economic/common/utils/app_pref.dart';
import 'package:gov_statistics_investigation_economic/resource/database/database_helper.dart';
import 'package:gov_statistics_investigation_economic/resource/database/provider/base_db_provider.dart';
import 'package:gov_statistics_investigation_economic/resource/database/table/filed_common.dart';
import 'package:gov_statistics_investigation_economic/resource/database/table/table_phieu_mautb_sanpham.dart';
import 'package:gov_statistics_investigation_economic/resource/database/table/table_phieu_nganh_tm.dart';
import 'package:gov_statistics_investigation_economic/resource/database/table/table_phieu_nganh_tm_sanpham.dart';

import 'package:sqflite/sqflite.dart';

class PhieuNganhTMSanPhamProvider
    extends BaseDBProvider<TablePhieuNganhTMSanPham> {
  static final PhieuNganhTMSanPhamProvider _singleton =
      PhieuNganhTMSanPhamProvider._internal();

  factory PhieuNganhTMSanPhamProvider() {
    return _singleton;
  }

  Database? db;

  PhieuNganhTMSanPhamProvider._internal();

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
      List<TablePhieuNganhTMSanPham> value, String createdAt) async {
    List<int> ids = [];
    for (var element in value) {
      element.createdAt = createdAt;
      //  element.updatedAt = createdAt;
      element.maDTV = AppPref.uid;
      ids.add(await db!.insert(tablePhieuNganhTMSanPham, element.toJson()));
    }
    return ids;
  }

  @override
  Future onCreateTable(Database database) {
    return database.execute('''
    CREATE TABLE IF NOT EXISTS $tablePhieuNganhTMSanPham
      (
      $columnId INTEGER PRIMARY KEY AUTOINCREMENT, 
      $colPhieuNganhTMSanPhamIDCoSo  TEXT,
      $colPhieuNganhTMSanPhamSTT_SanPham  INTEGER,
      $colPhieuNganhTMSanPhamMaNganhC5  TEXT,
      $colPhieuNganhTMSanPhamMoTaSanPham  TEXT,
      $colPhieuNganhTMSanPhamA1_2  REAL,
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
  Future update(TablePhieuNganhTMSanPham value, String idCoSo) async {
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
    var i = await db!.update(tablePhieuNganhTMSanPham, values,
        where: '$columnId = ?', whereArgs: [columId]);

    log('UPDATE PHIEU 04_C32: $i');
  }

  Future updateValueByIdCoso(String fieldName, value, iDCoSo, id) async {
    Map<String, Object?> values = {
      fieldName: value,
      columnUpdatedAt: DateTime.now().toIso8601String(),
    };
    var i = await db!.update(tablePhieuNganhTMSanPham, values,
        where: '$columnId = ? AND $columnIDCoSo = ?', whereArgs: [id, iDCoSo]);

    log('UPDATE PHIEU 04_C32: ${i.toString()}');
  }

  Future<List<Map>> selectByIdCoSo(String idCoso) async {
    String createdAt = AppPref.dateTimeSaveDB!;

    List<Map> maps = await db!.rawQuery('''
          SELECT * FROM $tablePhieuNganhTMSanPham 
          WHERE $columnIDCoSo = '$idCoso' 
          AND $columnCreatedAt = '$createdAt'
        ''');
    return maps;
  }

  Future<List<Map>> selectByIdMaNganhC5(String idCoso, String maNganhC5) async {
    String createdAt = AppPref.dateTimeSaveDB!;

    List<Map> maps = await db!.rawQuery('''
          SELECT * FROM $tablePhieuNganhTMSanPham 
          WHERE $columnIDCoSo = '$idCoso' 
          AND  $colPhieuNganhTMSanPhamMaNganhC5 = '$maNganhC5' 
          AND $columnCreatedAt = '$createdAt'
        ''');
    return maps;
  }

  Future<List<Map>> selectByIdCoSoSync(String idCoso) async {
    String createdAt = AppPref.dateTimeSaveDB!;

    List<Map> maps = await db!.rawQuery('''
          SELECT * FROM $tablePhieuNganhTMSanPham 
          WHERE $columnIDCoSo = '$idCoso' 
          AND $colPhieuNganhTMSanPhamA1_2 is not null
          AND $colPhieuNganhTMSanPhamMaNganhC5 is not null 
          AND $columnCreatedAt = '$createdAt' 
        ''');
    return maps;
  }

  Future<List<Map>> selectCap1GL8610ByIdCoSo(
      String idCoso, List<String> maSanPhamCap1GL8610B) async {
    String createdAt = AppPref.dateTimeSaveDB!;

    var sql = "  SELECT distinct $tablePhieuMauTBSanPham.$colPhieuMauTBSanPhamIDCoSo, ";
    sql +=
        " $tablePhieuMauTBSanPham.$colPhieuMauTBSanPhamSTTSanPham AS STT_SanPham, ";
    sql +=
        " $tablePhieuMauTBSanPham.$colPhieuMauTBSanPhamA5_1_2 as MaNganhC5, ";
    sql +=
        " $tablePhieuMauTBSanPham.$colPhieuMauTBSanPhamA5_1_1 as MoTaSanPham, ";
    sql += " $tablePhieuNganhTMSanPham.$colPhieuNganhTMSanPhamA1_2, ";
    sql += " '${AppPref.uid}' as MADTV ";
    sql += " FROM $tablePhieuMauTBSanPham ";
    sql +=
        " LEFT JOIN $tablePhieuNganhTMSanPham  ON $tablePhieuMauTBSanPham.$colPhieuMauTBSanPhamA5_1_2=$tablePhieuNganhTMSanPham.$colPhieuNganhTMSanPhamMaNganhC5 ";
    sql +=
        " AND $tablePhieuMauTBSanPham.$colPhieuMauTBSanPhamSTTSanPham=$tablePhieuNganhTMSanPham.$colPhieuMauTBSanPhamSTTSanPham ";
    sql += " WHERE $tablePhieuMauTBSanPham.$columnIDCoSo = '$idCoso'  ";
    sql += " AND $tablePhieuMauTBSanPham.$columnCreatedAt = '$createdAt' ";
    sql +=
        " AND $tablePhieuMauTBSanPham.$colPhieuMauTBSanPhamA5_1_2 in (${maSanPhamCap1GL8610B.map((e) => "'$e'").join(', ')})";
    List<Map> maps = await db!.rawQuery(sql);
    return maps;
  }

  Future<int> getMaxSTTByIdCoso(String idCoso) async {
    String createdAt = AppPref.dateTimeSaveDB!;

    List<Map> map = await db!.rawQuery('''
          SELECT MAX($colPhieuNganhTMSanPhamSTT_SanPham) as MaxSTT FROM $tablePhieuNganhTMSanPham 
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

  Future<bool> isExistQuestion(String idCoso) async {
    String createdAt = AppPref.dateTimeSaveDB!;
    List<Map> map = await db!.query(tablePhieuNganhTMSanPham, where: '''
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
        "SELECT ${fields.join('+')} as total FROM $tablePhieuNganhTMSanPham  WHERE $columnIDCoSo = '$idCoso' AND $columnId=$id  AND $columnCreatedAt = '$createdAt' AND $columnMaDTV='${AppPref.uid}'";
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
        "SELECT ${fields.join(tongVsTich)} as total FROM $tablePhieuNganhTMSanPham  WHERE $columnIDCoSo = '$idCoso' AND $columnId=$id  AND $columnCreatedAt = '$createdAt' AND $columnMaDTV='${AppPref.uid}'";
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

  Future<double> tongTriGiaVonCau1T(String idCoSo) async {
    double result = 0.0;

    String createdAt = AppPref.dateTimeSaveDB!;

    String sql =
        "SELECT SUM($colPhieuNganhTMSanPhamA1_2) as total FROM $tablePhieuNganhTMSanPham  WHERE $columnIDCoSo = '$idCoSo'  AND $columnCreatedAt = '$createdAt' AND $columnMaDTV='${AppPref.uid}'";
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
    var res = db!
        .delete(tablePhieuNganhTMSanPham, where: '''  $columnId = '$id'  ''');
    return res;
  }

  Future<int> deleteByCoSoId(String coSoId) {
    var res = db!.delete(tablePhieuNganhTMSanPham,
        where: '''  $columnIDCoSo = '$coSoId'  ''');
    return res;
  }

  Future<int> deleteByIdMaNganhC5(String idCoso, String maNganhC5) async {
    var res = db!.delete(tablePhieuNganhTMSanPham,
        where:
            '''  $columnIDCoSo = '$idCoso' AND  $colPhieuNganhTMSanPhamMaNganhC5 = '$maNganhC5' ''');
    return res;
  }

  Future<int> deleteByListMaNganhC5(
      String idCoso, List<String> maNganhC5) async {
    var res = db!.delete(tablePhieuNganhTMSanPham,
        where:
            '''  $columnIDCoSo = '$idCoso' AND  $colPhieuNganhTMSanPhamMaNganhC5 not in (${maNganhC5.map((e) => "'$e'").join(', ')})  ''');
    return res;
  }

  @override
  Future deletedTable(Database database) async {
    return await database
        .rawQuery('DROP TABLE IF EXISTS $tablePhieuNganhTMSanPham');
  }
}
