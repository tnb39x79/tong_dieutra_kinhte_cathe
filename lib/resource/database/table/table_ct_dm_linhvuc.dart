const String tableCTDmLinhVuc = 'CT_DM_LinhVuc';
const String columnCTDmLinhVucId = '_id';
const String columnCTDmLinhVucMa = 'Ma';
const String columnCTDmLinhVucTen = 'Ten';

class TableCTDmLinhVuc {
  int? id;
  int? ma;
  String? ten;

  TableCTDmLinhVuc({this.id, this.ma, this.ten});

  TableCTDmLinhVuc.fromJson(Map json) {
    id = json['_id'];
    ma = json['Ma'];
    ten = json['Ten'];
  }

  Map<String, Object?> toJson() {
    final data = <String, Object?>{};
    data['Ma'] = ma;
    data['Ten'] = ten;
    return data;
  }

  static List<TableCTDmLinhVuc> listFromJson(dynamic localities) {
    List<TableCTDmLinhVuc> list = [];
    if (localities != null) {
      for (var item in localities) {
        list.add(TableCTDmLinhVuc.fromJson(item));
      }
    }
    return list;
  }
}
