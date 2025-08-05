import 'dart:ffi';

import 'package:gov_statistics_investigation_economic/resource/database/table/table_dm_bkcoso_sxkd_nganh_sanpham.dart';
import 'package:gov_statistics_investigation_economic/resource/database/table/table_p07mau.dart';
import 'package:gov_statistics_investigation_economic/resource/model/question/product_model.dart';

///Bảng kê cơ sở sản xuất kinh doanh CT_DI_BKCoSoSXKD
///
const String tablebkCoSoSXKD = 'DmBkCoSoSXKD';
const String columnBkCoSoSXKDId = '_id';
const String columnBkCoSoSXKDMaPhieu = 'MaPhieu';
const String columnBkCoSoSXKDIDCoSo = 'IDCoSo';
const String columnBkCoSoSXKDMaTinh = 'MaTinh';
const String columnBkCoSoSXKDTenTinh = 'TenTinh';
const String columnBkCoSoSXKDMaHuyen = 'MaHuyen';
const String columnBkCoSoSXKDTenHuyen = 'TenHuyen';
const String columnBkCoSoSXKDMaXa = 'MaXa';
const String columnBkCoSoSXKDTenXa = 'TenXa';
const String columnBkCoSoSXKDMaThon = 'maThon';
const String columnBkCoSoSXKDTenThon = 'TenThon';
const String columnBkCoSoSXKDMaDiaBan = 'MaDiaBan';
const String columnBkCoSoSXKDTenDiaBan = 'TenDiaBan';
const String columnBkCoSoSXKDMaDiaDiem = 'MaDiaDiem';
const String columnBkCoSoSXKDTenDiaDiem = 'TenDiaDiem';
const String columnBkCoSoSXKDMaCoSo = 'MaCoSo';
const String columnBkCoSoSXKDTenCoSo = 'TenCoSo';
const String columnbkCoSoSXKDMaSoThue = 'MaSoThue';
const String columnBkCoSoSXKDDiaChi = 'DiaChi';
const String columnBkCoSoSXKDDienThoai = 'DienThoai';
const String columnBkCoSoSXKDEmail = 'Email';
const String columnBkCoSoSXKDSoLaoDong = 'SoLaoDong';
const String columnBkCoSoSXKDDoanhThu = 'DoanhThu';

const String columnBkCoSoSXKDMaTinhTrangHD = 'MaTinhTrangHD';
const String columnBkCoSoSXKDMaTinhTrangHDTruocTD = 'MaTinhTrangHDTruocTD';
const String columnBkCoSoSXKDMaTrangThaiDT = 'MaTrangThaiDT';
const String columnBkCoSoSXKDTenNguoiCungCap = 'TenNguoiCungCap';
const String columnBkCoSoSXKDDienThoaiNguoiCungCap = 'DienThoaiNguoiCungCap';
const String columnBkCoSoSXKDIDCoSoDuPhong = 'IDCoSo_DuPhong';
const String columnBkCoSoSXKDIDCoSoThayThe = 'IDCoSo_ThayThe';
const String columnBkCoSoSXKDMaDTV = 'MaDTV';
const String columnBkCoSoSXKDLoaiDieuTra = 'LoaiDieuTra';
//const String columnBkCoSoSXKDMauBoSung = 'MauBoSung';
///0: chưa insert; 1: đã insert logic; vào bảng Xác nhận logic
const String columnBkCoSoSXKDTrangThaiLogic = 'TrangThaiLogic';
const String columnBkCoSoSXKDIsSyncSuccess = 'SyncSuccess';

/// tablebkCoSoSXKD -> TablebkCoSoSXKD gồm
/// List DanhSachCoSoSXKD_PV

class TableBkCoSoSXKD {
  int? id;
  int? maPhieu;
  String? iDCoSo;
  String? maTinh;
  String? tenTinh;
  String? maHuyen;
  String? tenHuyen;
  String? maXa;
  String? tenXa;
  String? maThon;
  String? tenThon;
  String? maDiaBan;
  String? tenDiaBan;
  int? maCoSo;
  String? tenCoSo;
  //int? coSoSo;

  String? maSoThue;
  String? diaChi;
  String? dienThoai;
  String? email;
  String? maDiaDiem;
  String? tenDiaDiem;
  double? doanhThu;
  int? soLaoDong;
  int? maTinhTrangHD;

  int? maTinhTrangHDTruocTD;
  String? tenNguoiCungCap;
  String? dienThoaiNguoiCungCap;

  String? maDTV;
  int? maTrangThaiDT;
  String? iDCoSoDuPhong;
  String? iDCoSoThayThe;
  int? loaiDieuTra;
  int? trangThaiLogic;
  int? isSyncSuccess;
  String? createdAt;
  String? updatedAt;

  List<TableBkCoSoSXKDNganhSanPham>? tableNganhSanPhams;
  TablePhieuMau? tablePhieuMau;

  TableBkCoSoSXKD(
      {this.id,
      this.maPhieu,
      this.iDCoSo,
      this.maTinh,
      this.tenTinh,
      this.maHuyen,
      this.tenHuyen,
      this.maXa,
      this.tenXa,
      this.maThon,
      this.tenThon,
      this.maDiaBan,
      this.tenDiaBan,
      this.maDiaDiem,
      this.tenDiaDiem,
      this.maCoSo,
      this.tenCoSo,
      this.maSoThue,
      this.diaChi,
      this.dienThoai,
      this.doanhThu,
      this.soLaoDong,
      this.maTinhTrangHD,
      this.maTinhTrangHDTruocTD,
      this.iDCoSoDuPhong,
      this.iDCoSoThayThe,
      this.maDTV,
      this.maTrangThaiDT,
      this.tablePhieuMau,
      this.tableNganhSanPhams,
      this.trangThaiLogic,
      this.loaiDieuTra,
      this.isSyncSuccess,
      this.createdAt,
      this.updatedAt});

  TableBkCoSoSXKD.fromJson(dynamic json) {
    id = json['_id'];
    maPhieu = json['MaPhieu'];
    iDCoSo = json['IDCoSo'];
    maTinh = json['MaTinh'];
    tenTinh = json['TenTinh'];
    maHuyen = json['MaHuyen'];
    tenHuyen = json['TenHuyen'];
    maXa = json['MaXa'];
    tenXa = json['TenXa'];
    maThon = json['MaThon'];
    tenThon = json['TenThon'];
    maDiaBan = json['MaDiaBan'];
    tenDiaBan = json['TenDiaBan'];
    maCoSo = json['MaCoSo'];
    tenCoSo = json['TenCoSo'];

    maSoThue = json['MaSoThue'];
    diaChi = json['DiaChi'];
    dienThoai = json['DienThoai'];

    doanhThu = json['DoanhThuUocTinh'];
    soLaoDong = json['SoLaodong'];

    maTinhTrangHD = json['MaTinhTrangHD'];
    maTrangThaiDT = json['MaTrangThaiDT'];
    maTinhTrangHDTruocTD = json['MaTinhTrangHDTruocTD'];
    tenNguoiCungCap = json['TenNguoiCungCap'];
    dienThoaiNguoiCungCap = json['DienThoaiNguoiCungCap'];
    iDCoSoDuPhong = json['IDCoSo_DuPhong'];
    iDCoSoThayThe = json['IDCoSo_ThayThe'];

    maDTV = json['MaDTV'];
    loaiDieuTra =
        (json['LoaiDieuTra'] == true || json['LoaiDieuTra'] == "true") ? 1 : 0;
    isSyncSuccess = json['SyncSuccess'];
    createdAt = json['CreatedAt'];
    updatedAt = json['UpdatedAt'];
    //maDiaDiem = json['MaDiaDiem'];
    //tenDiaDiem = json['TenDiaDiem'];
    tablePhieuMau = json['PhieuCaTheResponseDto'] != null
        ? TablePhieuMau.fromJson(json['PhieuCaTheResponseDto'])
        : null;
    tableNganhSanPhams = json['cT_DI_BKCoSoSXKD_NganhDtos'] != null
        ? TableBkCoSoSXKDNganhSanPham.listFromJson(
            json['cT_DI_BKCoSoSXKD_NganhDtos'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['MaPhieu'] = maPhieu;
    data['IDCoSo'] = iDCoSo;
    data['MaTinh'] = maTinh;
    data['TenTinh'] = tenTinh;
    data['MaHuyen'] = maHuyen;
    data['TenHuyen'] = tenHuyen;
    data['MaXa'] = maXa;
    data['TenXa'] = tenXa;
    data['MaDiaBan'] = maDiaBan;
    data['TenDiaBan'] = tenDiaBan;
    data['MaCoSo'] = maCoSo;
    data['TenCoSo'] = tenCoSo;
    data['TenThon'] = tenThon;
    data['MaDiaDiem'] = maDiaDiem;
    data['TenDiaDiem'] = tenDiaDiem;
    data['MaSoThue'] = maSoThue;
    data['DiaChi'] = diaChi;
    data['DienThoai'] = dienThoai;

    data['DoanhThu'] = doanhThu;
    data['soLaoDong'] = soLaoDong;
    data['MaTinhTrangHD'] = maTinhTrangHD;
    data['MaTrangThaiDT'] = maTrangThaiDT;
    data['MaTinhTrangHDTruocTD'] = maTinhTrangHDTruocTD;
    data['IDCoSo_DuPhong'] = iDCoSoDuPhong;
    data['IDCoSo_ThayThe'] = iDCoSoThayThe;
    data['TenNguoiCungCap'] = tenNguoiCungCap;
    data['DienThoaiNguoiCungCap'] = dienThoaiNguoiCungCap;
    data['MaDTV'] = maDTV;
    data['TrangThaiLogic'] = trangThaiLogic;
    data['LoaiDieuTra'] = loaiDieuTra;
    data['SyncSuccess'] = isSyncSuccess;
    data['CreatedAt'] = createdAt;
    data['UpdatedAt'] = updatedAt;

    return data;
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
