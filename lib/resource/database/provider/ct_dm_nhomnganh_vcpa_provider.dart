import 'package:gov_statistics_investigation_economic/resource/database/database_helper.dart';
import 'package:gov_statistics_investigation_economic/resource/database/provider/base_db_provider.dart';
import 'package:gov_statistics_investigation_economic/resource/database/table/table_ct_dm_nhomnganh_vcpa.dart';
import 'package:sqflite/sqflite.dart';

class CTDmNhomNganhVcpaProvider extends BaseDBProvider<TableCTDmNhomNganhVcpa> {
  static final CTDmNhomNganhVcpaProvider _singleton =
      CTDmNhomNganhVcpaProvider._internal();

  factory CTDmNhomNganhVcpaProvider() {
    return _singleton;
  }

  Database? db;

  CTDmNhomNganhVcpaProvider._internal();

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
      List<TableCTDmNhomNganhVcpa> value, String createdAt) async {
    try {
      await db!.delete(tableCTDmNhomNganhVcpa);
    } catch (e) {
      // developer.log(e.toString());
    }
    List<int> ids = [];
    for (var element in value) {
      ids.add(await db!.insert(tableCTDmNhomNganhVcpa, element.toJson()));
    }
    return ids;
  }

  Future<List<int>> insertNhomNganhVcpa(
      List<dynamic> value, String create) async {
    List<int> ids = [];
    for (dynamic map in value) {
      ids.add(await db!.insert(tableCTDmNhomNganhVcpa, map));
    }
    return ids;
  }

  @override
  Future onCreateTable(Database database) async {
    return database.execute('''
      CREATE TABLE IF NOT EXISTS $tableCTDmNhomNganhVcpa
      (
        $columnCTDmNhomNganhVcpaId INTEGER PRIMARY KEY AUTOINCREMENT,
        $columnCTDmNhomNganhVcpaCap1 TEXT,
        $columnCTDmNhomNganhVcpaCap5 TEXT,
        $columnCTDmNhomNganhVcpaDonViTinh TEXT,
        $columnCTDmNhomNganhVcpaLinhVuc TEXT,
        $columnCTDmNhomNganhVcpaMoTaNganhSanPham TEXT
      )
      ''');
  }

  @override
  Future<List<Map>> selectAll() async {
    return await db!.query(tableCTDmNhomNganhVcpa);
  }

  @override
  Future<Map> selectOne(int id) {
    // TODO: implement selectOne
    throw UnimplementedError();
  }

  @override
  Future update(TableCTDmNhomNganhVcpa value, String id) {
    // TODO: implement update
    throw UnimplementedError();
  }

  Future<List<Map>> searchCap8(String key) async {
    final List<Map> maps = await db!.query(tableCTDmNhomNganhVcpa, where: '''
      $columnCTDmNhomNganhVcpaMoTaNganhSanPham LIKE '%$key%' 
      ''');

    return maps;
  }

  Future<List<Map>> searchVcpaCap5(String keyword) async {
    final List<Map> maps = await db!.query(tableCTDmNhomNganhVcpa, where: '''
      $columnCTDmNhomNganhVcpaMoTaNganhSanPham LIKE '%$keyword%'
      OR $columnCTDmNhomNganhVcpaMoTaNganhSanPham LIKE '%$keyword%'
      ''');

    return maps;
  }

  Future<List<Map>> selectAlls() async {
    final List<Map> maps = await db!.query(tableCTDmNhomNganhVcpa);
    return maps;
  }

  Future<bool> hasCap8(String cap5Cap8) async {
    var map = await db!.rawQuery('''
      select * from $tableCTDmNhomNganhVcpa where Cap5 = '$cap5Cap8' and length(Cap5)==8
    ''');

    if (map.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> hasCap5(String cap5Cap8) async {
    var map = await db!.rawQuery('''
      select * from $tableCTDmNhomNganhVcpa where Cap5 = '$cap5Cap8' and length(Cap5)==5
    ''');

    if (map.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }
Future<bool> hasMaVcpa(String cap5Cap8) async {
    var map = await db!.rawQuery('''
      select * from $tableCTDmNhomNganhVcpa where Cap5 = '$cap5Cap8'
    ''');

    if (map.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }
  Future<Map> getByVcpaCap5(String vcpaCap5) async {
    final List<Map> maps = await db!.query(tableCTDmNhomNganhVcpa, where: '''
      $columnCTDmNhomNganhVcpaCap5 = '$vcpaCap5' 
      ''');

    if (maps.isNotEmpty) {
      return maps[0];
    }
    return {};
  }

  Future<Map> getByVcpaCap5s(List<String> vcpaCap5s) async {
    var vcpas = List.filled(vcpaCap5s.length, '?').join(',');
    final List<Map> maps = await db!.query(tableCTDmNhomNganhVcpa, where: '''
      $columnCTDmNhomNganhVcpaCap5 in ($vcpas}) 
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
        "SELECT Cap1 FROM $tableCTDmNhomNganhVcpa  WHERE ($columnCTDmNhomNganhVcpaCap5 in (${vcpaCap5s.map((e) => "'$e'").join(', ')}) OR substr($columnCTDmNhomNganhVcpaCap5,1,5) in (${vcpaCap5s.map((e) => "'$e'").join(', ')}) )AND $columnCTDmNhomNganhVcpaCap1 in ('B','C','E')";
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
        "SELECT Cap1 FROM $tableCTDmNhomNganhVcpa  WHERE ($columnCTDmNhomNganhVcpaCap5 in (${vcpa5Inputs.map((e) => "'$e'").join(', ')})  OR  substr($columnCTDmNhomNganhVcpaCap5,1,5) in (${vcpa5Inputs.map((e) => "'$e'").join(', ')})) AND $columnCTDmNhomNganhVcpaCap1 in ('B','C','D','E')";
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
    final List<Map> maps = await db!.query(tableCTDmNhomNganhVcpa, where: '''
      $columnCTDmNhomNganhVcpaCap5 = '$vcpaCap5' 
      ''');
    bool isGResult = false;
    bool isLResult = false;
    if (maps.isNotEmpty) {
      var res = maps[0];
      if (res != null) {
        var isG = res['Cap1'] == 'G';
        if (isG) {
          String maC5 = res['Cap5'];
          String sqlG =
              "SELECT Cap5 FROM $tableCTDmNhomNganhVcpa  WHERE $columnCTDmNhomNganhVcpaCap5 = '$vcpaCap5' AND (substr($columnCTDmNhomNganhVcpaCap5,1,3) not in (${maVcpaLoaiTruG_C3.map((e) => "'$e'").join(', ')}) AND substr($columnCTDmNhomNganhVcpaCap5,1,4) not in (${maVcpaLoaiTruG_C4.map((e) => "'$e'").join(', ')}) AND substr($columnCTDmNhomNganhVcpaCap5,1,5) not in (${maVcpaLoaiTruG_C5.map((e) => "'$e'").join(', ')}) )AND $columnCTDmNhomNganhVcpaCap1 ='G'";
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
        var isL = res['Cap1'] == 'L';
        if (isL) {
          String maC5 = res['Cap5'];
          String sqlL =
              "SELECT Cap5 FROM $tableCTDmNhomNganhVcpa  WHERE substr($columnCTDmNhomNganhVcpaCap5,1,4) ='$maVcpaL6810' AND $columnCTDmNhomNganhVcpaCap1 ='L'";
          List<Map> maps = await db!.rawQuery(sqlL);
          List<String> cap5L = [];
          for (var item in maps) {
            item.forEach((key, value) {
              if (value != null) {
                cap5L.add(value);
              }
            });
          }
          isLResult = cap5L.isNotEmpty;
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
        "SELECT Cap1 FROM $tableCTDmNhomNganhVcpa  WHERE $columnCTDmNhomNganhVcpaCap5 in (${vcpa5Inputs.map((e) => "'$e'").join(', ')}) AND $columnCTDmNhomNganhVcpaCap1 in (${vcpa1DieuKiens.map((e) => "'$e'").join(', ')})";
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
        "SELECT Cap1 FROM $tableCTDmNhomNganhVcpa  WHERE $columnCTDmNhomNganhVcpaCap5 in (${vcpa5Inputs.map((e) => "'$e'").join(', ')}) AND substr($columnCTDmNhomNganhVcpaCap5,1,2) in (${vcpa2DieuKiens.map((e) => "'$e'").join(', ')})";
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

  Future<bool> kiemTraMaNganhCap5ByMaSanPham5(
      String vcpaCap5Inputs, String vcpaCap5DieuKiens) async {
    List<String> result = [];
    //var vcpas = vcpaCap5s.map((e) => "'$e'").join(', ');
    var vcpa5Inputs = vcpaCap5Inputs.split(';');
    var vcpa5DieuKiens = vcpaCap5DieuKiens.split(';');
    String sql =
        "SELECT Cap1 FROM $tableCTDmNhomNganhVcpa  WHERE $columnCTDmNhomNganhVcpaCap5 in (${vcpa5Inputs.map((e) => "'$e'").join(', ')}) AND substr($columnCTDmNhomNganhVcpaCap5,1,5) in (${vcpa5DieuKiens.map((e) => "'$e'").join(', ')})";
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
        "SELECT Cap1 FROM $tableCTDmNhomNganhVcpa  WHERE $columnCTDmNhomNganhVcpaCap5 in (${vcpa5Inputs.map((e) => "'$e'").join(', ')}) AND substr($columnCTDmNhomNganhVcpaCap5,1,5) in (${vcpa5DieuKiens.map((e) => "'$e'").join(', ')})";
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
    var result =
        await db!.rawQuery('SELECT COUNT(*) FROM $tableCTDmNhomNganhVcpa');
    int? count = Sqflite.firstIntValue(result);
    return count ?? 0;
  }

  @override
  Future deletedTable(Database database) async {
    try {
      return await database
          .rawQuery('DROP TABLE IF EXISTS $tableCTDmNhomNganhVcpa');
    } catch (e) {
      return null;
    }
  }
}
