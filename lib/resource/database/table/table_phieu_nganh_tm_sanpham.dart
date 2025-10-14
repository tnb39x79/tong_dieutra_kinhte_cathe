import 'table_p07mau.dart';

const String tablePhieuNganhTMSanPham = 'CT_Phieu_NganhTM_SanPham';

const String colPhieuNganhTMSanPhamId = '_id';
const String colPhieuNganhTMSanPhamIDCoSo = 'IDCoSo';
const String colPhieuNganhTMSanPhamSTT_SanPham = 'STT_SanPham';
const String colPhieuNganhTMSanPhamMaNganhC5 = 'MaNganhC5';
const String colPhieuNganhTMSanPhamMoTaSanPham = 'MoTaSanPham';
const String colPhieuNganhTMSanPhamA1_2 = 'A1_2';

const String colPhieuNganhTMSanPhamCreatedAt = 'CreatedAt';
const String colPhieuNganhTMSanPhamUpdatedAt = 'UpdatedAt';

class TablePhieuNganhTMSanPham {
  int? id;
  String? iDCoSo;
  int? sTT_SanPham;
  String? maNganhC5;
  double? a1_2;
  String? moTaSanPham; 
  String? maDTV;
  String? createdAt;
  String? updatedAt;

  TablePhieuNganhTMSanPham(
      {this.id,
      this.iDCoSo,
      this.sTT_SanPham,
      this.maNganhC5,
      this.a1_2,
      this.moTaSanPham, 
      this.maDTV,
      this.createdAt,
      this.updatedAt});

  TablePhieuNganhTMSanPham.fromJson(dynamic json) {
    id = json['_id'];
    iDCoSo = json['IDCoSo'];
    sTT_SanPham = json['STT_SanPham'];
    maNganhC5 = json['MaNganhC5'];
    a1_2 = json['A1_2'];
    moTaSanPham = json['MoTaSanPham']; 
    maDTV = json['MaDTV'];
    createdAt = json['CreatedAt'];
    updatedAt = json['UpdatedAt'];
  }

  Map<String, Object?> toJson() {
    var json = <String, Object?>{};
    json['_id'] = id;

    json['IDCoSo'] = iDCoSo;
    json['STT_SanPham'] = sTT_SanPham;
    json['MaNganhC5'] = maNganhC5;
    json['A1_2'] = a1_2;
    json['MoTaSanPham'] = moTaSanPham; 
    json['MaDTV'] = maDTV;
    json['CreatedAt'] = createdAt;
    json['UpdatedAt'] = updatedAt;
    return json;
  }

  static List<TablePhieuNganhTMSanPham>? fromListJson(dynamic json) {
    List<TablePhieuNganhTMSanPham> list = [];
    if (json != null) {
      for (var item in json) {
        list.add(TablePhieuNganhTMSanPham.fromJson(item));
      }
    }
    return list;
  }
}

class TablePhieuNganhTMSanPhamView {
  int? id;
  String? iDCoSo;
  int? sTT_SanPham;
  String? maNganhC5;
  double? a1_2;
  String? moTaSanPham;
  String? maLV;
  String? maDTV;
  String? createdAt;
  String? updatedAt;

  TablePhieuNganhTMSanPhamView(
      {this.id,
      this.iDCoSo,
      this.sTT_SanPham,
      this.maNganhC5,
      this.a1_2,
      this.moTaSanPham,
      this.maLV,
      this.maDTV,
      this.createdAt,
      this.updatedAt});

  TablePhieuNganhTMSanPhamView.fromJson(dynamic json) {
    id = json['_id'];
    iDCoSo = json['IDCoSo'];
    sTT_SanPham = json['STT_SanPham'];
    maNganhC5 = json['MaNganhC5'];
    a1_2 = json['A1_2'];
    moTaSanPham = json['MoTaSanPham'];
    maLV = json['MaLV'];
    maDTV = json['MaDTV'];
    createdAt = json['CreatedAt'];
    updatedAt = json['UpdatedAt'];
  }

  Map<String, Object?> toJson() {
    var json = <String, Object?>{};
    json['_id'] = id;

    json['IDCoSo'] = iDCoSo;
    json['STT_SanPham'] = sTT_SanPham;
    json['MaNganhC5'] = maNganhC5;
    json['A1_2'] = a1_2;
    json['MoTaSanPham'] = moTaSanPham;
    json['MaLV'] = maLV;
    json['MaDTV'] = maDTV;
    json['CreatedAt'] = createdAt;
    json['UpdatedAt'] = updatedAt;
    return json;
  }

  static List<TablePhieuNganhTMSanPhamView>? fromListJson(dynamic json) {
    List<TablePhieuNganhTMSanPhamView> list = [];
    if (json != null) {
      for (var item in json) {
        list.add(TablePhieuNganhTMSanPhamView.fromJson(item));
      }
    }
    return list;
  }
}
