const String tableTGDmSudDngPhanMem= 'TG_DM_SuDungPhanMem'; 
const String columnTGDmSudDngPhanMemId = '_id';
const String columnTGDmSudDngPhanMemMa = 'Ma';
const String columnTGDmSudDngPhanMemTen = 'Ten';  

class TableTGDmSudDngPhanMem {
  int? id;
  int? ma;
  String? ten;   

  TableTGDmSudDngPhanMem({
    this.id,
    this.ma,
    this.ten 
  });

  TableTGDmSudDngPhanMem.fromJson(Map json) {
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

  static List<TableTGDmSudDngPhanMem> listFromJson(dynamic localities) {
    List<TableTGDmSudDngPhanMem> list = [];
    if (localities != null) {
      for (var item in localities) {
        list.add(TableTGDmSudDngPhanMem.fromJson(item));
      }
    }
    return list;
  }
}
