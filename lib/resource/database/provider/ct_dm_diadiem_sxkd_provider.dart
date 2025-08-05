import 'dart:developer' as developer;
 
import 'package:gov_statistics_investigation_economic/resource/database/table/filed_common.dart';
import 'package:gov_statistics_investigation_economic/resource/database/table/table_ct_dm_diadiem_sxkd.dart';
import 'package:sqflite/sqflite.dart'; 
import 'package:gov_statistics_investigation_economic/resource/database/database_helper.dart';
import 'package:gov_statistics_investigation_economic/resource/database/provider/provider.dart';

class CTDmDiaDiemSXKDProvider extends BaseDBProvider<TableCTDmDiaDiemSXKD> {
  static final CTDmDiaDiemSXKDProvider _singleton =
      CTDmDiaDiemSXKDProvider._internal();

  factory CTDmDiaDiemSXKDProvider() {
    return _singleton;
  }

  Database? db;

  CTDmDiaDiemSXKDProvider._internal();

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
  Future<List<int>> insert(List<TableCTDmDiaDiemSXKD> value, String createdAt) async {
    try {
      await db!.delete(tableCTDmDiaDiemSXKD);
    } catch (e) {
      developer.log(e.toString());
    }
    List<int> ids = [];
    for (var element in value) { 
      ids.add(await db!.insert(tableCTDmDiaDiemSXKD, element.toJson()));
    }
    return ids;
  }

  @override
  Future onCreateTable(Database database) async {
    return database.execute('''
      CREATE TABLE IF NOT EXISTS $tableCTDmDiaDiemSXKD
      (
        $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
        $columnMa INTEGER,
        $columnTen TEXT ,
        $columnCTDmDiaDiemSXKDGhiRo INTEGER
      )
      ''');
  }

  @override
  Future<List<Map>> selectAll() async { 
    return await db!.query(tableCTDmDiaDiemSXKD);
  }

  @override
  Future<Map> selectOne(int id) {
    // TODO: implement selectOne
    throw UnimplementedError();
  }

  @override
  Future update(TableCTDmDiaDiemSXKD value, String id) {
    // TODO: implement update
    throw UnimplementedError();
  }

  @override
  Future deletedTable(Database database) async {
    try {
      return await database.rawQuery('DROP TABLE IF EXISTS $tableCTDmDiaDiemSXKD');
    } catch (e) {
      return null;
    }
  }
}
