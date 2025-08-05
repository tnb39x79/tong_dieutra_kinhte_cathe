const String tableDmCap = 'CT_DM_Cap';
const String columnDmCapId = '_id';
const String columnDmCapMa = 'Ma';
const String columnDDmCapTen = 'Ten';

class TableDmCap {
  int? id;
  int? ma;
  String? ten;

  TableDmCap({this.id, this.ma, this.ten});

  TableDmCap.fromJson(Map json) {
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

  static List<TableDmCap> listFromJson(dynamic localities) {
    List<TableDmCap> list = [];
    if (localities != null) {
      for (var item in localities) {
        list.add(TableDmCap.fromJson(item));
      }
    }
    return list;
  }
}
