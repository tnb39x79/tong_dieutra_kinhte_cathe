const String tablePhieuMauA68 = 'CT_PhieuCaThe_A68'; 
const String columnPhieuMauA68Id = '_id';
const String columnPhieuMauA68IdCoSo = 'IDCoSo';
const String columnPhieuMauA68STT = 'STT';
const String columnPhieuMauA68A6_8_0 = 'A6_8_0';
const String columnPhieuMauA68A6_8_1 = 'A6_8_1';
const String columnPhieuMauA68A6_8_2 = 'A6_8_2';
const String columnPhieuMauA68A6_8_3 = 'A6_8_3';
const String columnPhieuMauA68MaDTV = 'MaDTV';
const String columnPhieuMauA68reatedAt = 'CreatedAt';
const String columnPhieuMauA68UpdatedAt = 'UpdatedAt';

class TablePhieuMauA68 {
  int? id;
  String? iDCoSo;
  int? sTT;
  String? a6_8_0;
  int? a6_8_1;
  double? a6_8_2;
  double? a6_8_3;
  String? maDTV;
  String? createdAt;
  String? updatedAt;
  TablePhieuMauA68({
    this.id,
    this.iDCoSo,
    this.sTT,
    this.a6_8_0,
    this.a6_8_1,
    this.a6_8_2,
    this.a6_8_3,
    this.maDTV,
    this.createdAt,
    this.updatedAt,
  });
  TablePhieuMauA68.fromJson(dynamic json) {
    if (json != null) {
      id = json['_id'];

      iDCoSo = json['IDCoSo'];

      sTT = json['STT'];
      a6_8_0 = json['A6_8_0'];
      a6_8_1 = json['A6_8_1'];
      a6_8_2 = json['A6_8_2'];
      a6_8_3 = json['A6_8_3'];

      maDTV = json['MaDTV'];
      createdAt = json['createdAt'];
      updatedAt = json['updatedAt'];
    }
  }
  Map<String, Object?> toJson() {
    var map = <String, Object?>{};

    map['IDCoSo'] = iDCoSo;

    map['STT'] = sTT;
    map['A6_8_0'] = a6_8_0;
    map['A6_8_1'] = a6_8_1;
    map['A6_8_2'] = a6_8_2;
    map['A6_8_3'] = a6_8_3;
    map['MaDTV'] = maDTV;
    map['CreatedAt'] = createdAt;
    map['UpdatedAt'] = updatedAt;
    return map;
  }

  static List<TablePhieuMauA68>? fromListJson(json) {
    List<TablePhieuMauA68> list = [];
    if (json != null) {
      for (var item in json) {
        list.add(TablePhieuMauA68.fromJson(item));
      }
    }
    return list;
  }
}
