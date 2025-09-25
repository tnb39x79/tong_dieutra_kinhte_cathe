import 'table_p07mau.dart';

const String tablePhieuNganhTM = 'CT_Phieu_NganhTM';

const String colPhieuNganhTMId = '_id';
const String colPhieuNganhTMIDCoSo = 'IDCoSo';
const String colPhieuNganhTMA1T = 'A1T';
const String colPhieuNganhTMA2 = 'A2';
const String colPhieuNganhTMA3 = 'A3';
const String colPhieuNganhTMA3T = 'A3T';

const String colPhieuNganhTMCreatedAt = 'CreatedAt';
const String colPhieuNganhTMUpdatedAt = 'UpdatedAt';

class TablePhieuNganhTM {
  int? id;
  String? iDCoSo;
  double? a1T;
  int? a2;
  double? a3;
  double? a3T;

  String? maDTV;
  String? createdAt;
  String? updatedAt;

  TablePhieuNganhTM(
      {this.id,
      this.iDCoSo,
      this.a1T,
      this.a2,
      this.a3,
      this.a3T,
      this.maDTV,
      this.createdAt,
      this.updatedAt});

  TablePhieuNganhTM.fromJson(dynamic json) {
    id = json['_id'];
    iDCoSo = json['IDCoSo'];
    a1T = json['A1T'];
    a2 = json['A2'];
    a3 = json['A3'];
    a3T = json['A3T'];

    maDTV = json['MaDTV'];
    createdAt = json['CreatedAt'];
    updatedAt = json['UpdatedAt'];
  }

  Map<String, Object?> toJson() {
    var json = <String, Object?>{};
    json['_id'] = id;

    json['IDCoSo'] = iDCoSo;
    json['A1T'] = a1T;
    json['A2'] = a2;
    json['A3'] = a3;
    json['A3T'] = a3T;

    json['MaDTV'] = maDTV;
    json['CreatedAt'] = createdAt;
    json['UpdatedAt'] = updatedAt;
    return json;
  }

  static List<TablePhieuNganhTM>? fromListJson(dynamic json) {
    List<TablePhieuNganhTM> list = [];
    if (json != null) {
      for (var item in json) {
        list.add(TablePhieuNganhTM.fromJson(item));
      }
    }
    return list;
  }
}
