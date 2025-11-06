import 'dart:developer' as developer;
import 'package:gov_statistics_investigation_economic/common/utils/app_pref.dart';
import 'package:gov_statistics_investigation_economic/resource/database/table/filed_common.dart';
import 'package:gov_statistics_investigation_economic/resource/database/table/table_user_info.dart';
import 'package:sqflite/sqflite.dart';
import 'package:gov_statistics_investigation_economic/resource/database/database_helper.dart';

import 'base_db_provider.dart';

class UserInfoProvider extends BaseDBProvider<TableUserInfo> {
  static final UserInfoProvider _singleton = UserInfoProvider._internal();

  factory UserInfoProvider() {
    return _singleton;
  }

  Database? db;

  UserInfoProvider._internal();

  @override
  Future delete(int id) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future init() async {
    db = await DatabaseHelper.instance.database;
  }

  @override
  Future<List<int>> insert(List<TableUserInfo> value, String createdAt) async {
    try {
      await db!.delete(tableUserInfo,
          where: '''$columnUserInfoMaDangNhap='${AppPref.uid}' ''');
    } catch (e) {
      developer.log(e.toString());
    }
    List<int> ids = [];
    for (var element in value) {
      element.createdAt = createdAt;
      element.updatedAt = createdAt;
      ids.add(await db!.insert(tableUserInfo, element.toJson()));
    }
    return ids;
  }

  @override
  Future onCreateTable(Database database) async {
    return await database.execute('''
      CREATE TABLE IF NOT EXISTS $tableUserInfo
      (
        $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
        $columnUserInfoMaDangNhap TEXT,
        $columnUserInfoTenNguoiDung TEXT,
        $columnUserInfoMatKhau TEXT,
        $columnUserInfoMaTinh TEXT,
        $columnUserInfoMaTKCS TEXT,
        $columnUserInfoDiaChi TEXT,
        $columnUserInfoSDT TEXT,
        $columnUserInfoGhiChu TEXT,
        $columnUserInfoNgayCapNhat   TEXT,
        $columnUserInfoActive INTERGER,
        $columnUserInfoImei   TEXT, 
        $columnCreatedAt TEXT,
        $columnUpdatedAt TEXT,
        $columnUserInfoIsSuccess INTEGER
      )
      ''');
  }

  @override
  Future<List<Map>> selectAll() {
    // TODO: implement selectAll
    throw UnimplementedError();
  }

  @override
  Future<Map> selectOne(int id) {
    // TODO: implement selectOne
    throw UnimplementedError();
  }

  @override
  Future update(TableUserInfo value, String id) {
    // TODO: implement update
    throw UnimplementedError();
  }

  Future<Map?> selectLastOneWithId(String maDangNhap) async {
    try {
      String sql =
          "SELECT * FROM $tableUserInfo  WHERE $columnUserInfoMaDangNhap = '$maDangNhap' ORDER BY $columnUserInfoId DESC LIMIT 1";
      var map = await db!.rawQuery(sql);
      if (map.isNotEmpty) {
        return map[0];
      } else {
        return null;
      }
    } on DatabaseException catch (e) {
      developer.log(e.toString());
      return null;
    } catch (e) {
      return null;
    }
  }

  @override
  Future deletedTable(Database database) async {
    try {
      return await database.rawQuery('DROP TABLE IF EXISTS $tableUserInfo');
    } catch (e) {
      return null;
    }
  }
}
