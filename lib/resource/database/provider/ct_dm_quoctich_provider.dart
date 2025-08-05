import 'package:gov_statistics_investigation_economic/resource/database/database_helper.dart';
import 'package:gov_statistics_investigation_economic/resource/database/provider/base_db_provider.dart';
import 'package:gov_statistics_investigation_economic/resource/database/table/table_ct_dm_quoctich.dart';
import 'package:sqflite/sqflite.dart';
 
class DmQuocTichProvider extends BaseDBProvider<TableCTDmQuocTich> {
  static final DmQuocTichProvider _singleton = DmQuocTichProvider._internal();

  factory DmQuocTichProvider() {
    return _singleton;
  }

  Database? db;

  DmQuocTichProvider._internal();

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
      List<TableCTDmQuocTich> value, String createdAt) async {
    try {
      await db!.delete(tableDmQuocTich);
    } catch (e) {
      //    developer.log(e.toString());
    }
    List<int> ids = [];
    for (var element in value) {
      ids.add(await db!.insert(tableDmQuocTich, element.toJson()));
    }
    return ids;
  }

  @override
  Future onCreateTable(Database database) async {
    return database.execute('''
      CREATE TABLE IF NOT EXISTS $tableDmQuocTich
      (
        $columnDmQuocTichId INTEGER PRIMARY KEY AUTOINCREMENT,
        $columnDmQuocTichMa INTEGER,
        $columnDmQuocTichTen TEXT 
      )
      ''');
  }

  @override
  Future<List<Map>> selectAll() async {
    return await db!.query(tableDmQuocTich);
  }

  @override
  Future<Map> selectOne(int id) {
    // TODO: implement selectOne
    throw UnimplementedError();
  }

  @override
  Future update(TableCTDmQuocTich value, String id) {
    // TODO: implement update
    throw UnimplementedError();
  }

  @override
  Future deletedTable(Database database) async {
    try {
      return await database.rawQuery('DROP TABLE IF EXISTS $tableDmQuocTich');
    } catch (e) {
      return null;
    }
  }
}
