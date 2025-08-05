const String tableCTDmDiaDiemSXKD = 'CT_DM_DiaDiemSXKD';
const String columnCTDmDiaDiemSXKDId = '_id';
const String columnCTDmDiaDiemSXKDMa = 'Ma';
const String columnCTDmDiaDiemSXKDTen = 'Ten';
const String columnCTDmDiaDiemSXKDGhiRo = 'GhiRo';

class TableCTDmDiaDiemSXKD {
  int? id;
  int? ma;
  String? ten;
  int? ghiRo;

  TableCTDmDiaDiemSXKD({this.id, this.ma, this.ten, this.ghiRo});

  TableCTDmDiaDiemSXKD.fromJson(dynamic json) {
    id = json['_id'];
    ma = json['Ma'];
    ten = json['Ten'];
    ghiRo = json['GhiRo'];
  }

  Map<String, Object?> toJson() {
    var map = <String, Object?>{};
    map['Ma'] = ma;
    map['Ten'] = ten;
    map['GhiRo'] = ghiRo;
    return map;
  }

  static List<TableCTDmDiaDiemSXKD> listFromJson(json) {
    List<TableCTDmDiaDiemSXKD> list = [];
    if (json != null) {
      for (var item in json) {
        list.add(TableCTDmDiaDiemSXKD.fromJson(item));
      }
    }
    return list;
  }
}
