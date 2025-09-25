import 'dart:developer';

import 'package:gov_statistics_investigation_economic/common/utils/app_pref.dart';
import 'package:gov_statistics_investigation_economic/resource/database/database_helper.dart';
import 'package:gov_statistics_investigation_economic/resource/database/provider/base_db_provider.dart';
import 'package:gov_statistics_investigation_economic/resource/database/table/filed_common.dart';
import 'package:gov_statistics_investigation_economic/resource/database/table/table_p07mau.dart';
import 'package:sqflite/sqflite.dart';

class PhieuProvider extends BaseDBProvider<TablePhieu> {
  static final PhieuProvider _singleton = PhieuProvider._internal();

  factory PhieuProvider() {
    return _singleton;
  }

  Database? db;

  PhieuProvider._internal();

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
      List<TablePhieu> value, String createdAt) async {
    List<int> ids = [];
    for (var element in value) {
      element.createdAt = createdAt;
      //   element.updatedAt = createdAt;
      
      ids.add(await db!.insert(tablePhieu, element.toJson()));
    }
    return ids;
  }

  @override
  Future onCreateTable(Database database) {
    return database.execute('''
    CREATE TABLE IF NOT EXISTS $tablePhieu
      (
        $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
        $colPhieuIDCoSo  TEXT,
        $colPhieuLoaiPhieu  INTEGER,
        $colPhieuMaTinh  TEXT,
        $colPhieuMaTKCS  TEXT,
        $colPhieuMaXa  TEXT,
        $colPhieuMaThon  TEXT,
        $colPhieuIDDB  TEXT,
        $colPhieuMaDiaBan  TEXT,
        $colPhieuTrangThaiCoSo  INTEGER,
        $colPhieuMaCoSo  INTEGER,
        $colPhieuTenCoSo  TEXT,
        $colPhieuDiaChi  TEXT,
        $colPhieuTenChuCoSo  TEXT,
        $colPhieuSDTCoSo  TEXT,
        $colPhieuMaNganhMau  TEXT,
        $colPhieuMaDTV  TEXT,
        $colPhieuKinhDo  REAL,
        $colPhieuViDo  REAL,
        $colPhieuNguoiTraLoi  TEXT,
        $colPhieuSoDienThoai  TEXT,
        $colPhieuThoiGianBD  TEXT,
        $colPhieuThoiGianKT  TEXT,
        $colPhieuGhiChu  TEXT,
        $colPhieuGiaiTrinhToaDo  TEXT,
        $colPhieuGiaiTrinhThoiGianPV  TEXT,
        $colPhieuNgayCapNhat  TEXT,
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
  Future update(TablePhieu value, String id) async {
    String createAt = AppPref.dateTimeSaveDB!;
    String updatedAt = DateTime.now().toIso8601String();
    value.updatedAt = updatedAt;
    await db!.update(tablePhieu, value.toJson(), where: '''
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
        .update(tablePhieu, values, where: '$columnId = ?', whereArgs: [id]);

    log('UPDATE PHIEU 04: $i');
  }

  Future updateValue(String fieldName, value, idCoSo) async {
    String createAt = AppPref.dateTimeSaveDB!;
    Map<String, Object?> values = {
      fieldName: value,
      columnUpdatedAt: DateTime.now().toIso8601String(),
    };
    var i = await db!.update(tablePhieu, values,
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
      await db!.update(tablePhieu, multiValue,
          where: '$columnIDCoSo= ? AND $columnCreatedAt = ? ',
          whereArgs: [idCoSo, createdAt]);
    } else {
      Map<String, Object?> values = {
        fieldName: value,
        "UpdatedAt": DateTime.now().toIso8601String()
      };
      await db!.update(tablePhieu, values,
          where: '$columnIDCoSo= ? AND $columnCreatedAt = ? ',
          whereArgs: [idCoSo, createdAt]);
    }
  }

  Future<Map> selectByIdCoSo(String idCoso) async {
    String createdAt = AppPref.dateTimeSaveDB!;

    List<Map> map = await db!.rawQuery('''
          SELECT * FROM $tablePhieu 
          WHERE $columnIDCoSo = '$idCoso' 
          AND $columnCreatedAt = '$createdAt'
        ''');
    return map.isNotEmpty ? map[0] : {};
  }

  Future<bool> isExistQuestion(String idCoso) async {
    String createdAt = AppPref.dateTimeSaveDB!;
    List<Map> map = await db!.query(tablePhieu, where: '''
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
        "SELECT ${fields.join('+')} as total FROM $tablePhieu  WHERE $columnIDCoSo = '$idCoso'   AND $columnCreatedAt = '$createdAt' AND $columnMaDTV='${AppPref.uid}'";
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
        "SELECT ${fields.join('+')} as total FROM $tablePhieu  WHERE $columnIDCoSo = '$idCoso'   AND $columnCreatedAt = '$createdAt' AND $columnMaDTV='${AppPref.uid}'";
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
        "SELECT ${fields.join('*')} as total FROM $tablePhieu  WHERE $columnIDCoSo = '$idCoso'   AND $columnCreatedAt = '$createdAt' AND $columnMaDTV='${AppPref.uid}'";
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
        "SELECT ${fields.join('*')} as total FROM $tablePhieu  WHERE $columnIDCoSo = '$idCoso'   AND $columnCreatedAt = '$createdAt' AND $columnMaDTV='${AppPref.uid}'";
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
        "SELECT $columnKinhDo,$columnViDo FROM $tablePhieu  WHERE $columnIDCoSo = '$idCoso'   AND $columnCreatedAt = '$createdAt' AND $columnMaDTV='${AppPref.uid}'";
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
        "SELECT ${fields.join(',')}  FROM $tablePhieu WHERE $columnIDCoSo = '$idCoso'   AND $columnCreatedAt = '$createdAt' AND $columnMaDTV='${AppPref.uid}'";
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
        "UPDATE $tablePhieu SET ${fields.join(',')} WHERE $columnIDCoSo = '$idCoso'   AND $columnCreatedAt = '$createdAt' AND $columnMaDTV='${AppPref.uid}'";
    result = await db!.rawUpdate(sql);

    return result;
  }

  Future<int> deleteByCoSoId(String coSoId) {
    var res =
        db!.delete(tablePhieu, where: '''  $columnIDCoSo = '$coSoId'  ''');
    return res;
  }

  @override
  Future deletedTable(Database database) async {
    return await database.rawQuery('DROP TABLE IF EXISTS $tablePhieu');
  }
}
