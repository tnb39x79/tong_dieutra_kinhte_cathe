const String tableTGDmXepHangDiTich = 'TG_DM_XepHangDiTich'; 
const String columnTGDmXepHangDiTichId = '_id';
const String columnTGDmXepHangDiTichMa = 'Ma';
const String columnTGDmXepHangDiTichTen = 'Ten';  

class TableTGDmXepHangDiTich {
  int? id;
  int? ma;
  String? ten;   

  TableTGDmXepHangDiTich({
    this.id,
    this.ma,
    this.ten 
  });

  TableTGDmXepHangDiTich.fromJson(Map json) {
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

  static List<TableTGDmXepHangDiTich> listFromJson(dynamic localities) {
    List<TableTGDmXepHangDiTich> list = [];
    if (localities != null) {
      for (var item in localities) {
        list.add(TableTGDmXepHangDiTich.fromJson(item));
      }
    }
    return list;
  }
}
