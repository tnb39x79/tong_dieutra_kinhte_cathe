const String tablePhieuMauA61 = 'CT_PhieuCaThe_A61';

const String columnPhieuMauA61Id = '_id';
const String columnPhieuMauA61IdCoSo = 'IDCoSo';
const String columnPhieuMauA61STT = 'STT';
const String columnPhieuMauA61A6_1_0 = 'A6_1_0';
const String columnPhieuMauA61A6_1_1 = 'A6_1_1';
const String columnPhieuMauA61A6_1_2 = 'A6_1_2';
const String columnPhieuMauA61A6_1_3 = 'A6_1_3';
const String columnPhieuMauA61MaDTV = 'MaDTV';
const String columnPhieuMauA61reatedAt = 'CreatedAt';
const String columnPhieuMauA61UpdatedAt = 'UpdatedAt';

class TablePhieuMauA61 {
  int? id;
  String? iDCoSo;
  int? sTT;
  String? a_6_1_0;
  int? a_6_1_1;
  int? a_6_1_2;
  int? a_6_1_3;
  String? maDTV;
  String? createdAt;
  String? updatedAt;
  TablePhieuMauA61({
    this.id,
    this.iDCoSo,
    this.sTT,
    this.a_6_1_0,
    this.a_6_1_1,
    this.a_6_1_2,
    this.a_6_1_3,
    this.maDTV,
    this.createdAt,
    this.updatedAt,
  });
  TablePhieuMauA61.fromJson(dynamic json) {
    if (json != null) {
      id = json['_id'];

      iDCoSo = json['IDCoSo'];

      sTT = json['STT'];
      a_6_1_0 = json['A6_1_0'];
      a_6_1_1 = json['A6_1_1'];
      a_6_1_2 = json['A6_1_2'];
      a_6_1_3 = json['A6_1_3'];

      maDTV = json['MaDTV'];
      createdAt = json['createdAt'];
      updatedAt = json['updatedAt'];
    }
  }
  Map<String, Object?> toJson() {
    var map = <String, Object?>{};

    map['IDCoSo'] = iDCoSo;

    map['STT'] = sTT;
    map['A6_1_0'] = a_6_1_0;
    map['A6_1_1'] = a_6_1_1;
    map['A6_1_2'] = a_6_1_2;
    map['A6_1_3'] = a_6_1_3;
    map['MaDTV'] = maDTV;
    map['CreatedAt'] = createdAt;
    map['UpdatedAt'] = updatedAt;
    return map;
  }

  static List<TablePhieuMauA61>? fromListJson(json) {
    List<TablePhieuMauA61> list = [];
    if (json != null) {
      for (var item in json) {
        list.add(TablePhieuMauA61.fromJson(item));
      }
    }
    return list;
  }
}
