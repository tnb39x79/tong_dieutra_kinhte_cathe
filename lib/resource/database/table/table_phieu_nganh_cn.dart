import 'table_p07mau.dart';

const String tablePhieuNganhCN = 'CT_Phieu_NganhCN';

const String colPhieuNganhCNId = '_id';
const String colPhieuNganhCNIDCoSo = 'IDCoSo';
const String colPhieuNganhCNSTT_SanPham = 'STT_SanPham';
const String colPhieuNganhCNMaNganhC5 = 'MaNganhC5';
const String colPhieuNganhCNA1_1 = 'A1_1';
const String colPhieuNganhCNA1_2 = 'A1_2';
const String colPhieuNganhCNA2_1 = 'A2_1';
const String colPhieuNganhCNA2_2 = 'A2_2';

const String colPhieuNganhCNCreatedAt = 'CreatedAt';
const String colPhieuNganhCNUpdatedAt = 'UpdatedAt';

class TablePhieuNganhCN {
  int? id;
  String? iDCoSo;
  int? sTT_SanPham;
  String? maNganhC5;
  String? a1_1;
  String? a1_2;
  String? a2_1;
  double? a2_2;
  String? maDTV;
  String? createdAt;
  String? updatedAt;

  TablePhieuNganhCN(
      {this.id,
      this.iDCoSo,
      this.sTT_SanPham,
      this.maNganhC5,
      this.a1_1,
      this.a1_2,
      this.a2_1,
      this.a2_2,
      this.maDTV,
      this.createdAt,
      this.updatedAt});

  TablePhieuNganhCN.fromJson(dynamic json) {
    id = json['_id'];
    iDCoSo = json['IDCoSo'];
    sTT_SanPham = json['STT_SanPham'];
    maNganhC5 = json['MaNganhC5'];
    a1_1 = json['A1_1'];
    a1_2 = json['A1_2'];
    a2_1 = json['A2_1'];
    a2_2 = json['A2_2'];

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
    json['A1_1'] = a1_1;
    json['A1_2'] = a1_2;
    json['A2_1'] = a2_1;
    json['A2_2'] = a2_2;
    json['MaDTV'] = maDTV;
    json['CreatedAt'] = createdAt;
    json['UpdatedAt'] = updatedAt;
    return json;
  }

  static List<TablePhieuNganhCN>? fromListJson(dynamic json) {
    List<TablePhieuNganhCN> list = [];
    if (json != null) {
      for (var item in json) {
        list.add(TablePhieuNganhCN.fromJson(item));
      }
    }
    return list;
  }
}
