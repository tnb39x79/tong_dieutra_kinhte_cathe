import 'table_p07mau.dart';

const String tablePhieuNganhVTGhiRo = 'CT_Phieu_NganhVT_GhiRo';

const String colPhieuNganhVTGhiRoId = '_id';
const String colPhieuNganhVTGhiRoIDCoSo = 'IDCoSo';
const String colPhieuNganhVTGhiRoMaCauHoi = 'MaCauHoi';
const String colPhieuNganhVTGhiRoSTT = 'STT';
const String colPhieuNganhVTGhiRoCGhiRo = 'C_GhiRo';
const String colPhieuNganhVTGhiRoC1 = 'C_1';
const String colPhieuNganhVTGhiRoC2 = 'C_2';
const String colPhieuNganhVTGhiRoC3 = 'C_3';
const String colPhieuNganhVTGhiRoC4 = 'C_4';

const String colPhieuNganhVTGhiRoCreatedAt = 'CreatedAt';
const String colPhieuNganhVTGhiRoUpdatedAt = 'UpdatedAt';

class TablePhieuNganhVTGhiRo {
  int? id;
  String? iDCoSo;
  String? maCauHoi;
  int? sTT;
  String? cGhiRo;
  int? c_1;
  int? c_2;
  double? c_3;
  double? c_4;

  String? maDTV;
  String? createdAt;
  String? updatedAt;

  TablePhieuNganhVTGhiRo(
      {this.id,
      this.iDCoSo,
      this.maCauHoi,
      this.sTT,
      this.cGhiRo,
      this.c_1,
      this.c_2,
      this.c_3,
      this.c_4,
      this.maDTV,
      this.createdAt,
      this.updatedAt});

  TablePhieuNganhVTGhiRo.fromJson(dynamic json) {
    id = json['_id'];
    iDCoSo = json['IDCoSo'];
    maCauHoi = json['MaCauHoi'];
    sTT = json['STT'];
    cGhiRo = json['C_GhiRo'];
    c_1 = json['C_1'];
    c_2 = json['C_2'];
    c_3 = json['C_3'];
    c_4 = json['C_4'];

    maDTV = json['MaDTV'];

    createdAt = json['CreatedAt'];
    updatedAt = json['UpdatedAt'];
  }

  Map<String, Object?> toJson() {
    var json = <String, Object?>{};
    json['_id'] = id;

    json['IDCoSo'] = iDCoSo;
    json['MaCauHoi'] = maCauHoi;
    json['STT'] = sTT;
    json['C_GhiRo'] = cGhiRo;
    json['C_1'] = c_1;
    json['C_2'] = c_2;
    json['C_3'] = c_3;
    json['C_4'] = c_4;
    json['MaDTV'] = maDTV;
    json['CreatedAt'] = createdAt;
    json['UpdatedAt'] = updatedAt;
    return json;
  }

  static List<TablePhieuNganhVTGhiRo>? fromListJson(dynamic json) {
    List<TablePhieuNganhVTGhiRo> list = [];
    if (json != null) {
      for (var item in json) {
        list.add(TablePhieuNganhVTGhiRo.fromJson(item));
      }
    }
    return list;
  }
}
