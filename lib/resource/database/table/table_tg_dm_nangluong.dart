const String tableTGDmNangLuong = 'TG_DM_NangLuong';
const String columnTGDmNangLuongId = '_id';
const String columnTGDmNangLuongMa = 'Ma';
const String columnTGDmNangLuongTen = 'Ten';
const String columnTGDmNangLuongGhiRo = 'GhiRo';

class TableTGDmNangLuong {
  int? id;
  String? ma;
  String? ten;
  int? ghiRo;

  TableTGDmNangLuong({this.id, this.ma, this.ten, this.ghiRo});

  TableTGDmNangLuong.fromJson(Map json) {
    id = json['_id'];
    ma = json['Ma'];
    ten = json['Ten'];
    ghiRo = json['GhiRo'];
  }

  Map<String, Object?> toJson() {
    final data = <String, Object?>{};
    data['Ma'] = ma;
    data['Ten'] = ten;
     data['GhiRo'] = ghiRo;
    return data;
  }

  static List<TableTGDmNangLuong> listFromJson(dynamic localities) {
    List<TableTGDmNangLuong> list = [];
    if (localities != null) {
      for (var item in localities) {
        list.add(TableTGDmNangLuong.fromJson(item));
      }
    }
    return list;
  }
}
