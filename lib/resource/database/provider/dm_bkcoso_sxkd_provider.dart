import 'dart:developer' as developer;

import 'package:gov_statistics_investigation_economic/resource/database/table/filed_common.dart';
import 'package:gov_statistics_investigation_economic/resource/database/table/table_dm_bkcoso_sxkd.dart';
import 'package:gov_statistics_investigation_economic/resource/database/table/table_phieu.dart';
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

 Future<List<int>> getDuLieuPVInsert(List<TableBkCoSoSXKD> value, String createdAt,
      {bool? fromGetData = false}) async {
   
    List<int> ids = [];
    for (var element in value) { 
      element.createdAt = createdAt; 
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
       

        $colBkCoSoSXKDIDCoSo  TEXT,
        $colBkCoSoSXKDLoaiPhieu  INTEGER,
        $colBkCoSoSXKDMaTinh  TEXT,
        $colBkCoSoSXKDTenTinh  TEXT,
        $colBkCoSoSXKDMaTKCS  TEXT,
        $colBkCoSoSXKDTenTKCS  TEXT,
        $colBkCoSoSXKDMaXa  TEXT,
        $colBkCoSoSXKDTenXa  TEXT,
        $colBkCoSoSXKDMaThon  TEXT,
        $colBkCoSoSXKDTenThon  TEXT,
        $colBkCoSoSXKDIDDB  TEXT,
        $colBkCoSoSXKDMaDiaBan  TEXT,
        $colBkCoSoSXKDTenDiaBan  TEXT,
        $colBkCoSoSXKDMaCoSo  INTEGER,
        $colBkCoSoSXKDTenCoSo  TEXT,
        $colBkCoSoSXKDDiaChi  TEXT,
        $colBkCoSoSXKDTenChuCoSo  TEXT,
        $colBkCoSoSXKDMaDiaDiem  INTEGER,
        $colBkCoSoSXKDDienThoai  TEXT,
        $colBkCoSoSXKDEmail  TEXT,
        $colBkCoSoSXKDSoLaoDong  INTEGER,
        $colBkCoSoSXKDDoanhThu  REAL,
        $colBkCoSoSXKDMaTinhTrangHD  INTEGER,
        $colBkCoSoSXKDTenNguoiCungCap  TEXT,
        $colBkCoSoSXKDDienThoaiNguoiCungCap  TEXT,
        $colBkCoSoSXKDMaDTV  TEXT,
        $colBkCoSoSXKDMaTrangThaiDT  INTEGER, 
        $colBkCoSoSXKDMaTrangThaiDT2  INTEGER, 
        $colBkCoSoSXKDTrangThaiLogic INTEGER, 
        $colBkCoSoSXKDIsSyncSuccess INTEGER, 
        
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

  Future<List<Map>> selectAllNotMaTrangThaiDT2(
      List<String> idCoSoDangPV) async {
    String createdAt = AppPref.dateTimeSaveDB!;
    if (idCoSoDangPV.isEmpty) {
      return await db!.query(tablebkCoSoSXKD, where: '''
      $columnCreatedAt = '$createdAt'  AND $columnMaDTV = '${AppPref.uid}'
      
    ''');
    } else {
      return await db!.query(tablebkCoSoSXKD, where: '''
      $columnCreatedAt = '$createdAt'  AND $columnMaDTV = '${AppPref.uid}'
      AND   $colBkCoSoSXKDIDCoSo  not in (${idCoSoDangPV.map((e) => "'$e'").join(', ')})
    ''');
    }
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

  Future getDuLieuPVUpdateByIdCoSo(
      TableBkCoSoSXKD value, String idCoSo, String createAt) async {
    await db!.update(tablebkCoSoSXKD, value.toJsonGetDLPV(), where: '''
      $columnCreatedAt = '$createAt' AND $colBkCoSoSXKDIDCoSo = '$idCoSo' 
      AND $columnMaDTV= '${AppPref.uid}'
    ''');
  }

  Future<List<Map>> selectAllByIdCoSoMaThaiDT2(int maTrangThaiDT2) async {
    String createdAt = AppPref.dateTimeSaveDB!;
    List<Map> map = await db!.rawQuery('''
          SELECT * FROM $tablebkCoSoSXKD  
          WHERE  $columnCreatedAt = '$createdAt'
          AND $colBkCoSoSXKDMaTrangThaiDT2 = $maTrangThaiDT2
        ''');
    return map;
  }

  Future<Map> selectByIdCoSo(String idCoSo) async {
    String createdAt = AppPref.dateTimeSaveDB!;
    List<Map> map = await db!.rawQuery('''
          SELECT * FROM $tablebkCoSoSXKD 
          WHERE $colBkCoSoSXKDIDCoSo = '$idCoSo' 
          AND $columnCreatedAt = '$createdAt'
        ''');
    return map.isNotEmpty ? map[0] : {};
  }

  Future<String> selectTenXaByIdCoSo(String maXa) async {
    String createdAt = AppPref.dateTimeSaveDB!;
    String result = '';
    List<Map> map = await db!.rawQuery('''
          SELECT TenXa FROM $tablebkCoSoSXKD 
          WHERE $colBkCoSoSXKDMaXa = '$maXa' 
          AND $columnCreatedAt = '$createdAt'
          LIMIT 1
        ''');
    for (var item in map) {
      item.forEach((key, value) {
        if (value != null) {
          result = value;
        }
      });
    }
    return result;
  }

  Future<int?> countAll(int maDoiTuongDT) async {
    String createdAt = AppPref.dateTimeSaveDB!;
    int? count = Sqflite.firstIntValue(await db!.rawQuery('''
      SELECT COUNT(*) FROM $tablebkCoSoSXKD 
      WHERE $columnCreatedAt = '$createdAt'
      AND $columnMaDTV = '${AppPref.uid}' 
      AND $columnMaPhieu = $maDoiTuongDT
      '''));
    return count;
  }

  Future<int?> countOfUnInterviewed(
      int maDoiTuongDT, String maDiaBan, String maXa) async {
    String createdAt = AppPref.dateTimeSaveDB!;
    int? count = Sqflite.firstIntValue(await db!.rawQuery('''
      SELECT COUNT(*) FROM $tablebkCoSoSXKD
      WHERE $colBkCoSoSXKDMaTrangThaiDT IN (${AppDefine.chuaPhongVan}, ${AppDefine.dangPhongVan})
      AND $columnCreatedAt = '$createdAt'
      AND $columnMaDTV = '${AppPref.uid}'
      AND $columnMaPhieu = '$maDoiTuongDT' 
      AND $colBkCoSoSXKDMaDiaBan = '$maDiaBan'
      AND $colBkCoSoSXKDMaXa = '$maXa'
      '''));

    return count;
  }

  Future<int?> countOfUnInterviewedAll(int maDoiTuongDT) async {
    String createdAt = AppPref.dateTimeSaveDB!;
    int? count = Sqflite.firstIntValue(await db!.rawQuery('''
      SELECT COUNT(*) FROM $tablebkCoSoSXKD
      WHERE $colBkCoSoSXKDMaTrangThaiDT IN (${AppDefine.chuaPhongVan}, ${AppDefine.dangPhongVan})
      AND $columnCreatedAt = '$createdAt'
      AND $columnMaDTV = '${AppPref.uid}'
      AND $columnMaPhieu = $maDoiTuongDT
      '''));

    return count;
  }

  Future<int?> countOfInterviewed(
      int maDoiTuongDT, String maDiaBan, String maXa) async {
    String createdAt = AppPref.dateTimeSaveDB!;
    int? count = Sqflite.firstIntValue(await db!.rawQuery('''
      SELECT COUNT(*) FROM $tablebkCoSoSXKD
      WHERE $colBkCoSoSXKDMaTrangThaiDT = ${AppDefine.hoanThanhPhongVan} 
      AND $columnCreatedAt = '$createdAt'
      AND $colBkCoSoSXKDLoaiPhieu = $maDoiTuongDT
      AND $colBkCoSoSXKDMaDiaBan = '$maDiaBan'
      AND $colBkCoSoSXKDMaXa = '$maXa'
      AND $columnMaDTV = '${AppPref.uid}'
      '''));
    return count;
  }

  Future<int?> countOfInterviewedAll(int maDoiTuongDT) async {
    String createdAt = AppPref.dateTimeSaveDB!;
    int? count = Sqflite.firstIntValue(await db!.rawQuery('''
      SELECT COUNT(*) FROM $tablebkCoSoSXKD
      WHERE $colBkCoSoSXKDMaTrangThaiDT = ${AppDefine.hoanThanhPhongVan} 
      AND $columnCreatedAt = '$createdAt'
      AND $columnMaDTV = '${AppPref.uid}'
       AND $columnMaPhieu = $maDoiTuongDT
      '''));
    return count;
  }

// AND ($colBkCoSoSXKDIsSyncSuccess=${AppDefine.synced} OR $colBkCoSoSXKDIsSyncSuccess=${AppDefine.unSync} OR $colBkCoSoSXKDIsSyncSuccess=0 OR $colBkCoSoSXKDIsSyncSuccess is null)
  Future<int?> countSyncSuccess() async {
    String createdAt = AppPref.dateTimeSaveDB!;
    int? count = Sqflite.firstIntValue(await db!.rawQuery('''
      SELECT COUNT(*) FROM $tablebkCoSoSXKD
      WHERE $colBkCoSoSXKDMaTrangThaiDT = ${AppDefine.hoanThanhPhongVan} 
      AND $columnCreatedAt = '$createdAt'
      AND $columnMaDTV = '${AppPref.uid}'
     AND ($colBkCoSoSXKDIsSyncSuccess=${AppDefine.synced})
      '''));
    return count;
  }

// AND $colBkCoSoSXKDIsSyncSuccess=${AppDefine.synced}
  Future<int?> countSyncSuccessAll(int maDoiTuongDT) async {
    String createdAt = AppPref.dateTimeSaveDB!;
    int? count = Sqflite.firstIntValue(await db!.rawQuery('''
      SELECT COUNT(*) FROM $tablebkCoSoSXKD
      WHERE $colBkCoSoSXKDMaTrangThaiDT = ${AppDefine.hoanThanhPhongVan} 
      AND $columnCreatedAt = '$createdAt'
      AND $columnMaDTV = '${AppPref.uid}'
     
        AND $columnMaPhieu = $maDoiTuongDT
      '''));
    return count;
  }

  //AND $colBkCoSoSXKDIsSyncSuccess=${AppDefine.unSync}
  Future<int?> countPhieuUnSyncAll(int maDoiTuongDT) async {
    String createdAt = AppPref.dateTimeSaveDB!;
    int? count = Sqflite.firstIntValue(await db!.rawQuery('''
      SELECT COUNT(*) FROM $tablebkCoSoSXKD
      WHERE $colBkCoSoSXKDMaTrangThaiDT in (  ${AppDefine.dangPhongVan} ,${AppDefine.chuaPhongVan} )
      AND $columnCreatedAt = '$createdAt'
      AND $columnMaDTV = '${AppPref.uid}'
      
       
        AND $columnMaPhieu = $maDoiTuongDT
      '''));
    return count;
  }

  Future<List<Map>> selectListUnInterviewedAll(
      int maDoiTuongDT, String maDiaBan, String maXa) async {
    String createdAt = AppPref.dateTimeSaveDB!;

    return await db!.rawQuery('''
    SELECT * FROM $tablebkCoSoSXKD
    WHERE $columnCreatedAt = '$createdAt' 
    AND $colBkCoSoSXKDMaTrangThaiDT IN (${AppDefine.chuaPhongVan}, ${AppDefine.dangPhongVan})    
    AND $columnMaDTV = '${AppPref.uid}'
    AND $colBkCoSoSXKDLoaiPhieu = $maDoiTuongDT
    AND $colBkCoSoSXKDMaDiaBan = '$maDiaBan'
    AND $colBkCoSoSXKDMaXa = '$maXa'
    ''');
  }

  Future<List<Map>> searchListUnInterviewedAll(
      int maDoiTuongDT, String maDiaBan, String maXa, String search) async {
    String createdAt = AppPref.dateTimeSaveDB!;

    return await db!.rawQuery('''
    SELECT * FROM $tablebkCoSoSXKD
    WHERE $columnCreatedAt = '$createdAt' 
    AND $colBkCoSoSXKDMaTrangThaiDT IN (${AppDefine.chuaPhongVan}, ${AppDefine.dangPhongVan})
    AND $colBkCoSoSXKDMaDiaBan = '$maDiaBan'
    AND $colBkCoSoSXKDLoaiPhieu = '$maDoiTuongDT'
    AND $colBkCoSoSXKDMaXa = '$maXa'
    AND $columnMaDTV = '${AppPref.uid}'
    AND $colBkCoSoSXKDTenCoSo LIKE '%$search%'
    OR $colBkCoSoSXKDTenCoSo LIKE '%$search'
    ''');
  }

  Future<List<Map>> selectListInterviewedAll(
      int maDoiTuongDT, String maDiaBan, String maXa) async {
    String createdAt = AppPref.dateTimeSaveDB ?? "";

    return await db!.rawQuery('''
    SELECT * FROM $tablebkCoSoSXKD
    WHERE $columnCreatedAt = '$createdAt' 
    AND $colBkCoSoSXKDMaTrangThaiDT = ${AppDefine.hoanThanhPhongVan}
     AND $columnMaDTV = '${AppPref.uid}'
    AND $colBkCoSoSXKDMaDiaBan = '$maDiaBan'
    AND $colBkCoSoSXKDLoaiPhieu = '$maDoiTuongDT'
    AND $colBkCoSoSXKDMaXa = '$maXa'
    ''');
  }

  Future<List<Map>> searchListInterviewedAll(
      int maDoiTuongDT, String maDiaBan, String maXa, String search) async {
    String createdAt = AppPref.dateTimeSaveDB!;

    return await db!.rawQuery('''
    SELECT * FROM $tablebkCoSoSXKD
    WHERE $columnCreatedAt = '$createdAt' 
    AND $colBkCoSoSXKDMaTrangThaiDT = ${AppDefine.hoanThanhPhongVan}
    AND $colBkCoSoSXKDMaDiaBan = '$maDiaBan'
    AND $colBkCoSoSXKDLoaiPhieu = '$maDoiTuongDT'
    AND $colBkCoSoSXKDMaXa = '$maXa'
    AND $columnMaDTV = '${AppPref.uid}'
    AND $colBkCoSoSXKDTenCoSo LIKE '%$search%'
    OR $colBkCoSoSXKDTenCoSo LIKE '%$search'
    ''');
  }

  Future<List<Map>> selectAllListInterviewedSync() async {
    String createdAt = AppPref.dateTimeSaveDB ?? "";
    print('createdAt: $createdAt');
    return await db!.query(tablebkCoSoSXKD, where: '''
      $columnCreatedAt = '$createdAt'
      AND $colBkCoSoSXKDMaTrangThaiDT = ${AppDefine.hoanThanhPhongVan}
      AND $colBkCoSoSXKDMaTrangThaiDT2 = ${AppDefine.hoanThanhPhongVan}
      AND NOT $columnUpdatedAt = '$createdAt'
      AND $columnMaDTV='${AppPref.uid}'
      ORDER BY $colBkCoSoSXKDId
    ''');
  }

  Future<List<Map>> getListInterviewedPaginatedSync(
      int pageNumber, int pageSize) async {
    int offset = (pageNumber - 1) * pageSize;
    String createdAt = AppPref.dateTimeSaveDB ?? "";
    String sWhere = " $columnCreatedAt = '$createdAt' ";
    sWhere +=
        "  AND $colBkCoSoSXKDMaTrangThaiDT = ${AppDefine.hoanThanhPhongVan} ";
    sWhere +=
        "   AND $colBkCoSoSXKDMaTrangThaiDT2 = ${AppDefine.hoanThanhPhongVan} ";
    sWhere += "   AND NOT $columnUpdatedAt = '$createdAt' ";
    sWhere += "   AND $columnMaDTV='${AppPref.uid}' ";
    sWhere += "   ORDER BY $colBkCoSoSXKDId ";
    sWhere += "  LIMIT $pageSize ";
    sWhere += "   OFFSET $offset ";
    developer.log('getListInterviewedPaginatedSync $sWhere');
    return await db!.query(tablebkCoSoSXKD, where: sWhere);
  }
  // // AND ($colBkCoSoSXKDIDCoSo in (SELECT $colPhieuIDCoSo FROM $tablePhieu WHERE $colPhieuThoiGianBD IS NOT NULL AND $colPhieuThoiGianKT IS NOT NULL ))

  Future<List<Map>> selectAllListInterviewed() async {
    String createdAt = AppPref.dateTimeSaveDB ?? "";
    print('createdAt: $createdAt');
    return await db!.query(tablebkCoSoSXKD, where: '''
      $columnCreatedAt = '$createdAt'
      AND $colBkCoSoSXKDMaTrangThaiDT = ${AppDefine.hoanThanhPhongVan}
      AND NOT $columnUpdatedAt = '$createdAt'
      AND $columnMaDTV='${AppPref.uid}'
    ''');
  }

  Future<Map?> getInformation(String idCoSo) async {
    String createdAt = AppPref.dateTimeSaveDB!;
    List<Map> map = await db!.query(tablebkCoSoSXKD, where: '''
      $columnCreatedAt = '$createdAt'
      AND $colBkCoSoSXKDIDCoSo = '$idCoSo'
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
      AND $colBkCoSoSXKDIDCoSo = '$idCoSo'
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
      "MaTrangThaiDT2": AppDefine.hoanThanhPhongVan,
      "UpdatedAt": DateTime.now().toIso8601String()
    };
    String createdAt = AppPref.dateTimeSaveDB ?? "";
    developer.log('ID HO: $idCoSo');
    await db!.update(tablebkCoSoSXKD, values,
        where: '$colBkCoSoSXKDIDCoSo= ? AND $columnCreatedAt= "$createdAt"',
        whereArgs: [idCoSo]);
    print('updateTrangThai');
    print('db: ${await db!.query(tablebkCoSoSXKD, where: '''
      $colBkCoSoSXKDMaTrangThaiDT = ${AppDefine.hoanThanhPhongVan}
    ''')}');
  }

  Future updateTrangThaiDTTinhTrangHD(String idCoSo, int tinhTrangHD) async {
    Map<String, Object?> values = {
      colBkCoSoSXKDMaTrangThaiDT: AppDefine.hoanThanhPhongVan,
      colBkCoSoSXKDMaTinhTrangHD: tinhTrangHD,
      "UpdatedAt": DateTime.now().toIso8601String()
    };
    String createdAt = AppPref.dateTimeSaveDB ?? "";
    developer.log('ID HO: $idCoSo');
    var res = await db!.update(tablebkCoSoSXKD, values,
        where: '$colBkCoSoSXKDIDCoSo= ? AND $columnCreatedAt= "$createdAt"',
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
          where: '$colBkCoSoSXKDIDCoSo= ? AND $columnCreatedAt = ? ',
          whereArgs: [idCoSo, createdAt]);
    }
  }

  Future updateValue(key, value, String idCoSo) async {
    String createdAt = AppPref.dateTimeSaveDB ?? "";

    Map<String, Object?> values = {
      key: value,
      "UpdatedAt": DateTime.now().toIso8601String()
    };
    developer.log('ID CS: $idCoSo');
    await db!.update(tablebkCoSoSXKD, values,
        where: '$colBkCoSoSXKDIDCoSo= ? AND $columnCreatedAt= "$createdAt"',
        whereArgs: [idCoSo]);
  }

  Future updateSuccess(List idCoSos) async {
    String createdAt = AppPref.dateTimeSaveDB ?? "";

    for (var item in idCoSos) {
      var update = await db!.update(tablebkCoSoSXKD,
          {"UpdatedAt": createdAt, "SyncSuccess": AppDefine.synced},
          where: '$colBkCoSoSXKDIDCoSo= ? AND $columnCreatedAt= "$createdAt"',
          whereArgs: [item]);
      developer.log('RESULT UPDATE CSSXKD $item SUCCESS=$update');
    }
  }

  Future updateTrangThaiLogic(fieldName, value, String idCoSo) async {
    String createdAt = AppPref.dateTimeSaveDB ?? "";

    Map<String, Object?> values = {fieldName: value};
    developer.log('ID CS: $idCoSo');
    await db!.update(tablebkCoSoSXKD, values,
        where: '$colBkCoSoSXKDIDCoSo= ? AND $columnCreatedAt= "$createdAt"',
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
