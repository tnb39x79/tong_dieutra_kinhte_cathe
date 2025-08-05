const String tableTGDmTrinhDoChuyenMon = 'TG_DM_TrinhDoChuyenMon';
const String columnTGDmTrinhDoChuyenMonId = '_id';
const String columnTGDmTrinhDoChuyenMonMa = 'Ma';
const String columnTGDmTrinhDoChuyenMonTen = 'Ten';
const String columnTGDmTrinhDoChuyenMonSTT = 'STT';
const String columnTGDmTrinhDoChuyenMonGhiRo = 'GhiRo';

class TableTGDmTrinhDoChuyenMon {
  int? id;
  int? ma;
  String? ten;
  int? stt;
  int? ghiRo;

  TableTGDmTrinhDoChuyenMon({this.id, this.ma, this.ten, this.stt, this.ghiRo});

  TableTGDmTrinhDoChuyenMon.fromJson(Map json) {
    id = json['_id'];
    ma = json['Ma'];
    ten = json['Ten'];
     stt = json['STT'];
      ghiRo = json['GhiRo'];
  }

  Map<String, Object?> toJson() {
    final data = <String, Object?>{};
    data['Ma'] = ma;
    data['Ten'] = ten;
     data['STT'] = stt;
      data['GhiRo'] = ghiRo;
    return data;
  }

  static List<TableTGDmTrinhDoChuyenMon> listFromJson(dynamic localities) {
    List<TableTGDmTrinhDoChuyenMon> list = [];
    if (localities != null) {
      for (var item in localities) {
        list.add(TableTGDmTrinhDoChuyenMon.fromJson(item));
      }
    }
    return list;
  }
}
