const String tableCTDmTrinhDoCm = 'CT_DM_TrinhDoChuyenMon'; 
const String columnCTDmTrinhDoCmId = '_id';
const String columnCTDmTrinhDoCmMa = 'Ma';
const String columnCTDmTrinhDoCmTen = 'Ten';  

class TableCTDmTrinhDoChuyenMon {
  int? id;
  int? ma;
  String? ten;   

  TableCTDmTrinhDoChuyenMon({
    this.id,
    this.ma,
    this.ten 
  });

  TableCTDmTrinhDoChuyenMon.fromJson(Map json) {
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

  static List<TableCTDmTrinhDoChuyenMon> listFromJson(dynamic localities) {
    List<TableCTDmTrinhDoChuyenMon> list = [];
    if (localities != null) {
      for (var item in localities) {
        list.add(TableCTDmTrinhDoChuyenMon.fromJson(item));
      }
    }
    return list;
  }
}
