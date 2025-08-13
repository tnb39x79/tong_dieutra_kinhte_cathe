import 'dart:developer';

import 'package:gov_statistics_investigation_economic/resource/database/provider/dm_bkcoso_sxkd_nganh_sanpham_provider.dart';
import 'package:gov_statistics_investigation_economic/resource/database/provider/dm_cokhong_provider.dart';
import 'package:gov_statistics_investigation_economic/resource/database/provider/dm_dantoc_provider.dart';
import 'package:gov_statistics_investigation_economic/resource/database/provider/dm_gioitinh_provider.dart';
import 'package:gov_statistics_investigation_economic/resource/database/provider/dm_linhvuc_provider.dart';
import 'package:gov_statistics_investigation_economic/resource/database/provider/dm_mota_sanpham_provider.dart'; 
import 'package:gov_statistics_investigation_economic/resource/database/provider/xacnhan_logic_provider.dart';
import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

import 'provider/provider.dart';
import 'provider/provider_p07mau.dart';
import 'provider/provider_p07mau_dm.dart'; 

class DatabaseHelper {
  static const _databaseVersion = 1;
  static const _databaseName = 'DieuTraKinhTeCaTheTonGiao.db';
  final dataProvider = DataProvider();
  final doiTuongDieuTraProvider = DmDoiTuongDieuTraProvider(); 
  final bkCoSoSXKDProvider = BKCoSoSXKDProvider();
  final bkCoSoSXKDNganhSanPhamProvider = BKCoSoSXKDNganhSanPhamProvider();
  final dmMotaSanphamProvider = DmMotaSanphamProvider();
  final dmLinhvucProvider = DmLinhvucProvider();

  final diaBanCoSoSXKdProvider = DiaBanCoSoSXKDProvider(); 
  final diaBanCoSoSXKDProvider = DiaBanCoSoSXKDProvider();

  final dmTinhTrangHDProvider = DmTinhTrangHDProvider();
  final dmTrangThaiDTProvider = DmTrangThaiDTProvider();
  final dmCoKhongProvider = DmCoKhongProvider();
  final dmDanTocProvider = DmDanTocProvider();
  final dmGioiTinhProvider = DmGioiTinhProvider();
  //final dmTongHopKQProvider = DmTongHopKQProvider();
  final xacNhanLogicProvider = XacNhanLogicProvider();

  final userInfoProvider = UserInfoProvider();

  ///Phiếu Cá thể mẫu
  ///thieeus dm_cap, dm hoat dong logistic
  final ctDmCapProvider = DmCapProvider();
  final ctDmHoatDongLogisticProvider = CTDmHoatDongLogisticProvider();
  final ctDmDiaDiemSXKDProvider = CTDmDiaDiemSXKDProvider();
  final ctDmLinhVucProvider = CTDmLinhVucProvider();
  final ctDmLoaiDiaDiemProvider = CTDmLoaiDiaDiemProvider();
  final ctDmNhomNganhVcpaProvider = CTDmNhomNganhVcpaProvider();
  final dmQuocTichProvider = DmQuocTichProvider();
  final ctDmTinhTrangDKKDProvider = CTDmTinhTrangDKKDProvider();
  final ctDmTrinhDoChuyenMonProvider = CTDmTrinhDoChuyenMonProvider();

  final phieuMauProvider = PhieuMauProvider();
  final phieuMauA61Provider = PhieuMauA61Provider();
  final phieuMauA68Provider = PhieuMauA68Provider();
  final phieuMauSanphamProvider = PhieuMauSanphamProvider();
  

  // only have a single app-wide reference to the database
  static Database? _database;

  // make this a singleton class
  DatabaseHelper._privateConstructor();

  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  Future<Database> get database async {
    if (_database != null) return _database!;
    // lazily instantiate the db the first time it is accessed
    _database = await _initDatabase();
    await createTable(_database!);
    return _database!;
  }

  // this opens the database (and creates it if it doesn't exist)
  Future<Database> _initDatabase() async {
    String path = p.join(await getDatabasePath(), _databaseName);
    return await openDatabase(
      path,
      version: _databaseVersion,
      onUpgrade: (db, int? oldVersion, int? newVersion) async {
        if (newVersion != oldVersion) await deleteAll(db);
        createTable(db);
      },
      onCreate: _onCreateTable,
    );
  }

  // get path location database
  Future<String> getDatabasePath() async {
    // Get a location using getDatabasesPath
    var databasesPath = await getDatabasesPath();
    String path = p.join(databasesPath, _databaseName);
    return path;
  }

  //delete
  Future deleteDB() async {
    // Delete the database
    await deleteDatabase(await getDatabasePath());
  }

  // close
  Future closeDB() async {
    // Close the database
    await _database?.close();
  }

  Future _onCreateTable(Database db, int databaseVersion) async {
    log('onCreated table');
    // todo: create table when start app if not exist db
  }

  Future createTable(Database db) async {
    log('BEGIN::createTable', name: 'DatabaseHelper');
    await Future.wait([
      dataProvider.onCreateTable(db),
      doiTuongDieuTraProvider.onCreateTable(db),
      userInfoProvider.onCreateTable(db), 
      bkCoSoSXKDProvider.onCreateTable(db),
      bkCoSoSXKDNganhSanPhamProvider.onCreateTable(db),
      dmMotaSanphamProvider.onCreateTable(db),
      dmLinhvucProvider.onCreateTable(db),
      diaBanCoSoSXKdProvider.onCreateTable(db), 
      diaBanCoSoSXKDProvider.onCreateTable(db),
      dmTinhTrangHDProvider.onCreateTable(db),
      dmTrangThaiDTProvider.onCreateTable(db),
      dmCoKhongProvider.onCreateTable(db),
      dmDanTocProvider.onCreateTable(db),
      dmGioiTinhProvider.onCreateTable(db),
      xacNhanLogicProvider.onCreateTable(db)
    ]);

    // dm phieu cá thể mẫu
    await Future.wait([
      ctDmCapProvider.onCreateTable(db),
      ctDmHoatDongLogisticProvider.onCreateTable(db),
      ctDmDiaDiemSXKDProvider.onCreateTable(db),
      ctDmLinhVucProvider.onCreateTable(db),
      ctDmLoaiDiaDiemProvider.onCreateTable(db),
      ctDmNhomNganhVcpaProvider.onCreateTable(db),
      dmQuocTichProvider.onCreateTable(db),
      ctDmTinhTrangDKKDProvider.onCreateTable(db),
      ctDmTrinhDoChuyenMonProvider.onCreateTable(db),
     // ctDmNhomNganhVcpaProvider.onCreateTable(db)
    ]);

    // phieu cá thể mẫu
    await Future.wait([
      phieuMauProvider.onCreateTable(db),
      phieuMauA61Provider.onCreateTable(db),
      phieuMauA68Provider.onCreateTable(db),
      phieuMauSanphamProvider.onCreateTable(db)
    ]);

     

    log('END::Create all table compelete');
  }

  Future deleteAll(Database db) async {
    log('BEGIN::deleteAll table', name: 'DatabaseHelper');

    await dataProvider.deletedTable(db);
    await doiTuongDieuTraProvider.deletedTable(db);
    await userInfoProvider.deletedTable(db); 
    await bkCoSoSXKDNganhSanPhamProvider.deletedTable(db);
    await dmMotaSanphamProvider.deletedTable(db);
    await dmLinhvucProvider.deletedTable(db);
    await bkCoSoSXKDProvider.deletedTable(db);
    await diaBanCoSoSXKdProvider.deletedTable(db); 
    await diaBanCoSoSXKDProvider.deletedTable(db);
    // await dmTongHopKQProvider.deletedTable(db);
    await xacNhanLogicProvider.deletedTable(db);

    await dmTinhTrangHDProvider.deletedTable(db);
    await dmTrangThaiDTProvider.deletedTable(db);
    await dmCoKhongProvider.deletedTable(db);
    await dmDanTocProvider.deletedTable(db);
    await dmGioiTinhProvider.deletedTable(db);

    // DM hieu ca the mau
    await ctDmCapProvider.deletedTable(db);
    await ctDmHoatDongLogisticProvider.deletedTable(db);
    await ctDmLinhVucProvider.deletedTable(db);
    await ctDmDiaDiemSXKDProvider.deletedTable(db);
    await ctDmLoaiDiaDiemProvider.deletedTable(db);
    await dmQuocTichProvider.deletedTable(db);
    await ctDmTinhTrangDKKDProvider.deletedTable(db);
    await ctDmTrinhDoChuyenMonProvider.deletedTable(db);
    await ctDmNhomNganhVcpaProvider.deletedTable(db);

    // phieu ca the mau
    await phieuMauProvider.deletedTable(db);
    await phieuMauA61Provider.deletedTable(db);
    await phieuMauA68Provider.deletedTable(db);
    await phieuMauSanphamProvider.deletedTable(db);
 

    log('END::deleteAll table compelete');
    createTable(db);
  }

  ///DÙNG CHO LẤY DỮ LIỆU PHỎNG VẤN KHI NHẤN NÚT LẤY DỮ LIỆU PHỎNG VẤN : Chỉ tạo các talbe dữ liệu
  Future createOnlyDataTable(Database db) async {
    log('BEGIN::createDataTable', name: 'DatabaseHelper');
    await Future.wait([
      dataProvider.onCreateTable(db),
      doiTuongDieuTraProvider.onCreateTable(db),
      userInfoProvider.onCreateTable(db), 
      bkCoSoSXKDProvider.onCreateTable(db),
      bkCoSoSXKDNganhSanPhamProvider.onCreateTable(db),
      diaBanCoSoSXKdProvider.onCreateTable(db),
       
      diaBanCoSoSXKDProvider.onCreateTable(db),
      
      xacNhanLogicProvider.onCreateTable(db)
    ]);

    // phieu ca the mau

    await Future.wait([
      phieuMauProvider.onCreateTable(db),
      phieuMauA61Provider.onCreateTable(db),
      phieuMauA68Provider.onCreateTable(db),
      phieuMauSanphamProvider.onCreateTable(db)
    ]);
 
    log('END::Create all table compelete');
  }

  ///DÙNG CHO LẤY DỮ LIỆU PHỎNG VẤN KHI NHẤN NÚT LẤY DỮ LIỆU PHỎNG VẤN : Chỉ delete các table dữ liệu
  Future deleteOnlyDataTable(Database db) async {
    log('BEGIN::deleteDataTableAll table', name: 'DatabaseHelper');

    await dataProvider.deletedTable(db);
    await doiTuongDieuTraProvider.deletedTable(db);
    await userInfoProvider.deletedTable(db); 
    await bkCoSoSXKDNganhSanPhamProvider.deletedTable(db);
    await bkCoSoSXKDProvider.deletedTable(db);
    await diaBanCoSoSXKdProvider.deletedTable(db); 
    await diaBanCoSoSXKDProvider.deletedTable(db);
    //  await dmTongHopKQProvider.deletedTable(db);
    await xacNhanLogicProvider.deletedTable(db);

    // phieu ca mau
    phieuMauProvider.deletedTable(db);
    phieuMauA61Provider.deletedTable(db);
    phieuMauA68Provider.deletedTable(db);
    phieuMauSanphamProvider.deletedTable(db);
 
    log('END::deleteAll table compelete');
    createOnlyDataTable(db);
  }
}
