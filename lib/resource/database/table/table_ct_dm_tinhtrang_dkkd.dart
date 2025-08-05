const String tableCTDmTinhTrangDKKD = 'CT_DM_TinhTrangDKKD';  

const String columnCTDmTinhTrangDKKDId = '_id';
const String columnCTDmTinhTrangDKKDMa= 'Ma';
const String columnCTDmTinhTranDKKDTen= 'Ten';  

class TableCTDmTinhTrangDKKD {
  int? id;
  int? ma;
  String? ten;   

  TableCTDmTinhTrangDKKD({
    this.id,
    this.ma,
    this.ten 
  });

  TableCTDmTinhTrangDKKD.fromJson(Map json) {
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

  static List<TableCTDmTinhTrangDKKD> listFromJson(dynamic localities) {
    List<TableCTDmTinhTrangDKKD> list = [];
    if (localities != null) {
      for (var item in localities) {
        list.add(TableCTDmTinhTrangDKKD.fromJson(item));
      }
    }
    return list;
  }
}
