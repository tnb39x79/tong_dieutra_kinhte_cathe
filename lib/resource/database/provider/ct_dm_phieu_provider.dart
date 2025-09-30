import 'package:gov_statistics_investigation_economic/resource/database/database_helper.dart';
import 'package:gov_statistics_investigation_economic/resource/database/provider/base_db_provider.dart';
import 'package:gov_statistics_investigation_economic/resource/database/table/filed_common.dart';
import 'package:gov_statistics_investigation_economic/resource/database/table/table_ct_dm_phieu.dart';
import 'package:sqflite/sqflite.dart';

class DmPhieuProvider extends BaseDBProvider<TableCTDmPhieu> {
  static final DmPhieuProvider _singleton = DmPhieuProvider._internal();

  factory DmPhieuProvider() {
    return _singleton;
  }

  Database? db;

  DmPhieuProvider._internal();

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
  Future<List<int>> insert(List<TableCTDmPhieu> value, String createdAt) async {
    try {
      await db!.delete(tableCTDmPhieu);
    } catch (e) {
      //    developer.log(e.toString());
    }
    List<int> ids = [];
    for (var element in value) {
      ids.add(await db!.insert(tableCTDmPhieu, element.toJson()));
    }
    return ids;
  }

  @override
  Future onCreateTable(Database database) async {
    return database.execute('''
      CREATE TABLE IF NOT EXISTS $tableCTDmPhieu
      (
        $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
        $colPhieuMaPhieu  INTEGER,
        $colPhieuTenPhieu  TEXT,
        $colPhieuBangDuLieu  TEXT,
        $colPhieuGhiChu  TEXT,
        $colPhieuTenHienThi  TEXT,
        $colPhieuTenHienThiCapi  TEXT,
        $colPhieuTenPhieuCapi  TEXT,
        $colPhieuActive  INTEGER
      )
      ''');
  }

  @override
  Future<List<Map>> selectAll() async {
    return await db!.query(tableCTDmPhieu);
  }

  Future<Map> getByMaPhieu(String maPhieu) async {
    final List<Map> maps = await db!.query(tableCTDmPhieu, where: '''
      $colPhieuMaPhieu = '$maPhieu' 
      ''');

    if (maps.isNotEmpty) {
      return maps[0];
    }
    return {};
  }

  @override
  Future<Map> selectOne(int id) {
    // TODO: implement selectOne
    throw UnimplementedError();
  }

  @override
  Future update(TableCTDmPhieu value, String id) {
    // TODO: implement update
    throw UnimplementedError();
  }

  @override
  Future deletedTable(Database database) async {
    try {
      return await database.rawQuery('DROP TABLE IF EXISTS $tableCTDmPhieu');
    } catch (e) {
      return null;
    }
  }
}
