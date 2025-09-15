import 'dart:ffi';

import 'package:gov_statistics_investigation_economic/resource/database/table/table_dm_bkcoso_sxkd_nganh_sanpham.dart';
import 'package:gov_statistics_investigation_economic/resource/database/table/table_p07mau.dart';
import 'package:gov_statistics_investigation_economic/resource/model/question/product_model.dart';

///Bảng kê cơ sở sản xuất kinh doanh CT_DI_BKCoSoSXKD
///
const String tablebkCoSoSXKD = 'DmBkCoSoSXKD';
const String colBkCoSoSXKDId = '_id';
const String colBkCoSoSXKDIDCoSo = 'IDCoSo';
const String colBkCoSoSXKDLoaiPhieu = 'LoaiPhieu';
const String colBkCoSoSXKDMaTinh = 'MaTinh';
const String colBkCoSoSXKDTenTinh = 'TenTinh';
const String colBkCoSoSXKDMaTKCS = 'MaTKCS';
const String colBkCoSoSXKDTenTKCS = 'TenTKCS';
const String colBkCoSoSXKDMaXa = 'MaXa';
const String colBkCoSoSXKDTenXa = 'TenXa';
const String colBkCoSoSXKDMaThon = 'MaThon';
const String colBkCoSoSXKDTenThon = 'TenThon';
const String colBkCoSoSXKDIDDB = 'IDDB';
const String colBkCoSoSXKDMaDiaBan = 'MaDiaBan';
const String colBkCoSoSXKDTenDiaBan = 'TenDiaBan';
const String colBkCoSoSXKDMaCoSo = 'MaCoSo';
const String colBkCoSoSXKDTenCoSo = 'TenCoSo';
const String colBkCoSoSXKDDiaChi = 'DiaChi';
const String colBkCoSoSXKDTenChuCoSo = 'TenChuCoSo';
const String colBkCoSoSXKDMaDiaDiem = 'MaDiaDiem';
const String colBkCoSoSXKDDienThoai = 'DienThoai';
const String colBkCoSoSXKDEmail = 'Email';
const String colBkCoSoSXKDSoLaoDong = 'SoLaoDong';
const String colBkCoSoSXKDDoanhThu = 'DoanhThu';
const String colBkCoSoSXKDMaTinhTrangHD = 'MaTinhTrangHD';
const String colBkCoSoSXKDTenNguoiCungCap = 'TenNguoiCungCap';
const String colBkCoSoSXKDDienThoaiNguoiCungCap = 'DienThoaiNguoiCungCap';
const String colBkCoSoSXKDMaDTV = 'MaDTV';
const String colBkCoSoSXKDMaTrangThaiDT = 'MaTrangThaiDT';
//const String columnBkCoSoSXKDMauBoSung = 'MauBoSung';
///0: chưa insert; 1: đã insert logic; vào bảng Xác nhận logic
const String colBkCoSoSXKDTrangThaiLogic = 'TrangThaiLogic';
const String colBkCoSoSXKDIsSyncSuccess = 'SyncSuccess';

/// tablebkCoSoSXKD -> TablebkCoSoSXKD gồm
/// List DanhSachCoSoSXKD_PV

class TableBkCoSoSXKD {
  int? id;
  String? iDCoSo;
  int? loaiPhieu;
  String? maTinh;
  String? tenTinh;
  String? maTKCS;
  String? tenTKCS;
  String? maXa;
  String? tenXa;
  String? maThon;
  String? tenThon;
  String? iDDB;
  String? maDiaBan;
  String? tenDiaBan;
  int? maCoSo;
  String? tenCoSo;
  String? diaChi;
  String? tenChuCoSo;
  String? maDiaDiem;
  String? dienThoai;
  String? email;
  int? soLaoDong;
  double? doanhThu;
  int? maTinhTrangHD;
  String? tenNguoiCungCap;
  String? dienThoaiNguoiCungCap;
  String? maDTV;
  int? maTrangThaiDT;
  int? trangThaiLogic;
  int? isSyncSuccess;
  String? createdAt;
  String? updatedAt;

  List<TableBkCoSoSXKDNganhSanPham>? tableNganhSanPhams;
  TablePhieu? tablePhieu;

  TableBkCoSoSXKD(
      {this.id,
      this.iDCoSo,
      this.loaiPhieu,
      this.maTinh,
      this.maTKCS,
      this.maXa,
      this.maThon,
      this.tenThon,
      this.iDDB,
      this.maDiaBan,
      this.tenDiaBan,
      this.maCoSo,
      this.tenCoSo,
      this.diaChi,
      this.tenChuCoSo,
      this.maDiaDiem,
      this.dienThoai,
      this.email,
      this.soLaoDong,
      this.doanhThu,
      this.maTinhTrangHD,
      this.tenNguoiCungCap,
      this.dienThoaiNguoiCungCap,
      this.maDTV,
      this.maTrangThaiDT,
      this.tablePhieu,
      this.tableNganhSanPhams,
      this.trangThaiLogic,
      this.isSyncSuccess,
      this.createdAt,
      this.updatedAt});

  TableBkCoSoSXKD.fromJson(dynamic json) {
    id = json['_id'];
    iDCoSo = json['IDCoSo'];
    loaiPhieu = json['LoaiPhieu'];
    maTinh = json['MaTinh'];
    tenTinh = json['TenTinh'];
    maTKCS = json['MaTKCS'];
    tenTKCS = json['TenTKCS'];
    maXa = json['MaXa'];
    tenXa = json['TenXa'];
    maThon = json['MaThon'];
    tenThon = json['TenThon'];
    iDDB = json['IDDB'];
    maDiaBan = json['MaDiaBan'];
    tenDiaBan = json['TenDiaBan'];
    maCoSo = json['MaCoSo'];
    tenCoSo = json['TenCoSo'];
    diaChi = json['DiaChi'];
    tenChuCoSo = json['TenChuCoSo'];
    maDiaDiem = json['MaDiaDiem'];
    dienThoai = json['DienThoai'];
    email = json['Email'];
    soLaoDong = json['SoLaoDong'];
    doanhThu = json['DoanhThu'];
    maTinhTrangHD = json['MaTinhTrangHD'];
    tenNguoiCungCap = json['TenNguoiCungCap'];
    dienThoaiNguoiCungCap = json['DienThoaiNguoiCungCap'];
    maDTV = json['MaDTV'];
    maTrangThaiDT = json['MaTrangThaiDT'];

    isSyncSuccess = json['SyncSuccess'];
    createdAt = json['CreatedAt'];
    updatedAt = json['UpdatedAt'];

    //tenDiaDiem = json['TenDiaDiem'];
    tablePhieu = json['PhieuCaTheResponseDto'] != null
        ? TablePhieu.fromJson(json['PhieuCaTheResponseDto'])
        : null;
    tableNganhSanPhams = json['CT_DI_BKCoSoSXKD_NganhDtos'] != null
        ? TableBkCoSoSXKDNganhSanPham.listFromJson(
            json['CT_DI_BKCoSoSXKD_NganhDtos'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['IDCoSo'] = iDCoSo;
    json['LoaiPhieu'] = loaiPhieu;
    json['MaTinh'] = maTinh;
    json['TenTinh'] = tenTinh;
    json['MaTKCS'] = maTKCS;
    json['TenTKCS'] = tenTKCS;
    json['MaXa'] = maXa;
    json['TenXa'] = tenXa;
    json['MaThon'] = maThon;
    json['TenThon'] = tenThon;
    json['IDDB'] = iDDB;
    json['MaDiaBan'] = maDiaBan;
    json['TenDiaBan'] = tenDiaBan;
    json['MaCoSo'] = maCoSo;
    json['TenCoSo'] = tenCoSo;
    json['DiaChi'] = diaChi;
    json['TenChuCoSo'] = tenChuCoSo;
    json['MaDiaDiem'] = maDiaDiem;
    json['DienThoai'] = dienThoai;
    json['Email'] = email;
    json['SoLaoDong'] = soLaoDong;
    json['DoanhThu'] = doanhThu;
    json['MaTinhTrangHD'] = maTinhTrangHD;
    json['TenNguoiCungCap'] = tenNguoiCungCap;
    json['DienThoaiNguoiCungCap'] = dienThoaiNguoiCungCap;
    json['MaDTV'] = maDTV;
    json['MaTrangThaiDT'] = maTrangThaiDT;
    json['TrangThaiLogic'] = trangThaiLogic;
    json['SyncSuccess'] = isSyncSuccess;
    json['CreatedAt'] = createdAt;
    json['UpdatedAt'] = updatedAt;

    return json;
  }

  static List<TableBkCoSoSXKD> listFromJson(dynamic json) {
    List<TableBkCoSoSXKD> list = [];
    if (json != null) {
      for (var item in json) {
        list.add(TableBkCoSoSXKD.fromJson(item));
      }
    }
    return list;
  }
}
