import 'dart:developer' as developer;

import 'package:gov_statistics_investigation_economic/resource/database/table/filed_common.dart';
import 'package:gov_statistics_investigation_economic/resource/database/table/table_dm_bkcoso_sxkd.dart';
import 'package:sqflite/sqflite.dart';
import 'package:gov_statistics_investigation_economic/common/common.dart';
import 'package:gov_statistics_investigation_economic/config/config.dart';
import 'package:gov_statistics_investigation_economic/common/utils/utils.dart';
import 'package:gov_statistics_investigation_economic/resource/database/database_helper.dart';
import 'package:gov_statistics_investigation_economic/resource/database/provider/provider.dart';

///
///Bổ sung điều kiện $columnMaDtv=AppPref.uid
class BKCoSoSXKDProvider extends BaseDBProvider<TableBkCoSoSXKD> {
  static final BKCoSoSXKDProvider _singleton = BKCoSoSXKDProvider._internal();

  factory BKCoSoSXKDProvider() {
    return _singleton;
  }

  Database? db;

  BKCoSoSXKDProvider._internal();

  @override
  Future delete(int id) async {}

  @override
  Future init() async {
    db = await DatabaseHelper.instance.database;
  }

  @override
  Future<List<int>> insert(List<TableBkCoSoSXKD> value, String createdAt,
      {bool? fromGetData = false}) async {
    try {
      await db!
          .delete(tablebkCoSoSXKD, where: '''$columnMaDTV='${AppPref.uid}' ''');
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
      ids.add(await db!.insert(tablebkCoSoSXKD, element.toJson()));
    }
    return ids;
  }

  @override
  Future onCreateTable(Database database) async {
    return database.execute('''
      CREATE TABLE IF NOT EXISTS $tablebkCoSoSXKD
      (
        $columnId INTEGER PRIMARY KEY AUTOINCREMENT, 
        $columnBkCoSoSXKDMaPhieu INTEGER,
       $columnBkCoSoSXKDIDCoSo TEXT,
        $columnBkCoSoSXKDMaTinh TEXT,
        $columnBkCoSoSXKDTenTinh TEXT,
        $columnBkCoSoSXKDMaHuyen TEXT,
        $columnBkCoSoSXKDTenHuyen TEXT,
        $columnBkCoSoSXKDMaXa TEXT,
        $columnBkCoSoSXKDTenXa TEXT,
        $columnBkCoSoSXKDMaThon TEXT,
        $columnBkCoSoSXKDTenThon TEXT,
        $columnBkCoSoSXKDMaDiaBan TEXT,
        $columnBkCoSoSXKDTenDiaBan TEXT,
        $columnBkCoSoSXKDMaDiaDiem TEXT,
        $columnBkCoSoSXKDTenDiaDiem TEXT,
        $columnBkCoSoSXKDMaCoSo INTEGER,
        $columnBkCoSoSXKDTenCoSo TEXT,
        $columnbkCoSoSXKDMaSoThue TEXT,
         
        $columnBkCoSoSXKDDiaChi TEXT,
        $columnBkCoSoSXKDDienThoai TEXT,      
        $columnBkCoSoSXKDEmail TEXT, 
        $columnBkCoSoSXKDDoanhThu REAL,
        $columnBkCoSoSXKDSoLaoDong INTEGER,  
        $columnBkCoSoSXKDMaTinhTrangHD INTEGER,
        $columnBkCoSoSXKDMaTrangThaiDT INTEGER,
        $columnBkCoSoSXKDMaTinhTrangHDTruocTD INTEGER,
        $columnBkCoSoSXKDTenNguoiCungCap TEXT, 
        $columnBkCoSoSXKDDienThoaiNguoiCungCap TEXT, 
        $columnBkCoSoSXKDIDCoSoDuPhong TEXT,
        $columnBkCoSoSXKDIDCoSoThayThe TEXT,
        $columnMaDTV TEXT,
        $columnBkCoSoSXKDLoaiDieuTra INTEGER, 
        $columnBkCoSoSXKDTrangThaiLogic INTEGER, 
        $columnBkCoSoSXKDIsSyncSuccess INTEGER, 
        $columnCreatedAt TEXT,
        $columnUpdatedAt TEXT
      )
      ''');
  }

  @override
  Future<List<Map>> selectAll() async {
    String createdAt = AppPref.dateTimeSaveDB!;
    return await db!.query(tablebkCoSoSXKD, where: '''
      $columnCreatedAt = '$createdAt'  AND $columnMaDTV = '${AppPref.uid}'
    ''');
  }

  @override
  Future<Map> selectOne(int id) {
    // TODO: implement selectOne
    throw UnimplementedError();
  }

  @override
  Future update(TableBkCoSoSXKD value, String id) {
    // TODO: implement update
    throw UnimplementedError();
  }

  Future<int?> countOfUnInterviewed(int maDoiTuongDT, String maDiaBan) async {
    String createdAt = AppPref.dateTimeSaveDB!;
    int? count = Sqflite.firstIntValue(await db!.rawQuery('''
      SELECT COUNT(*) FROM $tablebkCoSoSXKD
      WHERE $columnBkCoSoSXKDMaTrangThaiDT IN (${AppDefine.chuaPhongVan}, ${AppDefine.dangPhongVan})
      AND $columnCreatedAt = '$createdAt'
      AND $columnMaDTV = '${AppPref.uid}'
      AND $columnMaPhieu = '$maDoiTuongDT' 
      AND $columnBkCoSoSXKDMaDiaBan = '$maDiaBan'
      '''));

    return count;
  }

  Future<int?> countOfUnInterviewedAll(int maDoiTuongDT) async {
    String createdAt = AppPref.dateTimeSaveDB!;
    int? count = Sqflite.firstIntValue(await db!.rawQuery('''
      SELECT COUNT(*) FROM $tablebkCoSoSXKD
      WHERE $columnBkCoSoSXKDMaTrangThaiDT IN (${AppDefine.chuaPhongVan}, ${AppDefine.dangPhongVan})
      AND $columnCreatedAt = '$createdAt'
      AND $columnMaDTV = '${AppPref.uid}'
      AND $columnMaPhieu = '$maDoiTuongDT' 
      '''));

    return count;
  }

  Future<int?> countOfInterviewed(int maDoiTuongDT, String maDiaBan) async {
    String createdAt = AppPref.dateTimeSaveDB!;
    int? count = Sqflite.firstIntValue(await db!.rawQuery('''
      SELECT COUNT(*) FROM $tablebkCoSoSXKD
      WHERE $columnBkCoSoSXKDMaTrangThaiDT = ${AppDefine.hoanThanhPhongVan} 
      AND $columnCreatedAt = '$createdAt'
      AND $columnBkCoSoSXKDMaPhieu = $maDoiTuongDT
      AND $columnBkCoSoSXKDMaDiaBan = '$maDiaBan'
      AND $columnMaDTV = '${AppPref.uid}'
      '''));
    return count;
  }

  Future<int?> countOfInterviewedAll(int maDoiTuongDT) async {
    String createdAt = AppPref.dateTimeSaveDB!;
    int? count = Sqflite.firstIntValue(await db!.rawQuery('''
      SELECT COUNT(*) FROM $tablebkCoSoSXKD
      WHERE $columnBkCoSoSXKDMaTrangThaiDT = ${AppDefine.hoanThanhPhongVan} 
      AND $columnCreatedAt = '$createdAt'
      AND $columnMaDTV = '${AppPref.uid}'
       AND $columnMaPhieu = '$maDoiTuongDT' 
      '''));
    return count;
  }

  Future<int?> countSyncSuccess() async {
    String createdAt = AppPref.dateTimeSaveDB!;
    int? count = Sqflite.firstIntValue(await db!.rawQuery('''
      SELECT COUNT(*) FROM $tablebkCoSoSXKD
      WHERE $columnBkCoSoSXKDMaTrangThaiDT = ${AppDefine.hoanThanhPhongVan} 
      AND $columnCreatedAt = '$createdAt'
      AND $columnMaDTV = '${AppPref.uid}'
      AND $columnBkCoSoSXKDIsSyncSuccess=1
      '''));
    return count;
  }

  Future<int?> countSyncSuccessAll(int maDoiTuongDT) async {
    String createdAt = AppPref.dateTimeSaveDB!;
    int? count = Sqflite.firstIntValue(await db!.rawQuery('''
      SELECT COUNT(*) FROM $tablebkCoSoSXKD
      WHERE $columnBkCoSoSXKDMaTrangThaiDT = ${AppDefine.hoanThanhPhongVan} 
      AND $columnCreatedAt = '$createdAt'
      AND $columnMaDTV = '${AppPref.uid}'
      AND $columnBkCoSoSXKDIsSyncSuccess=1
        AND $columnMaPhieu = '$maDoiTuongDT' 
      '''));
    return count;
  }

  Future<List<Map>> selectListUnInterviewedAll(
      int maDoiTuongDT, String maDiaBan) async {
    String createdAt = AppPref.dateTimeSaveDB!;

    return await db!.rawQuery('''
    SELECT * FROM $tablebkCoSoSXKD
    WHERE $columnCreatedAt = '$createdAt' 
    AND $columnBkCoSoSXKDMaTrangThaiDT IN (${AppDefine.chuaPhongVan}, ${AppDefine.dangPhongVan})    
    AND $columnMaDTV = '${AppPref.uid}'
    AND $columnBkCoSoSXKDMaPhieu = $maDoiTuongDT
    AND $columnBkCoSoSXKDMaDiaBan = '$maDiaBan'
    ''');
  }

  Future<List<Map>> searchListUnInterviewedAll(
      int maDoiTuongDT, String maDiaBan, String search) async {
    String createdAt = AppPref.dateTimeSaveDB!;

    return await db!.rawQuery('''
    SELECT * FROM $tablebkCoSoSXKD
    WHERE $columnCreatedAt = '$createdAt' 
    AND $columnBkCoSoSXKDMaTrangThaiDT IN (${AppDefine.chuaPhongVan}, ${AppDefine.dangPhongVan})
    AND $columnBkCoSoSXKDMaDiaBan = '$maDiaBan'
    AND $columnBkCoSoSXKDMaPhieu = '$maDoiTuongDT'
    AND $columnMaDTV = '${AppPref.uid}'
    AND $columnBkCoSoSXKDTenCoSo LIKE '%$search%'
    OR $columnBkCoSoSXKDTenCoSo LIKE '%$search'
    ''');
  }

  Future<List<Map>> selectListInterviewedAll(
      int maDoiTuongDT, String maDiaBan) async {
    String createdAt = AppPref.dateTimeSaveDB ?? "";

    return await db!.rawQuery('''
    SELECT * FROM $tablebkCoSoSXKD
    WHERE $columnCreatedAt = '$createdAt' 
    AND $columnBkCoSoSXKDMaTrangThaiDT = ${AppDefine.hoanThanhPhongVan}
     AND $columnMaDTV = '${AppPref.uid}'
    AND $columnBkCoSoSXKDMaDiaBan = '$maDiaBan'
    AND $columnBkCoSoSXKDMaPhieu = '$maDoiTuongDT'
    ''');
  }

  Future<List<Map>> searchListInterviewedAll(
      int maDoiTuongDT, String maDiaBan, String search) async {
    String createdAt = AppPref.dateTimeSaveDB!;

    return await db!.rawQuery('''
    SELECT * FROM $tablebkCoSoSXKD
    WHERE $columnCreatedAt = '$createdAt' 
    AND $columnBkCoSoSXKDMaTrangThaiDT = ${AppDefine.hoanThanhPhongVan}
    AND $columnBkCoSoSXKDMaDiaBan = '$maDiaBan'
    AND $columnBkCoSoSXKDMaPhieu = '$maDoiTuongDT'
    AND $columnMaDTV = '${AppPref.uid}'
    AND $columnBkCoSoSXKDTenCoSo LIKE '%$search%'
    OR $columnBkCoSoSXKDTenCoSo LIKE '%$search'
    ''');
  }

  Future<List<Map>> selectAllListInterviewedSync() async {
    String createdAt = AppPref.dateTimeSaveDB ?? "";
    print('createdAt: $createdAt');
    return await db!.query(tablebkCoSoSXKD, where: '''
      $columnCreatedAt = '$createdAt'
      AND $columnBkCoSoSXKDMaTrangThaiDT = ${AppDefine.hoanThanhPhongVan}
      AND NOT $columnUpdatedAt = '$createdAt'
      AND $columnMaDTV='${AppPref.uid}'
    ''');
  }

  Future<List<Map>> selectAllListInterviewed() async {
    String createdAt = AppPref.dateTimeSaveDB ?? "";
    print('createdAt: $createdAt');
    return await db!.query(tablebkCoSoSXKD, where: '''
      $columnCreatedAt = '$createdAt'
      AND $columnBkCoSoSXKDMaTrangThaiDT = ${AppDefine.hoanThanhPhongVan}
      AND NOT $columnUpdatedAt = '$createdAt'
      AND $columnMaDTV='${AppPref.uid}'
    ''');
  }

  Future<Map?> getInformation(String idCoSo) async {
    String createdAt = AppPref.dateTimeSaveDB!;
    List<Map> map = await db!.query(tablebkCoSoSXKD, where: '''
      $columnCreatedAt = '$createdAt'
      AND $columnBkCoSoSXKDIDCoSo = '$idCoSo'
       AND $columnMaDTV='${AppPref.uid}'
    ''');
    if (map.isEmpty) return {};
    return map[0];
  }

  Future<int> selectTrangThaiLogicById({required String idCoSo}) async {
    String createdAt = AppPref.dateTimeSaveDB!;
    List<Map> maps = await db!.rawQuery('''
        SELECT TrangThaiLogic FROM $tablebkCoSoSXKD
        WHERE  $columnCreatedAt = '$createdAt'
      AND $columnBkCoSoSXKDIDCoSo = '$idCoSo'
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
    await db!.update(tablebkCoSoSXKD, values,
        where: '$columnBkCoSoSXKDIDCoSo= ? AND $columnCreatedAt= "$createdAt"',
        whereArgs: [idCoSo]);
    print('updateTrangThai');
    print('db: ${await db!.query(tablebkCoSoSXKD, where: '''
      $columnBkCoSoSXKDMaTrangThaiDT = ${AppDefine.hoanThanhPhongVan}
    ''')}');
  }

  Future updateTrangThaiDTTinhTrangHD(String idCoSo, int tinhTrangHD) async {
    Map<String, Object?> values = {
      columnBkCoSoSXKDMaTrangThaiDT: AppDefine.hoanThanhPhongVan,
      columnBkCoSoSXKDMaTinhTrangHD: tinhTrangHD,
      "UpdatedAt": DateTime.now().toIso8601String()
    };
    String createdAt = AppPref.dateTimeSaveDB ?? "";
    developer.log('ID HO: $idCoSo');
    var res = await db!.update(tablebkCoSoSXKD, values,
        where: '$columnBkCoSoSXKDIDCoSo= ? AND $columnCreatedAt= "$createdAt"',
        whereArgs: [idCoSo]);
    print('updateTrangThai $res');
  }

  Future updateValues(String idCoSo, {Map<String, Object?>? multiValue}) async {
    String createdAt = AppPref.dateTimeSaveDB ?? "";
    if (multiValue != null) {
      ///Bỏ update trường UpdatedAt vì:
      /// Phiếu sau khi đồng bộ vào sửa phiếu => còn lỗi logic chưa hoàn thành lại phiếu vẫn đồng bộ lên .
      ///multiValue['UpdatedAt'] = DateTime.now().toIso8601String();
      await db!.update(tablebkCoSoSXKD, multiValue,
          where: '$columnBkCoSoSXKDIDCoSo= ? AND $columnCreatedAt = ? ',
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
    await db!.update(tablebkCoSoSXKD, values,
        where: '$columnBkCoSoSXKDIDCoSo= ? AND $columnCreatedAt= "$createdAt"',
        whereArgs: [idCoSo]);
  }

  Future updateSuccess(List idCoSos) async {
    String createdAt = AppPref.dateTimeSaveDB ?? "";

    for (var item in idCoSos) {
      var update = await db!.update(
          tablebkCoSoSXKD, {"UpdatedAt": createdAt, "SyncSuccess": 1},
          where:
              '$columnBkCoSoSXKDIDCoSo= ? AND $columnCreatedAt= "$createdAt"',
          whereArgs: [item]);
      developer.log('RESULT UPDATE CSSXKD SUCCESS=$update');
    }
  }

  Future updateTrangThaiLogic(fieldName, value, String idCoSo) async {
    String createdAt = AppPref.dateTimeSaveDB ?? "";

    Map<String, Object?> values = {fieldName: value};
    developer.log('ID HO: $idCoSo');
    await db!.update(tablebkCoSoSXKD, values,
        where: '$columnBkCoSoSXKDIDCoSo= ? AND $columnCreatedAt= "$createdAt"',
        whereArgs: [idCoSo]);
  }

  Future<int> deleteByCoSoId(String coSoId) {
    var res =
        db!.delete(tablebkCoSoSXKD, where: '''  $columnIDCoSo = '$coSoId'  ''');
    return res;
  }

  @override
  Future deletedTable(Database database) async {
    try {
      return await database.rawQuery('DROP TABLE IF EXISTS $tablebkCoSoSXKD');
    } catch (e) {
      return null;
    }
  }
}
