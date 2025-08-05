const String tablePhieuTonGiaoA43 = 'TG_PhieuTonGiao_A4_3';
const String columnPhieuTonGiaoA43Id = '_id';
const String columnPhieuTonGiaoA43IDCoSo = 'IDCoSo';
const String columnPhieuTonGiaoA43STT = 'STT';
const String columnPhieuTonGiaoA43A4_3_1 = 'A4_3_1';
const String columnPhieuTonGiaoA43A4_3_2 = 'A4_3_2';
const String columnPhieuTonGiaoA43A4_3_3 = 'A4_3_3';
const String columnPhieuTonGiaoA43A4_3_4 = 'A4_3_4';
const String columnPhieuTonGiaoA43A4_3_5 = 'A4_3_5';
const String columnPhieuTonGiaoA43MaDTV = 'MaDTV';
const String columnPhieuTonGiaoA43reatedAt = 'CreatedAt';
const String columnPhieuTonGiaoA43UpdatedAt = 'UpdatedAt';

class TablePhieuTonGiaoA43 {
  int? id;
  String? iDCoSo;

  int? sTT;
  String? a4_3_1;
  String? a4_3_2;
  int? a4_3_3;
  double? a4_3_4;
  double? a4_3_5;
  String? maDTV;
  String? createdAt;
  String? updatedAt;
  TablePhieuTonGiaoA43({
    this.id,
    this.iDCoSo,
    this.sTT,
    this.a4_3_1,
    this.a4_3_2,
    this.a4_3_3,
    this.a4_3_4,
    this.a4_3_5,
    this.maDTV,
    this.createdAt,
    this.updatedAt,
  });

  TablePhieuTonGiaoA43.fromJson(dynamic json) {
    id = json['_id'];

    iDCoSo = json['IDCoSo'];

    sTT = json['STT'];
    a4_3_1 = json['A4_3_1'];
    a4_3_2 = json['A4_3_2'];
    a4_3_3 = json['A4_3_3'];
    a4_3_4 = json['A4_3_4'];
    a4_3_5 = json['A4_3_5'];
    maDTV = json['MaDTV'];
    createdAt = json['CreatedAt'];
    updatedAt = json['UpdatedAt'];
  }

  Map<String, dynamic> toJson() {
    var data = <String, Object?>{};

    data['IDCoSo'] = iDCoSo;

    data['STT'] = sTT;
    data['A4_3_1'] = a4_3_1;
    data['A4_3_2'] = a4_3_2;
    data['A4_3_3'] = a4_3_3;
    data['A4_3_4'] = a4_3_4;
     data['A4_3_5'] = a4_3_5;
    data['MaDTV'] = maDTV;
    data['CreatedAt'] = createdAt;
    data['UpdatedAt'] = updatedAt;
    return data;
  }

  static List<TablePhieuTonGiaoA43>? fromListJson(dynamic json) {
    List<TablePhieuTonGiaoA43> list = [];
    if (json != null) {
      for (var item in json) {
        list.add(TablePhieuTonGiaoA43.fromJson(item));
      }
    }
    return list;
  }
}
