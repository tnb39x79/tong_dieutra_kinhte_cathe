const String tableTGDmCapCongNhan = 'TG_DM_CapCongNhan';
const String columnTGDmCapCongNhanId = '_id';
const String columnTGDmCapCongNhanMa = 'Ma';
const String columnTGDmCapCongNhanTen = 'Ten';
const String columnTGDmCapCongNhanSTT = 'STT';

class TableTGDmCapCongNhan {
  int? id;
  int? ma;
  String? ten; 

  TableTGDmCapCongNhan({this.id, this.ma, this.ten });

  TableTGDmCapCongNhan.fromJson(Map json) {
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

  static List<TableTGDmCapCongNhan> listFromJson(dynamic localities) {
    List<TableTGDmCapCongNhan> list = [];
    if (localities != null) {
      for (var item in localities) {
        list.add(TableTGDmCapCongNhan.fromJson(item));
      }
    }
    return list;
  }
}
