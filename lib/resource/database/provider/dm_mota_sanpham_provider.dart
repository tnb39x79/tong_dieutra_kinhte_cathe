import 'package:gov_statistics_investigation_economic/resource/database/database_helper.dart';
import 'package:gov_statistics_investigation_economic/resource/database/provider/base_db_provider.dart';
import 'package:gov_statistics_investigation_economic/resource/database/table/table_dm_mota_sanpham.dart';
import 'package:gov_statistics_investigation_economic/resource/model/product/product_ai_model.dart';
import 'package:gov_statistics_investigation_economic/resource/model/vcpa_offline_ai/models/predict_model.dart';
import 'package:sqflite/sqflite.dart';

class DmMotaSanphamProvider extends BaseDBProvider<TableDmMotaSanpham> {
  static final DmMotaSanphamProvider _singleton =
      DmMotaSanphamProvider._internal();

  factory DmMotaSanphamProvider() {
    return _singleton;
  }

  Database? db;

  DmMotaSanphamProvider._internal();

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
      List<TableDmMotaSanpham> value, String createdAt) async {
    try {
      if (value.isNotEmpty) {
        await db!.delete(tableDmMoTaSanPham);
      }
    } catch (e) {
      // developer.log(e.toString());
    }
    List<int> ids = [];
    for (var element in value) {
      ids.add(await db!.insert(tableDmMoTaSanPham, element.toJson()));
    }
    return ids;
  }

  Future<List<int>> insertNhomNganhVcpa(
      List<dynamic> value, String create) async {
    List<int> ids = [];
    for (dynamic map in value) {
      ids.add(await db!.insert(tableDmMoTaSanPham, map));
    }
    return ids;
  }

  @override
  Future onCreateTable(Database database) async {
    return database.execute('''
      CREATE TABLE IF NOT EXISTS $tableDmMoTaSanPham
      (
        $columnDmMoTaSPId INTEGER PRIMARY KEY AUTOINCREMENT,
        $columnDmMoTaSPMaSanPham TEXT,
        $columnDmMoTaSPTenSanPham TEXT,
        $columnDmMoTaSPTenSanPhamKoDau TEXT,
        $columnDmMoTaSPMoTaChiTiet TEXT,
        $columnDmMoTaSPMoTaChiTietKoDau TEXT,
        $columnDmMoTaSPDonViTinh TEXT,
        $columnDmMoTaSPMaLV TEXT,
        $columnDmMoTaSPTenLinhVuc TEXT
      )
      ''');
  }

  @override
  Future<List<Map>> selectAll() async {
    return await db!.query(tableDmMoTaSanPham);
  }

  @override
  Future<Map> selectOne(int id) {
    // TODO: implement selectOne
    throw UnimplementedError();
  }

  @override
  Future update(TableDmMotaSanpham value, String id) {
    // TODO: implement update
    throw UnimplementedError();
  }

  Future<List<Map>> searchCap8(String key) async {
    final List<Map> maps = await db!.query(tableDmMoTaSanPham, where: '''
      $columnDmMoTaSPMoTaChiTiet LIKE '%$key%' 
      ''');

    return maps;
  }

  Future<List<Map>> searchVcpaCap5(String keyword) async {
    final List<Map> maps = await db!.query(tableDmMoTaSanPham, where: '''
      $columnDmMoTaSPMoTaChiTiet LIKE '%$keyword%'
      OR $columnDmMoTaSPTenSanPham LIKE '%$keyword%'
      OR $columnDmMoTaSPMoTaChiTietKoDau LIKE '%$keyword%'
      OR $columnDmMoTaSPMaSanPham LIKE '%$keyword%'
      ''');

    return maps;
  }

  Future<List<Map>> searchVcpaCap5ByLinhVuc(String keyword, String maLV) async {
    if (keyword != '') {
      List<String> kws = keyword.split(' ');
      List<String> whs = [];
      //   for (var item in kws) {
      //     String s1 =
      //         "$columnDmMoTaSPTenSanPham LIKE '%$item%' OR $columnDmMoTaSPMoTaChiTiet LIKE '%$item%' OR $columnDmMoTaSPMoTaChiTietKoDau LIKE '%$item%' OR $columnDmMoTaSPMaSanPham LIKE '%$item%'";
      //     whs.add(s1);
      //   }
      //   String s2 =
      //         "$columnDmMoTaSPTenSanPham LIKE '%$keyword%' OR  $columnDmMoTaSPMoTaChiTiet LIKE '%$keyword%' OR $columnDmMoTaSPMoTaChiTietKoDau LIKE '%$keyword%' OR $columnDmMoTaSPMaSanPham LIKE '%$keyword%'";
      //   if (whs.isNotEmpty) {
      //     String wh = "(${whs.join(' OR')}  OR $s2) AND $columnDmMoTaSPMaLV = '$maLV'";
      //     if(maLV=='' || maLV=='0'){
      //       wh = "(${whs.join(' OR ')} OR $s2 ) ";
      //     }
      //     final List<Map> maps = await db!.query(tableDmMoTaSanPham, where: '''
      //   $wh
      //   ''');
      //     return maps;
      //   }
      // }
      // return    [];
      String sWh =
          "($columnDmMoTaSPTenSanPham LIKE '%$keyword%' OR $columnDmMoTaSPTenSanPham = '$keyword' OR $columnDmMoTaSPTenSanPhamKoDau = '$keyword' OR $columnDmMoTaSPTenSanPhamKoDau LIKE '%$keyword%' OR  $columnDmMoTaSPMoTaChiTiet LIKE '%$keyword%' OR $columnDmMoTaSPMoTaChiTietKoDau LIKE '%$keyword%'  OR $columnDmMoTaSPMaSanPham LIKE '%$keyword%')";
      if (maLV != '' && maLV != '0') {
        sWh = " $sWh AND $columnDmMoTaSPMaLV = '$maLV'";
      }
      final List<Map> maps = await db!.query(tableDmMoTaSanPham, where: '''
      $sWh
      ''');

      return maps;
    }
    return    [];
  }

  Future<List<Map>> mapResultAIToDmSanPham(
      List<ProductAiModel> products, String maLV) async {
    List<String> vcpas = [];
    if (products != null && products.isNotEmpty) {
      for (var item in products) {
        if (item.code != null && item.code != '') {
          vcpas.add(item.code!);
        }
      }
    } else {
      return [];
    }
    if (vcpas.isEmpty) {
      return [];
    }
    String sWh =
        "$columnDmMoTaSPMaSanPham in (${vcpas.map((e) => "'$e'").join(', ')})";
    if (maLV != '' && maLV != '0') {
      sWh = " $sWh AND $columnDmMoTaSPMaLV = '$maLV'";
    }
    final List<Map> maps = await db!.query(tableDmMoTaSanPham, where: '''
      $sWh
      ''');

    return maps;
  }

  Future<List<Map>> mapResultAIToDmSanPhamOffline(
      List<PredictionResult> products, String maLV) async {
    List<String> vcpas = [];
    if (products != null && products.isNotEmpty) {
      for (var item in products) {
        if (item.code != null && item.code != '') {
          vcpas.add(item.code!);
        }
      }
    } else {
      return [];
    }
    if (vcpas.isEmpty) {
      return [];
    }
    String sWh =
        "$columnDmMoTaSPMaSanPham in (${vcpas.map((e) => "'$e'").join(', ')})";
    if (maLV != '' && maLV != '0') {
      sWh = " $sWh AND $columnDmMoTaSPMaLV = '$maLV'";
    }
    final List<Map> maps = await db!.query(tableDmMoTaSanPham, where: '''
      $sWh
      ''');

    return maps;
  }

  Future<List<Map>> selectAlls() async {
    final List<Map> maps = await db!.query(tableDmMoTaSanPham);
    return maps;
  }

  Future<bool> hasCap8(String cap5Cap8) async {
    var map = await db!.rawQuery('''
      select * from $tableDmMoTaSanPham where $columnDmMoTaSPMaSanPham = '$cap5Cap8' and length($columnDmMoTaSPMaSanPham)==8
    ''');

    if (map.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> hasCap5(String cap5Cap8) async {
    var map = await db!.rawQuery('''
      select * from $TableDmMotaSanpham where $columnDmMoTaSPMaSanPham = '$cap5Cap8' and length($columnDmMoTaSPMaSanPham)==5
    ''');

    if (map.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> hasMaVcpa(String cap5Cap8) async {
    var map = await db!.rawQuery('''
      select * from $tableDmMoTaSanPham where $columnDmMoTaSPMaSanPham = '$cap5Cap8'
    ''');

    if (map.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  Future<Map> getByVcpaCap5(String vcpaCap5) async {
    final List<Map> maps = await db!.query(tableDmMoTaSanPham, where: '''
      $columnDmMoTaSPMaSanPham = '$vcpaCap5' 
      ''');

    if (maps.isNotEmpty) {
      return maps[0];
    }
    return {};
  }

  Future<Map> getByVcpaCap5s(List<String> vcpaCap5s) async {
    var vcpas = List.filled(vcpaCap5s.length, '?').join(',');
    final List<Map> maps = await db!.query(tableDmMoTaSanPham, where: '''
      $columnDmMoTaSPMaSanPham in ($vcpas}) 
      ''');

    if (maps.isNotEmpty) {
      return maps[0];
    }
    return {};
  }

  Future<bool> kiemTraMaNganhCap1BCEByMaVCPA(List<String> vcpaCap5s) async {
    List<String> result = [];
    var vcpas = vcpaCap5s.map((e) => "'$e'").join(', ');

    String sql =
        "SELECT MaLV FROM $tableDmMoTaSanPham  WHERE ($columnDmMoTaSPMaSanPham in (${vcpaCap5s.map((e) => "'$e'").join(', ')}) OR substr($columnDmMoTaSPMaSanPham,1,5) in (${vcpaCap5s.map((e) => "'$e'").join(', ')}) )AND $columnDmMoTaSPMaLV in ('B','C','E')";
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

  Future<bool> kiemTraMaNganhCap1BCDEByMaVCPA(String vcpaCap5Inputs) async {
    List<String> result = [];
    var vcpa5Inputs = vcpaCap5Inputs.split(';');
    String sql =
        "SELECT MaLV FROM $tableDmMoTaSanPham  WHERE ($columnDmMoTaSPMaSanPham in (${vcpa5Inputs.map((e) => "'$e'").join(', ')})  OR  substr($columnDmMoTaSPMaSanPham,1,5) in (${vcpa5Inputs.map((e) => "'$e'").join(', ')})) AND $columnDmMoTaSPMaLV in ('B','C','D','E')";
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

  ///G: 4513, 4520, 45413, 4542, 461,.....
  ///L 6810
  Future<bool> hasA5_5G_L6810(
      String vcpaCap5,
      List<String> maVcpaLoaiTruG_C3,
      List<String> maVcpaLoaiTruG_C4,
      List<String> maVcpaLoaiTruG_C5,
      String maVcpaL6810) async {
    final List<Map> maps = await db!.query(tableDmMoTaSanPham, where: '''
      $columnDmMoTaSPMaSanPham = '$vcpaCap5' 
      ''');
    bool isGResult = false;
    bool isLResult = false;
    if (maps.isNotEmpty) {
      var res = maps[0];
      if (res != null) {
        var isG = res['MaLV'] == 'G';
        if (isG) {
          String maC5 = res['MaSanPham'];
          String sqlG =
              "SELECT MaSanPham FROM $tableDmMoTaSanPham  WHERE $columnDmMoTaSPMaSanPham = '$vcpaCap5' AND (substr($columnDmMoTaSPMaSanPham,1,3) not in (${maVcpaLoaiTruG_C3.map((e) => "'$e'").join(', ')}) AND substr($columnDmMoTaSPMaSanPham,1,4) not in (${maVcpaLoaiTruG_C4.map((e) => "'$e'").join(', ')}) AND substr($columnDmMoTaSPMaSanPham,1,5) not in (${maVcpaLoaiTruG_C5.map((e) => "'$e'").join(', ')}) )AND $columnDmMoTaSPMaLV ='G'";
          List<Map> maps = await db!.rawQuery(sqlG);
          List<String> cap5G = [];
          for (var item in maps) {
            item.forEach((key, value) {
              if (value != null) {
                cap5G.add(value);
              }
            });
          }
          isGResult = cap5G.isNotEmpty;
        }
        var isL = res['MaLV'] == 'L';
        if (isL) {
          String maC5 = res['MaSanPham'];
          // if (maC5 == maVcpaL6810) {
          //   isLResult = true;
          // } else {

          // }
          String maC56810 = maC5;
          if (maC5.length > 4) {
            maC56810 = maC5.substring(0, 4);
          }
          isLResult = maC56810 == maVcpaL6810;
          //  String sqlL =
          //       "SELECT MaSanPham FROM $tableDmMoTaSanPham  WHERE substr($columnDmMoTaSPMaSanPham,0,5) ='$maC56810' AND $columnDmMoTaSPMaLV ='L'";
          //   List<Map> maps = await db!.rawQuery(sqlL);
          //   List<String> cap5L = [];
          //   for (var item in maps) {
          //     item.forEach((key, value) {
          //       if (value != null) {
          //         cap5L.add(value);
          //       }
          //     });
          //   }
          //   isLResult = cap5L.isNotEmpty;
        }
      }
    }
    return isGResult || isLResult;
  }

  Future<bool> kiemTraMaNganhCap1ByMaSanPham5(
      String vcpaCap5Inputs, String vcpaCap1DieuKiens) async {
    List<String> result = [];
    //var vcpas = vcpaCap5s.map((e) => "'$e'").join(', ');
    var vcpa5Inputs = vcpaCap5Inputs.split(';');
    var vcpa1DieuKiens = vcpaCap1DieuKiens.split(';');
    String sql =
        "SELECT MaLV FROM $tableDmMoTaSanPham  WHERE $columnDmMoTaSPMaSanPham in (${vcpa5Inputs.map((e) => "'$e'").join(', ')}) AND $columnDmMoTaSPMaLV in (${vcpa1DieuKiens.map((e) => "'$e'").join(', ')})";
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

  Future<bool> kiemTraMaNganhCap2ByMaSanPham5(
      String vcpaCap5Inputs, String vcpaCap2DienKiens) async {
    List<String> result = [];
    //var vcpas = vcpaCap5s.map((e) => "'$e'").join(', ');
    var vcpa5Inputs = vcpaCap5Inputs.split(';');
    var vcpa2DieuKiens = vcpaCap2DienKiens.split(';');
    String sql =
        "SELECT MaLV FROM $tableDmMoTaSanPham  WHERE $columnDmMoTaSPMaSanPham in (${vcpa5Inputs.map((e) => "'$e'").join(', ')}) AND substr($columnDmMoTaSPMaSanPham,1,2) in (${vcpa2DieuKiens.map((e) => "'$e'").join(', ')})";
    print('sql $sql');
    List<Map> maps = await db!.rawQuery(sql);
    for (var item in maps) {
      item.forEach((key, value) {
        if (value != null) {
          result.add(value);
        }
      });
    }
    print('kiemTraMaNganhCap2ByMaSanPham5result $result');
    return result.isNotEmpty;
  }

  Future<bool> kiemTraMaNganhCap5ByMaSanPham5(
      String vcpaCap5Inputs, String vcpaCap5DieuKiens) async {
    List<String> result = [];
    //var vcpas = vcpaCap5s.map((e) => "'$e'").join(', ');
    var vcpa5Inputs = vcpaCap5Inputs.split(';');
    var vcpa5DieuKiens = vcpaCap5DieuKiens.split(';');
    String sql =
        "SELECT MaLV FROM $tableDmMoTaSanPham  WHERE $columnDmMoTaSPMaSanPham in (${vcpa5Inputs.map((e) => "'$e'").join(', ')}) AND substr($columnDmMoTaSPMaSanPham,1,5) in (${vcpa5DieuKiens.map((e) => "'$e'").join(', ')})";
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

  Future<int> countMaNganhCap5ByMaSanPham5(
      String vcpaCap5Inputs, String vcpaCap5DieuKiens) async {
    List<String> result = [];
    //var vcpas = vcpaCap5s.map((e) => "'$e'").join(', ');
    var vcpa5Inputs = vcpaCap5Inputs.split(';');
    var vcpa5DieuKiens = vcpaCap5DieuKiens.split(';');
    String sql =
        "SELECT MaLV FROM $tableDmMoTaSanPham  WHERE $columnDmMoTaSPMaSanPham in (${vcpa5Inputs.map((e) => "'$e'").join(', ')}) AND substr($columnDmMoTaSPMaSanPham,1,5) in (${vcpa5DieuKiens.map((e) => "'$e'").join(', ')})";
    List<Map> maps = await db!.rawQuery(sql);
    for (var item in maps) {
      item.forEach((key, value) {
        if (value != null) {
          result.add(value);
        }
      });
    }
    return result.length;
  }

  Future<int> countAll() async {
    var result = await db!.rawQuery('SELECT COUNT(*) FROM $tableDmMoTaSanPham');
    int? count = Sqflite.firstIntValue(result);
    return count ?? 0;
  }

  @override
  Future deletedTable(Database database) async {
    try {
      return await database
          .rawQuery('DROP TABLE IF EXISTS $tableDmMoTaSanPham');
    } catch (e) {
      return null;
    }
  }
}
