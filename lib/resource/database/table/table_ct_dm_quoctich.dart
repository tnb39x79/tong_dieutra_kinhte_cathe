const String tableDmQuocTich = 'CT_DM_QuocTich';
const String columnDmQuocTichId = '_id';
const String columnDmQuocTichMa = 'MaQuocTich';
const String columnDmQuocTichTen = 'TenQuocTich';

class TableCTDmQuocTich {
  int? id;
  int? maQuocTich;
  String? tenQuocTich;

  TableCTDmQuocTich({this.id, this.maQuocTich, this.tenQuocTich});

  TableCTDmQuocTich.fromJson(Map json) {
    id = json['_id'];
    maQuocTich = json['MaQuocTich'];
    tenQuocTich = json['TenQuocTich'];
  }

  Map<String, Object?> toJson() {
    final data = <String, Object?>{};
    data['MaQuocTich'] = maQuocTich;
    data['TenQuocTich'] = tenQuocTich;
    return data;
  }

  static List<TableCTDmQuocTich> listFromJson(dynamic localities) {
    List<TableCTDmQuocTich> list = [];
    if (localities != null) {
      for (var item in localities) {
        list.add(TableCTDmQuocTich.fromJson(item));
      }
    }
    return list;
  }
}
