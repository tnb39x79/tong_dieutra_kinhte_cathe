const String tableDmGioiTinh = 'KT_DM_GioiTinh'; 
const String columnDmGioiTinhId = '_id';
const String columnDmGioiTinhMa = 'Ma';
const String columnDDmGioiTinhTen = 'Ten';  

class TableDmGioiTinh {
  int? id;
  int? ma;
  String? ten;   

  TableDmGioiTinh({
    this.id,
    this.ma,
    this.ten 
  });

  TableDmGioiTinh.fromJson(Map json) {
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

  static List<TableDmGioiTinh> listFromJson(dynamic localities) {
    List<TableDmGioiTinh> list = [];
    if (localities != null) {
      for (var item in localities) {
        list.add(TableDmGioiTinh.fromJson(item));
      }
    }
    return list;
  }
}
