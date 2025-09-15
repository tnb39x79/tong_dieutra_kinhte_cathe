import 'dart:developer' as developer;
import 'package:gov_statistics_investigation_economic/resource/database/table/filed_common.dart';
import 'package:sqflite/sqflite.dart';
import 'package:gov_statistics_investigation_economic/common/utils/utils.dart';
import 'package:gov_statistics_investigation_economic/resource/database/database_helper.dart';
import 'package:gov_statistics_investigation_economic/resource/database/provider/provider.dart';
import 'package:gov_statistics_investigation_economic/resource/database/table/table_data.dart';

class DataProvider extends BaseDBProvider<TableData> {
  static final DataProvider _singleton = DataProvider._internal();

  factory DataProvider() {
    return _singleton;
  }

  Database? db;

  DataProvider._internal();

  @override
  Future delete(int id) async {}

  @override
  Future init() async {
    db = await DatabaseHelper.instance.database;
  }

  @override
  Future<List<int>> insert(List<TableData> value, String createdAt) async {
    try {
      await db!
          .delete(tableData, where: '''$columnDataMaDTV='${AppPref.uid}' ''');
    } catch (e) {
      developer.log(e.toString());
    }
    List<int> ids = [];
    for (var element in value) {
      element.createdAt = createdAt;
      element.updatedAt = createdAt;
      ids.add(await db!.insert(tableData, element.toJson()));
    }
    return ids;
  }

  @override
  Future onCreateTable(Database database) async {
    return await database.execute('''
      CREATE TABLE IF NOT EXISTS $tableData
      (
        $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
        $columnDataMaDTV TEXT,
        $columnDataQuestionMau TEXT,
        $columnDataQuestionTB TEXT,
        $columnCreatedAt TEXT,
        $columnUpdatedAt TEXT
      )
      ''');
  }

  @override
  Future update(TableData value, String id) async {}

  @override
  Future<List<Map>> selectAll() async {
    return await db!.rawQuery('SELECT * FROM $tableData');
  }

  @override
  Future<Map> selectOne(int id) async {
    List<Map> map =
        await db!.rawQuery('SELECT * FROM $tableData WHERE $columnId = $id');
    return map[0];
  }

  Future<Map> selectTop1() async {
    String createdAt = AppPref.dateTimeSaveDB!;
    List<Map> map = await db!.query(
      tableData,
      where:
          ''' $columnDataMaDTV='${AppPref.uid}' AND $columnCreatedAt = '$createdAt' ''',
      limit: 1,
      orderBy: '$columnId DESC',
    );
    return map[0];
  }

  Future<Map> selectOneWithCreatedAt() async {
    String createdAt = AppPref.dateTimeSaveDB!;
    List<Map> map = await db!.query(tableData, where: '''
      $columnCreatedAt = '$createdAt' AND $columnDataMaDTV='${AppPref.uid}'
    ''');
    return map[0];
  }

  @override
  Future deletedTable(Database database) async {
    try {
      return await database.rawQuery('DROP TABLE IF EXISTS $tableData');
    } catch (e) {
      return null;
    }
  }
}
