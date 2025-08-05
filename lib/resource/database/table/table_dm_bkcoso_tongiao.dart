import 'package:gov_statistics_investigation_economic/resource/database/table/table_phieu_08_tongiao.dart';

///Bảng kê hộ CT_DI_BkCoSoTonGiao
///
const String tableBkTonGiao = 'DmBkTonGiao';
const String columnBkTonGiaoId = '_id';
const String columnBkTonGiaoIDCoSo = 'IDCoSo';
const String columnBkTonGiaoMaTinh = 'MaTinh';
const String columnBkTonGiaoTenTinh = 'TenTinh';
const String columnBkTonGiaoMaHuyen = 'MaHuyen';
const String columnBkTonGiaoTenHuyen = 'TenHuyen';
const String columnBkTonGiaoMaXa = 'MaXa';
const String columnBkTonGiaoTenXa = 'TenXa';
const String columnBkTonGiaoMaThon = 'MaThon';
const String columnBkTonGiaoTenThon = 'TenThon';
const String columnBkTonGiaoTTNT = 'TTNT';
const String columnBkTonGiaoMaCoSo = 'MaCoSo';
const String columnBkTonGiaoTenCoSo = 'TenCoSo';
const String columnBkTonGiaoDiaChi = 'DiaChi';
const String columnBkTonGiaoDienThoai = 'DienThoai';
const String columnBkTonGiaoEmail = 'Email';
const String columnBkTonGiaoMaTinhTrangHD = 'MaTinhTrangHD';
const String columnBkTonGiaoMaTrangThaiDT = 'MaTrangThaiDT';
const String columnBkTonGiaoMaTinhTrangHDTruocTD = 'MaTinhTrangHDTruocTD';
const String columnBkTonGiaoTenNguoiCungCap = 'TenNguoiCungCap';
const String columnBkTonGiaoDienThoaiNguoiCungCap = 'DienThoaiNguoiCungCap';

const String columnBkTonGiaoMaDTV = 'MaDTV';

///0: chưa insert; 1: đã insert logic; vào bảng Xác nhận logic
const String columnBkTonGiaoTrangThaiLogic = 'TrangThaiLogic';
const String columnBkTonGiaoIsSyncSuccess = 'SyncSuccess';

class TableBkTonGiao {
  int? id;
  String? iDCoSo;

  String? maTinh;
  String? tenTinh;
  String? maHuyen;
  String? tenHuyen;
  String? maXa;
  String? tenXa;
  String? maThon;
  String? tenThon;
  int? ttNT;
  int? maCoSo;
  String? tenCoSo;
  String? diaChi;
  String? dienThoai;
  String? email;
  int? maTinhTrangHD;
  int? maTrangThaiDT;
  int? maTinhTrangHDTruocTD;
  String? tenNguoiCungCap;
  String? dienThoaiNguoiCungCap;
  String? maDTV;
  int? trangThaiLogic;
  int? isSyncSuccess;
  String? createdAt;
  String? updatedAt;

  TablePhieuTonGiao? tablePhieuTonGiao;

  TableBkTonGiao({
    this.id,
    this.iDCoSo,
    this.maTinh,
    this.tenTinh,
    this.maHuyen,
    this.tenHuyen,
    this.maXa,
    this.tenXa,
    this.maThon,
    this.tenThon,
    this.ttNT,
    this.maCoSo,
    this.tenCoSo,
    this.diaChi,
    this.dienThoai,
    this.email,
    this.maTinhTrangHD,
    this.maTrangThaiDT,
    this.maTinhTrangHDTruocTD,
    this.tenNguoiCungCap,
    this.dienThoaiNguoiCungCap,
    this.maDTV,
    this.tablePhieuTonGiao,
    this.trangThaiLogic,
    this.isSyncSuccess,
    this.createdAt,
    this.updatedAt,
  });

  TableBkTonGiao.fromJson(dynamic json) {
    id = json['_id'];

    iDCoSo = json['IDCoSo'];
    maTinh = json['MaTinh'];
    tenTinh = json['TenTinh'];
    maHuyen = json['MaHuyen'];
    tenHuyen = json['TenHuyen'];
    maXa = json['MaXa'];
    tenXa = json['TenXa'];
    maThon = json['MaThon'];
    tenThon = json['TenThon'];
    ttNT = json['TTNT'];
    maCoSo = json['MaCoSo'];
    tenCoSo = json['TenCoSo'];
    diaChi = json['DiaChi'];
    dienThoai = json['DienThoai'];
    email = json['Email'];
    //   coSoSo = json['CoSoSo'];
    maTinhTrangHD = json['MaTinhTrangHD'];
    maTinhTrangHDTruocTD = json['MaTinhTrangHDTruocTD'];
    maTrangThaiDT = json['MaTrangThaiDT'];
    tenNguoiCungCap = json['TenNguoiCungCap'];
    dienThoaiNguoiCungCap = json['DienThoaiNguoiCungCap'];
    maDTV = json['MaDTV'];
    trangThaiLogic = json['TrangThaiLogic'];
    isSyncSuccess = json['SyncSuccess'];
    createdAt = json['CreatedAt'];
    updatedAt = json['UpdatedAt'];
    tablePhieuTonGiao = json['PhieuTonGiaoResponseDto'] != null
        ? TablePhieuTonGiao.fromJson(json['PhieuTonGiaoResponseDto'])
        : null;
  }
  Map<String, Object?> toJson() {
    final Map<String, Object?> data = <String, Object?>{};

    data['IDCoSo'] = iDCoSo;

    data['MaTinh'] = maTinh;
    data['TenTinh'] = tenTinh;
    data['MaHuyen'] = maHuyen;
    data['TenHuyen'] = tenHuyen;
    data['MaXa'] = maXa;
    data['TenXa'] = tenXa;
    data['MaThon'] = maThon;
    data['TenThon'] = tenThon;
    data['TTNT'] = ttNT;
    data['MaCoSo'] = maCoSo;
    data['TenCoSo'] = tenCoSo;
    data['DiaChi'] = diaChi;
    data['DienThoai'] = dienThoai;
    data['Email'] = email;
    //   data['CoSoSo'] = coSoSo;
    data['MaTrangThaiDT'] = maTrangThaiDT;
    data['MaTinhTrangHD'] = maTinhTrangHD;
    data['MaTinhTrangHDTruocTD'] = maTinhTrangHDTruocTD;
    data['MaTrangThaiDT'] = maTrangThaiDT;
    data['TenNguoiCungCap'] = tenNguoiCungCap;
    data['DienThoaiNguoiCungCap'] = dienThoaiNguoiCungCap;
    data['MaDTV'] = maDTV;
    data['TrangThaiLogic'] = trangThaiLogic;
    data['SyncSuccess'] = isSyncSuccess;
    data['CreatedAt'] = createdAt;
    data['UpdatedAt'] = updatedAt;
    return data;
  }

  static List<TableBkTonGiao> listFromJson(dynamic json) {
    List<TableBkTonGiao> list = [];
    if (json != null) {
      for (dynamic item in json) {
        TableBkTonGiao table = TableBkTonGiao.fromJson(item);
        list.add(table);
      }
    }
    return list;
  }
}
