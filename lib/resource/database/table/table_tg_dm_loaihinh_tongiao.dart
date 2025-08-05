const String tableTGDmLoaiHinhTonGiao = 'TG_DM_LoaiHinhTonGiao'; 
const String columnTGDmLoaiHinhTonGiaoId = '_id';
const String columnTGDmLoaiHinhTonGiaoMa = 'Ma';
const String columnTGDmLoaiHinhTonGiaoTen= 'Ten';  
const String columnTGDmLoaiHinhTonGiaoSTT= 'STT'; 

class TableTGDmLoaiHinhTonGiao {
  int? id;
  int? ma;
  String? ten;   
  int? stt;

  TableTGDmLoaiHinhTonGiao({
    this.id,
    this.ma,
    this.ten ,
this.stt
  });

  TableTGDmLoaiHinhTonGiao.fromJson(Map json) {
    id = json['_id'];
    ma = json['Ma'];
    ten = json['Ten']; 
    stt = json['STT']; 
  }

  Map<String, Object?> toJson() {
    final data = <String, Object?>{};
    data['Ma'] = ma;
    data['Ten'] = ten;  
     data['STT'] = stt;  
    return data;
  }

  static List<TableTGDmLoaiHinhTonGiao> listFromJson(dynamic localities) {
    List<TableTGDmLoaiHinhTonGiao> list = [];
    if (localities != null) {
      for (var item in localities) {
        list.add(TableTGDmLoaiHinhTonGiao.fromJson(item));
      }
    }
    return list;
  }
}
