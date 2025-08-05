const String tableCTDmLoaiDiaDiem = 'CT_DM_LoaiDiaDiem'; 
const String columnCCTDmLoaiDiaDiemId = '_id';
const String columnCTDmLoaiDiaDiemMa= 'Ma';
const String columnCTDmLoaiDiaDiemTen= 'Ten';  

class TableCTDmLoaiDiaDiem {
  int? id;
  int? ma;
  String? ten;   

  TableCTDmLoaiDiaDiem({
    this.id,
    this.ma,
    this.ten 
  });

  TableCTDmLoaiDiaDiem.fromJson(Map json) {
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

  static List<TableCTDmLoaiDiaDiem> listFromJson(dynamic localities) {
    List<TableCTDmLoaiDiaDiem> list = [];
    if (localities != null) {
      for (var item in localities) {
        list.add(TableCTDmLoaiDiaDiem.fromJson(item));
      }
    }
    return list;
  }
}
