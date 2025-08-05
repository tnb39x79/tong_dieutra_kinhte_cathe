const String tableDmCoKhong = 'KT_DM_CoKhong'; 
const String columnDmCoKhongId = '_id';
const String columnDmCoKhongMa = 'Ma';
const String columnDmCoKhongTen= 'Ten';  

class TableDmCoKhong {
  int? id;
  int? ma;
  String? ten;   

  TableDmCoKhong({
    this.id,
    this.ma,
    this.ten 
  });

  TableDmCoKhong.fromJson(Map json) {
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

  static List<TableDmCoKhong> listFromJson(dynamic localities) {
    List<TableDmCoKhong> list = [];
    if (localities != null) {
      for (var item in localities) {
        list.add(TableDmCoKhong.fromJson(item));
      }
    }
    return list;
  }
}
