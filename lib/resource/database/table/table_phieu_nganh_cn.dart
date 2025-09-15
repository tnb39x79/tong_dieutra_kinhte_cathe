import 'table_p07mau.dart';

const String tablePhieuNganhCN = 'CT_PhieuNganhCN';

const String colPhieuNganhCNId = '_id';
const String colPhieuNganhCNIDCoSo = 'IDCoSo';
const String colPhieuNganhCNSTTSanPham = 'STT_SanPham';
const String colPhieuNganhCNMaNganhC5 = 'MaNganhC5';
const String colPhieuNganhCNA1_1 = 'A1_1';
const String colPhieuNganhCNA1_2 = 'A1_2';
const String colPhieuNganhCNA2_3 = 'A2_3';
const String colPhieuNganhCNA2_4 = 'A2_4';

const String colPhieuNganhCNCreatedAt = 'CreatedAt';
const String colPhieuNganhCNUpdatedAt = 'UpdatedAt';

class TablePhieuNganhCN {
  int? id;
  String? iDCoSo;
  int? sTTSanPham;
  String? maNganhC5;
  String? a1_1;
  String? a1_2;
  String? a2_3;
  double? a2_4;
  String? maDTV;
  String? createdAt;
  String? updatedAt;

  TablePhieuNganhCN(
      {this.id,
      this.iDCoSo,
      this.sTTSanPham,
      this.maNganhC5,
      this.a1_1,
      this.a1_2,
      this.a2_3,
      this.a2_4,
      this.maDTV,
      this.createdAt,
      this.updatedAt});

  TablePhieuNganhCN.fromJson(dynamic json) {
    id = json['_id'];
    iDCoSo = json['IDCoSo'];
    sTTSanPham = json['STT_SanPham'];
    maNganhC5 = json['MaNganhC5'];
    a1_1 = json['A1_1'];
    a1_2 = json['A1_2'];
    a2_3 = json['A2_3'];
    a2_4 = json['A2_4'];

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
    json['A1_1'] = a1_1;
    json['A1_2'] = a1_2;
    json['A2_3'] = a2_3;
    json['A2_4'] = a2_4;

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
