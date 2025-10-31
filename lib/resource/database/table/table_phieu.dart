import 'package:gov_statistics_investigation_economic/resource/database/table/table_phieu_mautb.dart';

import 'table_p07mau.dart';

///Trường xác định cơ sở cá thể đó <3 tháng, và doanh thu <100triệu là không thoả mãn điều kiện là cơ sở sxkd: lưu gía trị=0 ngược lại thoả mãn lưu  =1
const String tablePhieu = 'CT_Phieu';

const String colPhieuID = '_id';
const String colPhieuIDCoSo = 'IDCoSo';
const String colPhieuLoaiPhieu = 'LoaiPhieu';
const String colPhieuMaTinh = 'MaTinh';
const String colPhieuMaTKCS = 'MaTKCS';
const String colPhieuMaXa = 'MaXa';
const String colPhieuMaThon = 'MaThon';
const String colPhieuIDDB = 'IDDB';
const String colPhieuMaDiaBan = 'MaDiaBan';
const String colPhieuTrangThaiCoSo = 'TrangThaiCoSo';
const String colPhieuMaCoSo = 'MaCoSo';
const String colPhieuTenCoSo = 'TenCoSo';
const String colPhieuDiaChi = 'DiaChi';
const String colPhieuTenChuCoSo = 'TenChuCoSo';
const String colPhieuSDTCoSo = 'SDTCoSo';
const String colPhieuMaNganhMau = 'MaNganhMau';
const String colPhieuMaDTV = 'MaDTV';
const String colPhieuKinhDo = 'KinhDo';
const String colPhieuViDo = 'ViDo';
const String colPhieuNguoiTraLoi = 'NguoiTraLoi';
const String colPhieuSoDienThoai = 'SoDienThoai';
const String colPhieuThoiGianBD = 'ThoiGianBD';
const String colPhieuThoiGianKT = 'ThoiGianKT';
const String colPhieuGhiChu = 'GhiChu';
const String colPhieuGiaiTrinhToaDo = 'GiaiTrinhToaDo';
const String colPhieuGiaiTrinhThoiGianPV = 'GiaiTrinhThoiGianPV';
const String colPhieuNgayCapNhat = 'NgayCapNhat';

const String colPhieuCreatedAt = 'CreatedAt';
const String colPhieuUpdatedAt = 'UpdatedAt';

class TablePhieu {
  int? id;
  String? iDCoSo;
  int? loaiPhieu;
  String? maTinh;
  String? maTKCS;
  String? maXa;
  String? maThon;
  String? iDDB;
  String? maDiaBan;
  int? trangThaiCoSo;
  int? maCoSo;
  String? tenCoSo;
  String? diaChi;
  String? tenChuCoSo;
  String? sDTCoSo;
  String? maNganhMau;
  String? maDTV;
  double? kinhDo;
  double? viDo;
  String? nguoiTraLoi;
  String? soDienThoai;
  String? thoiGianBD;
  String? thoiGianKT;
  String? ghiChu;
  String? giaiTrinhToaDo;
  String? giaiTrinhThoiGianPV;
  String? ngayCapNhat;

  //String? hoTenDTV;
  //String? soDienThoaiDTV;
  String? createdAt;
  String? updatedAt;
  TablePhieuMauTB? tablePhieuMauTB;
  List<TablePhieuMauTBSanPham>? tablePhieuMauTBSanPham;
  List<TablePhieuNganhCN>? tablePhieuNganhCN;
  TablePhieuNganhLT? tablePhieuNganhLT;
  TablePhieuNganhTM? tablePhieuNganhTM;
  List<TablePhieuNganhTMSanPham>? tablePhieuNganhTMSanPham;
  TablePhieuNganhVT? tablePhieuNganhVT;

  TablePhieu(
      {this.id,
      this.iDCoSo,
      this.loaiPhieu,
      this.maTinh,
      this.maTKCS,
      this.maXa,
      this.maThon,
      this.iDDB,
      this.maDiaBan,
      this.trangThaiCoSo,
      this.maCoSo,
      this.tenCoSo,
      this.diaChi,
      this.tenChuCoSo,
      this.sDTCoSo,
      this.maNganhMau,
      this.maDTV,
      this.kinhDo,
      this.viDo,
      this.nguoiTraLoi,
      this.soDienThoai,
      this.thoiGianBD,
      this.thoiGianKT,
      this.ghiChu,
      this.giaiTrinhToaDo,
      this.giaiTrinhThoiGianPV,
      this.ngayCapNhat,
      this.tablePhieuMauTB,
      this.tablePhieuMauTBSanPham,
      this.tablePhieuNganhCN,
      this.tablePhieuNganhLT,
      this.tablePhieuNganhTM,
      this.tablePhieuNganhTMSanPham,
      this.tablePhieuNganhVT,
      this.createdAt,
      this.updatedAt});

  TablePhieu.fromJson(dynamic json) {
    id = json['_id'];
    iDCoSo = json['IDCoSo'];
    loaiPhieu = json['LoaiPhieu'];
    maTinh = json['MaTinh'];
    maTKCS = json['MaTKCS'];
    maXa = json['MaXa'];
    maThon = json['MaThon'];
    iDDB = json['IDDB'];
    maDiaBan = json['MaDiaBan'];
    trangThaiCoSo = json['TrangThaiCoSo'];
    maCoSo = json['MaCoSo'];
    tenCoSo = json['TenCoSo'];
    diaChi = json['DiaChi'];
    tenChuCoSo = json['TenChuCoSo'];
    sDTCoSo = json['SDTCoSo'];
    maNganhMau = json['MaNganhMau'];
    maDTV = json['MaDTV'];
    kinhDo = json['KinhDo'];
    viDo = json['ViDo'];
    nguoiTraLoi = json['NguoiTraLoi'];
    soDienThoai = json['SoDienThoai'];
    thoiGianBD = json['ThoiGianBD'];
    thoiGianKT = json['ThoiGianKT'];
    ghiChu = json['GhiChu'];
    giaiTrinhToaDo = json['GiaiTrinhToaDo'];
    giaiTrinhThoiGianPV = json['GiaiTrinhThoiGianPV'];
    ngayCapNhat = json['NgayCapNhat'];

    tablePhieuMauTB = json['Phieu_MauTB'] != null
        ? TablePhieuMauTB.fromJson(json['Phieu_MauTB'])
        : null;
    tablePhieuMauTBSanPham = json['Phieu_MauTB_SanPham'] != null
        ? TablePhieuMauTBSanPham.fromListJson(json['Phieu_MauTB_SanPham'])
        : null;
    tablePhieuNganhCN = json['Phieu_NganhCN'] != null
        ? TablePhieuNganhCN.fromListJson(json['Phieu_NganhCN'])
        : null;
    tablePhieuNganhLT = json['Phieu_NganhLT'] != null
        ? TablePhieuNganhLT.fromJson(json['Phieu_NganhLT'])
        : null;

    tablePhieuNganhTM = json['Phieu_NganhTM'] != null
        ? TablePhieuNganhTM.fromJson(json['Phieu_NganhTM'])
        : null;

    tablePhieuNganhTMSanPham = json['Phieu_NganhTM_SanPham'] != null
        ? TablePhieuNganhTMSanPham.fromListJson(json['Phieu_NganhTM_SanPham'])
        : null;

    tablePhieuNganhVT = json['Phieu_NganhVT'] != null
        ? TablePhieuNganhVT.fromJson(json['Phieu_NganhVT'])
        : null;

    createdAt = json['CreatedAt'];
    updatedAt = json['UpdatedAt'];
  }

  Map<String, Object?> toJson() {
    var json = <String, Object?>{};
    json['IDCoSo'] = iDCoSo;
    json['LoaiPhieu'] = loaiPhieu;
    json['MaTinh'] = maTinh;
    json['MaTKCS'] = maTKCS;
    json['MaXa'] = maXa;
    json['MaThon'] = maThon;
    json['IDDB'] = iDDB;
    json['MaDiaBan'] = maDiaBan;
    json['TrangThaiCoSo'] = trangThaiCoSo;
    json['MaCoSo'] = maCoSo;
    json['TenCoSo'] = tenCoSo;
    json['DiaChi'] = diaChi;
    json['TenChuCoSo'] = tenChuCoSo;
    json['SDTCoSo'] = sDTCoSo;
    json['MaNganhMau'] = maNganhMau;
    json['MaDTV'] = maDTV;
    json['KinhDo'] = kinhDo;
    json['ViDo'] = viDo;
    json['NguoiTraLoi'] = nguoiTraLoi;
    json['SoDienThoai'] = soDienThoai;
    json['ThoiGianBD'] = thoiGianBD;
    json['ThoiGianKT'] = thoiGianKT;
    json['GhiChu'] = ghiChu;
    json['GiaiTrinhToaDo'] = giaiTrinhToaDo;
    json['GiaiTrinhThoiGianPV'] = giaiTrinhThoiGianPV;
    json['NgayCapNhat'] = ngayCapNhat;

    json['CreatedAt'] = createdAt;
    json['UpdatedAt'] = updatedAt;
    return json;
  }

 Map<String, Object?> toJsonGetDLPV() {
    var json = <String, Object?>{};
    json['IDCoSo'] = iDCoSo;
    json['LoaiPhieu'] = loaiPhieu;
    json['MaTinh'] = maTinh;
    json['MaTKCS'] = maTKCS;
    json['MaXa'] = maXa;
    json['MaThon'] = maThon;
    json['IDDB'] = iDDB;
    json['MaDiaBan'] = maDiaBan;
    json['TrangThaiCoSo'] = trangThaiCoSo;
    json['MaCoSo'] = maCoSo;
    json['TenCoSo'] = tenCoSo;
    json['DiaChi'] = diaChi;
    json['TenChuCoSo'] = tenChuCoSo;
    json['SDTCoSo'] = sDTCoSo;
    json['MaNganhMau'] = maNganhMau;
    json['MaDTV'] = maDTV;
    json['KinhDo'] = kinhDo;
    json['ViDo'] = viDo;
    json['NguoiTraLoi'] = nguoiTraLoi;
    json['SoDienThoai'] = soDienThoai;
    json['ThoiGianBD'] = thoiGianBD;
    json['ThoiGianKT'] = thoiGianKT;
    json['GhiChu'] = ghiChu;
    json['GiaiTrinhToaDo'] = giaiTrinhToaDo;
    json['GiaiTrinhThoiGianPV'] = giaiTrinhThoiGianPV;
    json['NgayCapNhat'] = ngayCapNhat; 
    json['CreatedAt'] = createdAt; 
    return json;
  }

  static List<TablePhieu>? fromListJson(dynamic json) {
    List<TablePhieu> list = [];
    if (json != null) {
      for (var item in json) {
        list.add(TablePhieu.fromJson(item));
      }
    }
    return list;
  }
}
