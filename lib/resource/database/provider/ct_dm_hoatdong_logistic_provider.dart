import 'dart:developer' as developer;

import 'package:gov_statistics_investigation_economic/resource/database/database_helper.dart';
import 'package:sqflite/sqflite.dart';

import '../table/table_ct_dm_hoatdong_logistic.dart';
import 'base_db_provider.dart';

class CTDmHoatDongLogisticProvider
    extends BaseDBProvider<TableCTDmHoatDongLogistic> {
  static final CTDmHoatDongLogisticProvider _singleton =
      CTDmHoatDongLogisticProvider._internal();

  factory CTDmHoatDongLogisticProvider() {
    return _singleton;
  }

  Database? db;

  CTDmHoatDongLogisticProvider._internal();

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
      List<TableCTDmHoatDongLogistic> value, String createdAt) async {
    try {
      await db!.delete(tableCTDmHoatDongLogistic);
    } catch (e) {
      developer.log(e.toString());
    }
    List<int> ids = [];
    for (var element in value) {
      ids.add(await db!.insert(tableCTDmHoatDongLogistic, element.toJson()));
    }
    return ids;
  }

  @override
  Future onCreateTable(Database database) async {
    return database.execute('''
      CREATE TABLE IF NOT EXISTS $tableCTDmHoatDongLogistic
      (
        $columnCTDmHoatDongLigisticId INTEGER PRIMARY KEY AUTOINCREMENT,
        $columnCTDmHoatDongLigisticMa INTEGER,
        $columnCTDmHoatDongLigisticTen TEXT 
      )
      ''');
  }

  @override
  Future<List<Map>> selectAll() async {
    return await db!.query(tableCTDmHoatDongLogistic);
  }

  @override
  Future<Map> selectOne(int id) {
    // TODO: implement selectOne
    throw UnimplementedError();
  }

  @override
  Future update(TableCTDmHoatDongLogistic value, String id) {
    // TODO: implement update
    throw UnimplementedError();
  }

  @override
  Future deletedTable(Database database) async {
    try {
      return await database.rawQuery('DROP TABLE IF EXISTS $tableCTDmHoatDongLogistic');
    } catch (e) {
      return null;
    }
  }
}
