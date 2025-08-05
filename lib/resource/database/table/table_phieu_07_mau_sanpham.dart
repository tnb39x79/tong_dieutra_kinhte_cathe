const String tablePhieuMauSanPham = 'CT_PhieuCaThe_SanPham';
const String columnPhieuMauSanPhamId = '_id';
const String columnPhieuMauSanPhamIdCoSo = 'IDCoSo';
const String columnPhieuMauSanPhamMaNganhC5 = 'MaNganh_C5';
const String columnPhieuMauSanPhamSTTNganhC5 = 'STT_NganhC5';
const String columnPhieuMauSanPhamSTTSanPham = 'STT_Sanpham';
const String columnPhieuMauSanPhamA5_1_1 = 'A5_1_1';
const String columnPhieuMauSanPhamA5_1_2 = 'A5_1_2';
const String columnPhieuMauSanPhamDonViTinh = 'DonViTinh';
const String columnPhieuMauSanPhamA5_2 = 'A5_2';
const String columnPhieuMauSanPhamA5_3 = 'A5_3';
const String columnPhieuMauSanPhamA5_3_1 = 'A5_3_1';
const String columnPhieuMauSanPhamA5_4 = 'A5_4';
const String columnPhieuMauSanPhamA5_5 = 'A5_5';
const String columnPhieuMauSanPhamA5_6 = 'A5_6';
const String columnPhieuMauSanPhamA5_6_1 = 'A5_6_1';
const String columnPhieuMauSanPhamA5_0 = 'A5_0';
const String columnPhieuMauSanPhamA5_7 = 'A5_7'; 
const String columnPhieuMauSanPhamDefault = 'IsDefault'; 
const String columnPhieuMauSanPhamIsSync = 'IsSync';
const String columnPhieuMauSanPhamMaDTV = 'MaDTV';
const String columnPhieuMauSanPhamCreatedAt = 'CreatedAt';
const String columnPhieuMauSanPhamUpdatedAt = 'UpdatedAt';

class TablePhieuMauSanPham {
  int? id;
  String? iDCoSo;
  String? maNganhC5;
  int? sTTNganhC5;
  int? sTTSanPham;
  String? a5_1_1;

  ///Mã sản phẩm
  String? a5_1_2;
  String? donViTinh;
  double? a5_2;
  double? a5_3;
  double? a5_3_1;
  double? a5_4;
  double? a5_5;
  int? a5_6;
  double? a5_6_1;
  int? a5_0;
  double? a5_7;

  int? isDefault; 
  int? isSync;
  String? maDTV;
  String? createdAt;
  String? updatedAt;

  TablePhieuMauSanPham({
    this.id,
    this.iDCoSo,
    this.maNganhC5,
    this.sTTNganhC5,
    this.sTTSanPham,
    this.a5_1_1,
    this.a5_1_2,
    this.donViTinh,
    this.a5_2,
    this.a5_3,
    this.a5_3_1,
    this.a5_4,
    this.a5_5,
    this.a5_6,
    this.a5_6_1,
    this.a5_0,
    this.a5_7,
    this.isDefault, 
    this.isSync,
    this.maDTV,
    this.createdAt,
    this.updatedAt,
  });
  TablePhieuMauSanPham.fromJson(dynamic json) {
    if (json != null) {
      id = json['_id'];

      iDCoSo = json['IDCoSo'];

      maNganhC5 = json['MaNganh_C5'];
      sTTNganhC5 = json['STT_NganhC5'];
      sTTSanPham = json['STT_Sanpham'];
      a5_1_1 = json['A5_1_1'];
      a5_1_2 = json['A5_1_2'];
      donViTinh = json['DonViTinh'];
      a5_2 = json['A5_2'];
      a5_3 = json['A5_3'];
      a5_3_1 = json['A5_3_1'];
      a5_4 = json['A5_4'];
      a5_5 = json['A5_5'];
      a5_6 = json['A5_6'];
      a5_6_1 = json['A5_6_1'];
      a5_0 = json['A5_0'];
      a5_7 = json['A5_7'];
      isDefault = json['IsDefault']; 
      isSync = json['IsSync'];
      maDTV = json['MaDTV'];
      createdAt = json['createdAt'];
      updatedAt = json['updatedAt'];
    }
  }
  Map<String, Object?> toJson() {
    var map = <String, Object?>{};
map['_id'] = id;
    map['IDCoSo'] = iDCoSo;

    map['MaNganh_C5'] = maNganhC5;
    map['STT_NganhC5'] = sTTNganhC5;
    map['STT_Sanpham'] = sTTSanPham;
    map['A5_1_1'] = a5_1_1;
    map['A5_1_2'] = a5_1_2;
    map['DonViTinh'] = donViTinh;
    map['A5_2'] = a5_2;
    map['A5_3'] = a5_3;
    map['A5_3_1'] = a5_3_1;
    map['A5_4'] = a5_4;
    map['A5_5'] = a5_5;
    map['A5_6'] = a5_6;
    map['A5_6_1'] = a5_6_1;
    map['A5_0'] = a5_0;
    map['A5_7'] = a5_7;
    map['IsDefault'] = isDefault; 
    map['IsSync'] = isSync;
    map['MaDTV'] = maDTV;
    map['CreatedAt'] = createdAt;
    map['UpdatedAt'] = updatedAt;
    return map;
  }

  static List<TablePhieuMauSanPham>? fromListJson(json) {
    List<TablePhieuMauSanPham> list = [];
    if (json != null) {
      for (var item in json) {
        list.add(TablePhieuMauSanPham.fromJson(item));
      }
    }
    return list;
  }
}
