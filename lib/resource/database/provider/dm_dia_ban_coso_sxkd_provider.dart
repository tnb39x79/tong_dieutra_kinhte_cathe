import 'dart:developer' as developer;
import 'dart:developer';

import 'package:gov_statistics_investigation_economic/resource/database/table/filed_common.dart';
import 'package:gov_statistics_investigation_economic/resource/database/table/table_dm_bkcoso_sxkd.dart';
import 'package:gov_statistics_investigation_economic/resource/database/table/table_dm_dia_ban_coso_sxkd.dart';
import 'package:sqflite/sqflite.dart';
import 'package:gov_statistics_investigation_economic/common/common.dart';

import 'package:gov_statistics_investigation_economic/common/utils/utils.dart';
import 'package:gov_statistics_investigation_economic/resource/database/database_helper.dart';
import 'package:gov_statistics_investigation_economic/resource/database/provider/provider.dart';

class DiaBanCoSoSXKDProvider extends BaseDBProvider<TableDmDiaBanCosoSxkd> {
  static final DiaBanCoSoSXKDProvider _singleton =
      DiaBanCoSoSXKDProvider._internal();

  factory DiaBanCoSoSXKDProvider() {
    return _singleton;
  }

  Database? db;

  DiaBanCoSoSXKDProvider._internal();

  @override
  Future init() async {
    db = await DatabaseHelper.instance.database;
  }

  @override
  Future delete(int id) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future<List<int>> insert(
      List<TableDmDiaBanCosoSxkd> value, String createdAt) async {
    try {
      await db!.delete(tableDiaBanCoSoSXKD,
          where: '''$columnMaDTV='${AppPref.uid}' ''');
    } catch (e) {
      developer.log(e.toString());
    }
    List<int> ids = [];
    for (var element in value) {
      element.createdAt = createdAt;
      //    element.updatedAt = createdAt;
      ids.add(await db!.insert(tableDiaBanCoSoSXKD, element.toJson()));
    }
    return ids;
  }

  @override
  Future onCreateTable(Database database) async {
    return database.execute('''
      CREATE TABLE IF NOT EXISTS $tableDiaBanCoSoSXKD
      (
        $columnDmDiaBanCoSoSxkdId INTEGER PRIMARY KEY AUTOINCREMENT, 
        $columnDmDiaBanCoSoSxkdMaPhieu INTEGER,
        $columnDmDiaBanCoSoSxkdMaTinh TEXT,
        $columnDmDiaBanCoSoSxkdMaTKCS TEXT,
        $columnDmDiaBanCoSoSxkdMaXa TEXT,
        $columnDmDiaBanCoSoSxkdTenXa TEXT,
         $columnDmDiaBanCoSoSxkdMaThon TEXT,
        $columnDmDiaBanCoSoSxkdMaDiaBan TEXT,
        $columnDmDiaBanCoSoSxkdTenDiaBan TEXT, 
        $columnMaDTV TEXT, 
        $columnCreatedAt TEXT,
        $columnUpdatedAt TEXT
      )
      ''');
  }

  @override
  Future<List<Map>> selectAll() async {
    String createdAt = AppPref.dateTimeSaveDB!;
    return await db!.query(tableDiaBanCoSoSXKD, where: '''
      $columnCreatedAt = '$createdAt'
    ''');
  }

  @override
  Future<Map> selectOne(int id) {
    // TODO: implement selectOne
    throw UnimplementedError();
  }
 Future<List<Map>> selectAllByMaPhieu() async {
    String createdAt = AppPref.dateTimeSaveDB!;
    String cols="  $tableDiaBanCoSoSXKD.$columnDmDiaBanCoSoSxkdMaTinh,$tableDiaBanCoSoSXKD.$columnDmDiaBanCoSoSxkdMaTKCS,";
    cols +=" $tableDiaBanCoSoSXKD.$columnDmDiaBanCoSoSxkdMaXa,$tableDiaBanCoSoSXKD.$columnDmDiaBanCoSoSxkdMaDiaBan,";
    cols +=" $tableDiaBanCoSoSXKD.$columnDmDiaBanCoSoSxkdTenDiaBan,$tableDiaBanCoSoSXKD.$columnDmDiaBanCoSoMaDTV,";
    //cols +=" $tableDiaBanCoSoSXKD.$columnDmDiaBanCoSoCreatedAt,$tableDiaBanCoSoSXKD.$columnDmDiaBanCoSoUpdatedAt,";
    cols +=" (SELECT $tablebkCoSoSXKD.$colBkCoSoSXKDTenXa FROM $tablebkCoSoSXKD WHERE $tablebkCoSoSXKD.$colBkCoSoSXKDMaXa = $tableDiaBanCoSoSXKD.$columnDmDiaBanCoSoSxkdMaXa ) AS TenXa";

    String sql = "Select DISTINCT $cols  FROM $tableDiaBanCoSoSXKD ";
    sql +=
        " WHERE $columnCreatedAt = '$createdAt' ORDER BY $tableDiaBanCoSoSXKD.$columnDmDiaBanCoSoSxkdMaXa ";
        log(sql);
    return await db!.rawQuery(sql);
  }
  Future<List<Map>> selectByMaPhieu(int maDoiTuongDT) async {
    String createdAt = AppPref.dateTimeSaveDB!;
    String cols=" $tableDiaBanCoSoSXKD.$columnDmDiaBanCoSoSxkdId,$tableDiaBanCoSoSXKD.$columnDmDiaBanCoSoSxkdMaPhieu,";
    cols +=" $tableDiaBanCoSoSXKD.$columnDmDiaBanCoSoSxkdMaTinh,$tableDiaBanCoSoSXKD.$columnDmDiaBanCoSoSxkdMaTKCS,";
    cols +=" $tableDiaBanCoSoSXKD.$columnDmDiaBanCoSoSxkdMaXa,$tableDiaBanCoSoSXKD.$columnDmDiaBanCoSoSxkdMaDiaBan,";
    cols +=" $tableDiaBanCoSoSXKD.$columnDmDiaBanCoSoSxkdTenDiaBan,$tableDiaBanCoSoSXKD.$columnDmDiaBanCoSoMaDTV,";
    cols +=" $tableDiaBanCoSoSXKD.$columnDmDiaBanCoSoCreatedAt,$tableDiaBanCoSoSXKD.$columnDmDiaBanCoSoUpdatedAt,";
    cols +=" (SELECT $tablebkCoSoSXKD.$colBkCoSoSXKDTenXa FROM $tablebkCoSoSXKD WHERE $tablebkCoSoSXKD.$colBkCoSoSXKDMaXa = $tableDiaBanCoSoSXKD.$columnDmDiaBanCoSoSxkdMaXa ) AS TenXa";

    String sql = "Select $cols  FROM $tableDiaBanCoSoSXKD ";
    sql +=
        " WHERE $columnCreatedAt = '$createdAt' AND $columnMaPhieu = $maDoiTuongDT ";
    return await db!.rawQuery(sql);
  }

  Future<List<Map>> selectByMaPhieuV0(int maDoiTuongDT) async {
    String createdAt = AppPref.dateTimeSaveDB!;
    return await db!.query(tableDiaBanCoSoSXKD, where: '''
      $columnCreatedAt = '$createdAt'
      AND $columnMaPhieu = $maDoiTuongDT
    ''');
  }

  @override
  Future update(TableDmDiaBanCosoSxkd value, String id) {
    // TODO: implement update
    throw UnimplementedError();
  }

  @override
  Future deletedTable(Database database) async {
    try {
      return await database
          .rawQuery('DROP TABLE IF EXISTS $tableDiaBanCoSoSXKD');
    } catch (e) {
      return null;
    }
  }
}
