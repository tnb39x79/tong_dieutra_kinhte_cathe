import 'dart:developer' as developer;
 
import 'package:gov_statistics_investigation_economic/resource/database/table/filed_common.dart';
import 'package:gov_statistics_investigation_economic/resource/database/table/table_tg_dm_xephang_ditich.dart';
 
import 'package:sqflite/sqflite.dart';
 
import 'package:gov_statistics_investigation_economic/resource/database/database_helper.dart';
import 'package:gov_statistics_investigation_economic/resource/database/provider/provider.dart';

class TGDmXepHangDiTichProvider extends BaseDBProvider<TableTGDmXepHangDiTich> {
  static final TGDmXepHangDiTichProvider _singleton =
      TGDmXepHangDiTichProvider._internal();

  factory TGDmXepHangDiTichProvider() {
    return _singleton;
  }

  Database? db;

  TGDmXepHangDiTichProvider._internal();

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
  Future<List<int>> insert(List<TableTGDmXepHangDiTich> value, String createdAt) async {
    try {
      await db!.delete(tableTGDmXepHangDiTich);
    } catch (e) {
      developer.log(e.toString());
    }
    List<int> ids = [];
    for (var element in value) { 
      ids.add(await db!.insert(tableTGDmXepHangDiTich, element.toJson()));
    }
    return ids;
  }

  @override
  Future onCreateTable(Database database) async {
    return database.execute('''
      CREATE TABLE IF NOT EXISTS $tableTGDmXepHangDiTich
      (
        $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
        $columnMa INTEGER,
        $columnTen TEXT 
      )
      ''');
  }

  @override
  Future<List<Map>> selectAll() async { 
    return await db!.query(tableTGDmXepHangDiTich);
  }

  @override
  Future<Map> selectOne(int id) {
    // TODO: implement selectOne
    throw UnimplementedError();
  }

  @override
  Future update(TableTGDmXepHangDiTich value, String id) {
    // TODO: implement update
    throw UnimplementedError();
  }

  @override
  Future deletedTable(Database database) async {
    try {
      return await database.rawQuery('DROP TABLE IF EXISTS $tableTGDmXepHangDiTich');
    } catch (e) {
      return null;
    }
  }
}
