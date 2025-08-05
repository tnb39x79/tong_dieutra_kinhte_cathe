const String tableTGDmXepHang = 'TG_DM_XepHang'; 
const String columnTGDmXepHangId = '_id';
const String columnTGDmXepHangMa = 'Ma';
const String columnTGDmXepHangTen = 'Ten';  

class TableTGDmXepHang {
  int? id;
  int? ma;
  String? ten;   

  TableTGDmXepHang({
    this.id,
    this.ma,
    this.ten 
  });

  TableTGDmXepHang.fromJson(Map json) {
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

  static List<TableTGDmXepHang> listFromJson(dynamic localities) {
    List<TableTGDmXepHang> list = [];
    if (localities != null) {
      for (var item in localities) {
        list.add(TableTGDmXepHang.fromJson(item));
      }
    }
    return list;
  }
}
