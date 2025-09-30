import 'dart:developer' as developer;

import 'package:gov_statistics_investigation_economic/resource/database/table/filed_common.dart';
import 'package:gov_statistics_investigation_economic/resource/database/table/table_dm_linhvuc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:gov_statistics_investigation_economic/common/common.dart';

import 'package:gov_statistics_investigation_economic/common/utils/utils.dart';
import 'package:gov_statistics_investigation_economic/resource/database/database_helper.dart';
import 'package:gov_statistics_investigation_economic/resource/database/provider/provider.dart';

class DmLinhvucProvider extends BaseDBProvider<TableDmLinhvuc> {
  static final DmLinhvucProvider _singleton = DmLinhvucProvider._internal();

  factory DmLinhvucProvider() {
    return _singleton;
  }

  Database? db;

  DmLinhvucProvider._internal();

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
  Future<List<int>> insert(List<TableDmLinhvuc> value, String createdAt) async {
    try {
      if (value.isNotEmpty) {
        await db!.delete(tableDmLinhVuc);
      }
    } catch (e) {
      developer.log(e.toString());
    }
    List<int> ids = [];
    try {
      for (var element in value) {
        ids.add(await db!.insert(tableDmLinhVuc, element.toJson()));
      }
    } catch (e) {
      developer.log(e.toString());
    }
    return ids;
  }

  @override
  Future onCreateTable(Database database) async {
    return database.execute('''
      CREATE TABLE IF NOT EXISTS $tableDmLinhVuc
      (
        $columnDmLinhVucId INTEGER PRIMARY KEY AUTOINCREMENT,
        $columnDmLinhVucMaLV TEXT,
        $columnDmLinhVucTenLinhVuc TEXT ,
         $columnDmLinhVucTuKhoa TEXT 
      )
      ''');
  }

  @override
  Future<List<Map>> selectAll() async {
    String createdAt = AppPref.dateTimeSaveDB!;
    return await db!.query(tableDmLinhVuc);
  }

  @override
  Future<Map> selectOne(int id) {
    // TODO: implement selectOne
    throw UnimplementedError();
  }

  @override
  Future update(TableDmLinhvuc value, String id) {
    // TODO: implement update
    throw UnimplementedError();
  }

  Future<Map> getByMaLV(String maLV) async {
    final List<Map> maps = await db!.query(tableDmLinhVuc, where: '''
      $columnDmLinhVucMaLV = '$maLV' 
      ''');

    if (maps.isNotEmpty) {
      return maps[0];
    }
    return {};
  }

  @override
  Future deletedTable(Database database) async {
    try {
      return await database.rawQuery('DROP TABLE IF EXISTS $tableDmLinhVuc');
    } catch (e) {
      return null;
    }
  }
}
