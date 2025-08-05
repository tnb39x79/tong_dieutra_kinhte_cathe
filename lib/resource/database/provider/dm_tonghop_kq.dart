import 'dart:developer' as developer;

import 'package:gov_statistics_investigation_economic/resource/database/table/table_dm_tonghop_kq.dart';
import 'package:sqflite/sqflite.dart';
import 'package:gov_statistics_investigation_economic/resource/database/database_helper.dart';
import 'package:gov_statistics_investigation_economic/resource/database/provider/provider.dart';

class DmTongHopKQProvider extends BaseDBProvider<TableDmTongHopKQ> {
  static final DmTongHopKQProvider _singleton = DmTongHopKQProvider._internal();

  factory DmTongHopKQProvider() {
    return _singleton;
  }

  Database? db;

  DmTongHopKQProvider._internal();

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
      List<TableDmTongHopKQ> value, String createdAt) async {
    try {
      await db!.delete(tableDmTongHopKQ);
    } catch (e) {
      developer.log(e.toString());
    }
    List<int> ids = [];
    for (var element in value) {
      ids.add(await db!.insert(tableDmTongHopKQ, element.toJson()));
    }
    return ids;
  }

  @override
  Future onCreateTable(Database database) async {
    return database.execute('''
      CREATE TABLE IF NOT EXISTS $tableDmTongHopKQ
      (
        $columnDmTongHopKQId TEXT PRIMARY KEY,
        $columnDmTongHopKQMaPhieu INTEGER,
        $columnDmTongHopKQMaCauHoi TEXT, 
        $columnDmTongHopKQMaSo TEXT,
         $columnDmTongHopKQTenTruongChiTiet TEXT,
          $columnDmTongHopKQTenTruongTongSo TEXT
      )
      ''');
  }

  @override
  Future<List<Map>> selectAll() async {
    return await db!.query(tableDmTongHopKQ, where: '''
      $columnDmTongHopKQId IS NOT NULL
    ''');
  }

  @override
  Future<Map> selectOne(int id) {
    // TODO: implement selectOne
    throw UnimplementedError();
  }

  Future<Map> selectOneById({required String id}) async {
    List<Map> maps = await db!.rawQuery('''
        SELECT * FROM $tableDmTongHopKQ
        WHERE $columnDmTongHopKQId = '$id'  
      ''');

    return maps.isNotEmpty ? maps[0] : {};
  }

  @override
  Future update(TableDmTongHopKQ value, String id) {
    // TODO: implement update
    throw UnimplementedError();
  }

  @override
  Future deletedTable(Database database) async {
    try {
      return await database.rawQuery('DROP TABLE IF EXISTS $tableDmTongHopKQ');
    } catch (e) {
      return null;
    }
  }
}
