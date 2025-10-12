import 'dart:developer';

import 'package:gov_statistics_investigation_economic/common/utils/app_pref.dart';
import 'package:gov_statistics_investigation_economic/resource/database/database_helper.dart';
import 'package:gov_statistics_investigation_economic/resource/database/provider/base_db_provider.dart';
import 'package:gov_statistics_investigation_economic/resource/database/table/filed_common.dart';
import 'package:gov_statistics_investigation_economic/resource/database/table/table_p07mau.dart';
import 'package:gov_statistics_investigation_economic/resource/resource.dart';

import 'package:sqflite/sqflite.dart';

class PhieuMauTBSanPhamProvider extends BaseDBProvider<TablePhieuMauTBSanPham> {
  static final PhieuMauTBSanPhamProvider _singleton =
      PhieuMauTBSanPhamProvider._internal();

  factory PhieuMauTBSanPhamProvider() {
    return _singleton;
  }

  Database? db;

  PhieuMauTBSanPhamProvider._internal();

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
  Future<List<int>> insert(
      List<TablePhieuMauTBSanPham> value, String createdAt) async {
    List<int> ids = [];
    for (var element in value) {
      element.createdAt = createdAt;
      //    element.updatedAt = createdAt;
      element.isDefault = element.sTTSanPham == 1 ? 1 : null;
      element.maDTV = AppPref.uid;
      ids.add(await db!.insert(tablePhieuMauTBSanPham, element.toJson()));
    }
    return ids;
  }

  @override
  Future onCreateTable(Database database) {
    return database.execute('''
    CREATE TABLE IF NOT EXISTS $tablePhieuMauTBSanPham
      (
      $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
      $colPhieuMauTBSanPhamIDCoSo  TEXT,
      $colPhieuMauTBSanPhamSTTSanPham  INTEGER,
      $colPhieuMauTBSanPhamMaNganhC5  TEXT,
      $colPhieuMauTBSanPhamA5_1_1  TEXT,
      $colPhieuMauTBSanPhamA5_1_2  TEXT,
      $colPhieuMauTBSanPhamA5_2  REAL,
      $columnMaLV TEXT,
      $columnPhieuMauSanPhamDefault INTEGER, 
      $columnPhieuMauSanPhamIsSync INTEGER, 
      $columnMaDTV  TEXT,
      $columnCreatedAt TEXT,
      $columnUpdatedAt TEXT
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
  Future update(TablePhieuMauTBSanPham value, String id) async {
    String createAt = AppPref.dateTimeSaveDB!;
    String updatedAt = DateTime.now().toIso8601String();
    value.updatedAt = updatedAt;
    await db!.update(tablePhieuMauTBSanPham, value.toJson(), where: '''
      $columnCreatedAt = '$createAt' AND $columnIDCoSo = '$id' 
      
    ''');
  }

  Future updateValue(String fieldName, value, columnId) async {
    String createdAt = AppPref.dateTimeSaveDB!;
    Map<String, Object?> values = {
      fieldName: value,
      columnUpdatedAt: DateTime.now().toIso8601String(),
    };

    var i = await db!.update(tablePhieuMauTBSanPham, values,
        where:
            "$columnId = '$columnId'  AND $columnCreatedAt = '$createdAt'  AND $columnMaDTV = '${AppPref.uid}'");

    log('UPDATE PHIEU 04: $i');
  }

  Future updateValueByIdCoso(String fieldName, value, iDCoSo, id) async {
    Map<String, Object?> values = {
      fieldName: value,
      columnUpdatedAt: DateTime.now().toIso8601String(),
    };
    var i = await db!.update(tablePhieuMauTBSanPham, values,
        where: '$columnId = ? AND $columnIDCoSo = ?', whereArgs: [id, iDCoSo]);

    log('UPDATE san pham: ${i.toString()}');
  }

  Future updateValueAndCalculateTotal(String fieldName, value, idCoSo,
      List<String> fieldNames, String fieldNameTotal) async {
    String createdAt = AppPref.dateTimeSaveDB!;
    Map<String, Object?> values = {
      fieldName: value,
      columnUpdatedAt: DateTime.now().toIso8601String(),
    };

    var i = await db!.update(tablePhieuMauTBSanPham, values,
        where:
            "$columnIDCoSo = '$idCoSo'  AND $columnCreatedAt = '$createdAt'  AND $columnMaDTV = '${AppPref.uid}'");

    log('UPDATE PHIEU 04: $i');

    ///Tính tổng
    await totalByMaCauHoi(idCoSo, fieldNames);
    Map<String, Object?> totalValues = {
      fieldNameTotal: value,
      columnUpdatedAt: DateTime.now().toIso8601String(),
    };
    var totalUp = await db!.update(tablePhieuMauTBSanPham, totalValues,
        where:
            "$columnIDCoSo = '$idCoSo'  AND $columnCreatedAt = '$createdAt'  AND $columnMaDTV = '${AppPref.uid}'");

    log('UPDATE PHIEU 04 totalUp: $totalUp');
  }

  Future totalA5_2(idCoSo) async {
    String createdAt = AppPref.dateTimeSaveDB!;

    ///Tính tổng
    var total = 0.0;
    List<Map> map = await db!.rawQuery('''
          SELECT SUM($colPhieuMauTBSanPhamA5_2) as totalA5_2 FROM $tablePhieuMauTBSanPham 
          WHERE $columnIDCoSo = '$idCoSo' 
          AND $columnCreatedAt = '$createdAt'
        ''');
    if (map.isNotEmpty) {
      if (map[0] != null) {
        total = map[0]['totalA5_2'] ?? 0;
      }
    }

    log('UPDATE totalA5_2: $total');
    return total;
  }

  Future updateMultiFieldNullValue(
      List<String> fieldNames, value, idCoSo) async {
    String createdAt = AppPref.dateTimeSaveDB!;
    Map<String, Object?> values = {
      columnUpdatedAt: DateTime.now().toIso8601String(),
    };
    for (var item in fieldNames) {
      values.addEntries({item: value}.entries);
    }

    var i = await db!.update(tablePhieuMauTBSanPham, values,
        where:
            "$columnIDCoSo = '$idCoSo'  AND $columnCreatedAt = '$createdAt'  AND $columnMaDTV = '${AppPref.uid}'");

    log('UPDATE PHIEU  : $i');
  }

  Future updateMultiFieldNullValueById(
      List<String> fieldNames, value, idCoSo, id) async {
    String createdAt = AppPref.dateTimeSaveDB!;
    Map<String, Object?> values = {
      columnUpdatedAt: DateTime.now().toIso8601String(),
    };
    for (var item in fieldNames) {
      values.addEntries({item: value}.entries);
    }

    var i = await db!.update(tablePhieuMauTBSanPham, values,
        where:
            "$columnIDCoSo = '$idCoSo'  AND $columnMaDTV = '${AppPref.uid}'  AND  $columnId=$id ");

    log('UPDATE PHIEU 04: $i');
  }

  Future<int> deleteById(int id) {
    var res =
        db!.delete(tablePhieuMauTBSanPham, where: '''  $columnId = '$id'  ''');
    return res;
  }
  // Future<Map> selectOneByIdCoSo(String idCoso) async {
  //   String createdAt = AppPref.dateTimeSaveDB!;

  //   List<Map> map = await db!.rawQuery('''
  //         SELECT * FROM $tablePhieuMauTBSanPham
  //         WHERE $columnIDCoSo = '$idCoso'
  //         AND $columnCreatedAt = '$createdAt'
  //         AND $columnMaDTV='${AppPref.uid}'
  //       ''');
  //   return map.isNotEmpty ? map[0] : {};
  // }
  Future<List<Map>> selectByIdCoSo(String idCoso) async {
    String createdAt = AppPref.dateTimeSaveDB!;

    List<Map> maps = await db!.rawQuery('''
          SELECT * FROM $tablePhieuMauTBSanPham 
          WHERE $columnIDCoSo = '$idCoso' 
          AND $columnMaDTV='${AppPref.uid}'
          AND $columnCreatedAt = '$createdAt' ORDER BY STT_SanPham
        ''');
    return maps;
  }

  Future<List<Map>> selectByIdCosoSync(String idCoso) async {
    String createdAt = AppPref.dateTimeSaveDB!;

    List<Map> maps = await db!.rawQuery('''
          SELECT * FROM $tablePhieuMauTBSanPham 
          WHERE $columnIDCoSo = '$idCoso' 
          AND $colPhieuMauTBSanPhamSTTSanPham is not null
          AND $colPhieuMauTBSanPhamMaNganhC5 is not null
          AND $colPhieuMauTBSanPhamA5_1_1 is not null
          AND $colPhieuMauTBSanPhamA5_1_2 is not null 
          AND $colPhieuMauTBSanPhamA5_2 is not null 
          AND $columnCreatedAt = '$createdAt' ORDER BY STT_SanPham
        ''');
    return maps;
  }

  Future<Map> selectByIdCosoFieldNames(
      String idCoso, List<String> fieldNames) async {
    String createdAt = AppPref.dateTimeSaveDB!;
    // List<String> fields = [];
    // for (var item in fieldNames) {
    //   if (item.bangDuLieu == tablePhieu04SanPham) {
    //     fields.add(item.tenTruong!);
    //   }
    // }
    List<Map> map = await db!.rawQuery('''
          SELECT  ${fieldNames.join(',')} FROM $tablePhieuMauTBSanPham 
          WHERE $columnIDCoSo = '$idCoso' 
          AND $columnCreatedAt = '$createdAt'
          AND $columnMaDTV='${AppPref.uid}'
        ''');
    return map.isNotEmpty ? map[0] : {};
  }

  Future<bool> isExistProduct(String idCoso) async {
    String createdAt = AppPref.dateTimeSaveDB!;
    List<Map> map = await db!.query(tablePhieuMauTBSanPham, where: '''
      $columnCreatedAt = '$createdAt'
      AND $columnIDCoSo = '$idCoso' AND $columnMaDTV='${AppPref.uid}'
    ''');
    return map.isNotEmpty;
  }

  Future<bool> isExistProductBySTT(String idCoso, int stt) async {
    String createdAt = AppPref.dateTimeSaveDB!;
    List<Map> map = await db!.query(tablePhieuMauTBSanPham, where: '''
      $columnCreatedAt = '$createdAt'
      AND  $colPhieuMauTBSanPhamSTTSanPham = '$stt'
      AND $columnIDCoSo = '$idCoso' AND $columnMaDTV='${AppPref.uid}'
    ''');
    return map.isNotEmpty;
  }

  Future<bool> isExistProductById(String idCoso, int id) async {
    String createdAt = AppPref.dateTimeSaveDB!;
    List<Map> map = await db!.query(tablePhieuMauTBSanPham, where: '''
      $columnCreatedAt = '$createdAt'
      AND  $columnId = '$id'
      AND $columnIDCoSo = '$idCoso' AND $columnMaDTV='${AppPref.uid}'
    ''');
    return map.isNotEmpty;
  }

  Future<bool> isExistProductByMaNganhC5(
      String idCoso, String maNganhC5) async {
    String createdAt = AppPref.dateTimeSaveDB!;
    List<Map> map = await db!.query(tablePhieuMauTBSanPham, where: '''
      $columnCreatedAt = '$createdAt'
      AND  $colPhieuMauTBSanPhamMaNganhC5 = '$maNganhC5'
      AND $columnIDCoSo = '$idCoso' AND $columnMaDTV='${AppPref.uid}'
    ''');
    return map.isNotEmpty;
  }

  Future<bool> checkExistDataIOByMaCauHoi(
      String idCoso, List<String> fieldNames) async {
    bool result = false;
    List<int> countValues = [];
    String createdAt = AppPref.dateTimeSaveDB!;
    List<Map> map = await db!.rawQuery('''
          SELECT ${fieldNames.join(',')} FROM $tablePhieuMauTBSanPham 
          WHERE $columnIDCoSo = '$idCoso' 
          AND $columnCreatedAt = '$createdAt'
          AND $columnMaDTV='${AppPref.uid}'
        ''');

    for (var item in map) {
      item.forEach((key, value) {
        if (value != null) {
          countValues.add(1);
        }
      });
    }
    result = countValues.isNotEmpty;

    return result;
  }

  Future<int> getMaxSTTByIdCoso(String idCoso) async {
    String createdAt = AppPref.dateTimeSaveDB!;

    List<Map> map = await db!.rawQuery('''
          SELECT MAX($colPhieuMauTBSanPhamSTTSanPham) as MaxSTT FROM $tablePhieuMauTBSanPham 
          WHERE $columnIDCoSo = '$idCoso' 
          AND $columnCreatedAt = '$createdAt'
        ''');
    if (map.isNotEmpty) {
      if (map[0] != null) {
        return map[0]['MaxSTT'] ?? 0;
      }
    }
    return 0;
  }

  Future<int> getIsDefaultByIdCoso(String idCoso) async {
    String createdAt = AppPref.dateTimeSaveDB!;

    List<Map> map = await db!.rawQuery('''
          SELECT IsDefault FROM $tablePhieuMauTBSanPham 
          WHERE $columnIDCoSo = '$idCoso' 
          AND $columnCreatedAt = '$createdAt'
        ''');
    if (map.isNotEmpty) {
      if (map[0] != null) {
        return map[0]['IsDefault'] ?? 0;
      }
    }
    return 0;
  }

  Future<int> countNotIsDefaultByIdCoso(String idCoso) async {
    String createdAt = AppPref.dateTimeSaveDB!;

    List<Map> map = await db!.rawQuery('''
          SELECT _id FROM $tablePhieuMauTBSanPham 
          WHERE $columnIDCoSo = '$idCoso' 
          AND $columnCreatedAt = '$createdAt'
          AND $columnPhieuMauSanPhamDefault is null 
        ''');
    if (map.isNotEmpty) {
      if (map[0] != null) {
        return map[0]['_id'] ?? 0;
      }
    }
    return 0;
  }

  Future<int> deleteNotIsDefault(String idCoso) async {
    String createdAt = AppPref.dateTimeSaveDB!;
//     var sqlDel="DELETE FROM $tablePhieuMauTBSanPham WHERE $columnIDCoSo = '$idCoso' AND $columnPhieuMauSanPhamDefault <> 1  AND $columnCreatedAt = '$createdAt'";
//  var res = await db!.rawDelete(sqlDel);
    int id = 0;
    var res = 0;
    List<Map> map = await db!.rawQuery('''
          SELECT $columnId FROM $tablePhieuMauTBSanPham 
          WHERE $columnIDCoSo = '$idCoso' 
          AND $columnPhieuMauSanPhamDefault = 1
          AND $columnCreatedAt = '$createdAt'
        ''');
    if (map.isNotEmpty) {
      if (map[0] != null) {
        id = map[0]['_id'] ?? 0;
      }
    }
    if (id > 0) {
      res = await db!.delete(tablePhieuMauTBSanPham,
          where:
              '''  $columnIDCoSo = '$idCoso' AND $columnId <> $id  AND $columnCreatedAt = '$createdAt'  ''');
    }
    return res;
  }

  Future<double> totalByMaCauHoi(String idCoso, List<String> fieldNames) async {
    double result = 0.0;

    String createdAt = AppPref.dateTimeSaveDB!;
    List<String> fields = [];
    for (var item in fieldNames) {
      fields.add("IFNULL($item,0)");
    }
    String sql =
        "SELECT ${fields.join('+')} as total FROM $tablePhieuMauTBSanPham  WHERE $columnIDCoSo = '$idCoso'   AND $columnCreatedAt = '$createdAt' AND $columnMaDTV='${AppPref.uid}'";
    List<Map> map = await db!.rawQuery(sql);

    for (var item in map) {
      item.forEach((key, value) {
        if (value != null) {
          result = value;
        }
      });
    }

    return result;
  }

  ///maVCPACap2: ví dụ mã cấp 2 là 55 ở Phần VII; Lấy cho câu A7_10 và A7_11
  Future<double> totalA5_2ByMaVcpaCap2(idCoSo, String maVCPACap2) async {
    String createdAt = AppPref.dateTimeSaveDB!;
    var vcpa2DieuKiens = maVCPACap2.split(';');

    ///Tính tổng
    var total = 0.0;
    List<Map> map = await db!.rawQuery('''
          SELECT SUM($colPhieuMauTBSanPhamA5_2) as totalA5_2 FROM $tablePhieuMauTBSanPham 
          WHERE $columnIDCoSo = '$idCoSo' 
          AND $columnCreatedAt = '$createdAt'
          AND substr($colPhieuMauTBSanPhamA5_1_2,1,2) in (${vcpa2DieuKiens.map((e) => "'$e'").join(', ')})
        ''');
    if (map.isNotEmpty) {
      if (map[0] != null) {
        total = map[0]['totalA5_2'] ?? 0;
      }
    }

    log('UPDATE totalA5_2ByMaVcpaCap2 totalA5_2: $total');
    return total;
  }

  ///Kiểm tra mã ngành trường cap5 có trong danh sách đầu vào vcpaCap5s
  Future<bool> kiemTraMaNganhVCPA(List<String> vcpaCap5s) async {
    List<String> result = [];
    var vcpas = vcpaCap5s.map((e) => "'$e'").join(', ');

    String sql =
        "SELECT $colPhieuMauTBSanPhamMaNganhC5 FROM $tablePhieuMauTBSanPham  WHERE $colPhieuMauTBSanPhamMaNganhC5 in (${vcpaCap5s.map((e) => "'$e'").join(', ')})";
    List<Map> maps = await db!.rawQuery(sql);
    for (var item in maps) {
      item.forEach((key, value) {
        if (value != null) {
          result.add(value);
        }
      });
    }
    return result.isNotEmpty;
  }

  ///Lấy tất cả mã sản phẩm thuộc cơ sở
  Future<List<String>> getMaSanPhamsByIdCoso(String idCoso) async {
    String createdAt = AppPref.dateTimeSaveDB!;
    List<String> result = [];
    List<Map> maps = await db!.rawQuery('''
          SELECT $colPhieuMauTBSanPhamA5_1_2 FROM $tablePhieuMauTBSanPham 
          WHERE $columnIDCoSo = '$idCoso' 
          AND $columnCreatedAt = '$createdAt'
        ''');

    for (var item in maps) {
      item.forEach((key, value) {
        if (value != null) {
          result.add(value);
        }
      });
    }
    return result;
  }

  ///
  ///dsSPs: masanpham cach nhau dau ;
  Future<List<Map>> getSanPhamsByIdCosoSps(String idCoso, String dsSPs) async {
    String createdAt = AppPref.dateTimeSaveDB!;
    var vcpa5Inputs = dsSPs.split(';');
    List<Map> maps = await db!.rawQuery('''
          SELECT * FROM $tablePhieuMauTBSanPham 
          WHERE $columnIDCoSo = '$idCoso' 
          AND $columnMaDTV='${AppPref.uid}'
          AND $colPhieuMauTBSanPhamA5_1_2 in (${vcpa5Inputs.map((e) => "'$e'").join(', ')}) 
          AND $columnCreatedAt = '$createdAt' ORDER BY STT_SanPham
        ''');
    return maps;
  }

  Future<List<String>> getMaSanPhamsByIdCosoSps(
      String idCoso, String dsSPs) async {
    String createdAt = AppPref.dateTimeSaveDB!;
    List<String> result = [];
    var vcpa5Inputs = dsSPs.split(';');
    List<Map> maps = await db!.rawQuery('''
          SELECT $colPhieuMauTBSanPhamA5_1_2  FROM $tablePhieuMauTBSanPham 
          WHERE $columnIDCoSo = '$idCoso' 
          AND $columnMaDTV='${AppPref.uid}'
          AND $colPhieuMauTBSanPhamA5_1_2 in (${vcpa5Inputs.map((e) => "'$e'").join(', ')}) 
          AND $columnCreatedAt = '$createdAt' ORDER BY STT_SanPham
        ''');
    for (var item in maps) {
      item.forEach((key, value) {
        if (value != null) {
          result.add(value);
        }
      });
    }
    return result;
  }

  ///nganh:
  ///CN: Công nghiệp; VTHK: Vận tải hành khách; VTHH; LT: Thương mại; TM: Thương mại
  ///maVcpAQuiDinh:
  ///   => Nếu là VTHK là: vcpaCap5VanTaiHanhKhach =  "49210;49220;49290;49312;49313;49319;49321;49329;50111;50112;50211;50212"
  ///   => Nếu là VTHH là: vcpaCap5VanTaiHangHoa = "49331;49332;49333;49334;49339;50121;50122;50221;50222";
  ///   => LT là: Cấp 2 = 55
  ///   => TM là: HOẠT ĐỘNG BÁN BUÔN; BÁN LẺ; SỬA CHỮA Ô TÔ, MÔ TÔ, XE MÁY, XE CÓ ĐỘNG CƠ KHÁC VÀ HOẠT ĐỘNG KINH DOANH BẤT ĐỘNG SẢN CẤP 1 LÀ G VÀ NGÀNH L6810  (TRỪ CÁC MÃ 4513-4520-45413-4542-461)]
  ///   => TM là : Cấp 2 = 56
  Future doanhThuNganh(idCoSo, String nganh, String maVcpAQuiDinh) async {
    String createdAt = AppPref.dateTimeSaveDB!;

    ///Tính tổng
    var total = 0.0;
    String sql = '';
    String sWhere = '';
    if (nganh == 'CN') {
      sWhere = " $colPhieuMauTBSanPhamA5_1_2 in ('B','C','D','E') ";
    } else if (nganh == 'VTHK' || nganh == 'VTHH') {
      var maVcpAQuiDinhs = maVcpAQuiDinh.split(';');
      sWhere =
          "   substr($colPhieuMauTBSanPhamA5_1_2,1,5) in (${maVcpAQuiDinhs.map((e) => "'$e'").join(', ')})";
    } else if (nganh == 'LT') {
      String vcpaCap2LT = "55";
      sWhere = " (substr($colPhieuMauTBSanPhamA5_1_2,1,2) = '$vcpaCap2LT')";
    } else if (nganh == 'TM') {
      ///Bán buôn bán lẻ;
      ///"45413";
      String maVcpaLoaiTruG_C5 = "45413";

      ///"4513;4520;4542";
      String maVcpaLoaiTruG_C4 = "4513;4520;4542";

      ///"461";
      String maVcpaLoaiTruG_C3 = "461";
      String maVcpaL6810 = "6810";
      var arrG_C5 = maVcpaLoaiTruG_C5.split(';');
      var arrG_C4 = maVcpaLoaiTruG_C4.split(';');
      var arrG_C3 = maVcpaLoaiTruG_C3.split(';');
      sWhere =
          " ((substr($colPhieuMauTBSanPhamA5_1_2,1,3) not in (${arrG_C3.map((e) => "'$e'").join(', ')}) AND substr($colPhieuMauTBSanPhamA5_1_2,1,4) not in (${arrG_C4.map((e) => "'$e'").join(', ')}) AND substr($colPhieuMauTBSanPhamA5_1_2,1,5) not in (${arrG_C5.map((e) => "'$e'").join(', ')}) )AND $columnMaLV ='G')";

      ///
      sWhere +=
          " OR (substr($colPhieuMauTBSanPhamA5_1_2,1,4) =$maVcpaL6810 AND $columnMaLV ='L')";

      String vcpaCap2TM = "56";
      sWhere += " OR (substr($colPhieuMauTBSanPhamA5_1_2,1,2) = '$vcpaCap2TM')";
    }
    
    sql =
        " SELECT SUM($colPhieuMauTBSanPhamA5_2) as totalA5_2 FROM $tablePhieuMauTBSanPham ";
    sql += "  WHERE  $columnIDCoSo = '$idCoSo' ";
    sql += "  AND  $columnCreatedAt = '$createdAt'";
    sql += " AND $sWhere";
log('doanhThuNganh CN:: sql: $sql');
    List<Map> map = await db!.rawQuery(sql);
    if (map.isNotEmpty) {
      if (map[0] != null) {
        total = map[0]['totalA5_2'] ?? 0;
      }
    }

    log('doanhThuNganh $nganh: $total');
    return total;
  }

  Future updateSuccess(List idCoSos) async {
    String createdAt = AppPref.dateTimeSaveDB ?? "";

    for (var item in idCoSos) {
      var update = await db!.update(tablePhieuMauTBSanPham,
          {"UpdatedAt": createdAt, columnPhieuMauSanPhamIsSync: 1},
          where: '$columnIDCoSo= ? AND $columnCreatedAt= "$createdAt"',
          whereArgs: [item]);
      log('RESULT UPDATE HO SUCCESS=$update');
    }
  }

  Future<int> deleteByCoSoId(String coSoId) {
    var res = db!.delete(tablePhieuMauTBSanPham,
        where: '''  $columnIDCoSo = '$coSoId'  ''');
    return res;
  }

  @override
  Future deletedTable(Database database) async {
    return await database
        .rawQuery('DROP TABLE IF EXISTS $tablePhieuMauTBSanPham');
  }
}
