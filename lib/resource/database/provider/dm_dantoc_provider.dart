import 'dart:developer' as developer;

import 'package:gov_statistics_investigation_economic/resource/database/table/filed_common.dart';
import 'package:gov_statistics_investigation_economic/resource/database/table/table_dm_dantoc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:gov_statistics_investigation_economic/resource/database/database_helper.dart';
import 'package:gov_statistics_investigation_economic/resource/database/provider/provider.dart';

class DmDanTocProvider extends BaseDBProvider<TableDmDanToc> {
  static final DmDanTocProvider _singleton = DmDanTocProvider._internal();

  factory DmDanTocProvider() {
    return _singleton;
  }

  Database? db;

  DmDanTocProvider._internal();

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
  Future<List<int>> insert(List<TableDmDanToc> value, String createdAt) async {
    try {
      await db!.delete(tableDmDanToc);
    } catch (e) {
      developer.log(e.toString());
    }
    List<int> ids = [];
    for (var element in value) {
      ids.add(await db!.insert(tableDmDanToc, element.toJson()));
    }
    return ids;
  }

  Future<List<Map>> searchDmDanToc(String keyword) async {
    final List<Map> maps = await db!.query(tableDmDanToc, where: '''
      $columnDmDanTocTenDanToc LIKE '%$keyword%'
      OR $columnDmDanTocTenGoiKhac LIKE '%$keyword%'
      ''');

    return maps;
  }

  @override
  Future onCreateTable(Database database) async {
    return database.execute('''
      CREATE TABLE IF NOT EXISTS $tableDmDanToc
      (
        $columnDmDanTocId INTEGER PRIMARY KEY AUTOINCREMENT,
        $columnDmDanTocMaDanToc TEXT,
        $columnDmDanTocTenDanToc TEXT,
        $columnDmDanTocTenGoiKhac TEXT,
        $columnDmDanTocSTT INTEGER 
      )
      ''');
  }

  @override
  Future<List<Map>> selectAll() async {
    return await db!.query(tableDmDanToc);
  }

  @override
  Future<Map> selectOne(int id) {
    // TODO: implement selectOne
    throw UnimplementedError();
  }

  Future<List<Map>> selectByMaDanToc(String maDanToc) async {
    List<Map> maps = await db!.rawQuery('''
        SELECT * FROM $tableDmDanToc
        WHERE $columnDmDanTocMaDanToc = '$maDanToc' 
      ''');

    return maps;
  }

  @override
  Future update(TableDmDanToc value, String id) {
    // TODO: implement update
    throw UnimplementedError();
  }

  @override
  Future deletedTable(Database database) async {
    try {
      return await database.rawQuery('DROP TABLE IF EXISTS $tableDmDanToc');
    } catch (e) {
      return null;
    }
  }
}
