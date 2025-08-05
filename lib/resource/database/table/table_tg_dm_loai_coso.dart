const String tableTGDmLoaiCoSo = 'TG_DM_LoaiCoSo';
const String columnTGDmLoaiCoSoId = '_id';
const String columnTGDmLoaiCoSoMa = 'Ma';
const String columnTGDmLoaiCoSoTen = 'Ten';
const String columnTGDmLoaiSTT = 'STT';
const String columnTGDmLoaiGhiRo = 'GhiRo';

class TableTGDmLoaiCoSo {
  int? id;
  int? ma;
  String? ten;
  int? stt;
  int? ghiRo;

  TableTGDmLoaiCoSo({this.id, this.ma, this.ten, this.stt, this.ghiRo});

  TableTGDmLoaiCoSo.fromJson(Map json) {
    id = json['_id'];
    ma = json['Ma'];
    ten = json['Ten'];
    stt = json['STT'];
    ghiRo = json['GhiRo'];
  }

  Map<String, Object?> toJson() {
    final data = <String, Object?>{};
    data['Ma'] = ma;
    data['Ten'] = ten;
    data['STT'] = stt;
    data['GhiRo'] = ghiRo;
    return data;
  }

  static List<TableTGDmLoaiCoSo> listFromJson(dynamic localities) {
    List<TableTGDmLoaiCoSo> list = [];
    if (localities != null) {
      for (var item in localities) {
        list.add(TableTGDmLoaiCoSo.fromJson(item));
      }
    }
    return list;
  }
}
