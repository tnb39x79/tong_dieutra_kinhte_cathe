const String tableDmLoaiTonGiao = 'KT_DM_LoaiTonGiao'; 
const String columnDmLoaiTonGiaoId = '_id';
const String columnDmLoaiTonGiaoMa = 'Ma';
const String columnDmLoaiTonGiaoTen= 'Ten';  

class TableDmLoaiTonGiao {
  int? id;
  int? ma;
  String? ten;   

  TableDmLoaiTonGiao({
    this.id,
    this.ma,
    this.ten 
  });

  TableDmLoaiTonGiao.fromJson(Map json) {
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

  static List<TableDmLoaiTonGiao> listFromJson(dynamic localities) {
    List<TableDmLoaiTonGiao> list = [];
    if (localities != null) {
      for (var item in localities) {
        list.add(TableDmLoaiTonGiao.fromJson(item));
      }
    }
    return list;
  }
}
