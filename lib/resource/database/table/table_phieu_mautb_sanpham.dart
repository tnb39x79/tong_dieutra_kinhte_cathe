import 'table_p07mau.dart';

const String tablePhieuMauTBSanPham = 'CT_PhieuMauTB_SanPham';

const String tablePhieuMauTBSanPhamID = '_id';
const String colPhieuMauTBSanPhamIDCoSo = 'IDCoSo';
const String colPhieuMauTBSanPhamSTTSanPham = 'STT_SanPham';
const String colPhieuMauTBSanPhamMaNganhC5 = 'MaNganhC5';
const String colPhieuMauTBSanPhamA5_1_1 = 'A5_1_1';
const String colPhieuMauTBSanPhamA5_1_2 = 'A5_1_2';
const String colPhieuMauTBSanPhamA5_2 = 'A5_2';

const String columnPhieuMauSanPhamDefault = 'IsDefault';
const String columnPhieuMauSanPhamIsSync = 'IsSync';
const String colPhieuMauTBSanPhamCreatedAt = 'CreatedAt';
const String colPhieuMauTBSanPhamUpdatedAt = 'UpdatedAt';

class   TablePhieuMauTBSanPham {
  int? id;
  String? iDCoSo;
  int? sTTSanPham;
  String? maNganhC5;
  String? a5_1_1;
  String? a5_1_2;
  double? a5_2;

  int? isDefault;
  int? isSync;

  String? maDTV;
  String? createdAt;
  String? updatedAt;

  TablePhieuMauTBSanPham(
      {this.id,
      this.iDCoSo,
      this.sTTSanPham,
      this.maNganhC5,
      this.a5_1_1,
      this.a5_1_2,
      this.a5_2,
      this.isDefault,
      this.isSync,
      this.maDTV,
      this.createdAt,
      this.updatedAt});

  TablePhieuMauTBSanPham.fromJson(dynamic json) {
    id = json['_id'];
    iDCoSo = json['IDCoSo'];
    sTTSanPham = json['STT_SanPham'];
    maNganhC5 = json['MaNganhC5'];
    a5_1_1 = json['A5_1_1'];
    a5_1_2 = json['A5_1_2'];
    a5_2 = json['A5_2'];

    isDefault = json['IsDefault'];
    isSync = json['IsSync'];
    maDTV = json['MaDTV'];
    createdAt = json['CreatedAt'];
    updatedAt = json['UpdatedAt'];
  }

  Map<String, Object?> toJson() {
    var json = <String, Object?>{};
    json['_id'] = id;

    json['IDCoSo'] = iDCoSo;
    json['STT_SanPham'] = sTTSanPham;
    json['MaNganhC5'] = maNganhC5;
    json['A5_1_1'] = a5_1_1;
    json['A5_1_2'] = a5_1_2;
    json['A5_2'] = a5_2;

    json['IsDefault'] = isDefault;
    json['IsSync'] = isSync;
    json['MaDTV'] = maDTV;
    json['CreatedAt'] = createdAt;
    json['UpdatedAt'] = updatedAt;
    return json;
  }

  static List<TablePhieuMauTBSanPham>? fromListJson(dynamic json) {
    List<TablePhieuMauTBSanPham> list = [];
    if (json != null) {
      for (var item in json) {
        list.add(TablePhieuMauTBSanPham.fromJson(item));
      }
    }
    return list;
  }
}
