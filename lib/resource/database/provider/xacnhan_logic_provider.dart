import 'dart:developer' as developer;

import 'package:gov_statistics_investigation_economic/resource/database/table/table_xacnhan_logic.dart';
import 'package:sqflite/sqflite.dart';
import 'package:gov_statistics_investigation_economic/common/common.dart';

import 'package:gov_statistics_investigation_economic/common/utils/utils.dart';
import 'package:gov_statistics_investigation_economic/resource/database/database_helper.dart';
import 'package:gov_statistics_investigation_economic/resource/database/provider/provider.dart';

class XacNhanLogicProvider extends BaseDBProvider<TableXacnhanLogic> {
  static final XacNhanLogicProvider _singleton =
      XacNhanLogicProvider._internal();

  factory XacNhanLogicProvider() {
    return _singleton;
  }

  Database? db;

  XacNhanLogicProvider._internal();

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
      List<TableXacnhanLogic> value, String createdAt) async {
    try {
      await db!.delete(tableXacNhanLogic);
    } catch (e) {
      developer.log(e.toString());
    }
    List<int> ids = [];
    for (var element in value) {
      ids.add(await db!.insert(tableXacNhanLogic, element.toJson()));
    }
    return ids;
  }

  @override
  Future onCreateTable(Database database) async {
    return database.execute('''
      CREATE TABLE IF NOT EXISTS $tableXacNhanLogic
      (
        $columnXnLogicId INTEGER PRIMARY KEY AUTOINCREMENT,
        $columnXnLogicMaDTV TEXT, 
        $columnXnLogicManHinh INTEGER,
        $columnXnLogicIdDoiTuong TEXT, 
         $columnXnLogicMaDoiTuongDT INTEGER, 
        $columnXnLogicIsLogic INTEGER ,  
         $columnXnLogicIsEnableMenuItem INTEGER ,  
         $columnXnLogicNoiDungLogic TEXT, 
        $columnXnLogicMaTrangThaiDT INTEGER 
      )
      ''');
  }

  @override
  Future<List<Map>> selectAll() async {
    throw UnimplementedError();
  }

  @override
  Future<Map> selectOne(int id) {
    // TODO: implement selectOne
    throw UnimplementedError();
  }

  @override
  Future update(TableXacnhanLogic value, String id) {
    // TODO: implement update
    throw UnimplementedError();
  }

  Future<int> insertUpdate(TableXacnhanLogic value,
      {bool? isUpdateEnable}) async {
    var id = 0;
    try {
      List<Map> mapCheck = await db!.query(tableXacNhanLogic, where: '''
        $columnXnLogicMaDTV = '${AppPref.uid}' AND $columnXnLogicManHinh = '${value.manHinh}' AND $columnXnLogicIdDoiTuong = '${value.idDoiTuong}'
    ''');
      if (mapCheck.isNotEmpty) {
        var tblRes = TableXacnhanLogic.listFromJson(mapCheck).first;
        List<String> ndLogics = [];
        if (tblRes.noiDungLogic != '' && tblRes.noiDungLogic != null) {
          var arr = tblRes.noiDungLogic!.split('^');
          var items = arr.where((x) => x != '').toSet().toList();
          ndLogics.addAll(items);
        }
        if (value.noiDungLogic != '' && value.noiDungLogic != null) {
          ndLogics.add(value.noiDungLogic!.trim());
        }
        List<String> ndLogics2 = [];
        if (ndLogics.isNotEmpty) {
          for (var item in ndLogics) {
            var itemTmp = item
                .replaceAll(': ', ':')
                .replaceAll(':  ', ':')
                .replaceAll('\r\n', '')
                .replaceAll('\n', '')
                .replaceAll('\r', '');
            ndLogics2.add(itemTmp);
          }
          final seen = Set<String>();
          final unique = ndLogics2.where((str) => seen.add(str)).toList();
          String ndLogic = unique.join('^');
          value.noiDungLogic = ndLogic;
        }
        if (value.isLogic == 1) {
          value.noiDungLogic = null;
        }

        // String ndLogic = '';
        // for (var item in mapCheck) {
        //   if (item['NoiDungLogic'] != '' && item['NoiDungLogic']!=null) {
        //     ndLogic = item['NoiDungLogic'];
        //   }
        // }
        // if (ndLogic != '') {
        //   ndLogic = '${value.noiDungLogic}^$ndLogic';
        // }
        // if (ndLogic != '') {
        //   value.noiDungLogic = ndLogic;
        // }
        if (isUpdateEnable == true || isUpdateEnable == null) {
          id = await db!.update(tableXacNhanLogic, value.toJson(), where: '''
        $columnXnLogicMaDTV = '${AppPref.uid}' AND $columnXnLogicManHinh = '${value.manHinh}' AND $columnXnLogicIdDoiTuong = '${value.idDoiTuong}'
        ''');
        } else {
          Map<String, Object?> values = {
            'MaDTV': value.maDTV,
            'ManHinh': value.manHinh,
            'IdDoiTuong': value.idDoiTuong,
            'MaDoiTuongDT': value.maDoiTuongDT,
            'IsLogic': value.isLogic,
            'NoiDungLogic': value.noiDungLogic,
            'MaTrangThaiDT': value.maTrangThaiDT
          };

          id = await db!.update(tableXacNhanLogic, values, where: '''
$columnXnLogicMaDTV = '${AppPref.uid}' AND $columnXnLogicManHinh = '${value.manHinh}' AND $columnXnLogicIdDoiTuong = '${value.idDoiTuong}'
             ''');
        }
      } else {
        id = await db!.insert(tableXacNhanLogic, value.toJson());
      }
    } catch (e) {
      developer.log(e.toString());
    }

    return id;
  }

  Future<List<Map>> selectByMaDTVManHinh(
      {required String manHinh, required String idDoiTuongDT}) async {
    List<Map> maps = await db!.rawQuery('''
        SELECT * FROM $tableXacNhanLogic
        WHERE $columnXnLogicMaDTV = '${AppPref.uid}' 
        AND $columnXnLogicManHinh = '$manHinh'  AND $columnXnLogicIdDoiTuong = '$idDoiTuongDT'
      ''');
    return maps;
  }

  Future<List<Map>> selectByIdDoiTuongDT(
      {required String maDoiTuongDT, required String idDoiTuongDT}) async {
    List<Map> maps = await db!.rawQuery('''
        SELECT * FROM $tableXacNhanLogic
        WHERE $columnXnLogicMaDTV = '${AppPref.uid}' 
       AND $columnXnLogicMaDoiTuongDT = '$maDoiTuongDT'
       AND $columnXnLogicIdDoiTuong = '$idDoiTuongDT'
      ''');
    return maps;
  }

  ///idDoiTuongDT: Mã cơ sở sx hoặc mã idho
  Future<String?> kiemTraLogicByIdDoiTuongDT(
      {required String maDoiTuongDT, required String idDoiTuongDT}) async {
    String? result;
    List<Map> maps = await db!.rawQuery('''
        SELECT NoiDungLogic FROM $tableXacNhanLogic
        WHERE $columnXnLogicMaDTV = '${AppPref.uid}' 
       AND $columnXnLogicMaDoiTuongDT = '$maDoiTuongDT'
       AND $columnXnLogicIdDoiTuong = '$idDoiTuongDT'
       AND $columnXnLogicIsLogic=0
      ''');
    List<String?> res = [];
    for (var item in maps) {
      item.forEach((key, value) {
        if (value != null && value != '') {
          res.add(value);
        }
      });
    }
    if (res.isNotEmpty) {
      result = res.join(';');
    }

    return result;
  }

  Future<int> deleteByIdHo(idDoiTuong) {
    var res = db!.delete(tableXacNhanLogic,
        where: '''  $columnXnLogicIdDoiTuong = '$idDoiTuong'  ''');
    return res;
  }
Future<int> deleteByIdHoManHinh(idDoiTuong,manhinh) {
    var res = db!.delete(tableXacNhanLogic,
        where: '''  $columnXnLogicIdDoiTuong = '$idDoiTuong' AND $columnXnLogicManHinh=$manhinh  ''');
    return res;
  }
  @override
  Future deletedTable(Database database) async {
    try {
      return await database.rawQuery('DROP TABLE IF EXISTS $tableXacNhanLogic');
    } catch (e) {
      return null;
    }
  }
}
