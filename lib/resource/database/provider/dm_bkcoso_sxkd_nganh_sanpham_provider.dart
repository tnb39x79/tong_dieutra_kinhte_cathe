import 'dart:developer' as developer;

import 'package:gov_statistics_investigation_economic/resource/database/table/filed_common.dart';
import 'package:gov_statistics_investigation_economic/resource/database/table/table_dm_bkcoso_sxkd_nganh_sanpham.dart';

import 'package:sqflite/sqflite.dart';
import 'package:gov_statistics_investigation_economic/resource/database/database_helper.dart';
import 'package:gov_statistics_investigation_economic/resource/database/provider/provider.dart';

class BKCoSoSXKDNganhSanPhamProvider
    extends BaseDBProvider<TableBkCoSoSXKDNganhSanPham> {
  static final BKCoSoSXKDNganhSanPhamProvider _singleton =
      BKCoSoSXKDNganhSanPhamProvider._internal();

  factory BKCoSoSXKDNganhSanPhamProvider() {
    return _singleton;
  }

  Database? db;

  BKCoSoSXKDNganhSanPhamProvider._internal();

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
      List<TableBkCoSoSXKDNganhSanPham> value, String createdAt) async {
    try {
      await db!.delete(tableBkCoSoSXKDNganhSanPham);
    } catch (e) {
      developer.log(e.toString());
    }
    List<int> ids = [];
    for (var element in value) {
      ids.add(await db!.insert(tableBkCoSoSXKDNganhSanPham, element.toJson()));
    }
    return ids;
  }
 Future getDuLieuPVUpdateByIdCoSo(
      TableBkCoSoSXKDNganhSanPham value, String idCoSo, String createAt) async {  
    await db!.update(tableBkCoSoSXKDNganhSanPham, value.toJson(), where: ''' $columnIDCoSo = '$idCoSo'  
    ''');
  }
  @override
  Future onCreateTable(Database database) async {
    return database.execute('''
      CREATE TABLE IF NOT EXISTS $tableBkCoSoSXKDNganhSanPham
      (
        $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
        $columnIDCoSo TEXT,
        $columnBkCoSoSXKDNganhSanPhamMaNganh TEXT,
        $columnBkCoSoSXKDNganhSanPhamTenNganh TEXT
      )
      ''');
  }

  @override
  Future<List<Map>> selectAll() async {
    return await db!.query(tableBkCoSoSXKDNganhSanPham);
  }

  @override
  Future<Map> selectOne(int id) {
    // TODO: implement selectOne
    throw UnimplementedError();
  }

  Future<List<Map>> selectByIdCoSo(String idCoSo) async {
    String sql =
        "SELECT * FROM $tableBkCoSoSXKDNganhSanPham WHERE $columnIDCoSo = '$idCoSo'";

    var maps = await db!.rawQuery(sql);
    return maps;
  }

  Future<List<String>> selectMaNganhByIdCoSo(String idCoSo) async {
    List<String> result = [];
    String sql =
        "SELECT MaNganh FROM $tableBkCoSoSXKDNganhSanPham  WHERE $columnIDCoSo = '$idCoSo'";
    List<Map> map = await db!.rawQuery(sql);
    for (var item in map) {
      item.forEach((key, value) {
        if (value != null) {
          result.add(value);
        }
      });
    }
    return result;
  }

  @override
  Future update(TableBkCoSoSXKDNganhSanPham value, String id) {
    // TODO: implement update
    throw UnimplementedError();
  }

  @override
  Future deletedTable(Database database) async {
    try {
      return await database
          .rawQuery('DROP TABLE IF EXISTS $tableBkCoSoSXKDNganhSanPham');
    } catch (e) {
      return null;
    }
  }
}
