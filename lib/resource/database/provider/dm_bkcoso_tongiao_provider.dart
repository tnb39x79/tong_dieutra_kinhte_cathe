import 'dart:developer' as developer;

import 'package:gov_statistics_investigation_economic/resource/database/table/filed_common.dart';
import 'package:gov_statistics_investigation_economic/resource/database/table/table_dm_bkcoso_tongiao.dart';
import 'package:sqflite/sqflite.dart';
import 'package:gov_statistics_investigation_economic/common/common.dart';
import 'package:gov_statistics_investigation_economic/config/config.dart';
import 'package:gov_statistics_investigation_economic/common/utils/utils.dart';
import 'package:gov_statistics_investigation_economic/resource/database/database_helper.dart';
import 'package:gov_statistics_investigation_economic/resource/database/provider/provider.dart';

///
///Bổ sung điều kiện $columnMaDtv=AppPref.uid
class BKCoSoTonGiaoProvider extends BaseDBProvider<TableBkTonGiao> {
  static final BKCoSoTonGiaoProvider _singleton =
      BKCoSoTonGiaoProvider._internal();

  factory BKCoSoTonGiaoProvider() {
    return _singleton;
  }

  Database? db;

  BKCoSoTonGiaoProvider._internal();

  @override
  Future delete(int id) async {}

  @override
  Future init() async {
    db = await DatabaseHelper.instance.database;
  }

  @override
  Future<List<int>> insert(List<TableBkTonGiao> value, String createdAt,
      {bool? fromGetData = false}) async {
    try {
      await db!
          .delete(tableBkTonGiao, where: '''$columnMaDTV='${AppPref.uid}' ''');
    } catch (e) {
      developer.log(e.toString());
    }
    List<int> ids = [];
    for (var element in value) {
      // if (fromGetData == true &&
      //     element.maTrangThaiDT == AppDefine.hoanThanhPhongVan) {
      //   element.isSyncSuccess = 1;
      // }
      element.createdAt = createdAt;
      //   element.updatedAt = createdAt;
      ids.add(await db!.insert(tableBkTonGiao, element.toJson()));
    }
    return ids;
  }

  @override
  Future onCreateTable(Database database) async {
    return database.execute('''
      CREATE TABLE IF NOT EXISTS $tableBkTonGiao
      (
        $columnBkTonGiaoId INTEGER PRIMARY KEY AUTOINCREMENT, 
        $columnBkTonGiaoIDCoSo TEXT,
        $columnBkTonGiaoMaTinh TEXT,
        $columnBkTonGiaoTenTinh TEXT,
        $columnBkTonGiaoMaHuyen TEXT,
        $columnBkTonGiaoTenHuyen TEXT,
        $columnBkTonGiaoMaXa TEXT,
        $columnBkTonGiaoTenXa TEXT,
        $columnBkTonGiaoMaThon TEXT,
        $columnBkTonGiaoTenThon TEXT,  
        $columnBkTonGiaoTTNT INTERGER,  
        $columnBkTonGiaoMaCoSo INTERGER,
        $columnBkTonGiaoTenCoSo TEXT, 
        $columnBkTonGiaoDiaChi TEXT,
        $columnBkTonGiaoDienThoai TEXT,
        $columnBkTonGiaoEmail TEXT,   
        $columnBkTonGiaoMaTinhTrangHD INTEGER,
        $columnBkTonGiaoMaTrangThaiDT INTEGER,
        $columnBkTonGiaoMaTinhTrangHDTruocTD INTEGER, 
        $columnBkTonGiaoTenNguoiCungCap TEXT, 
        $columnBkTonGiaoDienThoaiNguoiCungCap TEXT, 
        $columnMaDTV TEXT, 
        $columnBkTonGiaoTrangThaiLogic INTEGER,
        $columnBkTonGiaoIsSyncSuccess INTEGER, 
        $columnCreatedAt TEXT,
        $columnUpdatedAt TEXT
      )
      ''');
  }

  @override
  Future<List<Map>> selectAll() async {
    String createdAt = AppPref.dateTimeSaveDB!;
    return await db!.query(tableBkTonGiao, where: '''
      $columnCreatedAt = '$createdAt'  AND $columnMaDTV = '${AppPref.uid}'
    ''');
  }

  @override
  Future<Map> selectOne(int id) {
    // TODO: implement selectOne
    throw UnimplementedError();
  }

  @override
  Future update(TableBkTonGiao value, String id) {
    // TODO: implement update
    throw UnimplementedError();
  }

  Future<int?> countOfUnInterviewed(String maXa) async {
    String createdAt = AppPref.dateTimeSaveDB!;
    int? count = Sqflite.firstIntValue(await db!.rawQuery('''
      SELECT COUNT(*) FROM $tableBkTonGiao
      WHERE $columnBkTonGiaoMaTrangThaiDT IN (${AppDefine.chuaPhongVan}, ${AppDefine.dangPhongVan})
      AND $columnCreatedAt = '$createdAt'
      AND $columnBkTonGiaoMaXa = '$maXa' 
      AND $columnMaDTV = '${AppPref.uid}'
      '''));

    return count;
  }

  Future<int?> countOfUnInterviewedAll() async {
    String createdAt = AppPref.dateTimeSaveDB!;
    int? count = Sqflite.firstIntValue(await db!.rawQuery('''
      SELECT COUNT(*) FROM $tableBkTonGiao
      WHERE $columnBkTonGiaoMaTrangThaiDT IN (${AppDefine.chuaPhongVan}, ${AppDefine.dangPhongVan})
      AND $columnCreatedAt = '$createdAt'
      AND $columnMaDTV = '${AppPref.uid}'
      '''));

    return count;
  }

  Future<int?> countOfInterviewed(String maXa) async {
    String createdAt = AppPref.dateTimeSaveDB!;
    int? count = Sqflite.firstIntValue(await db!.rawQuery('''
      SELECT COUNT(*) FROM $tableBkTonGiao
      WHERE $columnBkTonGiaoMaTrangThaiDT = ${AppDefine.hoanThanhPhongVan} 
      AND $columnCreatedAt = '$createdAt'  
      AND $columnBkTonGiaoMaXa = '$maXa'
      AND $columnMaDTV = '${AppPref.uid}'
      '''));
    return count;
  }

  Future<int?> countOfInterviewedAll() async {
    String createdAt = AppPref.dateTimeSaveDB!;
    int? count = Sqflite.firstIntValue(await db!.rawQuery('''
      SELECT COUNT(*) FROM $tableBkTonGiao
      WHERE $columnBkTonGiaoMaTrangThaiDT = ${AppDefine.hoanThanhPhongVan} 
      AND $columnCreatedAt = '$createdAt'
      AND $columnMaDTV = '${AppPref.uid}'
      '''));
    return count;
  }

  Future<int?> countSyncSuccess() async {
    String createdAt = AppPref.dateTimeSaveDB!;
    int? count = Sqflite.firstIntValue(await db!.rawQuery('''
      SELECT COUNT(*) FROM $tableBkTonGiao
      WHERE $columnBkTonGiaoMaTrangThaiDT = ${AppDefine.hoanThanhPhongVan} 
      AND $columnCreatedAt = '$createdAt'
      AND $columnMaDTV = '${AppPref.uid}'
       AND $columnBkTonGiaoIsSyncSuccess=1
      '''));
    return count;
  }

  Future<List<Map>> selectListUnInterviewed() async {
    String createdAt = AppPref.dateTimeSaveDB!;

    return await db!.rawQuery('''
    SELECT * FROM $tableBkTonGiao
    WHERE $columnCreatedAt = '$createdAt' 
    AND $columnBkTonGiaoMaTrangThaiDT IN (${AppDefine.chuaPhongVan}, ${AppDefine.dangPhongVan})
 
     AND $columnMaDTV = '${AppPref.uid}'
    ''');
  }

  Future<List<Map>> searchListUnInterviewed(String? search) async {
    String createdAt = AppPref.dateTimeSaveDB!;

    return await db!.rawQuery('''
    SELECT * FROM $tableBkTonGiao
    WHERE $columnCreatedAt = '$createdAt' 
    AND $columnBkTonGiaoMaTrangThaiDT IN (${AppDefine.chuaPhongVan}, ${AppDefine.dangPhongVan})
   
    AND $columnMaDTV = '${AppPref.uid}'
    AND $columnBkTonGiaoTenCoSo LIKE '%$search%'
    OR $columnBkTonGiaoTenCoSo LIKE '%$search'
    ''');
  }
//  Future<List<Map>> searchListUnInterviewedSearch(String maXa,String?  search) async {
//     String createdAt = AppPref.dateTimeSaveDB!;

//     return await db!.rawQuery('''
//     SELECT * FROM $tableBkTonGiao
//     WHERE $columnCreatedAt = '$createdAt'
//     AND $columnBkTonGiaoMaTrangThaiDT IN (${AppDefine.chuaPhongVan}, ${AppDefine.dangPhongVan})
//       AND $columnBkTonGiaoMaXa = '$maXa'
//     AND $columnMaDTV = '${AppPref.uid}'
//     AND $columnBkTonGiaoTenCoSo LIKE '%$search%'
//     OR $columnBkTonGiaoTenCoSo LIKE '%$search'
//     ''');
//   }
  Future<List<Map>> selectListInterviewed(String maXa) async {
    String createdAt = AppPref.dateTimeSaveDB ?? "";

    return await db!.rawQuery('''
    SELECT * FROM $tableBkTonGiao
    WHERE $columnCreatedAt = '$createdAt' 
    AND $columnBkTonGiaoMaTrangThaiDT = ${AppDefine.hoanThanhPhongVan}
 
    AND $columnBkTonGiaoMaXa = '$maXa'
     AND $columnMaDTV = '${AppPref.uid}'
    ''');
  }

  Future<List<Map>> searchListInterviewed(search) async {
    String createdAt = AppPref.dateTimeSaveDB ?? "";

    return await db!.rawQuery('''
    SELECT * FROM $tableBkTonGiao
    WHERE $columnCreatedAt = '$createdAt' 
    AND $columnBkTonGiaoMaTrangThaiDT = ${AppDefine.hoanThanhPhongVan} 

     AND $columnMaDTV = '${AppPref.uid}'
    AND $columnBkTonGiaoTenCoSo LIKE '%$search%'
    OR $columnBkTonGiaoTenCoSo LIKE '%$search'
    ''');
  }
//  Future<List<Map>> searchListInterviewedSearch(  search) async {
//     String createdAt = AppPref.dateTimeSaveDB ?? "";

//     return await db!.rawQuery('''
//     SELECT * FROM $tableBkTonGiao
//     WHERE $columnCreatedAt = '$createdAt'
//     AND $columnBkTonGiaoMaTrangThaiDT = ${AppDefine.hoanThanhPhongVan}

//      AND $columnMaDTV = '${AppPref.uid}'
//     AND $columnBkTonGiaoTenCoSo LIKE '%$search%'
//     OR $columnBkTonGiaoTenCoSo LIKE '%$search'
//     ''');
//   }
  Future<List<Map>> selectAllListInterviewedSync() async {
    String createdAt = AppPref.dateTimeSaveDB ?? "";
    print('createdAt: $createdAt');
    return await db!.query(tableBkTonGiao, where: '''
      $columnCreatedAt = '$createdAt'
      AND $columnBkTonGiaoMaTrangThaiDT = ${AppDefine.hoanThanhPhongVan}
      AND NOT $columnUpdatedAt = '$createdAt'
      AND $columnMaDTV='${AppPref.uid}'
    ''');
  }

  Future<List<Map>> selectAllListInterviewed() async {
    String createdAt = AppPref.dateTimeSaveDB ?? "";
    print('createdAt: $createdAt');
    var res = await db!.query(tableBkTonGiao, where: '''
        $columnBkTonGiaoMaTrangThaiDT = ${AppDefine.hoanThanhPhongVan}
     AND $columnCreatedAt = '$createdAt'
      AND $columnMaDTV = '${AppPref.uid}'
    ''');
    return res;
  }

  Future<Map?> getInformation(String idCoSo) async {
    String createdAt = AppPref.dateTimeSaveDB!;
    List<Map> map = await db!.query(tableBkTonGiao, where: '''
      $columnCreatedAt = '$createdAt'
      AND $columnBkTonGiaoIDCoSo = '$idCoSo'
       AND $columnMaDTV='${AppPref.uid}'
    ''');
    if (map.isEmpty) return {};
    return map[0];
  }

  Future<int> selectTrangThaiLogicById({required String idCoSo}) async {
    String createdAt = AppPref.dateTimeSaveDB!;
    List<Map> maps = await db!.rawQuery('''
        SELECT TrangThaiLogic FROM $tableBkTonGiao
        WHERE  $columnCreatedAt = '$createdAt'
      AND $columnBkTonGiaoIDCoSo = '$idCoSo'
       AND $columnMaDTV='${AppPref.uid}'
      ''');
    if (maps.isNotEmpty) {
      if (maps[0] != null) {
        return maps[0]['TrangThaiLogic'] ?? 0;
      }
    }
    return 0;
  }

  Future updateTrangThai(String idCoSo) async {
    Map<String, Object?> values = {
      "MaTrangThaiDT": AppDefine.hoanThanhPhongVan,
      "UpdatedAt": DateTime.now().toIso8601String()
    };
    String createdAt = AppPref.dateTimeSaveDB ?? "";
    developer.log('ID HO: $idCoSo');
    await db!.update(tableBkTonGiao, values,
        where: '$columnBkTonGiaoIDCoSo= ? AND $columnCreatedAt= "$createdAt"',
        whereArgs: [idCoSo]);
    print('updateTrangThai');
    print('db: ${await db!.query(tableBkTonGiao, where: '''
      $columnBkTonGiaoMaTrangThaiDT = ${AppDefine.hoanThanhPhongVan}
    ''')}');
  }

  Future updateTrangThaiDTTinhTrangHD(String idCoSo, int tinhTrangHD) async {
    Map<String, Object?> values = {
      "MaTrangThaiDT": AppDefine.hoanThanhPhongVan,
      "MaTinhTrangHD": tinhTrangHD,
      "UpdatedAt": DateTime.now().toIso8601String()
    };
    String createdAt = AppPref.dateTimeSaveDB ?? "";
    developer.log('ID CoSo: $idCoSo');
    await db!.update(tableBkTonGiao, values,
        where: '$columnBkTonGiaoIDCoSo= ? AND $columnCreatedAt= "$createdAt"',
        whereArgs: [idCoSo]);
    print('updateTrangThai');
  }

  Future updateValues(key, value, String idCoSo,
      {Map<String, Object?>? multiValue}) async {
    String createdAt = AppPref.dateTimeSaveDB ?? "";
    if (multiValue != null) {
      ///Bỏ update trường UpdatedAt vì:
      /// Phiếu sau khi đồng bộ vào sửa phiếu => còn lỗi logic chưa hoàn thành lại phiếu vẫn đồng bộ lên .
      ///multiValue['UpdatedAt'] = DateTime.now().toIso8601String();
      await db!.update(tableBkTonGiao, multiValue,
          where: '$columnBkTonGiaoIDCoSo= ? AND $columnCreatedAt = ? ',
          whereArgs: [idCoSo, createdAt]);
    } else {
      Map<String, Object?> values = {
        key: value,
        "UpdatedAt": DateTime.now().toIso8601String()
      };
      await db!.update(tableBkTonGiao, values,
          where: '$columnBkTonGiaoIDCoSo= ? AND $columnCreatedAt = ? ',
          whereArgs: [idCoSo, createdAt]);
    }
  }

  Future updateValue(key, value, String idCoSo) async {
    String createdAt = AppPref.dateTimeSaveDB ?? "";

    Map<String, Object?> values = {
      key: value,
      "UpdatedAt": DateTime.now().toIso8601String()
    };
    developer.log('ID HO: $idCoSo');
    await db!.update(tableBkTonGiao, values,
        where: '$columnBkTonGiaoIDCoSo= ? AND $columnCreatedAt= "$createdAt"',
        whereArgs: [idCoSo]);
  }

  Future updateSuccess(List idCoSos) async {
    String createdAt = AppPref.dateTimeSaveDB ?? "";

    for (var item in idCoSos) {
      var update = await db!.update(
          tableBkTonGiao, {"UpdatedAt": createdAt, "SyncSuccess": 1},
          where: '$columnBkTonGiaoIDCoSo= ? AND $columnCreatedAt= "$createdAt"',
          whereArgs: [item]);
      developer.log('RESULT UPDATE HO SUCCESS=$update');
    }
  }

  Future updateTrangThaiLogic(fieldName, value, String idCoSo) async {
    String createdAt = AppPref.dateTimeSaveDB ?? "";

    Map<String, Object?> values = {fieldName: value};
    developer.log('ID HO: $idCoSo');
    await db!.update(tableBkTonGiao, values,
        where: '$columnBkTonGiaoIDCoSo= ? AND $columnCreatedAt= "$createdAt"',
        whereArgs: [idCoSo]);
  }

  @override
  Future deletedTable(Database database) async {
    try {
      return await database.rawQuery('DROP TABLE IF EXISTS $tableBkTonGiao');
    } catch (e) {
      return null;
    }
  }
}
